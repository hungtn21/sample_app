class User < ApplicationRecord
  has_secure_password

  USER_PERMIT = %i(name email password password_confirmation birthday
gender).freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  enum gender: {female: 0, male: 1, other: 2}

  validates :name, presence: true, length:
                    {maximum: Settings.defaults.user.max_name_length}
  validates :email, presence: true, length:
                    {maximum: Settings.defaults.user.max_email_length},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validate :birthday_must_be_within_allowed_range
  validates :password, presence: true, length:
                    {minimum: Settings.defaults.user.min_password_length},
                    allow_nil: true
  before_save :downcase_email

  attr_accessor :remember_token, :activation_token, :reset_token

  before_create :create_activation_digest
  before_save :downcase_email

  scope :recent, -> {order(created_at: :desc)}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.defaults.user.password_reset_expiration.hours.ago
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def send_password_reset_confirmation_email
    UserMailer.password_reset_confirmation(self).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end

  def birthday_must_be_within_allowed_range
    return if birthday.blank?

    max_years = Settings.defaults.user.birthday_year_limit
    if birthday < max_years.years.ago.to_date || birthday > Time.zone.today
      errors.add(:birthday, :birthday_year_validation, count: max_years)
    end
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
