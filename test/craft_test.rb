require 'minitest/autorun'
require 'capybara/poltergeist'
require 'craft'

Craft.driver = :poltergeist

class Home
  include Craft

  def initialize
    visit('http://www.duckduckgo.com')
  end

  def search(query)
    fill_in('q', with: query)
    click_on('search_button_homepage')

    Search.new
  end
end

class Search
  include Craft

  def results
    all('.results_links_deep')
  end
end

class TestCraft < Minitest::Test
  def test_browser
    duck = Home.new
    search = duck.search('ruby')

    refute_empty search.results
  end

  def test_session
    thrs = %w(ruby python)
      .map { |query|
        Thread.new {
          Thread.current[:current_url] = Home.new.search(query).current_url
        }
      }
      .map(&:join)

    refute_equal thrs.first[:current_url], thrs.last[:current_url]
  end
end

