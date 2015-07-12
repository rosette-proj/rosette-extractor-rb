$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'rosette/extractors/ruby-extractor/version'

Gem::Specification.new do |s|
  s.name     = "rosette-extractor-rb"
  s.version  = ::Rosette::Extractors::RUBY_EXTRACTOR_VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'http://github.com/camertron'

  s.description = s.summary = 'Extracts translatable strings from Ruby source code for the Rosette internationalization platform.'

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency('jruby-parser', '~> 0.5.0')

  s.require_path = 'lib'
  s.files = Dir["{lib,spec}/**/*", 'Gemfile', 'History.txt', 'README.md', 'Rakefile', 'rosette-extractor-rb.gemspec']
end
