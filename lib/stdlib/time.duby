import java.util.Date
import java.text.SimpleDateFormat

#  Date and Time Pattern            Result
#  "yyyy.MM.dd G 'at' HH:mm:ss z"   2001.07.04 AD at 12:08:56 PDT
#  "EEE, MMM d, ''yy"               Wed, Jul 4, '01
#  "h:mm a"                         12:08 PM
#  "hh 'o''clock' a, zzzz"          12 o'clock PM, Pacific Daylight Time
#  "K:mm a, z"                      0:08 PM, PDT
#  "yyyyy.MMMMM.dd GGG hh:mm aaa"   02001.July.04 AD 12:08 PM
#  "EEE, d MMM yyyy HH:mm:ss Z"     Wed, 4 Jul 2001 12:08:56 -0700
#  "yyMMddHHmmssZ"                  010704120856-0700  

class Time
  def self.format(date:Date, pattern:String)
    SimpleDateFormat.new(pattern).format(date)
  end
end
