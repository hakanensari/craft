require 'capybara/poltergeist'
require_relative '../lib/craft'

Craft.driver = :poltergeist

class Page
  include Craft
end
