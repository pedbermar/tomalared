class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  helper_method :current_user_session, :current_user

  def calcular_fecha
    j = 0
    @posts = Hash.new
    data = params['data']
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
    
    puts from_time
    puts to_time

    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
    
    puts distance_in_minutes
    puts distance_in_seconds
    case language
    when 'ca' then say = {:less_seconds => 'menys de ? segons', :half_minute => 'mig minut', :less_minute => 'menys d\'un minut', :minutes => 'minuts', :one_minute => 'un minut', :hours => 'hores', :one_hour => 'una hora', :days => 'dies', :one_day => '1 dia', :months => 'mesos', :one_month => 'un mes', :years => 'anys', :one_year => 'un any'}
    when 'es' then say = {:less_seconds => 'menos de ? segundos', :half_minute => 'medio minuto', :less_minute => 'menos de un minuto', :minutes => 'minutos', :one_minute => 'un minuto', :hours => 'horas', :one_hour => 'una hora', :days => 'd&iacute;as', :one_day => 'un d&iacute;a',:months => 'meses', :one_month => 'un mes', :years => 'a&ntilde;os', :one_year => 'un a&ntilde;o'}
    when 'en' then say = {:less_seconds => 'less than ? seconds', :half_minute => 'half a minute', :less_minute => 'lesss than a minute', :minutes => 'minutes', :one_minute => '1 minute', :hours => 'hours', :one_hour => 'about 1 hour', :days => 'days', :one_day => '1 day',:months => 'months', :one_month => 'about 1 month', :years => 'year', :one_year => 'about 1 year'}
    end
    case distance_in_minutes
    when 0..1
      return (distance_in_minutes==0) ? say[:less_minute] : say[:one_minute] unless include_seconds
      case distance_in_seconds
      when 0..4   then result = "#{say[:less_seconds].sub(/\?/, '5')} <input type=\"hidden\" class=\"controlTiempo\" value=\"S\" />"
      when 5..9   then result = "#{say[:less_seconds].sub(/\?/, '10')} <input type=\"hidden\" class=\"controlTiempo\" value=\"S\" />"
      when 10..19 then result = "#{say[:less_seconds].sub(/\?/, '20')} <input type=\"hidden\" class=\"controlTiempo\" value=\"S\" />"
      when 20..39 then result = "#{say[:half_minute]} <input type=\"hidden\" class=\"controlTiempo\" value=\"S\" />"
      when 40..59 then result = "#{say[:less_minute]} <input type=\"hidden\" class=\"controlTiempo\" value=\"S\" />"
      else             result = "#{say[:one_minute]} <input type=\"hidden\" class=\"controlTiempo\" value=\"S\" />"
      end
    when 2..44           then result = "#{distance_in_minutes} #{say[:minutes]} <input type=\"hidden\" class=\"controlTiempo\" value=\"S\" />"
    when 45..89          then result = "#{say[:one_hour] <input type=\"hidden\" class=\"controlTiempo\" value=\"S\" />"
    when 90..1439        then result = "#{(distance_in_minutes.to_f / 60.0).round} #{say[:hours]} <input type=\"hidden\" class=\"controlTiempo\" value=\"S\" />"
    when 1440..2879      then result = "#{say[:one_day]} <input type=\"hidden\" class=\"controlTiempo\" value=\"N\" />"
    when 2880..43199     then result = "#{(distance_in_minutes / 1440).round} #{say[:days]} <input type=\"hidden\" class=\"controlTiempo\" value=\"N\" />"
    when 43200..86399    then result = "#{say[:one_month] <input type=\"hidden\" class=\"controlTiempo\" value=\"N\" />"
    when 86400..525959   then result = "#{(distance_in_minutes / 43200).round} #{say[:months]} <input type=\"hidden\" class=\"controlTiempo\" value=\"N\" />"
    when 525960..1051919 then result = "#{say[:one_year] <input type=\"hidden\" class=\"controlTiempo\" value=\"N\" />"
    else                      result = "#{(distance_in_minutes / 525960).round} #{say[:years]} <input type=\"hidden\" class=\"controlTiempo\" value=\"N\" />"
    end
    return result
  end
end
