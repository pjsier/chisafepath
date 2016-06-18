class HomeController < ApplicationController
  def index
  end

  def about
    render "about"
  end

  def map_page
    render "map"
  end

  def submitted
    render "submitted"
  end

  def routing
    render "routing", layout: false
  end

end
