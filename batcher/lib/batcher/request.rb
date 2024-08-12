module Batcher
  Request = Struct.new(:method, :url, :headers, :params)
end