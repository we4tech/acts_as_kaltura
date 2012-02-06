require 'active_support/concern'
require 'acts_as_kaltura/extension/entry'
require 'acts_as_kaltura/extension/response'
require 'acts_as_kaltura/extension/filter'
require 'acts_as_kaltura/extension/service'

module ActsAsKaltura
  module Extension
    extend ActiveSupport::Concern

    def cuepoint_service
      @cuepoint_service ||= ActsAsKaltura::Extension::Service::CuePointService.new(self)
    end
  end
end