# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def hace_tanto_tiempo (from_time, to_time = 0)
  # Traducción de distance_of_time_in_words
  
    include_seconds = true    
      
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
  
    say = {
            :less_seconds => t('datetime.distance_in_words.less_than_x_seconds.other'), 
            :half_minute => t('datetime.distance_in_words.half_a_minute'), 
            :less_minute => t('datetime.distance_in_words.less_than_x_minutes.one'), 
            :minutes => t('datetime.prompts.minute'), 
            :one_minute => t('datetime.distance_in_words.x_minutes.one'), 
            :hours => t('datetime.prompts.hour'), 
            :one_hour => t('datetime.distance_in_words.about_x_hours.one'), 
            :days => t('datetime.prompts.day'), 
            :one_day => t('datetime.distance_in_words.about_x_days.one'),
            :months => t('datetime.prompts.month'), 
            :one_month => t('datetime.distance_in_words.about_x_months.one'), 
            :years => t('datetime.prompts.year'), 
            :one_year => t('datetime.distance_in_words.about_x_years.one'),
           }
  
    case distance_in_minutes
      when 0..1
        return (distance_in_minutes==0) ? say[:less_minute] : say[:one_minute] unless include_seconds
        case distance_in_seconds
          when 0..4   then "<span class=\"tiempo\">#{say[:less_seconds].sub(/\?/, '5')}<input type=\"hidden\" class=\"controlTiempo\" value=\"S\" /></span>"
          when 5..9   then "<span class=\"tiempo\">#{say[:less_seconds].sub(/\?/, '10')}<input type=\"hidden\" class=\"controlTiempo\" value=\"S\" /></span>"
          when 10..19 then "<span class=\"tiempo\">#{say[:less_seconds].sub(/\?/, '20')}<input type=\"hidden\" class=\"controlTiempo\" value=\"S\" /></span>"
          when 20..39 then "<span class=\"tiempo\">#{say[:half_minute]}<input type=\"hidden\" class=\"controlTiempo\" value=\"S\" /></span>"
          when 40..59 then "<span class=\"tiempo\">#{say[:less_minute]}<input type=\"hidden\" class=\"controlTiempo\" value=\"S\" /></span>"
          else             "<span class=\"tiempo\">#{say[:one_minute]}<input type=\"hidden\" class=\"controlTiempo\" value=\"S\" /></span>"
        end
      when 2..44           then "<span class=\"tiempo\">#{distance_in_minutes} #{say[:minutes]}<input type=\"hidden\" class=\"controlTiempo\" value=\"S\" /></span>"
      when 45..89          then "<span class=\"tiempo\">#{say[:one_hour]}<input type=\"hidden\" class=\"controlTiempo\" value=\"S\" /></span>"
      when 90..1439        then "<span class=\"tiempo\">#{(distance_in_minutes.to_f / 60.0).round} #{say[:hours]}<input type=\"hidden\" class=\"controlTiempo\" value=\"S\" /></span>"
      when 1440..2879      then "<span class=\"tiempo\">#{say[:one_day]}<input type=\"hidden\" class=\"controlTiempo\" value=\"N\" /></span>"
      when 2880..43199     then "<span class=\"tiempo\">#{(distance_in_minutes / 1440).round} #{say[:days]}<input type=\"hidden\" class=\"controlTiempo\" value=\"N\" /></span>"
      when 43200..86399    then "<span class=\"tiempo\">#{say[:one_month]}<input type=\"hidden\" class=\"controlTiempo\" value=\"N\" /></span>"
      when 86400..525959   then "<span class=\"tiempo\">#{(distance_in_minutes / 43200).round} #{say[:months]}<input type=\"hidden\" class=\"controlTiempo\" value=\"N\" /></span>"
      when 525960..1051919 then "<span class=\"tiempo\">#{say[:one_year]}<input type=\"hidden\" class=\"controlTiempo\" value=\"N\" /></span>"
      else                      "<span class=\"tiempo\">#{(distance_in_minutes / 525960).round} #{say[:years]}<input type=\"hidden\" class=\"controlTiempo\" value=\"N\" /></span>"
     end
  end
end
