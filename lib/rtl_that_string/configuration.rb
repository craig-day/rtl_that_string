module RtlThatString
  class Configuration
    # Strategy to use when bi-directional text is detected
    attr_accessor :bidi_strategy

    # Token to split the string on when :bidi_strategy is :majority
    attr_accessor :split_token

    # Whether or not to do parallel processing on bi-directional text
    attr_accessor :parallel_bidi_processing

    # Number of tokens to start using parallel iteration
    attr_accessor :parallel_threshold

    # Number of threads to use when parallel processing. Set either this or
    # :parallel_processes, not both.
    attr_accessor :parallel_threads

    # Number of processes to use when parallel processing
    attr_accessor :parallel_processes

    # Number of characters to look at for bidi processing
    attr_accessor :sample_length

    def initialize
      self.bidi_strategy = :majority
      self.split_token = /\s/
      self.parallel_bidi_processing = true
      self.parallel_threshold = 5000
      self.parallel_threads = nil
      self.parallel_processes = nil
      self.sample_length = 10
    end
  end
end
