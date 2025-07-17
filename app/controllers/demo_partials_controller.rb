class DemoPartialsController < ApplicationController
  def new
    @zone = "Zone New action"
    @date = Time.zone.today
  end

  def edit
    @zone = "Zone New action"
    @date = Time.zone.today - 4
  end
end
