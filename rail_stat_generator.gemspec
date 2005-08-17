$:.unshift '../lib'
require 'rubygems'
require 'rake'

spec = Gem::Specification.new do |s|
  s.name = 'rail_stat_generator'
  s.version = "0.1.0"
  s.authors = ["Luben Manolov", "Nick Penkov"]
  s.email = "lubo_AT_manolov.org"
  s.homepage = "http://www.railstat.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "RailStat is a real-time web site statistics package which uses Ruby on Rails web application framework."
  s.files = FileList['templates/**/*', 'rail_stat_generator.rb', 'USAGE', 'MIT-LICENSE'].to_a
  s.rubyforge_project = 'railstat'
  s.autorequire = 'rail_stat_generator'
end

if $0==__FILE__
  Gem::manage_gems
  Gem::Builder.new(spec).build
end
