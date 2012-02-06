require 'active_support/concern'

module ActsAsKaltura
  module Annotation
    extend ActiveSupport::Concern

    class KalturaAnnotationAddFailure < ::StandardError; end
    class KalturaAnnotationUpdateFailure < ::StandardError; end

    module ClassMethods
      def acts_as_kaltura_annotation options = { }
        before_create :create_kaltura_annotation
        after_update :update_kaltura_annotation
        after_destroy :delete_kaltura_annotation
      end
    end

    def create_kaltura_annotation
      if self.cuepoint_key.nil?
        @kaltura_annotation = self.class.kaltura_client.cuepoint_service.
            add( self.as_annotation_cuepoint )
        raise KalturaAnnotationAddFailure if @kaltura_annotation.nil?

        self.cuepoint_key = @kaltura_annotation.id.to_s
      end
    end

    def update_kaltura_annotation
      if self.cuepoint_key.present?
        @kaltura_annotation = self.class.kaltura_client.cuepoint_service.
            update(self.cuepoint_key, self.as_annotation_cuepoint )
        raise KalturaAnnotationUpdateFailure if @kaltura_annotation.nil?
      end
    end

    def delete_kaltura_annotation
      if self.cuepoint_key.present?
        self.class.kaltura_client.cuepoint_service.delete(self.cuepoint_key)
        @kaltura_annotation = nil
      end
    end

    def kaltura_annotation
      @kaltura_annotation ||= find_kaltura_annotation
    end

    def kaltura_annotation=(annotation)
      @kaltura_annotation = annotation
    end

    private
      def find_kaltura_annotation
        if self.cuepoint_key.present?
          self.class.kaltura_client.cuepoint_service.get(self.cuepoint_key)
        end
      end
  end
end