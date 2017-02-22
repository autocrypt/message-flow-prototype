class UsersController < ApplicationController
  before_action :set_user
  before_action :set_autocrypt

  def show
  end

  def set_user
    @user = User.new(params[:id])
  end

  def set_autocrypt
    @autocrypt = Autocrypt.new(@user)
  end
end
