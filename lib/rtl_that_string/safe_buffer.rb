require_relative './base'

module RtlThatString
  module SafeBuffer
    include RtlThatString::Base

    private

    def rtl_string_borders
      prepend(RTL_START).concat(RTL_END)
    end

    def bidi_string_borders
      prepend(BIDI_START).concat(BIDI_END)
    end

    def rtl_html_borders
      prepend(BDO_OPEN).concat(BDO_CLOSE)
    end

    def bidi_html_borders
      prepend(BDE_OPEN).concat(BDE_CLOSE)
    end
  end
end
