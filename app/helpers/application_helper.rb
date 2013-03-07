# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def hace_tanto_tiempo (from_time, to_time = 0)
  # Traducción de distance_of_time_in_words
  
    include_seconds = true    
      
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
  
    case distance_in_minutes
    when 0..1
      return (distance_in_minutes==0) ? t('datetime.distance_in_words.less_than_x_minutes.one') : t('datetime.distance_in_words.about_x_minutes.one') unless include_seconds
      case distance_in_seconds
        when 0..4   then result = "#{t('datetime.distance_in_words.less_than_x_seconds.other').sub(/\?/, '5')}"
        when 5..9   then result = "#{t('datetime.distance_in_words.less_than_x_seconds.other').sub(/\?/, '10')}"
        when 10..19 then result = "#{t('datetime.distance_in_words.less_than_x_seconds.other').sub(/\?/, '20')}"
        when 20..39 then result = "#{t('datetime.distance_in_words.half_a_minute')}"
        when 40..59 then result = "#{t('datetime.distance_in_words.less_than_x_minutes.one')}"
        else             result = "#{t('datetime.distance_in_words.about_x_minutes.one')}"
      end
      when 2..44           then result = "#{t('datetime.distance_in_words.about_x_minutes.other').sub(/\?/, distance_in_minutes.to_s)}"
      when 45..89          then result = "#{t('datetime.distance_in_words.about_x_hours.one')}"
      when 90..1439        then result = "#{t('datetime.distance_in_words.about_x_hours.other').sub(/\?/, (distance_in_minutes.to_f / 60.0).round.to_s)}"
      when 1440..2879      then result = "#{t('datetime.distance_in_words.about_x_days.one')}"
      when 2880..43199     then result = "#{t('datetime.distance_in_words.about_x_days.other').sub(/\?/, (distance_in_minutes / 1440).round.to_s)}"
      when 43200..86399    then result = "#{t('datetime.distance_in_words.about_x_months.one')}"
      when 86400..525959   then result = "#{t('datetime.distance_in_words.about_x_months.other').sub(/\?/, (distance_in_minutes / 43200).round.to_s)}"
      when 525960..1051919 then result = "#{t('datetime.distance_in_words.about_x_years.one')}"
      else                      result = "#{t('datetime.distance_in_words.about_x_years.other').sub(/\?/, (distance_in_minutes / 525960).round.to_s)}"
    end
    
  end
end
