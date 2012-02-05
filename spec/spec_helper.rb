require "rubygems"
require "bundler"
Bundler.require

ENV["RAILS_ENV"] ||= 'test'

require 'rails/all'
require 'acts_as_kaltura'
require 'spec_helper/rails'
require 'rspec/rails'
require 'rspec/autorun'
require 'webmock/rspec'
require 'factory_girl_rails'
require 'shoulda-matchers'
require 'spec_helper/rspec'
require 'spec_helper/active_record'
require 'spec_helper/models'
Dir.glob(Rails.root.join('spec', 'factories', '*')).each { |f| require f }
