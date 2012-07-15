require 'yaml'
require 'active_support/concern'

module ActsAsKaltura
  module Config
    extend ActiveSupport::Concern

    class Logger
      def log(*args)
        puts args
      end
    end

    included do
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        class_attribute :_kaltura_config_file, :_kaltura_configs
        class_attribute :_kaltura_options, :instance_writer => false

        def _kaltura_config_file
          if @@_kaltura_config_file.nil?
            @@_kaltura_config_file = (defined?(Rails) ? Rails.root : File).join('config', 'kaltura.yml').to_s
          end

          @@_kaltura_config_file
        end
      CODE
    end

    module ClassMethods

      def overrode_kaltura_client?
        _kaltura_options.include?(:setting_scope)
      end

      # Read kaltura YAML file and retrieve configuration for the given
      # environment. Returns a hash of kaltura configuration.
      #
      #   kaltura_config('production')
      #
      def kaltura_configs(env = Rails.env.to_s)
        if self._kaltura_configs.nil?
          self._kaltura_configs =
              YAML.load(File.read(self._kaltura_config_file)).
                  with_indifferent_access
        end

        self._kaltura_configs[env]
      end
    end
  end
end