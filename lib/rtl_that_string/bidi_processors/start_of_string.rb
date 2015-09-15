module RtlThatString
  module BidiProcessors
    class StartOfString
      def run(content)
        chunk = content[0, RtlThatString.configuration.sample_length]
        RtlThatString::DETECTOR.rtl?(chunk)
      end
    end
  end
end
