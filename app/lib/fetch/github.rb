# frozen_string_literal: true

module Fetch
  class Github
    module Queries
      def self.latest_public_libraries(limit:, order:, lang: nil)
        <<-EOQ
          {
            search(query: "is:public sort:#{order} language:#{lang.to_s}", type: REPOSITORY, last: #{limit}) {
              edges {
                node {
                  ... on Repository {
                    name
                    description
                    owner {
                      login
                    }
                    url
                    updatedAt
                  }
                }
              }
            }
          }
        EOQ
      end
    end

    API_ENDPOINT = 'https://api.github.com/graphql'
    DEFAULT_LIMIT = 50
    DEFAULT_ORDER = 'updated-desc'

    class << self
      def latest_public_libraries(lang: nil)
        query = Queries.latest_public_libraries(
          limit: DEFAULT_LIMIT, order: DEFAULT_ORDER, lang: lang
        )

        data = fetch(query).dig('data', 'search', 'edges')
        data.map do |node|
          Library.new(
            username: node.dig('node', 'owner', 'login'),
            name: node.dig('node', 'name'),
            description: node.dig('node', 'description'),
            url: node.dig('node', 'url'),
            updated_at: DateTime.parse(node.dig('node', 'updatedAt')),
            source: 'github'
          )
        end
      end

      def fetch(query)
        ::Fetch::HTTP::Client.new(API_ENDPOINT).post(query: query) do |request|
          request['Authorization'] = "bearer #{ENV['GITHUB_OAUTH_TOKEN']}"
        end
      end
    end
  end
end
