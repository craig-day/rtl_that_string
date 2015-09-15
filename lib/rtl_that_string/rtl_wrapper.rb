require 'nokogiri'
require 'rtl_that_string/bidi_processors/majority'
require 'rtl_that_string/bidi_processors/start_of_string'
require 'rtl_that_string/bidi_processors/treat_as_rtl'
require 'rtl_that_string/bidi_processors/treat_as_ltr'

module RtlThatString
  class RtlWrapper
    attr_accessor :bidi_processor

    def initialize
      @bidi_processor = case RtlThatString.configuration.bidi_strategy
      when :majority
        RtlThatString::BidiProcessors::Majority.new
      when :start_of_string
        RtlThatString::BidiProcessors::StartOfString.new
      when :treat_as_rtl
        RtlThatString::BidiProcessors::TreatAsRtl.new
      when :treat_as_ltr
        RtlThatString::BidiProcessors::TreatAsLtr.new
      else
        raise "Unknown bi-directional processor: '#{RtlThatString.configuration.bidi_strategy}'"
      end
    end

    # Wrap plain text or html in direction control unicode characters or tags
    #
    # If the string is detected as all RTL characters it will be bordered with
    # directional override characters. If it has mixed RTL and LTR it will get
    # wrapped with bi-directional override characters.
    #
    # If the `html: true` option is passed the string will get wrapped in either
    # a <bdo></bdo> or <bde></bde> tag.
    def wrap_for_rtl(content, html: false)
      return wrap_html_for_rtl(content) if html

      case RtlThatString::DETECTOR.direction(content)
      when StringDirection::RTL
        rtl_string_borders(content)
      when StringDirection::BIDI
        bidi_processor.run(content) ? bidi_string_borders(content) : content
      else
        content
      end
    end

    # Modifies content in place with the result from `with_rtl`
    def wrap_for_rtl!(content, html: false)
      content.replace wrap_for_rtl(content, html: html)
    end

    private

    # Evaluate the direction of text in an HTML blob by first removing the HTML
    # tags, then checking the plain text, then returning a wrapped blob of HTML
    def wrap_html_for_rtl(content)
      plain_text = Nokogiri::HTML(content).text

      case RtlThatString::DETECTOR.direction(plain_text)
      when StringDirection::RTL
        rtl_html_borders(content)
      when StringDirection::BIDI
        Rails.logger.info "*** #{bidi_processor.inspect}"
        Rails.logger.info "*** #{RtlThatString.configuration.inspect}"
        bidi_processor.run(plain_text) ? bidi_html_borders(content) : content
      else
        content
      end
    end

    # Use prepend/concat to support classes like ActiveSupport::SafeBuffer
    # without ruining HTML safety.

    def rtl_string_borders(content)
      content.prepend(RtlThatString::RTL_MARK) # Direction markers don't get used in pairs
    end

    def bidi_string_borders(content)
      content.prepend(RtlThatString::BIDI_START).concat(RtlThatString::BIDI_END)
    end

    def rtl_html_borders(content)
      content.prepend(RtlThatString::BDO_OPEN).concat(RtlThatString::BDO_CLOSE)
    end

    def bidi_html_borders(content)
      content.prepend(RtlThatString::BDE_OPEN).concat(RtlThatString::BDE_CLOSE)
    end
  end
end
