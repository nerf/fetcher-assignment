require 'net/http'

module Fetch
  module HTTP
    class Client
      class RequestError < StandardError; end

      DEFAULT_TIMEOUT = 30

      def initialize(uri)
        @uri = URI(uri)
      end

      def get(query = nil)
        set_query_params(query)
        request = ::Net::HTTP::Get.new(uri.request_uri)
        request['Accept'] = 'application/json'

        parse_response! client.request(request)
      rescue Errno::ECONNREFUSED, Net::ReadTimeout, Net::OpenTimeout
        raise RequestError, "GET request to `#{uri.host}` timed out."
      end

      def post(payload = nil)
        request = Net::HTTP::Post.new(uri.request_uri)
        request['Content-Type'] = 'application/json'
        request['Accept'] = 'application/json'
        request.body = JSON.generate(payload.compact) if payload
        parse_response! client.request(request)
      rescue Errno::ECONNREFUSED, Net::ReadTimeout, Net::OpenTimeout
        raise RequestError, "POST request to `#{uri.host}` timed out."
      end

      private

      attr_reader :uri

      def client
        client = ::Net::HTTP.new(uri.host, uri.port)
        client.use_ssl = uri.scheme == 'https'
        client.read_timeout = DEFAULT_TIMEOUT

        client
      end

      def set_query_params(params)
        return unless params

        uri.query = URI.encode_www_form(params.compact)
      end

      def parse_response!(response)
        case response
        when ::Net::HTTPOK
          JSON.parse(response.body)
        else
          raise RequestError, "Request to `#{uri.host}` has failed with " \
            + "status code `#{response.code}` `#{response.message}`."
        end
      rescue JSON::ParserError
        raise RequestError, "Request to `#{uri.host}` returned invalid data."
      end
    end
  end
end
