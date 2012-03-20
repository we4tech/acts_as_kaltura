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
      @@_kaltura_config_file = nil

      class << self
        def _kaltura_config_file=(file)
          @@_kaltura_config_file = file
        end

        def _kaltura_config_file
          if @@_kaltura_config_file.nil?
            @@_kaltura_config_file = Rails.root.join('config', 'kaltura.yml').to_s
          end

          @@_kaltura_config_file
        end
      end

      cattr_accessor :_kaltura_client
    end

    module ClassMethods
      def kaltura_configs(env = Rails.env.to_s)
        if !defined?(@@_kaltura_configs)
          @@_kaltura_configs = YAML.load(File.read(_kaltura_config_file)).with_indifferent_access
        end

        @@_kaltura_configs[env]
      end

      def kaltura_client(env = Rails.env.to_s)
        if _kaltura_client.nil?
          configs = kaltura_configs(env)
        else
          configs = _kaltura_client
        end

        config  = Kaltura::Configuration.new(configs[:partner_id])

        # Set timeout if mentioned in configuration
        if configs[:timeout].present?
          config.timeout = configs[:timeout]
        end

        # Set debug logger if mentioned in configuration
        if configs[:debug]
          config.logger = ActsAsKaltura::Config::Logger.new
          _debug_response
        end

        client          = Kaltura::Client.new(config)
        session         = client.session_service.start(
            configs[:admin_secret], '', Kaltura::Constants::SessionType::ADMIN)
        client.ks       = session
        _kaltura_client = client

        _kaltura_client
      end

      def reload_kaltura_client(env = Rails.env.to_s)
        _kaltura_client = nil
        kaltura_client
      end

      def _debug_response
        if ['test', 'development'].include?(Rails.env)
          Kaltura::ClientBase.class_eval do
            def parse_to_objects(data)
              puts data
              parse_xml_to_objects(data)
            end
          end
        end
      end
    end
  end
end