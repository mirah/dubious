import java.util.StringTokenizer
import java.lang.StringBuffer

class Inflections

  # camelize
  # classify
  # constantize
  # dasherize
  # demodulize
  # foreign_key
  # humanize
  # parameterize
  # tableize
  # underscore

  def self.pluralize(word:String)
    Inflection.pluralize(word)
  end

  def self.singularize(word:String)
    Inflection.singularize(word)
  end

  def self.titlecase(string:String)
    titleize(string)
  end

  def self.titleize(phrase:String)
    StringBuffer sb = StringBuffer.new
    StringTokenizer strTitleCase = StringTokenizer.new(phrase.toLowerCase)
    while strTitleCase.hasMoreTokens
      String s = strTitleCase.nextToken
      sb.append(s.replaceFirst(s.substring(0, 1),
          s.substring(0, 1).toUpperCase) + " ")
    end
    sb.toString
   end 
end
