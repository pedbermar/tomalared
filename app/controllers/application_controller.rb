class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  helper_method :current_user_session, :current_user

  def calcular_fecha
    j = 0
    @posts = Hash.new
    data = params['data']
    if data
      data.each do | o |
        i = 0
        comments = Hash.new
        obj = o[1]
        cs = obj['comments']
        if cs
          cs.each do | c |
            obj2 = c[1]
            comment = Hash[ id: obj2['id'], texto: hace_tanto_tiempo(Time.parse(obj2['fecha'].gsub(/[.]/, ":")),Time.now)]
            comments[i] = comment
            i = i + 1
          end
        end
        post = Hash[ id: obj['id'], texto: hace_tanto_tiempo(Time.parse(obj['fecha'].gsub(/[.]/, ":")),Time.now), comments: comments ]
        @posts[j] = post
        j = j + 1
      end
    end
    render json: @posts
  end
  
  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
    return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
    return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def hace_tanto_tiempo (from_time, to_time = 0)
    # Traducción de distance_of_time_in_words
    result = ""

    include_seconds = true
    language = 'es'

    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
    
        say = {
            :less_seconds => t('datetime.distance_in_words.less_than_x_seconds.other'), 
            :half_minute => t('datetime.distance_in_words.half_a_minute'), 
            :less_minute => t('datetime.distance_in_words.less_than_x_minutes.one'), 
            :minutes => t('datetime.distance_in_words.about_x_minutes.other'), 
            :one_minute => t('datetime.distance_in_words.x_minutes.one'), 
            :hours => t('datetime.distance_in_words.about_x_hours.other'), 
            :one_hour => t('datetime.distance_in_words.about_x_hours.one'), 
            :days => t('datetime.distance_in_words.about_x_days.other'),
            :one_day => t('datetime.distance_in_words.about_x_days.one'),
            :months => t('datetime.distance_in_words.about_x_months.other'), 
            :one_month => t('datetime.distance_in_words.about_x_months.one'), 
            :years => t('datetime.distance_in_words.about_x_years.other'), 
            :one_year => t('datetime.distance_in_words.about_x_years.one'),
           }
  
    case distance_in_minutes
    when 0..1
      return (distance_in_minutes==0) ? say[:less_minute] : say[:one_minute] unless include_seconds
      case distance_in_seconds
        when 0..4   then result = "#{say[:less_seconds].sub(/\?/, '5')}"
        when 5..9   then result = "#{say[:less_seconds].sub(/\?/, '10')}"
        when 10..19 then result = "#{say[:less_seconds].sub(/\?/, '20')}"
        when 20..39 then result = "#{say[:half_minute]}"
        when 40..59 then result = "#{say[:less_minute]}"
        else             result = "#{say[:one_minute]}"
      end
      when 2..44           then result = "#{say[:minutes].sub(/\?/, distance_in_minutes.to_s)}"
      when 45..89          then result = "#{say[:one_hour]}"
      when 90..1439        then result = "#{say[:hours].sub(/\?/, (distance_in_minutes.to_f / 60.0).round.to_s)}"
      when 1440..2879      then result = "#{say[:one_day]}"
      when 2880..43199     then result = "#{say[:days].sub(/\?/, (distance_in_minutes / 1440).round.to_s)}"
      when 43200..86399    then result = "#{say[:one_month]}"
      when 86400..525959   then result = "#{say[:months].sub(/\?/, (distance_in_minutes / 43200).round.to_s)}"
      when 525960..1051919 then result = "#{say[:one_year]}"
      else                      result = "#{say[:years].sub(/\?/, (distance_in_minutes / 525960).round.to_s)}"
    end
  	control = "S"
  	if distance_in_minutes > 1439
  		control = "N"
  	end
    return "<span class=\"tiempo\">" + result + "<input type=\"hidden\" class=\"controlTiempo\" value=\"" + control + "\" /></span>"
  end
end
