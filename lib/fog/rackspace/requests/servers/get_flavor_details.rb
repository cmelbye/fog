unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # Get details for flavor by id
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - Id of the flavor
        #     * 'name'<~String> - Name of the flavor
        #     * 'ram'<~Integer> - Amount of ram for the flavor
        #     * 'disk'<~Integer> - Amount of diskspace for the flavor
        def get_flavor_details(flavor_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "flavors/#{flavor_id}.json"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def get_flavor_details(flavor_id)
        end

      end
    end
  end

end
