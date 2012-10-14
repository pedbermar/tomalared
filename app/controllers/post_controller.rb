class PostController < ApplicationController

  helper :all

  # list by date - its own method so we can do pagination right
  def list_by_date
    datestring = "#{params[:year]}-#{params[:month]}"
    datestring << "-#{params[:day]}" if params[:day]
    list :conditions => ['created_at LIKE ?', datestring + '%']
  end

  # list by post type - its own method so we can do pagination right
  def list_by_type
    list :conditions => ['post_type = ?', params[:type]]
  end

  # list by user id
  def list_by_uid
     @user = User.find(params[:id])
    list :conditions => ['user_id = ?', @user[:id]]
  end

  # display all the posts associated with a tag
  def tag
    tags = params[:tag].split(' ')

    # if more than one tag is specified, get the posts containing all the
    # passed tags.  otherwise get all the posts with just the one tag.
    if tags.size > 1
      @posts = Post.find_by_tags(tags)
    else
      post_ids = Post.find(:all, :joins => 'JOIN posts_tags pt ON pt.post_id = posts.id', :include => :tags,
                           :conditions => ['pt.tag_id = tags.id AND tags.name = ?', tags]).map(&:id)
      @post_pages, @posts = paginate :posts, :include => [:tags, :user], :order => 'created_at DESC',
                                     :per_page => TUMBLE['limit'], :conditions => ['posts.id IN (?)', post_ids.join(',')]
    end

    if @posts.size.nonzero?
      render :action => 'list'
    else
      error "Tag not found."
    end
  end

  # show a post, or redirect if we got here through hackery.
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

  # override template root to your theme's
  def self.template_root
    theme_dir
  end
  helper :all

  #
  # post management
  #

  # we do this a lot.  hrm.

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
      redirect_to :action => :list_user, :id => current_user[:id]
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
      post = id ? Post.find(id) : Post.new
      # reset all of post's attributes, replacing them with those submitted
      # from the form
      post.attributes = params[:post]
      # if post has no user_id set, give it the id of the logged in user
      post.user_id ||= current_user[:id]
      type = params[:post_type]
      post.content = params[:content] if TYPES[type]
      post.post_type = type_parse(post.content)
      # POST_TYPE == IMAGE
      if post.post_type == 'image'
        capturanombre = "#{post.user_id}-#{Time.now}"
        capturanombre = capturanombre.gsub(" ","")
        direcion = "public/post/#{capturanombre}.jpg"
        if params[:img] == nil
          require 'open-uri'
          open(direcion, "wb") do |file|
            file << open(post.content).read
          end
        else
          File.open(direcion, "wb") do |file|
            file << open(params[:img]).read
          end
        end
        direcion2 = "/post/#{capturanombre}.jpg"
        post.content = direcion2
      end
      # POST_TYPE == QUOTE
      if post.post_type == 'quote'
        t11 = Array.new
        post.content.split.each do |t|
          if t.first == '#'
            t11 << t.gsub(/^#/,"")
          end
        end
        t11.each do |t|
          tag = Tag.find_by_name(t) || Tag.new(:name => t)
          post.tags << tag
        end
      else
        params[:tags].split.each do |t|
          tag = Tag.find_by_name(t) || Tag.new(:name => t)
          post.tags << tag
        end
      end
      # POST_TYPE == (LINK)
      if post.post_type == 'link'
        require 'metainspector'
        require 'iconv'
        doc = MetaInspector.new(post.content)
        desc = doc.description
        post.title = doc.title
        if doc.image
          img_path = doc.image
        else
          img_path = doc.images.first
        end

        if img_path
          require 'open-uri'
          capturanombre = "#{post.user_id}-#{Time.now.to_a.join}"
          direcion = "public/post/#{capturanombre}.jpg"
          open(direcion, "wb") do |file|
            file << open(img_path).read
          end
          img_url = "http://localhost:3000/post/#{capturanombre}.jpg"
          post.content = desc + "\n" + img_path + "\n" + doc.url + "\n" + doc.host
        else
          post.content = desc + "\n" + "no-img" + "\n" + doc.url + "\n" + doc.host
        end
      end
      @post = nil
      if id
        if post.save
          @post = Post.find(id)
        end
      else
        @post = Post.create!(:post_type => post.post_type, :title => post.title, :content => post.content, :user_id => post.user_id, :tags => post.tags)
      end
      # save the post - if it fails, send the user back from whence she came
      if @post
        # Notificaciones para las usuarios que siguen los GRUPOS
        post.tags.each do |t|
          t.users.each do |u|
            if u.id != current_user[:id]
              note = Notifications.new
              note.user_id = u.id
              note.note_type = 2
              note.from = current_user[:id]
              note.post_id = @post.id
              note.save
            end
          end
        end
        # Notificaciones para las MENCIONES
        if post.post_type == 'quote'
          mentions = Array.new
          post.content.split.each do |t|
            if t.first == '@'
              mentions << t.gsub(/^@/,"")
            end
          end
          mentions.each do |u|
            user = User.find_by_name(u)
            if user.id != current_user[:id]
              note = Notifications.new
              note.user_id = user.id
              note.note_type = 3
              note.from = current_user[:id]
              note.post_id = @post.id
              note.save
            end
          end
        end
        flash[:notice] = 'Mensaje se ha guardado correctamente.'
      else
        flash[:notice] = "Hubo un error al guardar el mensaje."
      end

      if !params[:external]
        respond_to do |format|
          format.html { redirect_to post_path }
          format.js
        end
      end
      #redirect_to :back
    end
  end

  # ooo, pagination.
  def list(options = Hash.new)
    @po = Post.new
    if params[:id]
      @posts = Post.find(:all, :conditions => {:id => params[:id]}, :order => 'id DESC')
      @uno_solo = true
    else
      if params[:type]
        @posts = Post.find(:all,
          :joins => 'JOIN posts_tags pt ON pt.post_id = posts.id',
          :conditions => {:post_type=> params[:type], 'pt.tag_id' => current_user.tags }, :order => 'id DESC')
          @posts = @posts.uniq_by{|x| x.id}
      else
          @posts = Post.find(:all,
          :joins => 'JOIN posts_tags pt ON pt.post_id = posts.id',
           :conditions => {'pt.tag_id' => current_user.tags}, :order => 'id DESC')
          @posts = @posts.uniq_by{|x| x.id}
      end
    end
    if !params[:external]
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def list_tag
    @po = Post.new
    @tag = Tag.find_by_name(params[:tag])
    # if more than one tag is specified, get the posts containing all the
    # passed tags.  otherwise get all the posts with just the one tag.
    if params[:type]
      @posts = Post.find(:all, :joins => 'JOIN posts_tags pt ON pt.post_id = posts.id',
                         :conditions => ['pt.tag_id = tags.id AND tags.name = ? AND posts.post_type = ?', params[:tag], params[:type]],
                         :order => 'posts.created_at DESC',
                         :include => [:tags, :user])
    else
      @posts = Post.find(:all, :joins => 'JOIN posts_tags pt ON pt.post_id = posts.id',
                         :conditions => ['pt.tag_id = tags.id AND tags.name = ?', params[:tag]],
                         :order => 'posts.created_at DESC',
                         :include => [:tags, :user])
    end

    #foto aleatoria de la cabezera de list por tags
    @tag_foto = Post.find(:all, :joins => 'JOIN posts_tags pt ON pt.post_id = posts.id',
                          :conditions => ['pt.tag_id = tags.id AND tags.name = ? AND posts.post_type = ?', params[:tag], "image"],
                          :order => 'rand()',
                          :limit => 1,
                          :include => [:tags, :user])

    @tag_foto.each do |tag_foto|
      @foto_tag = tag_foto.content
    end

    @post = Post.new
    @post.content = "##{params[:tag]} "

    @users_tag =  Tag.find_by_sql(['SELECT `tags_users`.* FROM `tags_users` WHERE tag_id = ?', @tag])

    if !params[:external]
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def list_user
    @po = Post.new

    if params[:name]
      @user = User.find_by_name(params[:name])
    else
      @user = User.find(current_user[:id])
    end
    @posts = Post.find(:all, :conditions => { :user_id => @user.id }, :order => 'id DESC', :limit => '10')
    @post_share = Share.find(:all, :conditions => {:user_id => @user.id })
    @post_share.each do |ps|
      p = Post.find(ps.post_id)
      p.created_at = ps.created_at
      @posts << p
    end
    @posts= @posts.sort_by {|post| post.created_at}.reverse

    @post = Post.new
    if params[:name]
      @post.content = "@#{params[:name]} : "
    end
    if params[:remote]
        respond_to do |format|
          format.html
          format.js
        end
    end
  end

  def note
    @po = Post.new
    note = Notifications.find(:all, :conditions => { :user_id => current_user[:id], :note_type => params[:note_type]}, :order => 'id DESC')

    @posts = Array.new
    note.each do |m|
      @posts << Post.find(m.post_id)
      m.unread = 0
      m.save
    end
    @posts = @posts.uniq_by{|x| x.id}
    render :list
  end

  # grab the post and destroy it.  simple enough.
  def delete
    @post = Post.find(params[:id])
    @notes = Notifications.find(:all, :conditions => { :post_id => @post.id})

    @notes.each do |m|
      m.destroy
    end
    @post.destroy

    flash[:notice] = 'Post Borrado.'
    respond_to do |format|
      format.html { redirect_to post_path }
      format.js
    end
  end

  def mentions
    @post = Post.new
    @user  = User.find(params[:user])
    @post.post_type = 'quote'
    @post.content = "@#{@user.name} "

    @mentions = Notifications.find(:all,
                                   :conditions => ["((`user_id` = ? AND `from` = ?) OR (`user_id` = ? AND `from` = ?)) AND `note_type` = 3", current_user[:id], params[:user], params[:user], current_user[:id]],
                                   :order => 'post_id DESC')

    @posts = Array.new
    @mentions.each do |m|
      @posts << Post.find(m.post_id)
    end
    render :action => 'edit'
  end

  def type_parse(str)
    if str.split.count == 1
      if str.split.first.match(/\A(http|https):\/\/www.youtube.com/)
        type = "video"
      elsif str.split.first.match(/(.png|.jpg|.gif)$/)
        type = "image"
      elsif str.split.first.match(/\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}/)
        type = "link"
      end
    elsif str.size < 150
      type = "quote"
    else
      type = "post"
    end
    return type
  end

end

