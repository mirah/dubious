import java.util.List
import java.util.HashMap

# Simply tie us over until we have Hash Literals
# http://github.com/headius/mirah/issues#issue/4

class Ha
  def self.sh(list:List)
    m = HashMap.new
    k = ""
    list.size.times do |i|
      if k.equals("")
        k = String(list.get(i))
      else
        m.put(k, String(list.get(i)))
        k = ""
      end
    end
    m
  end
end

__END__

$ mirah -e 'import stdlib.Ha
puts Ha.sh ["color", "red", "size", "XL", "parrern", "camouflage"]'
{color=red, parrern=camouflage, size=XL}
