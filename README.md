rosette-extractor-rb
====================

Extracts translatable strings from Ruby source code for the Rosette internationalization platform.

## Installation

`gem install rosette-extractor-rb`

Then, somewhere in your project:

```ruby
# this project must be run under jruby
require 'jbundler' # or somehow add dependent jars to your CLASSPATH
require 'rosette/extractors/ruby-extractor'
```

### Introduction

This library is generally meant to be used with the Rosette internationalization platform that extracts translatable phrases from git repositories. rosette-extractor-rb is capable of identifying translatable phrases in Ruby source files, specifically those that use one of the following translation strategies:

1. The `_()` function via [fast_gettext](https://github.com/grosser/fast_gettext).

Additional types of function calls are straightforward to support. Open an issue or pull request if you'd like to see support for another strategy.

### Usage with rosette-server

Let's assume you're configuring an instance of [`Rosette::Server`](https://github.com/rosette-proj/rosette-server). Adding fast_gettext support would cause your configuration to look something like this:

```ruby
require 'rosette/extractors/ruby-extractor'

Rosette::Server.configure do |config|
  config.add_repo('my_awesome_repo') do |repo_config|
    repo_config.add_extractor('ruby/fast-gettext') do |extractor_config|
      extractor_config.match_file_extension('.rb')
    end
  end
end
```

See the documentation contained in [rosette-core](https://github.com/rosette-proj/rosette-core) for a complete list of extractor configuration options in addition to `match_file_extension`.

### Standalone Usage

While most of the time rosette-extractor-rb will probably be used alongside rosette-server, there may arise use cases where someone might want to use it on its own. The `extract_each_from` method on `FastGettextExtractor` yields `Rosette::Core::Phrase` objects (or returns an enumerator):

```ruby
ruby_source_code = "def foo\n  _('bar')\nend"
extractor = Rosette::Extractors::RubyExtractor::FastGettextExtractor.new
extractor.extract_each_from(ruby_source_code) do |phrase|
  phrase.key  # => "bar"
end
```

## Requirements

This project must be run under jRuby. It uses [jbundler](https://github.com/mkristian/jbundler) to manage java dependencies via Maven. Run `gem install jbundler` and `jbundle` in the project root to download and install java dependencies.

## Running Tests

`bundle exec rake` or `bundle exec rspec` should do the trick.

## Authors

* Cameron C. Dutro: http://github.com/camertron
