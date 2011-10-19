require 'spec_helper'

describe PagesController do

  describe "GET 'index'" do
    
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should have a non-blank body" do
      get 'index'
      response.body.should_not =~ /<body>\s*<\/body>/
    end
  end
end
