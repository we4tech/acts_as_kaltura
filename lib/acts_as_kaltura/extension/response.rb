module ActsAsKaltura
  module Extension
    class CuePointListResponse < Kaltura::Response::BaseResponse; end
  end
end

module Kaltura
  module Response
    CuePointListResponse = ActsAsKaltura::Extension::CuePointListResponse
  end
end