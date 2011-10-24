require 'spec_helper'

describe User do
  before :each do
    @attr = {
        :username => "Foobar",
        :email    => "foo@bar.com",
        :password => "foobar",
        :password_confirmation => "foobar"
    } 
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

  describe "passwords" do
    before :each do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end
    
    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
    
    describe "password validations" do
      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confiramtion => "")).should_not be_valid
      end

      it "should require a matching password confirmation" do
        User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
      end
      
      it "should reject short passwords" do
        password = "a" * 5
        hash = @attr.merge(:password => password, :password_confirmation => password)
        User.new(hash).should_not be_valid
      end

      it "should reject long passwords" do
        password = "F" * 13
        hash = @attr.merge(:password => password, :password_confirmation => password)
        User.new(hash).should_not be_valid
      end
    end

    describe "password encryprion" do
      before :each do
        @user = User.create!(@attr)
      end
    
      it "should set the encrypted password attribute" do
        @user.encrypted_password.should_not be_blank
      end

      it "should have an encrypted password attribute" do
        @user.should respond_to(:encrypted_password)
      end

      it "should have a salt" do
        @user.should respond_to(:salt)
      end

      describe "has_password? method" do
        it "should exist" do
          @user.should respond_to(:has_password?) 
        end

        it "should return true if the passwords match" do
          @user.has_password?(@attr[:password]).should be_true
        end

        it "should return false if the passwords do not match" do
          @user.has_password?("password").should be_false
        end
      end

      describe "authenticate method" do

        it "should exist" do
          User.should respond_to(:authenticate)
        end

        it "should return nil on email/password mismatch" do
          User.authenticate(@attr[:username], :password => "password").should be_nil
        end

        it "should return user on username/password match" do
          User.authenticate(@attr[:username], @attr[:password]).should == @user
        end
      end
    end
  end
end









