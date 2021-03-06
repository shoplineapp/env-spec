$:.push File.expand_path('../lib', __FILE__)

# Force to load simplecov before requiring any file (say the version file)
if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start 'rails' do
    add_filter 'lib/generators'
  end
end

require 'env-spec/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'env-spec'
  s.version     = EnvSpec::VERSION
  s.authors     = ['Philip Yu']
  s.email       = ['ht.yu@me.com']
  s.homepage    = 'https://shopline.hk'
  s.summary     = 'Environment Variables Manager'
  s.description = 'Standardize and make environment variables work'
  s.license     = 'MIT'

  s.files = Dir["{lib}/**/*", 'MIT-LICENSE', 'README.md']
  s.test_files = Dir['spec/**/*']
  s.require_paths = ['lib']

  s.add_dependency 'rails'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec_junit_formatter'
  s.add_development_dependency 'simplecov'
end
