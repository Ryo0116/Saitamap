class UsersController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index; end

  private
  def require_login
    unless logged_in?
      redirect_to login_url
    end
  end
end