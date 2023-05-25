class SpotsController < ApplicationController
  before_action :authenticate_user!, except: [:show ,:index]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

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

  def edit
    @spot = Spot.find(params[:id])
  end

  def update
    if @spot.update(spot_params)
      flash[:notice] = "保存しました。"
      redirect_to spots_url
    else
      flash[:alert] = "問題が発生しました。"
      render 'edit'
    end
  end

  def destroy
    @spot = Spot.find(params.require(:id))
    if @spot.destroy
      flash[:notice] = "投稿したスポットを削除しました"
    else
      flash[:alert] = "スポットの削除中に問題が発生しました"
    end
    redirect_to spots_url
  end
  

  private
  def spot_params
    params.require(:spot).permit(:id, :name, :description, :address, :image_name, :user_id)
  end

  def ensure_correct_user
    @spot = Spot.find(params[:id])
    if @spot.user_id != current_user.id
      redirect_to root_path, alert: "他のユーザーの投稿は編集できません"
    end
  end
end
