import java.util.StringTokenizer

class Inflections

  # camelize
  # classify
  # constantize
  # demodulize
  # parameterize
  # tableize

  def self.foreign_key(word:String)
    underscore(word.toLowerCase) +"_id"
  end

  def self.humanize(word:String)
    TextHelper.capitalize(word.replaceAll("_id$", "").replaceAll("_", " "))
  end

  def self.dasherize(word:String)
    word.replaceAll("\\W","-").toLowerCase
  end

  def self.underscore(word:String)
    word.replaceAll("\\W","_").toLowerCase
  end

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
    sb = StringBuffer.new
    strTitleCase = StringTokenizer.new(phrase.toLowerCase)
    while strTitleCase.hasMoreTokens
      s = strTitleCase.nextToken
      sb.append(s.replaceFirst(s.substring(0, 1),
          s.substring(0, 1).toUpperCase) + " ")
    end
    sb.toString
   end 
end
