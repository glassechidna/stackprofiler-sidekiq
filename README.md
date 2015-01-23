# Stackprofiler::Sidekiq

Please read the [`stackprofiler`][1] gem README for background on Stackprofiler
in general.

This is a [Sidekiq][2] middleware that makes benchmarking of Sidekiq apps a breeze.
It utilises a fork of the the brilliant [`stackprof`][3] to enable low-overhead
sampling of Ruby processes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stackprofiler-sidekiq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stackprofiler-sidekiq

## Usage

[Sidekiq middleware][4] are helpers that can be included in your background jobs.
The Stackprofiler middleware is `Stackprofiler::Sidekiq::Middleware`. It can be
configured like this:

```ruby
require 'stackprofiler/sidekiq'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Stackprofiler::Sidekiq::Middleware, {
      ui_url: 'http://localhost:9292/receive',
      predicate: proc do |worker, job, queue|
        job['class'] == 'MyBackgroundJob'
      end
    }
  end
end
```

The `:ui_url` option is a URL that points to a running instance of the
Stackprofiler web UI. It is mandatory. Refer to the Stackprofiler gem README
to see how to run this (hint, run `stackprofiler` in the terminal).

The `:predicate` option is optional. By default, the middleware will profile
*every* Sidekiq job. This might be undesirable because you want to focus on
only one problematic job and filter out the others. The parameter is a proc
object that receives the same arguments as Sidekiq middleware - see the above
link to determine what these are. Returning a truthy value will have the job
profiled, otherwise it is ignored.

## Contributing

1. Fork it ( https://github.com/glassechidna/stackprofiler-sidekiq/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[1]: https://github.com/glassechidna/stackprofiler
[2]: https://github.com/mperham/sidekiq
[3]: https://github.com/tmm1/stackprof
[4]: https://github.com/mperham/sidekiq/wiki/Middleware
