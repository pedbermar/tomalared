class PostController < ApplicationController

  helper :all

  def show
    begin
      if params[:id]
        @post = Post.find(params[:id], :include => [:tags, :user])
      else
        redirect_to :action => 'list'
      end
    rescue ActiveRecord::RecordNotFound
      error "Post not found."
    end
  end

  # error method, for redirecting to our hand rolled 404 page
  # with a custom error message
  def error(x = nil)
    @error_msg = x
    render :action => 'error'
  end

  def edit()
    if current_user[:id] != params[:user_id]
      save
    end
  end

  # this method handles creation of new posts and editing of existing posts
  def save
    if params[:id] && request.get?
      # Aqui se genera los datos para la view del edit
      @post = Post.find(params[:id])
      @tags = @post.tag_names
      render :action => :edit
    elsif params[:id] && request.post?
      # Aqui se graba cuando editamos
      @po = Post.find(params[:id])
      @po.attributes = params[:post]
      @po.tag_names = params[:tags]
      @po.id = params[:id]
      @po.save
      redirect_to :action => :list, :id => current_user[:id]
    elsif !params[:id] && request.get?
      # want to create a new post -- go for it
      @post = Post.new
      @tags = nil
      render :action => :new
    elsif request.post?
      # post request means something big is going to happen.
      # set post variable to the post in question if we're editing, otherwise
      # open a new object
      id = params[:id]
      @post = id ? Post.find(id) : Post.new
      # reset all of post's attributes, replacing them with those submitted
      # from the form
      @post.attributes = params[:post]
      # if post has no user_id set, give it the id of the logged in user
      @post.user_id ||= current_user[:id]
      type = params[:post_type]
      @post.content = params[:content] if TYPES[type]
      @post.post_type = type_parse(@post.content)

      require 'htmlentities'
      coder = HTMLEntities.new
      string = @post.content
      @post.content = coder.encode(string, :basic)
      
      content = @post.content

      # POST_TYPE == IMAGE
      if @post.post_type == 'image'
        capturanombre = "#{@post.user_id}-#{Time.now}"
        capturanombre = capturanombre.gsub(" ","")
        direcion = "public/post/#{capturanombre}.jpg"
        if params[:img] == nil
          require 'open-uri'
          urls = Array.new
          @post.content.split.each do |u|
            if u.match(/(.png|.jpg|.gif)$/)
              urls << u
            end
          end
          open(direcion, "wb") do |file|
            file << open(urls.first).read
          end
        else
          File.open(direcion, "wb") do |file|
            file << open(params[:img]).read
          end
        end
        direcion2 = "/post/#{capturanombre}.jpg"
        @post.content = direcion2
      end

      # POST_TYPE == LINK || VIDEO
      if @post.post_type == 'link' || @post.post_type == 'video'
        require 'metainspector'
        require 'iconv'
        if @post.post_type == 'link'
          urls = Array.new
          @post.content.split.each do |u|
            if u.match(/(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix)
              urls << u
            end
          end
          doc = MetaInspector.new(urls.first)
        end
        if @post.post_type == 'video'
          urls = Array.new
          @post.content.split.each do |u|
            if u.match(/\A(http|https):\/\/www.youtube.com/)
              urls << u
            end
          end
          doc = MetaInspector.new(urls.first)
        end
        desc = doc.description
        @post.title = doc.title
        if doc.image
          img_path = doc.image
        else
          img_path = doc.images.first
        end

        if img_path
          require 'open-uri'
          capturanombre = "#{@post.user_id}-#{Time.now.to_a.join}"
          direcion = "public/post/#{capturanombre}.jpg"
          open(direcion, "wb") do |file|
            file << open(img_path).read
          end
          img_url = "/post/#{capturanombre}.jpg"
          post.content = desc + "\n" + img_url + "\n" + doc.url + "\n" + doc.host
        else
          post.content = desc + "\n" + "no-img" + "\n" + doc.url + "\n" + doc.host
        end
      end
      
      # Agregar tags
      t11 = Array.new
      content.split.each do |t|
        if t.first == '#'
          t11 << t.gsub(/^#/,"").gsub(/[^a-zA-Z0-9]/, "")
        end
      end
      
      t11.each do |t|
        tag = Tag.find_by_name(t) || Tag.new(:name => t)
        @post.tags << tag
        subs = Subscriptions.where(:post_id => t.id, :resource_type => Subscriptions::S_TAG)
        subs.each do |sub|
          Notification.send_notification(sub.user_id, current_user[:id], Notification::TAG_POST, @post.id)
        end
      end
      
      # Notificaciones para las menciones
      mentions = Array.new
      content.split.each do |t|
        if t.first == '@'
          mentions << t.gsub(/^@/,"")
        end
      end
           
      mentions.each do |u|
        user = User.find_by_name(u)
        if user
          Notification.send_notification(user.id, current_user[:id], Notification::USER, @post.id)
        end
      end
      Subscriptions.subscribe(current_user[:id], Subscriptions::S_POST, @post.id)
      # save the post - if it fails, send the user back from whence she came
      if @post.save
        flash[:notice] = 'El mensaje se ha guardado correctamente.'
      else
        flash[:notice] = 'Ha habido un problema al borrar el mensaje.'
      end

      if !params[:external] || params[:remote]
        respond_to do |format|
          format.html { redirect_to post_path }
          format.js
        end
      end
    end
  end

  def list(options = Hash.new)    
    @po = Post.new
    @post = Post.new
    @destinatario = ""
    @pagina = params[:pagina]
    @soloposts = params[:soloposts]?true:false
    last = params[:last].blank? ? 1 : params[:last]
    postId = params[:postId].blank? ? 1 : params[:postId]
    if params[:direccion] == "next"
      direccion = " AND posts.id < ?"
    elsif params[:direccion] == "prev"
      direccion = " AND posts.id > ?"
    else
      direccion = " AND 1=?"
    end
    if params[:postId]
      filtroId = " AND posts.id = ?"
    else
      filtroId = " AND 1=?"
    end
    if @pagina == "list"
      if params[:id]
        if !params[:last] and !params[:postId]
          @posts = Post.find(:all, 
                             :conditions => {:id => params[:id]})
        else
          @posts = Array.new
        end
        @uno_solo = true
      else
        if params[:type]
          @posts = Post.find(:all,
                             :joins => "JOIN posts_tags pt ON pt.post_id = posts.id",
                             :conditions => ["posts.post_type = ?  AND  pt.tag_id IN (?)" + direccion + filtroId, params[:type], current_user.tags, last, postId], 
                             :order => "posts.created_at DESC")
        else
          @posts = Post.find(:all,
                             :joins => "JOIN posts_tags pt ON pt.post_id = posts.id",
                             :conditions => ["pt.tag_id IN (?)" + direccion + filtroId, current_user.tags, last, postId], 
                             :order => "posts.created_at DESC")
        end
        @posts = @posts.uniq_by{|x| x.id}
      end
      if !@soloposts
        @page_name = "Todos los Posts"
      end
    elsif @pagina == "tag"
      @tagName = params[:id]
      @tag = Tag.find_by_name(@tagName)
      @destinatario = "#" + @tagName
      # if more than one tag is specified, get the posts containing all the
      # passed tags.  otherwise get all the posts with just the one tag.
      if params[:type]
        @posts = Post.find(:all, 
                           :joins => "JOIN posts_tags pt ON pt.post_id = posts.id",
                           :conditions => ["pt.tag_id = tags.id AND tags.name = ? AND posts.post_type = ?" + direccion + filtroId, @tagName, params[:type], last, postId],
                           :order => "posts.created_at DESC",
                           :include => [:tags, :user])
      else
        @posts = Post.find(:all, 
                           :joins => "JOIN posts_tags pt ON pt.post_id = posts.id",
                           :conditions => ["pt.tag_id = tags.id AND tags.name = ?" + direccion + filtroId, @tagName, last, postId],
                           :order => "posts.created_at DESC",
                           :include => [:tags, :user])
      end
      
      if !@soloposts
        #foto aleatoria de la cabezera de list por tags
        @tag_foto = Post.find(:all, 
                              :joins => "JOIN posts_tags pt ON pt.post_id = posts.id",
                              :conditions => ["pt.tag_id = tags.id AND tags.name = ? AND posts.post_type = ?", @tagName, "image"],
                              :order => "rand()",
                              :limit => 1,
                              :include => [:tags, :user])
    
        @tag_foto.each do |tag_foto|
          @foto_tag = tag_foto.content
        end
  
        @post.content = "##{params[:id]} "
    
        @users_tag =  Tag.find_by_sql(["SELECT u.*, tu.tag_id FROM tags_users as tu, users as u WHERE u.id = tu.user_id and tu.tag_id = ?", @tag])
        @page_name = "Post del Tag #{params[:id]}"
      end
    elsif @pagina == "user"
      if params[:id]
        if /^[\d]+(\.[\d]+){0,1}$/ === params[:id]
          @user = User.find(params[:id])
        else
          @user = User.find_by_name(params[:id])
        end
      else
        @user = User.find(current_user[:id])
      end
      if @user.id != current_user[:id]
        @destinatario = "@" + @user.name
      end
      @posts = Post.find(:all,
                         :select => "posts.id, posts.user_id, posts.title, posts.post_type, posts.content, ifnull(sh.created_at, posts.created_at) created_at",
                         :joins => "LEFT OUTER JOIN shares sh ON posts.id = sh.post_id",
                         :conditions => ["(posts.user_id = ? OR sh.user_id = ?)" + direccion + filtroId, @user.id, @user.id, last, postId], 
                         :order => "6 DESC", 
                         :limit => "10")
      #Post.find_by_sql ["SELECT * FROM vPosts WHERE user_id = ?" + direccion + filtroId + " ORDER BY created_at DESC LIMIT 10", @user.id, last, postId]

      if !@soloposts
        if params[:id]
          @post.content = "@#{params[:id]} : "
        end
        @page_name = "Post de #{@user.name}"
      end
    elsif params[:pagina] == "mentions"
      con = Notification.where(:user_id => current_user[:id], :from => params[:id], :note_type => Notifications::USER)
      con = con + Notification.where(:user_id => params[:id], :from => current_user[:id], :note_type => Notifications::USER)
      cons = Array.new
      con.each do |c|
        cons << c.post_id
      end
      @posts = Post.find(cons).sort_by {|x| x.created_at}.reverse
    elsif params[:pagina] == "notifications"
      comm= Notification.where(:user_id => current_user[:id], :note_type => params[:id])
      cons = Array.new
      comm.each do |c|        
        cons << c.post_id
      end
      if cons
        @posts = Post.find(cons).sort_by {|x| x.created_at}.reverse
        comm.each do |c|       
          if c.unread == 1
            c.unread = 0
            c.save
          end 
        end
      end      
    else
      if params[:id]
        @posts = Post.find(:all, :conditions => {:id => params[:id]}, :order => "id DESC")
        @uno_solo = true
      else
        if params[:type]
          @posts = Post.find(:all,
                             :joins => "JOIN posts_tags pt ON pt.post_id = posts.id",
                             :conditions => ["post_type = ? AND pt.tag_id IN (?)" + direccion + filtroId, params[:type], current_user.tags, last, postId],
                             :order => "posts.created_at DESC")
        else
          @posts = Post.find(:all,
                             :joins => "JOIN posts_tags pt ON pt.post_id = posts.id",
                             :conditions => ["pt.tag_id IN (?)" + direccion + filtroId, current_user.tags, last, postId],
                             :order => "posts.created_at DESC")
        end
        @posts = @posts.uniq_by{|x| x.id}
      end
      if !@soloposts
        @page_name = "Todos los Posts"
      end
    end
    @userNotif = User.find(current_user[:id])
    if !params[:external] || params[:remote]
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  # grab the post and destroy it.  simple enough.
  def delete
    @post = Post.find(params[:id])
    if @post           
      if @post.destroy        
        flash[:notice] = 'El mensaje se ha borrado correctamente.'
      else
        flash[:notice] = "Ha habido un problema al borrar el mensaje."
      end
    else
      flash[:notice] = "No se encuentra el mensaje."
    end
    respond_to do |format|
      format.html { redirect_to post_path }
      format.js
    end
  end

  def type_parse(str)
    plain = 0
    str.split.each do |x|
      if x.match(/\A(http|https):\/\/www.youtube.com/) == nil and 
      x.match(/(.png|.jpg|.gif)$/) == nil and
      x.match(/\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}/) == nil and 
      x.match(/^#/) == nil and
      x.match(/^@/) == nil
        plain = 1
      end
    end
    if  plain == 0 #str.split.count == 1
      imgs = Array.new
      videos = Array.new
      links = Array.new
      str.split.each do |w|
        if w.match(/(.png|.jpg|.gif)$/)
          imgs << w
        elsif w.match(/\A(http|https):\/\/www.youtube.com/)
          videos << w
        elsif w.match(/\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}/)
          links << w
        end
      end
      if imgs.count + videos.count + links.count == 1
        if imgs.first
          type = "image"
        elsif videos.first
          type = "video"
        elsif links.first
          type = "link"
        end
      else 
        type = "quote"
      end
    elsif str.size < 150
      type = "quote"
    else
      type = "post"
    end
    return type
  end
end