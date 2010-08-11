import com.google.appengine.ext.duby.db.Model
import com.google.appengine.api.datastore.*
import dubious.TimeConversion
import java.util.Date

class Contact < Model
  property :title,    String
  property :birthday, Date
  property :url,      Link
  property :platform, String
  property :editor,   String
  property :summary,  Text
  property :address,  PostalAddress
  property :phone,    PhoneNumber
  property :private,  Boolean

  def coerce_date(o:Object)
    TimeConversion.new('jsdate').parse(String(o))
  end
end
