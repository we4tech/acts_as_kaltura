require 'active_support/concern'

module ActsAsKaltura
  module Video
    extend ActiveSupport::Concern

    class NoUploadedFile < ::StandardError; end
    class NoUploadedTokenFound < ::StandardError; end
    class KalturaVideoAddFailure < ::StandardError; end

    included do
      class_attribute :_kaltura_options, :instance_writer => false
    end

    module ClassMethods
      def acts_as_kaltura_video(options = {})
        # Set instance accessors
        attr_accessor :video_file, :uploaded_video_token
        self._kaltura_options = options

        # Delegate kaltura attributes if :delegate option provided
        if options[:delegate].present?
          delegates_kaltura_attributes options[:delegate]
        end

        # Set validators
        validates :video_file, :presence => {:on => :create}

        # Set filters
        before_save :process_uploaded_video_file
        before_create :create_kaltura_video_entry
        before_update :update_kaltura_video_entry
        after_destroy :destroy_kaltura_video_entry
      end
    end

    module InstanceMethods

      #
      # Push user uploaded video file to kaltura server
      # If successful set upload token with the object
      #
      def process_uploaded_video_file
        if @video_file.present?
          video_file_stream =  if @video_file.respond_to?(:path, true)
            File.open(@video_file.path)
          else
            @video_file
          end
          @uploaded_video_token = self.class.kaltura_client.
              media_service.upload( video_file_stream )
          raise ActsAsKaltura::Video::NoUploadedTokenFound if @uploaded_video_token.nil?
        end
      end

      #
      # Create kaltura video entry based on current video data
      # if successful set kaltura id
      #
      def create_kaltura_video_entry
        if @video_file.present?
          # There must have uploaded token otherwise this should be invoked
          raise NoUploadedTokenFound if @uploaded_video_token.nil?

          # Covert host model as kaltura entry
          entry = as_kaltura_entry

          # Request kaltura service to store video entry for the
          # uploaded video file
          stored_entry = add_kaltuar_video_file(entry)

          # Nil return should throw exception
          raise KalturaVideoAddFailure  if stored_entry.nil?

          # Set kaltura_key from stored kaltura entry
          self.kaltura_key = stored_entry.id.to_s
          self.kaltura_syncd_at = Time.now

          self.class.run_kaltura_after_save_callbacks self
        end
      end

      #
      # Update kaltura existing video entry
      # If successful update kaltura_syncd_at
      #
      def update_kaltura_video_entry
        if kaltura_key.present?
          entry = as_kaltura_entry
          update_kaltura_entry(entry)

          if @video_file.nil?
            entry.id = kaltura_key
            add_kaltuar_video_file(entry)
          end

          self.class.run_kaltura_after_save_callbacks self
        end
      end

      def kaltura_entry
        find_kaltura_entry if @kaltura_entry.nil?
        @kaltura_entry
      end

      def kaltura_entry=(entry)
        @kaltura_entry = entry
      end

      def destroy_kaltura_video_entry
        if kaltura_key
          destroy_kaltura_entry
        end
      end

      private
        def add_kaltuar_video_file(entry)
          if @video_file && @uploaded_video_token
            self.class.kaltura_client.media_service.
                add_from_uploaded_file(entry, @uploaded_video_token)
          end
        end

        def update_kaltura_entry(entry)
          if kaltura_key.present?
            self.class.kaltura_client.media_service.update(kaltura_key, entry)
            self.kaltura_syncd_at = Time.now
          end
        end

        def find_kaltura_entry
          if kaltura_key
            if @kaltura_entry.nil?
              @kaltura_entry = self.class.kaltura_client.media_service.get(kaltura_key)
            end

            @kaltura_entry
          end
        end

        def destroy_kaltura_entry
          if kaltura_key
            self.class.kaltura_client.media_service.delete(kaltura_key)
            @kaltura_entry = nil
          end
        rescue

        end

        def as_kaltura_entry
          Kaltura::MediaEntry.new.tap do |entry|
            entry.name = title
            entry.description = description
            entry.tags = tags.map &:name
            entry.media_type = Kaltura::Constants::Media::Type::VIDEO
          end
        end
    end
  end
end