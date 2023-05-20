class SpotsController < ApplicationController
  protect_from_forgery
  before_action :authenticate_user!, except: [:show ,:index]

  def index
    @spots = Spot.all
  end

  def new
    @spot = current_user.spots.build
  end

  def create
    @spot = current_user.spots.build(spot_params)
    if @spot.save
      redirect_to spots_url, notice: "保存しました。"
    else
      flash[:alert] = "問題が発生しました。"
      render :new
    end
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def update
    new_params = spot_params
    new_params = spot_params.merge(active: true) if is_ready_spot
    if @spot.update(new_params)
      flash[:notice] = "保存しました。"
    else
      flash[:alert] = "問題が発生しました。"
    end
    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy
    flash[:notice] = "投稿したスポットを削除しました"
    redirect_to :spots_posts
  end

  private
  def spot_params
    params.require(:spot).permit(:id, :name, :description, :address, :image_name, :user_id)
  end
end
