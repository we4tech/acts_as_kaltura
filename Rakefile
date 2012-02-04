require 'rubygems'
require 'bundler'
require 'rake'
require 'rake/testtask'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks

task :default => 'spec:unit' do
end

namespace :spec do
  desc "Run acceptance specs"
  RSpec::Core::RakeTask.new('unit') do |t|
    t.pattern = 'spec/lib/**/*_spec.rb'
  end
end

begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name    = "acts_as_kaltura"
    gem.summary = "An extension for supporting acts_as_kaltura_video and acts_as_kaltura_annotation (which automatically maintains kaltura video and cuepoint)"
    gem.homepage = 'https://github.com/we4tech/acts_as_kaltura/'
    gem.description = 'Acts as kaltura'
    gem.email   = "hasan@somewherein.net"
    gem.authors = ["nhm tanveer hossain khan"]
    gem.files   = Dir["{lib}/**/*"]
  end

  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler or dependency not available."
end