import java.util.Arrays
import java.lang.Integer
import java.util.List
import java.util.Date
import java.io.File
import java.lang.String


class Array
  def self.of_ints(list:List)
    ints = int[list.size]
    list.size.times { |i| ints[i] = Integer(list.get(i)).intValue }
    ints
  end  

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

  def self.to_objects(dates:Date[])
    objects = Object[dates.length]
    dates.length.times { |i| objects[i] = dates[i] }
    objects
  end

  def self.sort(dates:Date[])
    objects = to_objects(dates)
    Arrays.sort(objects)
    dates.length.times { |i| dates[i] = Date(objects[i]) }
    dates
  end

  def self.as_list(dates:Date[])
    Arrays.asList(to_objects(dates))
  end

  def self.to_objects(files:File[])
    objects = Object[files.length]
    files.length.times { |i| objects[i] = files[i] }
    objects
  end

  def self.sort(files:File[])
    objects = to_objects(files)
    Arrays.sort(objects)
    files.length.times { |i| files[i] = File(objects[i]) }
    files
  end

  def self.as_list(files:File[])
    Arrays.asList(to_objects(files))
  end

  def self.to_objects(strings:String[])
    objects = Object[strings.length]
    strings.length.times { |i| objects[i] = strings[i] }
    objects
  end

  def self.sort(strings:String[])
    objects = to_objects(strings)
    Arrays.sort(objects)
    strings.length.times { |i| strings[i] = String(objects[i]) }
    strings
  end

  def self.as_list(strings:String[])
    Arrays.asList(to_objects(strings))
  end
end
