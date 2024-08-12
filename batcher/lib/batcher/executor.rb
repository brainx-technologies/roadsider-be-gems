module Batcher
  class Executor
    GET_METHOD = 'GET'.freeze
    DEFAULT_URL_METHOD = '/'.freeze
    HEADER_PREFIX = 'HTTP_'.freeze
    PATH_QUERY_SEPARATOR = '?'.freeze
    REQUEST_METHOD_KEY = 'REQUEST_METHOD'.freeze
    REQUEST_URI_KEY = 'REQUEST_URI'.freeze
    ORIGINAL_FULLPATH_KEY = 'ORIGINAL_FULLPATH'.freeze
    REQUEST_PATH_KEY = 'REQUEST_PATH'.freeze
    PATH_INFO_KEY = 'PATH_INFO'.freeze
    QUERY_STRING_KEY = 'QUERY_STRING'.freeze
    RACK_INPUT_KEY = 'rack.input'.freeze
    CONTENT_LENGTH_KEY = 'CONTENT_LENGTH'.freeze
    CONTENT_TYPE_HEADER = 'Content-Type'.freeze
    JSON_CONTENT_TYPE = 'application/json'.freeze

    attr_reader :app
    attr_reader :env
    attr_reader :request

    def initialize(app, env, request)
      @app = app
      @env = env
      @request = request
    end

    def execute
      env = self.env.deep_dup

      request.headers&.each do |header, value|
        env[[HEADER_PREFIX, header.to_s.underscore.upcase].join] = value
      end

      env[REQUEST_METHOD_KEY] = (request.method || GET_METHOD).upcase

      url = URI.parse(request.url || DEFAULT_URL_METHOD)

      env[REQUEST_URI_KEY] = env[ORIGINAL_FULLPATH_KEY] = [url.path, url.query].compact.join(PATH_QUERY_SEPARATOR)
      env[REQUEST_PATH_KEY] = env[PATH_INFO_KEY] = url.path
      env[QUERY_STRING_KEY] = url.query || ''

      env[RACK_INPUT_KEY] = StringIO.new((request.params || {}).to_json)
      env[CONTENT_LENGTH_KEY] = env[RACK_INPUT_KEY].size

      status, headers, body = *app.call(env)

      body = body.each.map(&:to_s).join
      if body.blank?
        body = nil
      elsif headers[CONTENT_TYPE_HEADER]&.include?(JSON_CONTENT_TYPE)
        body = JSON.parse(body)
      end

      Response.new(status, headers, body)
    end
  end
end