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
  end

  describe "GET 'new'" do
  end

end
