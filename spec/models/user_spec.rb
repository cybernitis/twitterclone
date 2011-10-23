require 'spec_helper'

describe User do
  it "should create a new user" do
    User.create!(:username => "Foobar", :email => "foo@bar.com")
  end

  it "should require a username" do
    user = User.new(:email => "foo@bar.com")
    user.should_not be_valid
  end

  it "should require an email" do
    user = User.new(:username => "Foobar")
    user.should_not be_valid
  end
end
