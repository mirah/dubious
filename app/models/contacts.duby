import com.google.appengine.ext.duby.db.Model
import com.google.appengine.api.datastore.*
import java.util.HashMap

class Contact < Model
  property 'title',   String
  property 'summary', Text
  property 'url',     Link
  property 'address', PostalAddress
  property 'phone',   PhoneNumber

  # we can drop this as soon as the built-in
  # properties method is fixed in MirahModel
  def get_properties
    hm = HashMap.new
    hm.put "title",   @title
    hm.put "summary", @summary
    hm.put "url",     @url
    hm.put "address", @address
    hm.put "phone",   @phone
    hm 
  end
end
