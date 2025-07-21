class ApplicationController < ActionController::Base
  before_action :set_locale

  private

  def set_locale
    if params[:locale].present? && I18n.available_locales.map(&:to_s).include?(params[:locale])
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
