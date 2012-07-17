module ActsAsKaltura
  module Extension
    class KalturaCuepoint < Kaltura::BaseEntry
      TYPE_AD         = 'adCuePoint.Ad'
      TYPE_ANNOTATION = 'annotation.Annotation'
      TYPE_CODE       = 'codeCuePoint.Code'

      STATUS_DELETED = 2
      STATUS_READY   = 1

      dual_attr_accessor :createdAt, :cuePointType, :entryId, :forceStop, :id,
                         :partnerData, :partnerId, :partnerSortValue,
                         :startTime, :status, :systemName, :tags, :thumbOffset,
                         :updatedAt, :userId
    end

    class KalturaAnnotation < KalturaCuepoint
      dual_attr_accessor :duration, :endTime, :parentId, :text, :cuepointId
    end
  end
end

module Kaltura
  class Annotation < ActsAsKaltura::Extension::KalturaAnnotation; end

  class BaseEntry
    attr_accessor :creator_id, :entitled_users_edit, :entitled_users_publish
  end

  class Category
    attr_accessor :full_ids, :updated_at, :description, :tags, :appear_in_list,
                  :privacy, :inheritance_type, :user_join_policy,
                  :default_permission_level, :owner, :direct_entries_count,
                  :reference_id, :contribution_policy, :members_count,
                  :pending_members_count, :privacy_context, :privacy_contexts,
                  :status, :inherited_parent_id, :partner_sort_value,
                  :partner_data, :default_order_by, :direct_sub_categories_count,
                  :moderation, :pending_entries_count

  end
end
