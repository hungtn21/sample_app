class StaticPagesController < ApplicationController
  # GET /static_pages/home
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed.newest,
                              items: Settings.defaults.user.items_per_page
  end

  # GET /static_pages/help
  def help; end

  # GET /static_pages/contact
  def contact; end
end
