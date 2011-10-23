class User < ActiveRecord::Base
  attr_accessible :username, :email

  validates :username, :presence => true
  validates :email, :presence => true
end
