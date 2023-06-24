class LikesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @spot = Spot.find(params[:id])
    Like.create(user_id: current_user.id, spot_id: @spot.id)
  end

  def destroy
    @spot = Spot.find(params[:id])
    like = Like.find_by(user_id: current_user.id, spot_id: @spot.id)
    like.destroy if like
  end
end

