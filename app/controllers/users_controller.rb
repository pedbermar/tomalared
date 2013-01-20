class UsersController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @user_session = UserSession.new
    @usernew = User.new
  end

  def create
    @user_session = UserSession.new    
    @usernew = User.new(params[:user])
    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    if @usernew .save_without_session_maintenance 
      @usernew.send_activation_instructions!
      flash[:notice] = "Tu cuenta ha sido creada. Por favor mira tu e-mail para ver las instrucciones de activacion!"
      redirect_to '/login'
    else
      flash[:notice] = "Hubo un problema creando tu usuario."
      render :action => :new
    end
  end

  def activate
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)

    raise Exception if @user.active?

    if @user.activate!
      UserSession.create(@user, false)
      @user.send_activation_confirmation!
      redirect_to account_url
    else
      render :action => :new
    end
  end

  def show
      redirect_to "/post/list/"
  end

  def edit
    @po = Post.new
    @user = User.find(current_user[:id])
  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Tu cuenta ha sido actualizada!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
 #
  # user handling
  #

  # see if the poor user is authorized
  def authorize
    #redirect_to :controller => 'admin', :action => 'login' unless logged_in?
  end

  # certain actions only the big man can perform
  def admin_user_only
    #redirect_to :controller => 'admin', :action => 'password' unless is_admin_user?
  end

  # the big man
  def is_admin_user?
    (logged_in? && current_user[:id] == User::ADMIN_USER_ID)
  end

  # user list
  def users
    @users = User.find(:all, :order => 'id ASC')
  end
  
  def list
    @users = User.find(:all, :order => 'id ASC')
  end

  # ajaxly rename a user
  def rename_user
    if request.post?
      user = User.find(params[:user_id])
      user.name = params[:user_name]
      user.save
      render :text => user.name
    end
  end

  # up and delete a user
  def delete_user
    user_id = params[:id]
    user = User.find(user_id)

    flash[:notice] = begin
                       user.destroy
                       Post.chown_posts(user_id,User::ADMIN_USER_ID)
                       "Usuario Borrado."
                     rescue CantDestroyAdminUser
                       "No puede borrar al admin :("
                     end

    redirect_to :action => :users
  end

  def updatefoto
   if request.post?
					File.open("public/img/#{current_user[:id]}.jpg", "wb") do |file|
						  file << open(params[:user_pic]).read
					 end
       end
     redirect_to :action => 'show'
   end

  def updatedatos
      user = User.find(current_user[:id])
      user.name = params[:name]
      user.email = params[:email]
      user.save
      redirect_to :action => 'show'
  end
end

