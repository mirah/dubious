import java.text.BreakIterator

class TextHelper

  # auto_link
  # concat
  # current_cycle
  # cycle
  # excerpt
  # highlight
  # markdown
  # reset_cycle
  # simple_format
  # textilize
  # textilize_without_paragraph
  # word_wrap

  def self.capitalize(word:String)
    word.replaceFirst(word[0,1], word[0,1].toUpperCase)
  end

  def self.pluralize(count:int, word:String)
    if count == 1
      "1 " + Inflection.singularize(word)
    else
      "#{count} " + Inflection.pluralize(word)
    end
  end

  def self.truncate(string:String, limit:int)
    truncate(string, limit, '')
  end

  def self.truncate(string:String, limit:int, omission:String)
    return string if string.length < limit
    bi = BreakIterator.getWordInstance
    bi.setText(string)
    first_after = bi.following(limit)
    string.substring(0, first_after) + omission
  end
end
