import com.google.appengine.ext.duby.db.Model
import com.google.appengine.api.datastore.*
import dubious.TimeConversion
import java.util.Map
import java.util.Date

class Contact < Model
  property :title,    String
  property :summary,  Text
  property :birthday, Date
  property :url,      Link
  property :address,  PostalAddress
  property :phone,    PhoneNumber

  # provide a formatted date
  def birthday_terse
    return "" if birthday.nil?
    formatter = TimeConversion.new('terse')
    formatter.format(birthday)
  end

  # parse the date, then update
  def update_plus(map:Map)
    if map.containsKey('birthday')
      if String(map.get('birthday')).length == 10
        formatter = TimeConversion.new('jsdate')
        map.put('birthday', formatter.parse(String(map.get('birthday'))))
      else
        map.put('birthday', nil) # empty string (or wrong length) set to nil
      end
    end
    update(map)
  end
end
