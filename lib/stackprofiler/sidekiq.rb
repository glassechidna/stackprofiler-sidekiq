require 'net/http'
require 'stackprofx'

module Stackprofiler
  module Sidekiq
    class Middleware
      def initialize opts={}
        @options = opts
        @predicate = opts[:predicate] || proc { true }
      end

      def call worker, job, queue, &blk
        opts = {mode: :wall, raw: true, threads: [Thread.current] }.merge @options

        if @predicate.call worker, job, queue
          profile = StackProfx.run(opts) { blk.call }

          klass, jid = job.values_at 'class', 'jid'
          profile[:suggested_rebase] = "#{klass}#perform"
          profile[:name] = "Sidekiq:#{klass}:#{jid}"

          Thread.new { send_profile profile }
        else
          blk.call
        end
      end

      def send_profile profile
        url = URI::parse ui_url
        headers = {'Content-Type' => 'application/x-ruby-marshal'}
        req = Net::HTTP::Post.new(url.to_s, headers)
        req.body = Marshal.dump profile

        response = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
      end

      def ui_url
        @options[:ui_url] || ENV['STACKPROFILER_UI_URL']
      end
    end
  end
end
