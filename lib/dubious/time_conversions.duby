import java.util.HashMap

class TimeConversions

  #  Date and Time Pattern           Result
  #  "yyyy.MM.dd G 'at' HH:mm:ss z"  2001.07.04 AD at 12:08:56 PDT
  #  "EEE, MMM d, ''yy"              Wed, Jul 4, '01
  #  "h:mm a"                        12:08 PM
  #  "hh 'o''clock' a, zzzz"         12 o'clock PM, Pacific Daylight Time
  #  "K:mm a, z"                     0:08 PM, PDT
  #  "yyyyy.MMMMM.dd GGG hh:mm aaa"  02001.July.04 AD 12:08 PM
  #  "EEE, d MMM yyyy HH:mm:ss Z"    Wed, 4 Jul 2001 12:08:56 -0700
  #  "yyMMddHHmmssZ"                 010704120856-0700  

  #  import java.text.SimpleDateFormat
  #  import java.util.Date
  #
  #  date = Date.new
  #  pattern = TimeConversions.pattern('month')
  #  SimpleDateFormat.new(pattern).format(date)

  def self.pattern(token:String)
    @thm = HashMap.new
    @thm.put('datetime', "EEE, d MMM yyyy HH:mm:ss Z")
    @thm.put('date',     "EEE, d MMM yyyy")      # Mon, 12 Nov 2007
    @thm.put('db',       "yyyy-MM-ss HH:mm:ss")  # 2007-01-18 06:10:17
    @thm.put('long',     "MMMMM d, yyyy HH:mm")  # January 18, 2007 06:10
    @thm.put('month',    "MMM yyyy")             # Nov 2007
    @thm.put('number',   "yyyyMMddHHmm")         # 20070118061017
    @thm.put('offset',   "Z")                    # -0700
    @thm.put('short',    "d MMM HH:mm")          # 18 Jan 06:10
    @thm.put('terse',    "yyyy-MM-dd")           # 2007-11-12
    @thm.put('time',     "HH:mm:ss")             # 06:10:17
    @thm.containsKey(token) ? @thm.get(token) : "HH:mm:ss Z"
  end
end
