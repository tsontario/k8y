# frozen_string_literal: true

require "test_helper"

module KubeclientNext
  module Client
    class APIBuilderTest < TestCase
      def setup
        super
        RESTClient.any_instance.stubs(:hardcoded_auth)
      end

      def test_build!
        mock_connection = Faraday.new do |builder|
          builder.adapter(:test, Faraday::Adapter::Test::Stubs.new) do |stub|
            stub.get("https://1.2.3.4/apis/test/v1") { |_env| [200, {}, discovery_response_fixture("test_v1")] }
          end
        end
        RESTClient.any_instance.expects(:connection).returns(mock_connection)

        api = API.new(group_version: GroupVersion.new(group: "test", version: "v1"))
        client = ::KubeclientNext::Client.from_config(config_fixture)
        refute(client.respond_to?(:get_testresource))
        refute(client.respond_to?(:get_testresources))
        builder = APIBuilder.new(api: api, client: client)
        builder.build!
        assert(client.respond_to?(:get_testresource))
        assert(client.respond_to?(:get_testresources))
      end

      private

      # Use raw JSON strings as that's what we expect to receive in production
      def discovery_response_fixture(name)
        File.read(discovery_response_fixture_path(name))
      end

      def discovery_response_fixture_path(name)
        File.expand_path(File.join("..", "..", "fixtures", "discovery", "#{name}.json"), __dir__)
      end
    end
  end
end
