class AutocryptsController < ApplicationController
  before_action :set_user
  before_action :set_autocrypt

  def show
  end

  def create
    @autocrypt.init
    redirect_to action: :show
  end

  def update
    @autocrypt.prefer_encrypt = prefer_encrypt_param
    redirect_to action: :show
  end

  protected

  def set_user
    @user = User.new(params[:user_id])
  end

  def set_autocrypt
    @autocrypt = Autocrypt.new(@user)
  end

  def prefer_encrypt_param
    params.require(:autocrypt).require(:prefer_encrypt)
  end
end
