require 'rake/testtask'

Rake::TestTask.new do |test|
  test.pattern = 'test/**/*_test.rb'
  test.libs << 'test'
end

begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name    = "acts_as_kaltura"
    gem.summary = "An extension for supporting acts_as_kaltura_video and acts_as_kaltura_annotation (which automatically maintains kaltura video and cuepoint)"
    gem.email   = "hasan@somewherein.net"
    gem.authors = ["nhm tanveer hossain khan"]
    gem.files   = Dir["{lib}/**/*"]
  end

  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler or dependency not available."
end