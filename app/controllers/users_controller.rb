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
    if params[:accept]      
      # Saving without session maintenance to skip
      # auto-login which can't happen here because
      # the User has not yet been activated
      if @usernew.save_without_session_maintenance 
        @usernew.send_activation_instructions! 
        flash[:notice] = "Tu cuenta ha sido creada. Por favor mira tu e-mail para ver las instrucciones de activacion!"
        render :action => :new
      else
        flash[:error] = "Hubo un problema creando tu usuario."
        render :action => :new
      end
    else
        flash[:error] = "Debe aceptar las condiciones."
        render :action => :new
    end
  end


  # up and delete a user
  def delete_user
    if params[:email] == current_user[:email]  
      user = User.find(current_user[:id])      
      user.destroy
      flash[:notice] = "Usuario Borrado."
      redirect_to '/'
    else
      flash[:error] = "Tienes que introducir tu email para verificar que quieres borrar la cuenta."
      redirect_to '/home#cuenta'
    end
    
  end

  def show
      redirect_to "/post/list/"
  end
  
   def crop
    @po = Post.new
    @user = User.find(current_user[:id])
  end

  def edit
    @po = Post.new
    @user = User.find(current_user[:id])
  end

  def update
    @po = Post.new    
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Tu cuenta ha sido actualizada!"
      not_conf = NotificationsConfig.new
      not_conf.user_id = current_user[:id]
      if params[:user][:photo].blank?
        if @user.cropping?
          @user.photo.reprocess!
        end
        redirect_to '/post/user/'
      else
        render :action => 'crop'
      end
    else
      render :action => :edit
    end
  end

  # user list
  def users
    @users = User.find(:all, :order => 'id ASC')
  end
  
  def list
    if params[:id]
      @users = User.find(:all, 
                         :conditions => {:id => params[:id]}, 
                         :order => 'id ASC')
    else
      @users = User.find(:all, :order => 'id ASC')
    end
    if params[:json]
      list = @users.map {| u | Hash[ name: u.name ]}
      render json: list
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
end

