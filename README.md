# Craft

Craft XML and HTML into objects.

## Example
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
end

page = Page.parse open('http://www.google.com')

page.title #=> 'Google'
page.links #=> ['http://www.google.com/imghp?hl=en&tab=wi', ...]
page.images #=> ['/LOGOS/2012/MOBY_DICK12-HP.JPG']
```
