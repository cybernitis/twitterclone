class PagesController < ApplicationController

  def index
    @title = 'Welcome'
    @user = User.new
  end
end
