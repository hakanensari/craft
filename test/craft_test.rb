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

  def test_thread_safety_in_a_rather_janky_way
    urls = %q{Threads are the Ruby implementation for a concurrent programming model}
      .split(' ')
      .map { |keyword|
        Thread.new {
          duck = Home.new
          Thread.current[:current_url] = duck.search(keyword).current_url
        }
      }
      .map(&:join)
      .map { |x| x[:current_url] }

    assert_equal urls, urls.uniq
  end
end
