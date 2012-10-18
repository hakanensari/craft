# Craft

Craft XML and HTML into objects.

## Example
```ruby
require 'craft'
require 'open-uri'

class Page < Craft
  one   :title,   'title'
  many  :links,   'a',    lambda { |a| a.attr('href') }
end

page = Page.parse open('http://www.google.com')

page.title #=> 'Google'
page.links #=> ['http://www.google.com/imghp?hl=en&tab=wi', ...]
```
