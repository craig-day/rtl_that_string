require_relative './base'

module RtlThatString
  module String
    include RtlThatString::Base

    private

    def rtl_string_borders
      "#{RTL_START}#{self}#{RTL_END}"
    end

    def bidi_string_borders
      "#{BIDI_START}#{self}#{BIDI_END}"
    end

    def rtl_html_borders
      "#{BDO_OPEN}#{self}#{BDO_CLOSE}"
    end

    def bidi_html_borders
      "#{BDE_OPEN}#{self}#{BDE_CLOSE}"
    end
  end
end
