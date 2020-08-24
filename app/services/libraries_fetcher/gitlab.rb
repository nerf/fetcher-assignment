# frozen_string_literal: true

class LibrariesFetcher
  class Gitlab
    API_ENDPOINT = 'https://gitlab.com/api/v4'
    DEFAULT_LIMIT = 50
    DEFAULT_ORDER = 'updated_at'

    class << self
      def latest_public_libraries(args = {})
        args[:per_page] = DEFAULT_LIMIT
        args[:order_by] = DEFAULT_ORDER
        args[:with_programming_language] = args.delete(:lang)

        fetch('/projects', args)
          .map { |node| build_from_node(node) }
      end

      def fetch(path, args)
        uri = API_ENDPOINT + path

        ::Lib::API::Client.new(uri).get(args)
      end

      def build_from_node(node)
        Library.new(
          username: namespace_from_path(node['path_with_namespace']),
          name: node['name'],
          description: node['description'],
          url: node['web_url'],
          updated_at: DateTime.parse(node['last_activity_at']),
          source: 'gitlab'
        )
      end

      def namespace_from_path(path_with_namespace)
        path_with_namespace.split('/').first
      end
    end
  end
end
