import com.google.appengine.ext.duby.db.Model
import com.google.appengine.api.datastore.*
import dubious.TimeConversion
import java.util.Date
import java.util.Map

class Contact < Model
  property :title,    String
  property :summary,  Text
  property :birthday, Date
  property :url,      Link
  property :address,  PostalAddress
  property :phone,    PhoneNumber

  def coerce_date(o:Object)
    TimeConversion.new('jsdate').parse(String(o))
  end
end
