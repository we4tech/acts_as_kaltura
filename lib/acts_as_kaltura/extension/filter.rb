module ActsAsKaltura
  module Extension
    class KalturaCuepointFilter < Kaltura::Filter::BaseEntryFilter
      attr_accessor :order_by
      attr_accessor :advanced_search
      attr_accessor :id_equal
      attr_accessor :id_in
      attr_accessor :cue_point_type_equal
      attr_accessor :cue_point_type_in
      attr_accessor :status_equal
      attr_accessor :status_in
      attr_accessor :entry_id_equal
      attr_accessor :entry_id_in
      attr_accessor :created_at_greater_than_or_equal
      attr_accessor :created_at_less_than_or_equal
      attr_accessor :updated_at_greater_than_or_equal
      attr_accessor :updated_at_less_than_or_equal
      attr_accessor :tags_like
      attr_accessor :tags_multi_like_or
      attr_accessor :tags_multi_like_and
      attr_accessor :start_time_greater_than_or_equal
      attr_accessor :start_time_less_than_or_equal
      attr_accessor :user_id_equal
      attr_accessor :user_id_in
      attr_accessor :partner_sort_value_equal
      attr_accessor :partner_sort_value_in
      attr_accessor :partner_sort_value_greater_than_or_equal
      attr_accessor :partner_sort_value_less_than_or_equal
      attr_accessor :force_stop_equal
      attr_accessor :system_name_equal
      attr_accessor :system_name_in
    end
  end
end