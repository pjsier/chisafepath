require 'rails_helper'

RSpec.describe HomeController, :type => :controller do
  describe "#index" do
    it "shows the main page" do
      get :index
      expect(response).to be_ok
    end
  end

  describe "#issue" do
    it "shows the issue submission page" do
      get :issue
      expect(response).to be_ok
    end
  end

  describe "#map_page" do
    it "displays the map page" do
      get :map_page
      expect(response).to be_ok
    end
  end

  describe "#routing" do
    it "displays the routing page" do
      get :routing
      expect(response).to be_ok
    end
  end

  describe "#submitted" do
    it "displays the submitted page" do
      get :submitted
      expect(response).to be_ok
    end
  end
end
