module Batcher
  class Middleware
    class ContentTypeNotAcceptable < StandardError
      def initialize
        super('Content type not acceptable')
      end
    end

    class RequestMalformed < StandardError
      def initialize
        super('Request malformed')
      end
    end

    REQUEST_METHOD_KEY = 'REQUEST_METHOD'.freeze
    REQUEST_PATH_INFO_KEY = 'PATH_INFO'.freeze
    CONTENT_TYPE_HEADER = 'Content-Type'.freeze
    JSON_CONTENT_TYPE = 'application/json'.freeze

    attr_reader :app

    def initialize(app)
      @app = app
    end

    def call(env)
      return app.call(env) unless env[REQUEST_METHOD_KEY] == Batcher.configuration.method.to_s.upcase && env[REQUEST_PATH_INFO_KEY] == Batcher.configuration.url

      begin
        batch_request = Rack::Request.new(env)

        raise ContentTypeNotAcceptable unless batch_request.content_type&.include?(JSON_CONTENT_TYPE)

        payload = JSON.parse(batch_request.body.read, symbolize_names: true) rescue raise(RequestMalformed)

        requests = (payload[:requests] || raise(RequestMalformed)).slice(0, Batcher.configuration.limit).map do |request_params|
          Request.new(*request_params.values_at(:method, :url, :headers, :params))
        end

        responses = requests.map do |request|
          begin
            Executor.new(app, env, request).execute
          rescue Exception => e
            Response.new(400, {}, {
              error: {
                type: e.class.name.demodulize.underscore,
                message: e.message
              }
            })
          end
        end

        batch_response = Response.new(200, {}, {
          responses: responses
        })
      rescue Exception => e
        batch_response = Response.new(400, {}, {
          error: {
            type: e.class.name.demodulize.underscore,
            message: e.message
          }
        })
      end

      [
        batch_response.status,
        (batch_response.headers || {}).merge(CONTENT_TYPE_HEADER => JSON_CONTENT_TYPE),
        [batch_response.body.present? ? batch_response.body.to_json : '']
      ]
    end
  end
end