class SessionController < ApplicationController
  # before_action: :current_user, only: [:destroy]
  before_action :require_no_user, only: [:new, :create]



  def new
    render :new
  end

  def create

    @user = User.find_by_credentials(session_params[:user_name], session_params[:password])
    if @user
      @user.reset_session_token!
      login(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = ["user login error"]
      render :new
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to cats_url
  end

  private
  def session_params
    params.require(:session).permit(:user_name, :password)
  end
end
