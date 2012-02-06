require 'active_support/concern'

module ActsAsKaltura
  module Delegator
    extend ActiveSupport::Concern

    included do
      self.set_kaltura_after_save_callback :reset_kaltura_delegated_attributes
    end

    module ClassMethods
      def delegates_kaltura_attributes(attrs)
        attrs.each do |attr|
          # def thumbnail_url
          #   _lookup_local_attribute(:"thumbnail_url") || _lookup_kaltura_attribute(:"thumbnail_url")
          # end
          class_eval <<-RUBY
            def #{attr}
              self._lookup_local_attribute(:'#{attr.to_s}') ||
               self._lookup_kaltura_attribute(:'#{attr.to_s}')
            end
          RUBY
        end
      end
    end

    protected
      def reset_kaltura_delegated_attributes
        if self.class._kaltura_options.present?
          self.class._kaltura_options[:delegate].each do |attr|
            self.send(:"#{attr}=", nil)
          end
        end
      end

      def _lookup_local_attribute(attr)
        self.read_attribute attr
      end

      def _lookup_kaltura_attribute(attr)
        if entry = self.kaltura_entry
          value = entry.send(attr)
          self.update_column(attr, value) if value
          value
        end
      end
  end
end