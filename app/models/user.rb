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

  attr_accessor :remember_token

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

  def authenticated? remember_token
    return false if remember_digest.blank?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
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
end
