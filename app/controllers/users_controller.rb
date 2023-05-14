class UsersController < ApplicationController
  skip_before_action :reauthenticate_user!, only: [:index]

  def index; end
end