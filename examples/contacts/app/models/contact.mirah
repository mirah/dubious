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

  # timestamps
  property :created_at, Date
  property :updated_at, Date
  def before_save
    @updated_at = Date.new
    @created_at = updated_at if @created_at.nil?
  end

  def coerce_date(o:Object)
    TimeConversion.new('jsdate').parse(String(o))
  end
end
