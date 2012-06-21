$:.push File.expand_path("../lib", __FILE__)

require "pipedrive/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pipedrive"
  s.version     = Pipedrive::VERSION
  s.authors     = ["Paul Ser"]
  s.email       = ["pashka4281@gmail.com"]
  s.summary     = "Pipedrive.com API wrapper gem."
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  #s.add_dependency "rails", "~> 3.2.3"
  #
  #s.add_development_dependency "sqlite3"
end
