# frozen_string_literal: true

require "forwardable"

module KubeclientNext
  module Client
    class API
      extend Forwardable

      attr_reader :group_version

      def_delegators(:@group_version, :group, :version)

      def initialize(group_version:)
        @group_version = group_version
        @discovered = false
      end

      def discovered?
        @discovered
      end

      # Core/v1 resources are in `/api/#{version}`. In general, all other resources are found in `/apis/GROUP/VERSION`
      def path
        @path ||= if group == "core"
          "/api/#{version}"
        else
          "/apis/#{group}/#{version}"
        end
      end
    end
  end
end