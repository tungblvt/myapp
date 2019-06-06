class User < ApplicationRecord
  attr_accessor :remember_token
  has_many :microposts

  before_save { email.downcase! }

  validates :name, presence: true, length: { maximum: Settings.validates.name.lenght }
  VALID_EMAIL_REGEX = Settings.validates.email.regex
  validates :email, presence: true, length: { maximum: Settings.validates.email.lenght }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: Settings.validates.password.lenght.minimum }
  validates :password_confirmation, presence: true, length: { minimum: Settings.validates.password.lenght.minimum }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update :remember_token
  end
end
