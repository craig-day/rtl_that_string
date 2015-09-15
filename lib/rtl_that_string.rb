require 'rtl_that_string/version'
require 'rtl_that_string/configuration'
require 'rtl_that_string/rtl_wrapper'
require 'string-direction'

module RtlThatString
  # String borders
  # http://www.w3.org/International/questions/qa-bidi-unicode-controls#pairedcontrols
  RTL_MARK = "\u202F".freeze  # RIGHT-TO-LEFT MARK
  LTR_MARK = "\u202E".freeze  # LEFT-TO-RIGHT MARK
  BIDI_START = "\u202B".freeze # RIGHT-TO-LEFT EMBEDDING (RLE)
  BIDI_END   = "\u202C".freeze # POP DIRECTIONAL FORMATTING (PDF)

  # Html wrapping tags
  # http://www.w3.org/International/questions/qa-bidi-unicode-controls#correspondance
  BDO_OPEN  = '<bdo dir="rtl">'.freeze
  BDO_CLOSE = '</bdo>'.freeze
  BDE_OPEN  = '<bde dir="rtl">'.freeze
  BDE_CLOSE = '</bde>'.freeze

  DETECTOR = StringDirection::Detector.new

  class << self
    attr_accessor :configuration
    attr_accessor :wrapper

    # Wrap plain text or html in direction control unicode characters or tags
    #
    # If the string is detected as all RTL characters it will be bordered with
    # directional override characters. If it has mixed RTL and LTR it will get
    # wrapped with bi-directional override characters.
    #
    # If the `html: true` option is passed the string will get wrapped in either
    # a <bdo></bdo> or <bde></bde> tag.
    def wrap_for_rtl(content, options = {})
      self.wrapper ||= RtlWrapper.new
      wrapper.wrap_for_rtl(content, options)
    end

    # Modifies content in place with the result from `with_rtl`
    def wrap_for_rtl!(content, options = {})
      content.replace wrap_for_rtl(content, options)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def reset_configuration
      self.configuration = Configuration.new
    end
  end
end
