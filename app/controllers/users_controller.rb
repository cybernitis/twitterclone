class UsersController < ApplicationController

  def create
  end

  def show
    @user = User.find(params[:id])
    @title = @user.username
  end
end
