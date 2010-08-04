import java.util.HashMap
import java.util.Date
import java.text.SimpleDateFormat

class TimeConversion
  def initialize(token:String)
    pattern = TimeConversion.for(token)
    @formatter = SimpleDateFormat.new(pattern)
  end

  def format(date:Date)
    @formatter.format(date)
  end

  def parse(str:String)
    @formatter.parse(str)
  end

  def self.for(token:String)
    hm = HashMap.new
    hm.put('clock',    "h:mm a, z")            # 12:08 PM PDT
    hm.put('datetime', "EEE, d MMM yyyy HH:mm:ss Z")
    hm.put('date',     "EEE, d MMM yyyy")      # Mon, 12 Nov 2007
    hm.put('db',       "yyyy-MM-ss HH:mm:ss")  # 2007-01-18 06:10:17
    hm.put('long',     "MMMMM d, yyyy HH:mm")  # January 18, 2007 06:10
    hm.put('month',    "MMM yyyy")             # Nov 2007
    hm.put('number',   "yyyyMMddHHmm")         # 20070118061017
    hm.put('offset',   "Z")                    # -0700
    hm.put('short',    "d MMM HH:mm")          # 18 Jan 06:10
    hm.put('jsdate',   "MM/dd/yyyy")           # 03/31/2007
    hm.put('terse',    "yyyy-MM-dd")           # 2007-11-12
    hm.put('time',     "HH:mm:ss")             # 06:10:17
    hm.containsKey(token) ? String(hm.get(token)) : "HH:mm:ss Z"
  end
end

__END__

$ duby -e 'import dubious.*
import java.util.Date
date = Date.new
puts TimeConversion.new("month").format(date)'
Jul 2010

$ duby -e 'import dubious.*
import java.util.Date
import java.text.SimpleDateFormat
date = Date.new
pattern = TimeConversion.for("month")
puts SimpleDateFormat.new(pattern).format(date)'
