module ActsAsKaltura
  module Extension
    module Service

      class CuePointService < Kaltura::Service::BaseService
        #
        # Create new cuepoint
        def add(cuepoint)
          kparams = { }
          client.add_param(kparams, 'cuePoint', cuepoint)
          perform_request('cuepoint_cuepoint', 'add', kparams, false)
        end

        #
        # Retrieve kaltura entry
        def get(entry_id, version = -1)
          kparams = { }
          client.add_param(kparams, 'id', entry_id)
          client.add_param(kparams, 'version', version)
          perform_request('cuepoint_cuepoint', 'get', kparams, false)
        end

        #
        # Count total available cue points for the specified filtered list
        def count(filter=nil)
          kparams = { }
          client.add_param(kparams, 'filter', filter)
          perform_request('cuepoint_cuepoint', 'count', kparams, false)
        end

        #
        # Update an existing cuepoint object
        def update(entry_id, cuepoint)
          kparams = { }
          client.add_param(kparams, 'id', entry_id)
          client.add_param(kparams, 'cuePoint', cuepoint)
          perform_request('cuepoint_cuepoint', 'update', kparams, false)
        end

        #
        # Retrieve list of existing videos, you can filter by passing filter
        # Also paginate through passing paginate object
        def list(filter = nil, pager = nil)
          kparams = { }
          client.add_param(kparams, 'filter', filter)
          client.add_param(kparams, 'pager', pager)
          perform_request('cuepoint_cuepoint', 'list', kparams, false)
        end

        #
        # Delete the specific cuepoint
        def delete(entry_id)
          kparams = { }
          client.add_param(kparams, 'id', entry_id)
          perform_request('cuepoint_cuepoint', 'delete', kparams, false)
        end
      end
    end
  end
end