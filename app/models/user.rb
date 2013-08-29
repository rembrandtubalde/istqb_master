class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  has_many :attempts, dependent: :destroy
  
  before_save do 
	self.email = email.downcase 
  end
  
  before_create do
    create_remember_token
  end
  
  validates :name, presence:true, length: { maximum: 50 }
  validates :email, presence:true, format: { with: VALID_EMAIL_REGEX },                  uniqueness: { case_sensitive: false }
  
    
  has_secure_password
  validates :password, presence:true, length: { minimum: 6 }
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

	  def create_remember_token
		self.remember_token = User.encrypt(User.new_remember_token)
	  end

end
