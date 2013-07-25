require_relative 'page'

10.times {
  fork {
    page = Page.new
    page.visit('http://slowapi.com/delay/0.1')
    STDOUT.puts page.text
  }
}

Process.waitall
