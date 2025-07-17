module UsersHelper
  def gender_options_for_select
    [
      [t(".gender_female"), :female],
      [t(".gender_male"), :male],
      [t(".gender_other"), :other]
    ]
  end

  def gravatar_for user, options = {size: Settings.defaults.user.gravatar_size}
    return if user.email.blank?

    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
