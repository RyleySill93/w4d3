class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def require_owner
    @cat = Cat.find(params[:id])
    redirect_to cats_url unless @cat.user_id == current_user.id

  end
  
  def require_no_user
    redirect_to cats_url if current_user
  end

  def current_user
    User.find_by( session_token: session[:session_token] )
  end

  def login(user)
    session[:session_token] = user.session_token
  end
end
