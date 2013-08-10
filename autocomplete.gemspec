# Maintain your gem's version:
#require "autocomplete/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "autocomplete"
  s.version     =  "0.0.1"
  s.authors     = "Kingston"
  s.email       = "kingston@kreatio.com"
#  s.homepage    = "TODO"
  s.summary     = "autocomplete based on rails 3 and jQuery"
  s.description = "Description of KreatioCore"

  s.files = Dir["{lib}/**/*"] + ["README.rdoc"]

  s.add_dependency "rails", "~> 3.1.3"
  # s.add_dependency "jquery-rails"
end
