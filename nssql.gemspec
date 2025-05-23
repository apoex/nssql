# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nssql/version'

Gem::Specification.new do |spec|
  spec.name          = 'nssql'
  spec.version       = NSSQL::VERSION
  spec.authors       = ['Love Ottosson']
  spec.email         = ['love.ottosson@apoex.se']

  spec.summary       = 'Lightweight gem for fetching data from NetSuite with SQL.'
  spec.description   = 'Represent NetSuite tables as you want and fetch only the needed data.'
  spec.homepage      = 'https://github.com/apoex/nssql'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/apoex/nssql'
    spec.metadata['changelog_uri'] = 'https://github.com/apoex/nssql/blob/master/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ruby-odbc', '~> 0.999991'
  spec.add_runtime_dependency 'faraday', '~> 1.10'

  spec.add_development_dependency 'bundler', '>= 1.17', '< 3'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rubocop', '>= 0.60.0'
  spec.add_development_dependency 'simplecov', '~> 0.17.1'
  spec.add_development_dependency 'mocha', '~> 2.7.1'
end
