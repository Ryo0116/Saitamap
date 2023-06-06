class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @spot = Spot.find(params[:spot_id])
    @like = current_user.likes.new(spot_id: @spot.id)
    @like.save
  end

  def destroy
    @spot = Spot.find(params[:spot_id])
    @like = current_user.likes.new(spot_id: @spot.id)
    @like.destroy
  end
end
