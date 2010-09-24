import java.util.HashMap
import java.util.Date
import java.text.SimpleDateFormat

class TimeConversion
  def initialize(token:String)
    @matcher = TimeConversion.matcher(token)
    @formatter = SimpleDateFormat.new(TimeConversion.pattern(token))
  end

  def format(date:Date)
    return "" if date.nil?
    @formatter.format(date)
  end

  def parse(str:String)
    return nil unless str.matches(@matcher)
    @formatter.parse(str)
  end

  def self.pattern(token:String)
    hm = HashMap.new
    hm.put('year',     "yyyy")                 # 2007
    hm.put('date',     "EEE, d MMM yyyy")      # Mon, 12 Nov 2007
    hm.put('time',     "HH:mm:ss")             # 06:10:17
    hm.put('offset',   "Z")                    # -0700
    hm.put('datetime', "#{hm[:date]} #{hm[:time]} #{hm[:offset]}")
    hm.put('db',       "yyyy-MM-ss HH:mm:ss")  # 2007-01-18 06:10:17
    hm.put('long',     "MMMMM d, yyyy HH:mm")  # January 18, 2007 06:10
    hm.put('tidy',     "MMM d, yyyy")          # Nov 12, 2007
    hm.put('month',    "MMM yyyy")             # Nov 2007
    hm.put('number',   "yyyyMMddHHmm")         # 20070118061017
    hm.put('short',    "d MMM HH:mm")          # 18 Jan 06:10
    hm.put('jsdate',   "MM/dd/yyyy")           # 03/31/2007
    hm.put('terse',    "yyyy-MM-dd")           # 2007-11-12
    hm.put('clock',    "h:mm a, z")            # 12:08 PM PDT
    hm.containsKey(token) ? String(hm.get(token)) : String(hm.get('time'))
  end

  def self.matcher(token:String)
    hm = HashMap.new
    hm.put('year',     "\\d\\d\\d\\d")
    hm.put('date',     "\\w\\w\\w, \\d \\w\\w\\w\\w \\d\\d\\d\\d")
    hm.put('time',     "\\d\\d:\\d\\d:\\d\\d")
    hm.put('offset',   "-*?\\d\\d\\d\\d")
    hm.put('datetime', "#{hm[:date]} #{hm[:time]} #{hm[:offset]}")
    hm.put('db',       "\\d\\d\\d\\d-\\d\\d-\\d\\d \\\d\\d:\\d\\d:\\d\\d")
    hm.put('long',     "\\w\\w\\w?+ \\d\\d*+, \\d\\d\\d\\d \\d\\d:\\d\\d")
    hm.put('tidy',     "\\w\\w\\w \\d\\d*+, \\d\\d\\d\\d")
    hm.put('month',    "\\w\\w\\w \\\d\\d\\d\\d")
    hm.put('number',   "\\d\\d\\d\\d\\d\\d\\d\\d\\d\\d\\d\\d")
    hm.put('short',    "\\d*?\\d \\w\\w\\w \\d\\d:\\d\\d")
    hm.put('jsdate',   "\\d\\d/\\d\\d/\\d\\d\\d\\d")
    hm.put('terse',    "\\d\\d\\d\\d-\\d\\d-\\d\\d")
    hm.put('clock',    "\\d\\d:\\d\\d \\w\\w \\w\\w\\w")
    hm.containsKey(token) ? String(hm.get(token)) : String(hm.get('time'))
  end
end