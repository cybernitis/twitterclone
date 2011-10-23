require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      response.should be_success
    end

    it "have the right title" do
      get :index
      response.should have_selector('title', :content => "Welcome")
    end
  end
end

def hello
  puts "World"
end

if hello
  puts :hell
else
  puts :yeah
end
