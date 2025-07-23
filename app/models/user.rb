class User < ApplicationRecord
  has_secure_password

  USER_PERMIT = %i(name email password password_confirmation birthday
gender).freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  enum gender: {female: 0, male: 1, other: 2}

  validates :name, presence: true,
  length: {maximum: Settings.defaults.user.max_name_length}
  validates :email, presence: true, length:
                    {maximum: Settings.defaults.user.max_email_length},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validate :birthday_must_be_within_allowed_range

  before_save :downcase_email

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
