Gem::Specification.new do |spec|
  spec.name          = "faceit-ruby"

  spec.version       = "3.1.7"
  spec.authors       = ["Kalle Lundgren"]
  spec.email         = ["kalle@saits.se"]

  spec.summary       = %q{Ruby client for the Faceit API and ready.}
  spec.homepage      = "https://github.com/kallelundgren93/faceit-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", "~> 2.7"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "vcr", "~> 3.0"
end
