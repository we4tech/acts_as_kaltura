# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "acts_as_kaltura"
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["nhm tanveer hossain khan"]
  s.date = "2012-02-06"
  s.description = "Acts as kaltura"
  s.email = "hasan@somewherein.net"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "lib/acts_as_kaltura.rb",
    "lib/acts_as_kaltura/annotation.rb",
    "lib/acts_as_kaltura/callbacks.rb",
    "lib/acts_as_kaltura/config.rb",
    "lib/acts_as_kaltura/delegator.rb",
    "lib/acts_as_kaltura/extension.rb",
    "lib/acts_as_kaltura/extension/entry.rb",
    "lib/acts_as_kaltura/extension/filter.rb",
    "lib/acts_as_kaltura/extension/response.rb",
    "lib/acts_as_kaltura/extension/service.rb",
    "lib/acts_as_kaltura/two_way_attr_accessor.rb",
    "lib/acts_as_kaltura/version.rb",
    "lib/acts_as_kaltura/video.rb"
  ]
  s.homepage = "https://github.com/we4tech/acts_as_kaltura/"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "An extension for supporting acts_as_kaltura_video and acts_as_kaltura_annotation (which automatically maintains kaltura video and cuepoint)"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<velir_kaltura-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.1.3"])
      s.add_runtime_dependency(%q<activerecord>, ["~> 3.1.3"])
    else
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<velir_kaltura-ruby>, [">= 0"])
      s.add_dependency(%q<activesupport>, ["~> 3.1.3"])
      s.add_dependency(%q<activerecord>, ["~> 3.1.3"])
    end
  else
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<velir_kaltura-ruby>, [">= 0"])
    s.add_dependency(%q<activesupport>, ["~> 3.1.3"])
    s.add_dependency(%q<activerecord>, ["~> 3.1.3"])
  end
end

