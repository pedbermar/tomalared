class UserSessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
    @usernew = User.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    @usernew = User.new
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to '/'
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to '/login'
  end
end

