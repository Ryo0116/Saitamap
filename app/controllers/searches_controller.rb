class SearchesController < ApplicationController
  before_action :authenticate_user!, except: [:search]

  def search
    if params[:keyword].present?
      @spots = Spot.where(["name LIKE? OR description LIKE? OR address LIKE?", "%#{params[:keyword]}%", "%#{params[:keyword]}%", "%#{params[:keyword]}%"])
    elsif params[:area].present?
      @spots = Spot.where(["address like?","%#{params[:area]}%"])
    end
  end
end
