require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
    before :each do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_succes
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector('title', :content => @user.username)
    end

    it "should have the user's name" do
      get :show, :id => @user
      response.should have_selector('h2', :content => @user.username)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector('img', :class => 'gravatar')
    end
  end

  describe "GET 'new'" do
  end

end
