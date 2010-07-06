import java.util.Arrays;
import java.util.List;
import java.util.Date;
import java.io.File;
import java.lang.String;


class Array

  def self.of_strings(list:List)
    strings = String[list.size]
    list.size.times { |i| strings[i] = String(list.get(i)) }
    strings
  end  

  def self.of_dates(list:List)
    dates = Date[list.size]
    list.size.times { |i| dates[i] = Date(list.get(i)) }
    dates
  end  

  def self.of_files(list:List)
    files = File[list.size]
    list.size.times { |i| files[i] = File(list.get(i)) }
    files
  end  

  def self.sort(dates:Date[])
    objects = Object[dates.length]
    dates.length.times { |i| objects[i] = dates[i] }
    Arrays.sort(objects)
    dates.length.times { |i| dates[i] = Date(objects[i]) }
    dates
  end

  def self.sort(files:File[])
    objects = Object[files.length]
    files.length.times { |i| objects[i] = files[i] }
    Arrays.sort(objects)
    files.length.times { |i| files[i] = File(objects[i]) }
    files
  end

  def self.sort(strings:String[])
    objects = Object[strings.length]
    strings.length.times { |i| objects[i] = strings[i] }
    Arrays.sort(objects)
    strings.length.times { |i| strings[i] = String(objects[i]) }
    strings
  end
end
