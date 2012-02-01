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
end
