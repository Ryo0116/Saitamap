class UsersController < ApplicationController
  def profile
    @user = current_user
  end

  before_action :authenticate_user!

  def update
    @user = current_user
    if @user.update_attributes(current_user_params)
      flash[:notice] = "保存しました"
    else
      flash[:alert] = "更新できません"
    end
    redirect_to root_path
  end

  private
  
  def current_user_params
    params.require(:user).permit(:image_name, :name, :email)
  end
end
