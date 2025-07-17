class StaticPagesController < ApplicationController
  def home; end

  def help; end

  def contact
    @name = "Hưng"
  end
end
