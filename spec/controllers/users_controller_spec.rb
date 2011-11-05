require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
    before :each do
      @user = Factory :user
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
        @attr = { :username => "", :email => "", :password => "", :password_confirmation => "" }
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

  describe "GET 'edit'" do
    before :each do
      @user = Factory :user
      test_sign_in @user
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => "Edit profile")
    end
  end

  describe "PUT 'update'" do

    before :each do
      @user = Factory :user
      test_sign_in @user
    end

    describe "failure" do
      
      before :each do
        @attr = {
          :username => "",
          :name => "",
          :email => "",
          :password => "",
          :password_confirmation => ""
        }
      end

      it "should have to right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector('title', :content => "Edit profile")
      end

      it "should render the 'update' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have an error message" do
        put :update, :id => @user, :user => @attr
        flash[:error].should =~ /please fill in all required fields/i
      end
      
      it "should not update the user" do
        put :update, :id => @user, :user => @attr
        @user.name.should_not == @attr[:name]
      end
    end

    describe "success" do
      before :each do
        @attr = { 
          :username => "username",
          :email    => "user@name.com",
          :password => "password",
          :password_confirmation => "password",
          :name     => "User Name"
        }
      end

      it "should update the user" do
        put :update, :id => @user, :user => @attr
        user = assigns :user
        @user.reload
        @user.username.should == user.username
        @user.name.should == user.name
        @user.email.should == user.email
        @user.encrypted_password.should == user.encrypted_password
      end

      it "should redirect to show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have an success message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /your profile has been updated/i
      end
    end
  end

  describe "authentication of edit/update actions" do
    
    before :each do
      @user = Factory :user
    end

    it "should deny acces to 'edit'" do
      get :edit, :id => @user
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'update'" do
      put :update, :id => @user, :user => {}
      response.should redirect_to(signin_path)
    end

    describe "for signed-in users" do

      before :each do
        user = Factory(:user, :username => "example", :email => "indiche@example.net")
        test_sign_in(user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end
end
