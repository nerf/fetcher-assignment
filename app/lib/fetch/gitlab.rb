# frozen_string_literal: true

module Fetch
  class Gitlab
    API_ENDPOINT = 'https://gitlab.com/api/v4'
    DEFAULT_LIMIT = 50
    DEFAULT_ORDER = 'updated_at'

    class << self
      def latest_public_libraries(args = {})
        args[:per_page] = DEFAULT_LIMIT
        args[:order_by] = DEFAULT_ORDER
        args[:with_programming_language] = args.delete(:lang)

        fetch('/projects', args).map do |library|
          Library.new(
            username: namespace_from_path(library['path_with_namespace']),
            name: library['name'],
            description: library['description'],
            url: library['web_url'],
            updated_at: DateTime.parse(library['last_activity_at']),
            source: 'gitlab'
          )
        end
      end

      def fetch(path, args)
        uri = API_ENDPOINT + path

        ::Fetch::HTTP::Client.new(uri).get(args)
      end

      def namespace_from_path(path_with_namespace)
        path_with_namespace.split('/').first
      end
    end
  end
end
