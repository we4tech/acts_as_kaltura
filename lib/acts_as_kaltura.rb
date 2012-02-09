require 'active_support/core_ext'
require 'acts_as_kaltura/version'
require 'acts_as_kaltura/two_way_attr_accessor'
require 'acts_as_kaltura/config'
require 'acts_as_kaltura/callbacks'
require 'acts_as_kaltura/delegator'
require 'acts_as_kaltura/extension'
require 'acts_as_kaltura/video'
require 'acts_as_kaltura/annotation'
require 'acts_as_kaltura/category'

module ActsAsKaltura
end

module ActiveRecord
  class Base
    include ActsAsKaltura::Config
    include ActsAsKaltura::Callbacks
    include ActsAsKaltura::Delegator
    include ActsAsKaltura::Video
    include ActsAsKaltura::Annotation
    include ActsAsKaltura::Category
  end
end

module Kaltura
  class Client
    include ActsAsKaltura::Extension
  end
end