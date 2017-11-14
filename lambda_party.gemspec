
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lambda_party/version"

Gem::Specification.new do |spec|
  spec.name          = "lambda_party"
  spec.version       = LambdaParty::VERSION
  spec.authors       = "Michael Novi"
  spec.email         = "mike@revboss.com"

  spec.summary       = %q{A gem that extends HTTParty to provide AWS Sigv4 signing to requests.}
  spec.description   = %q{A gem that extends HTTParty to provide AWS Sigv4 signing to requests.}
  spec.homepage      = "https://github.com/mikenovi/lmabda_party"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.15.6"
  spec.add_dependency "aws-sigv4", "~> 1.0.2"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end