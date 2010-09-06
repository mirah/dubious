import dubious.*
import java.util.Date

class ApplicationController < ActionController

  def initialize
    @terse = TimeConversion.new('terse')
  end

  def terse_date(date:Date)
    @terse.format(date)
  end

end
