module Batcher
  class Railtie < ::Rails::Railtie
    initializer 'batcher.middleware' do |app|
      app.middleware.insert_before Rack::Sendfile, Batcher::Middleware
    end
  end
end