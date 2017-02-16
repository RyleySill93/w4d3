class UsersController < ApplicationController
  before_action :require_no_user, only: [:create, :new]

  def new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      login(@user)
      #redirect to session????
      redirect_to cats_url
    else
      flash.now[:messages]= @user.errors.full_messages
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
