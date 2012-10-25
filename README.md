# Craft

[![Build Status][1]][2]
[![Code Climate][3]][4]

Craft XML and HTML into objects.

## Examples
```ruby
require 'craft'
require 'open-uri'

class Page < Craft
  # Use CSS selectors
  one   :title,   'title'

  # Use XPath
  many  :links,   'a/@href'

  # Perform transforms on returned nodes
  many  :images,  'img', lambda { |img| img.attr('src').upcase }

  # Stub attributes that don't need to be parsed
  stub :spidered_at, lambda { Time.now }
end

page = Page.parse open('http://www.google.com')

page.title #=> 'Google'
page.links #=> ['http://www.google.com/imghp?hl=en&tab=wi', ...]
page.images #=> ['/LOGOS/2012/MOBY_DICK12-HP.JPG']

page.attributes #=> { :title => 'Google', :links => ... }

class Script < Craft
  one :body, 'text()'
end

class Page < Craft
  many :scripts, 'script', Script
end

page = Page.parse open('http://www.google.com')
page.scripts[0].body #=> 'window.google=...'
```

[1]: https://secure.travis-ci.org/papercavalier/craft.png
[2]: http://travis-ci.org/papercavalier/craft
[3]: https://codeclimate.com/badge.png
[4]: https://codeclimate.com/github/papercavalier/craft
