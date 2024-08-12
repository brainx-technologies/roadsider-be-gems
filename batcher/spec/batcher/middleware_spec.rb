describe Batcher::Middleware do
  describe '.call' do
    let(:app) { -> (env) { [200, { 'Content-Type' => 'application/json' }, [{ key1: :value1 }.to_json]] } }
    let(:env) do
      {
        "PATH_INFO" => url,
        "REQUEST_METHOD" => method.to_s.upcase,
        "CONTENT_TYPE" => content_type,
        "GATEWAY_INTERFACE" => "CGI/1.1",
        "QUERY_STRING" => "",
        "REMOTE_ADDR" => "127.0.0.1",
        "REMOTE_HOST" => "127.0.0.1",
        "REQUEST_URI" => "http://localhost:3000/batch",
        "SCRIPT_NAME" =>"",
        "rack.input" => StringIO.new(payload.to_json),
        "rack.errors" => StringIO.new,
        "SERVER_NAME" => "localhost",
        "SERVER_PORT" => "3000",
        "SERVER_PROTOCOL" => "HTTP/1.1",
        "SERVER_SOFTWARE" => "WEBrick/1.3.1 (Ruby/1.9.3/2012-02-16)",
        "HTTP_USER_AGENT" => "curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8r zlib/1.2.5",
        "HTTP_HOST" => "localhost:3000"
      }
    end
    let(:response) { Batcher::Response.new(200, { header1: :value1 }, { data: { key1: :value1 } }) }
    before { allow_any_instance_of(Batcher::Executor).to receive(:execute).and_return(response) }
    subject { Batcher::Middleware.new(app).call(env) }

    context 'with batch request' do
      let(:method) { Batcher.configuration.method }
      let(:url) { Batcher.configuration.url }

      context 'with valid content type' do
        let(:content_type) { 'application/json' }

        context 'valid payload' do
          let(:payload) do
            {
              "requests": [
                "method": "get",
                "url": "/test"
              ]
            }
          end

          it 'returns correct response' do
            expect(subject[0]).to eq(200)
            expect(subject[1]).to eq({
                                       'Content-Type' => 'application/json'
                                     })
            expect(subject[2]).to eq([
                                       {
                                         responses: [
                                           response.as_json
                                         ]
                                       }.to_json
                                     ])
          end
        end

        context 'with invalid payload' do
          let(:payload) do
            {
              a: :b
            }
          end

          it 'returns correct response' do
            expect(subject[0]).to eq(400)
            expect(subject[1]).to eq({
                                       'Content-Type' => 'application/json'
                                     })
            expect(subject[2]).to eq([
                                       {
                                         error: {
                                           type: Batcher::Middleware::RequestMalformed.name.demodulize.underscore,
                                           message: Batcher::Middleware::RequestMalformed.new.message
                                         }
                                       }.to_json
                                     ])
          end
        end
      end

      context 'with invalid content type' do
        let(:content_type) { 'application/x-www-form-urlencoded' }
        let(:payload) do
          {
            "requests": [
              "method": "get",
              "url": "/test"
            ]
          }
        end

        it 'returns correct response' do
          expect(subject[0]).to eq(400)
          expect(subject[1]).to eq({
                                     'Content-Type' => 'application/json'
                                   })
          expect(subject[2]).to eq([
                                     {
                                       error: {
                                         type: Batcher::Middleware::ContentTypeNotAcceptable.name.demodulize.underscore,
                                         message: Batcher::Middleware::ContentTypeNotAcceptable.new.message
                                       }
                                     }.to_json
                                   ])
        end
      end
    end

    context 'with not batch request' do
      let(:url) { '/not_batch' }
      let(:method) { :get }
      let(:content_type) { 'application/json' }
      let(:payload) do
        {
          "requests": [
            "method": "get",
            "url": "/test"
          ]
        }
      end

      it 'returns correct response' do
        expect(subject).to eq(app.call(env))
      end
    end
  end
end