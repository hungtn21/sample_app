class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: Settings.defaults.micropost.display_size
  end

  PERMITTED_ATTRIBUTES = %i(content image).freeze
  
  scope :newest, -> {order(created_at: :desc)}

  validates :content, presence: true,
length: {maximum: Settings.defaults.micropost.max_content_length}
  validates :image, content_type: {
                      in: Settings.defaults.micropost.image_types,
                      message: I18n.t("errors.messages.invalid_image_type")
                    },
            size: {
              less_than: Settings.defaults.micropost.max_image_size.megabytes,
              message: I18n.t("errors.messages.file_too_large",
                              count: Settings.defaults.micropost.max_image_size)
            }
end
