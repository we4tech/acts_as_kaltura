require 'active_support/concern'

module ActsAsKaltura
  module Callbacks
    extend ActiveSupport::Concern

    included do
      cattr_accessor :_kaltura_after_save_callbacks
      @@_kaltura_after_save_callbacks = []
    end

    module ClassMethods
      def set_kaltura_after_save_callback(callback_method)
        _kaltura_after_save_callbacks << callback_method
      end

      def run_kaltura_after_save_callbacks(instance)
        if _kaltura_after_save_callbacks.present?
          _kaltura_after_save_callbacks.each { |m| instance.send m }
        end
      end
    end
  end
end