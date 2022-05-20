
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "oreilly_api/version"

Gem::Specification.new do |spec|
  spec.name          = "oreilly_api"
  spec.version       = OreillyApi::VERSION
  spec.authors       = ["TruptiHosmani"]
  spec.email         = ["dev@yourmechanic.com"]

  spec.summary       = "Gem to integrate O'Reilly Auto Parts Rest API"
  spec.description   = "This gem provides a simple way to integrate O'Reilly Auto Parts Rest Apis"
  spec.homepage      = "https://github.com/YourMechanic/oreilly_api"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/YourMechanic/oreilly_api"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 2.2.8'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.7'
  spec.add_dependency 'byebug'
  spec.add_dependency 'redis'
  spec.add_dependency 'redis_utility'
  spec.add_dependency 'rest-client'
  spec.add_dependency 'yajl-ruby'
  spec.add_development_dependency 'multi_json'
end
