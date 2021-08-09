# frozen_string_literal: true
require_relative "rest_client"

module KubeclientNext
  module Client
    class Client
      ContextNotFoundError = Class.new(Error)

      attr_reader :config
      attr_accessor :group, :version

      def initialize(config:, context: nil)
        @config = config
        @context = config.context(context) if context
      end

      def context
        @context ||= config.contexts.first
      end

      def context=(context_name)
        @context = config.context(context_name)
      end

      def get_namespaces
        # Just some ideas of a possible generic way to deal with group-versions.
        # Recall a key idea is to be able to use a single client instance to access multiple gvks.
        # For now, however, we're going to build the simplest thing we can: explicitly getting a single resource.
        # rest_client = RESTClientFactory.client_for(group: @group, version: @version)
        # rest_client_for()
        rest_client = RESTClient.new(config: config, context: "kind-kind", group: nil, version: "v1")
        response = rest_client.get_namespaces
        puts response
      end
    end
  end
end
