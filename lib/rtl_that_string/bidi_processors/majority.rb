require 'parallel'

module RtlThatString
  module BidiProcessors
    class Majority
      def run(content)
        tokens = content.split(RtlThatString.configuration.split_token)
        dir_counts = {}
        counter = lambda { |token| count_token(token, dir_counts) }

        if RtlThatString.configuration.parallel_bidi_processing && tokens.size > RtlThatString.configuration.parallel_threshold
          Parallel.each(tokens, &counter)
        else
          tokens.each(&counter)
        end

        dir_counts[StringDirection::RTL] > dir_counts[StringDirection::LTR]
      end

      private

      def count_token(token, count_hash)
        dir = RtlThatString::DETECTOR.direction(token)
        count_hash[dir] ||= 1
        count_hash[dir] += 1
      end
    end
  end
end
