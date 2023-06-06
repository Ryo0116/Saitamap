class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :spot_params

  def create
    Like.create(user_id: current_user.id, spot_id: params[:id])
  end

  def destroy
    Like.find_by(user_id: current_user.id, post_id: params[:id]).destroy
  end

  private

  def spot_params
    @spot = Spot.find(params[:id])
  end
end
