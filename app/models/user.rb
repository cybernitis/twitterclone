class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :username, :email, :password, :password_confirmation, :name

  validates :username, :presence   => true,
                       :length     => { :maximum => 50 },
                       :uniqueness => { :case_sensitive => false }

  validates :email, :presence   => true,
                    :format     => { :with => /^[\w.+\-]+@[a-z\d.]+\.[a-z]+$/i },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..12 }

  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  class << self
    def authenticate(username, submitted_password)
      user = find_by_username(username)
      (user && user.has_password?(submitted_password)) ? user : nil
    end

    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)  
    end
  end
