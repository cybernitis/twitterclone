require 'spec_helper'

describe User do
  before :each do
    @attr = { :username => "Foobar", :email => "foo@bar.com" } 
  end

  it "should create a new user" do
    User.create!(@attr)
  end

  it "should require a username" do
    user = User.new(@attr.merge(:username => ""))
    user.should_not be_valid
  end

  it "should require an email" do
    user = User.new(@attr.merge(:email => ""))
    user.should_not be_valid
  end

  it "should reject too long usernames" do
    username = "F" * 51 
    user = User.new(@attr.merge(:username => username))
    user.should_not be_valid
  end

  it "should accept valid email" do
    emails = %w[user@example.com FOO@BAR.ORG example.user@foo.bar.com]
    emails.each do |email|
      user = User.new(@attr.merge(:email => email))
      user.should be_valid
    end
  end

  it "should reject invalid email" do
    emails = %w[user@example,com FOO_AT_BAR.ORG example.user@foo]
    emails.each do |email|
      user = User.new(@attr.merge(:email => email))
      user.should_not be_valid
    end
  end

  it "shoud reject duplicate username" do
    User.create!(@attr)
    user = User.new(@attr)
    user.should_not be_valid
  end

  it "should reject usernames identical up to case" do
    username = "FOOBAR"
    User.create!(@attr)
    user = User.new(@attr.merge(:username => username))
    user.should_not be_valid
  end

  it "shoud reject duplicate email" do
    User.create!(@attr)
    user = User.new(@attr)
    user.should_not be_valid
  end

  it "should reject emails identical up to case" do
    email = @attr[:email].upcase
    User.create!(@attr.merge(:email => email))
    user = User.new(@attr)
    user.should_not be_valid
  end
end
