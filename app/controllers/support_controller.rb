class SupportController < ApplicationController
  def landing
    render :landing, :layout => "application"
  end

  def acknowledge
    render :acknowledge, :layout => "application"
  end
end
