import java.io.File
import java.io.BufferedInputStream
import java.io.FileInputStream

class Io
  def self.read(file:File)
    bytes = byte[int(file.length)]
    input = BufferedInputStream.new(FileInputStream.new(file))
    begin
      input.read(bytes)
    ensure
      input.close
    end
    String.new(bytes)
  end
end
