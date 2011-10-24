class User < ActiveRecord::Base
  attr_accessible :username, :email

  validates :username, :presence  => true,
                       :length    => { :maximum => 50 },
                       :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true,
                    :format   => { :with => /^[\w.+\-]+@[a-z\d.]+\.[a-z]+$/i },
                    :uniqueness => { :case_sensitive => false }
end
