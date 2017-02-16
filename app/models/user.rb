class User < ActiveRecord::Base
  attr_reader :password
  validates :session_token, :user_name, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :password_digest, presence: true

  after_initialize :ensure_session_token

  has_many :cats

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
     BCrypt::Password.new(self.password_digest).is_password?(password)
   end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    #debugger
    return user if user && user.is_password?(password)
    nil
  end

end
