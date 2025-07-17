class DemoPartialsController < ApplicationController
  # GET /demo_partials/new
  def new
    @zone = t(".zone")
    @date = Time.zone.today
  end

  # GET /demo_partials/:id/edit
  def edit
    @zone = t(".zone")
    @date = Time.zone.today - 4
  end
end
