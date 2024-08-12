describe Batcher::Executor do
  describe '.execute' do
    let(:app) { -> (env) { [200, { 'Content-Type' => 'application/json' }, [{ key1: :value1 }.to_json]] } }
    let(:env) do
      {
        "PATH_INFO" => Batcher.configuration.url,
        "REQUEST_METHOD" => Batcher.configuration.method.to_s.upcase,
        "CONTENT_TYPE" => 'application/json',
        "GATEWAY_INTERFACE" => "CGI/1.1",
        "QUERY_STRING" => "",
        "REMOTE_ADDR" => "127.0.0.1",
        "REMOTE_HOST" => "127.0.0.1",
        "REQUEST_URI" => "http://localhost:3000/batch",
        "SCRIPT_NAME" =>"",
        "rack.input" => StringIO.new,
        "rack.errors" => StringIO.new,
        "SERVER_NAME" => "localhost",
        "SERVER_PORT" => "3000",
        "SERVER_PROTOCOL" => "HTTP/1.1",
        "SERVER_SOFTWARE" => "WEBrick/1.3.1 (Ruby/1.9.3/2012-02-16)",
        "HTTP_USER_AGENT" => "curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8r zlib/1.2.5",
        "HTTP_HOST" => "localhost:3000"
      }
    end
    subject { Batcher::Executor.new(app, env, request).execute }

    context 'with valid request' do
      let(:request) { Batcher::Request.new(:post, '/endpoint', { header1: :value1 }, { data: { key1: :value1 } }) }

      it 'returns correct response' do
        expect(subject.status).to eq(200)
        expect(subject.headers).to eq({ 'Content-Type' => 'application/json' })
        expect(subject.body).to eq({ 'key1' => 'value1' })
      end
    end

    context 'with invalid request' do
      let(:request) { Batcher::Request.new(:post, 'invalid endpoint', { header1: :value1 }, { data: { key1: :value1 } }) }

      it 'returns correct response' do
        expect { subject }.to raise_error(URI::InvalidURIError)
      end
    end
  end
end