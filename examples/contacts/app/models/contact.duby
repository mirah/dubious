import com.google.appengine.ext.duby.db.Model
import com.google.appengine.api.datastore.*

class Contact < Model
  property 'title',   String
  property 'summary', Text
  property 'url',     Link
  property 'address', PostalAddress
  property 'phone',   PhoneNumber
end
