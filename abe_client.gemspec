require File.expand_path('../lib/abe_client/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = "abe_client"
  s.description   = %q{A client library for talking to the aTech blogging engine}
  s.summary       = s.description
  s.homepage      = "https://github.com/adamcooke/abe_client"
  s.version       = AbeClient::VERSION
  s.files         = Dir.glob("{lib}/**/*")
  s.require_paths = ["lib"]
  s.authors       = ["Adam Cooke"]
  s.email         = ["me@adamcooke.io"]
  s.licenses      = ['MIT']
  s.add_dependency "graphql-client", ">= 0.16.0"
  s.add_development_dependency "rake"
end
