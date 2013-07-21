require 'capybara'

module Craft
  include Capybara::DSL

  class << self
    attr_accessor :driver

    def session
      Thread.current[:session] ||= Capybara::Session.new(driver)
    end
  end

  def page
    Craft.session
  end
end
