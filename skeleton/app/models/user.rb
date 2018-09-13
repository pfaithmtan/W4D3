# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  password_digest :string           not null
#  session_token   :string           not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :username, presence: true, uniqueness: true
  validates :session_token, uniqueness: true
  validates :password_digest, presence: true
  
  after_initialize :ensure_session_token
  
  attr_reader :password
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    
    user && user.is_password?(password) ? user : nil
  end
  
  def password=(pw)
    @password = pw
    
    self.password_digest = BCrypt::Password.create(pw) # Stores to DB
  end
  
  def is_password?(pw)
    # self.password_digest == BCrpyt::Password.new(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw) 
  end
  
  
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64 # Stores to DB if not already generated
  end
  
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save! 
    self.session_token
  end
  
end
