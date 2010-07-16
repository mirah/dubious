import java.util.HashMap
import java.util.Date
import java.text.SimpleDateFormat

class TimeConversion

  #  Date and Time Pattern           Result
  #  "yyyy.MM.dd G 'at' HH:mm:ss z"  2001.07.04 AD at 12:08:56 PDT
  #  "EEE, MMM d, ''yy"              Wed, Jul 4, '01
  #  "h:mm a"                        12:08 PM
  #  "hh 'o''clock' a, zzzz"         12 o'clock PM, Pacific Daylight Time
  #  "K:mm a, z"                     0:08 PM, PDT
  #  "yyyyy.MMMMM.dd GGG hh:mm aaa"  02001.July.04 AD 12:08 PM
  #  "EEE, d MMM yyyy HH:mm:ss Z"    Wed, 4 Jul 2001 12:08:56 -0700
  #  "yyMMddHHmmssZ"                 010704120856-0700  

  def initialize(token:String)
    pattern = TimeConversion.for(token)
    @formatter = SimpleDateFormat.new(pattern)
  end

  def format(date:Date)
    @formatter.format(date)
  end

  def self.for(token:String)
    hm = HashMap.new
    hm.put('datetime', "EEE, d MMM yyyy HH:mm:ss Z")
    hm.put('date',     "EEE, d MMM yyyy")      # Mon, 12 Nov 2007
    hm.put('db',       "yyyy-MM-ss HH:mm:ss")  # 2007-01-18 06:10:17
    hm.put('long',     "MMMMM d, yyyy HH:mm")  # January 18, 2007 06:10
    hm.put('month',    "MMM yyyy")             # Nov 2007
    hm.put('number',   "yyyyMMddHHmm")         # 20070118061017
    hm.put('offset',   "Z")                    # -0700
    hm.put('short',    "d MMM HH:mm")          # 18 Jan 06:10
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
