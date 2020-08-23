module Fetch
  module HTTP
    class Client
      DEFAULT_TIMEOUT = 30

      def initialize(uri)
        @uri = URI(uri)
      end

      def get(query = nil)
        set_query_params(query)
        request = Net::HTTP::Get.new(uri.request_uri)
        request['Accept'] = 'application/json'

        client.request(request)
      end

      def post(payload = nil)
        request = Net::HTTP::Post.new(uri.request_uri)
        request['Content-Type'] = 'application/json'
        request['Accept'] = 'application/json'
        request.body = JSON.generate(payload) if payload

        client.request(request)
      end

      private

      attr_reader :uri

      def client
        client = Net::HTTP.new(uri.host, uri.port)
        client.use_ssl = uri.scheme == 'https'
        client.read_timeout = DEFAULT_TIMEOUT

        client
      end

      def set_query_params(params)
        return unless params

        uri.query = URI.encode_www_form(params)
      end
    end
  end
end
