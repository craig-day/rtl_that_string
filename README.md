# RtlThatString

RtlThatString is a library that helps support right-to-left text and html based on content. Right now the "default" behavior is only modify text if it is right-to-left or bi-directional.

- [Installation](#installation)
- [Usage](#usage)
    - [Out of the box](#out-of-the-box)
- [Configuration](#configuration)
    - [Available Configurations](#available-configurations)
    - [Example](#example)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rtl_that_string'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rtl_that_string

## Usage

### Out of the box

```ruby
require 'rtl_that_string'

RtlThatString.wrap_for_rtl("<p>هذا هو سلسلة من الحق في النص اليسار</p>", html: true)
# => "<bdo dir=\"rtl\"><p>هذا هو سلسلة من الحق في النص اليسار</p></bdo>"

RtlThatString.wrap_for_rtl("هذا هو سلسلة من الحق في النص اليسار")
# => "\u202Fهذا هو سلسلة من الحق في النص اليسار"

RtlThatString.wrap_for_rtl("אני גר בעיר של FooBarCentral")
# => "\u202Bאני גר בעיר של FooBarCentral\u202C"
```

## Configuration

```ruby
require 'rtl_that_string'

# Available config options and their defaults
RtlThatString.configure do |config|
  # Strategy to use when bi-directional text is detected
  config.bidi_strategy = :majority

  # Token to split the string on when config.bidi_strategy is :majority
  config.split_token = /\s/

  # Whether or not to do parallel processing on bi-directional text
  config.parallel_bidi_processing = true

  # Number of tokens to start using parallel iteration
  config.parallel_threshold = 5000

  # Number of threads to use when parallel processing. Set either this or
  # parallel_processes, not both.
  config.parallel_threads = nil

  # Number of processes to use when parallel processing. Set either this
  # or parallel_threads, not both.
  config.parallel_processes = nil

  # Number of characters to look at for bidi processing
  config.sample_length = 10
end
```

### Available configurations

#### bidi_strategy
Can be one of the following:
```ruby
:majority, :start_of_string, :treat_as_ltr, :treat_as_rtl
```

###### majority
Split the string into tokens based on [config.split_token](#split_token) then look at the direction of each token. The string will get the direction with the highest number of tokens, e.g. 50 rtl tokens, 20 ltr tokens => rtl string.

###### start_of_string
Look at the first X characters in the string to determine its direction, where X is set by [sample_length](#sample_length). 

###### treat_as_ltr
Just treat the string as left-to-right.

###### treat_as_rtl
Just treat the string as right-to-left.


#### split_token

The token to split the string on when using the [majority](#majority) bi-directional handling strategy. This can be any valid patter for ruby's [String#split](http://ruby-doc.org/core-2.2.0/String.html#method-i-split). 


#### parallel_bidi_processing

Process bi-direction strings in parallel? This is only used if the [bidi_strategy](#bidi_strategy) is set to `:majority`. The parallel processing is done using the [Parallel gem](https://github.com/grosser/parallel). 

#### parallel_threshold

The lower limit on the number of tokens to start parallel processing. Set this to `0` if you want to always force parallel processing. 

#### parallel_threads

The number of threads to use when parallel processing. Only set this *OR* the number of processes. An exception will be raised if you set both. See [here](https://github.com/grosser/parallel#threads) for more details.

#### parallel_processes

The number of processes to use when parallel processing. Only set this *OR* the number of threads. An exception will be raised if you set both. Defaults to the number of CPUs. See [here](https://github.com/grosser/parallel#processes) for more details. 

#### sample_length

The number of characters to look at when using the [start_of_string](#start_of_string) strategy. 


### Example

#### Set another bi-directional strategy

```ruby
require 'rtl_that_string'

# Just look at the first 15 characters, don't analyze all of the string
RtlThatString.configure do |config|
  config.bidi_strategy = :start_of_string
  config.sample_length = 15
end

RtlThatString.wrap_for_rtl("אני גר בעיר של FooBarCentral")
# => "\u202Fאני גר בעיר של FooBarCentral"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/craig-day/rtl_that_string.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
