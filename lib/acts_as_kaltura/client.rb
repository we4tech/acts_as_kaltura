require 'active_support/concern'

module ActsAsKaltura
  module Client
    extend ActiveSupport::Concern

    class Logger
      def log(*args)
        puts args
      end
    end

    included do
      class_eval <<-CODE
        attr_accessor :_instance_kaltura_client
        cattr_accessor :_kaltura_client
      CODE
    end

    # Find an existing client instance or create one based on :setting_scope
    # configuration.
    # Returns kaltura client instance.
    def kaltura_client
      @kaltura_client ||= _create_kaltura_client
    end

    # Find local kaltura client instance if overrode over :setting_scope
    # otherwise return the global client instance
    def local_or_global_kaltura_client
      if self.class.overrode_kaltura_client?
        self.kaltura_client
      else
        self.class.kaltura_client
      end
    end

    def _create_kaltura_client
      @@_kaltura_clients ||= {}
      config_callback = self._kaltura_options[:setting_scope]

      unless config_callback.present?
        raise "acts_as_kaltura_... :setting_scope => ... is not defined."
      end

      configs = config_callback.call(self)
      @@_kaltura_clients[configs] ||= self.class.create_kaltura_client(configs)
    end

    module ClassMethods

      # Create or return an existing kaltura client instance for the given
      # environment. If configuration is based on instance. Create or return
      # kaltura client instance for the given configuration and set it on
      # +_instance_kaltura_client+ .
      def kaltura_client(env = Rails.env.to_s)
        if self._kaltura_client.nil?
          self._kaltura_client = create_kaltura_client(kaltura_configs(env))
        end

        self._kaltura_client
      end

      def reload_kaltura_client(env = Rails.env.to_s)
        self._kaltura_client = nil
        self.kaltura_client(env)
      end

      def create_kaltura_client(configs)
        config = _create_kaltura_config(configs)

        Kaltura::Client.new(config).tap do |client|
          session   = client.session_service.start(
              configs[:admin_secret], '',
              Kaltura::Constants::SessionType::ADMIN
          )
          client.ks = session
        end
      end

    private

      def _create_kaltura_config(configs)
        Kaltura::Configuration.new(configs[:partner_id]).tap do |config|
          if configs[:timeout].present?
            config.timeout = configs[:timeout]
          end

          if configs[:debug]
            config.logger = ActsAsKaltura::Client::Logger.new
            _debug_response
          end
        end
      end

      def _debug_response
        if %w(test development).include?(Rails.env)
          Kaltura::ClientBase.class_eval <<-CODE
            def parse_to_objects(data)
              puts data
              parse_xml_to_objects(data)
            end
          CODE
        end
      end
    end
  end
end