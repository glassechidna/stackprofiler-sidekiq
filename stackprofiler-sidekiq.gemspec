# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'stackprofiler-sidekiq'
  spec.version       = '0.0.2'
  spec.authors       = ['Aidan Steele']
  spec.email         = ['aidan.steele@glassechidna.com.au']
  spec.summary       = %q{Sidekiq middleware for low-overhead profiling of background jobs.}
  spec.homepage      = 'https://github.com/glassechidna/stackprofiler-sidekiq'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'stackprofx', '~> 0.2'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
