module Blueprint
  Attribute = Struct.new(:name, :blueprint, :optional, :preloader, :reader, :if, :unless, :options)
end