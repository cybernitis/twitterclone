class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:username],
                             params[:session][:password])
    if user.nil?
      @title = "Sign in"
      flash.now[:error] = "Invalid email/password combination."
      render 'new'
    else
      sign_in user
      redirect_to user, :flash => {:success => "Welcome back!"}
    end
  end

  def destroy
  end
end
