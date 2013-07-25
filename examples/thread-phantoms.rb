# Trapping TTIN falls on deaf ears. Perhaps some hints at troubleshooting here:
#
# https://github.com/mperham/sidekiq/issues/1037
#
require_relative 'page'

10.times
  .map { |n|
    Thread.new {
      page = Page.new
      page.visit('http://slowapi.com/delay/0.1')
      STDOUT.puts page.text
    }
  }
  .map(&:join)
