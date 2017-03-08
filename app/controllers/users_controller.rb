class UsersController < ApplicationController

  def create
    redirect_to user_emails_path(params.require(:user).require(:name))
  end

end
