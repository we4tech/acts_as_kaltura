require 'active_support/concern'

module ActsAsKaltura
  module Category
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_kaltura_category
        before_create :create_kaltura_category
        before_update :update_kaltura_category
        before_destroy :destroy_kaltura_category
      end
    end

    def kaltura_category
      if @kaltura_category.nil? && self.kaltura_category_key.present?
        @kaltura_category = self.class.kaltura_client.
            category_service.get(self.kaltura_category_key)
      end

      @kaltura_category
    end

    def kaltura_siblings
      filter = Kaltura::Filter::CategoryFilter.new

      if self.parent && self.parent.kaltura_category_key
        filter.parent_id_equal = self.parent.kaltura_category_key
      else
        filter.parent_id_equal = 0
      end

      self.class.kaltura_client.category_service.list(filter)
    end

    protected
      def kaltura_reference_found?
        self.parent && self.parent.kaltura_category_key.present?
      end

    private
      def create_kaltura_category
        if kaltura_reference_found?
          @kaltura_category = self.class.kaltura_client.
              category_service.add self.as_kaltura_category
          self.kaltura_category_key = @kaltura_category.id
        end
      end

      def update_kaltura_category
        if self.kaltura_category_key.present?
          @kaltura_category = self.class.kaltura_client.category_service.
              update(self.kaltura_category_key, self.as_kaltura_category)
        end
      end

      def destroy_kaltura_category
        if self.kaltura_category_key.present?
          self.class.kaltura_client.category_service.
              delete(self.kaltura_category_key)
          @kaltura_category = nil
        end
      end
  end
end