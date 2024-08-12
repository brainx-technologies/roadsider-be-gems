require_relative 'lib/multiple_enum/version'

Gem::Specification.new do |spec|
  spec.name          = "multiple_enum"
  spec.version       = MultipleEnum::VERSION
  spec.authors       = ["Author"]
  spec.email         = ["valllllera@gmail.com"]

  spec.summary       = "Multiple enum for ActiveRecord."
  spec.description   = spec.summary
  spec.homepage      = "/be-gems"
  spec.required_ruby_version = ">= 2.5.0"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 5.0.0"
  spec.add_dependency "activerecord", ">= 5.0.0"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "faker"
end
