require 'rtl_that_string/version'
require 'rtl_that_string/string'
require 'rtl_that_string/safe_buffer' if defined?(ActiveSupport)

String.send :include, RtlThatString::String
ActiveSupport::SafeBuffer.send :include, RtlThatString::SafeBuffer if defined?(ActiveSupport)
