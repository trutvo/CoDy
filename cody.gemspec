require_relative 'lib/cody'

Gem::Specification.new do |s|
  s.name         = 'cody'
  s.version      = CoDy::VERSION
  s.summary      = "CoDy"
  s.description  = "This is an app to write a coding diray for a git repository."
  s.authors      = ["Thomas Volk"]
  s.email        = 'thomas.volk@trustedshops.com'
  s.homepage     = 'https://github.com/trutvo/CoDy'
  s.license      = 'Apache-2.0'
  s.files        = Dir.glob("{lib,bin}/**/*")
  s.require_path = 'lib'
  s.bindir       = 'bin'
  s.executables  = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
end