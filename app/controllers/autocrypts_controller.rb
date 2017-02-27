class AutocryptsController < ApplicationController
  before_action :set_user
  before_action :set_autocrypt

  def show
  end

  def update
    @autocrypt.init
    redirect_to action: :show
  end

  def set_user
    @user = User.new(params[:user_id])
  end

  def set_autocrypt
    @autocrypt = Autocrypt.new(@user)
  end
end
