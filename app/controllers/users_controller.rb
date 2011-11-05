class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

  def show
    @user = User.find(params[:id])
    @title = @user.username
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "Welcome to the Twitter!" }
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit profile"
  end

  def update
    @user = User.find(params[:id])
    @title = "Edit profile"
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Your profile has been updated." }
    else
      flash.now[:error] = "Please fill in all required fields."
      render 'edit'
    end
  end

  private
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
        
end
