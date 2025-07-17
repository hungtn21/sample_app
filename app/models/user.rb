class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

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

    max_years = Settings.defaults.user.max_age_years
    if birthday < max_years.years.ago.to_date || birthday > Time.zone.today
      errors.add(:birthday, :birthday_year_validation, count: max_years)
    end
  end
end
