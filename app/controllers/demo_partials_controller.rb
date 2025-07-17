class DemoPartialsController < ApplicationController
  def new
    @zone = t(".zone")
    @date = Time.zone.today
  end

  def edit
    @zone = t(".zone")
    @date = Time.zone.today - 4
  end
end
