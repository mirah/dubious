import java.lang.StringBuffer
import java.util.StringTokenizer

class Title
  def self.case(str:String)
    StringBuffer sb = StringBuffer.new
    str = str.toLowerCase
    StringTokenizer strTitleCase = StringTokenizer.new(str)
    while strTitleCase.hasMoreTokens
      String s = strTitleCase.nextToken
      sb.append(s.replaceFirst(s.substring(0, 1),
          s.substring(0, 1).toUpperCase) + " ")
    end
    sb.toString
   end 
end
