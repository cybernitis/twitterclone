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
      response.should have_selector('div', :content => @user.username, :class => "meta")
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector('img', :class => 'gravatar')
    end
  end

  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Sign up")
    end
  end

  describe "POST 'create'" do
    
    describe "failure" do
      
      before :each do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => "" }
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector('title', :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      
      before :each do
        @attr = { :username => "example", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar", :name => "Example User" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the twitter/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end

  describe "PUT 'update'" do

    describe "failure" do
      before :each do
        @user = Factory :user
        @attr = { :username => "example", :email => "user@example.com", :name => "Example User" }
      end

      it "should have to right title" do
        post :update, :id => @user
        response.should have_selector('title', :content => "Update profile")
      end

      it "should render the 'update' page" do
        post :update, :id => @user
        response.should render_template('edit')
      end
      
      it "should not update the user" do
        put :update, :id => @user, :user => @attr
        @user.name.should_not == @attr[:name]
      end
    end

    describe "success" do
      before :each do
        @user = Factory :user
        @attr = { :username => "foobar", :email => "foo@bar.com", :password => "foobar", :password_confirmation => "foobar", :name => "Foo Bar" }
      end

      it "should update the user" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
      end

      it "should redirect to show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have an success message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /your profile has been updated!/i
      end
    end
  end

end
