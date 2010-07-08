import javax.servlet.http.HttpServlet
import com.google.apphosting.api.ApiProxy;
import java.io.FileInputStream
import java.util.Properties
import java.lang.System
import java.util.ArrayList


class InfoPropertiesController < HttpServlet

  # GET /info/properties
  def doGet(request, response)
    rows =  tr 'Mirah version',      build_info('mirah')
    rows += tr 'Bitescript version', build_info('bitescript')
    rows += tr 'MirahModel version', build_info('model')
    rows += tr 'Java version',    prop('java.specification.version'),
                                  prop('java.vm.version')
    rows += tr 'Java vm name',    prop('java.vm.name')
    rows += tr 'Environment',     prop('runtime.environment').toLowerCase
    rows += tr 'Runtime version', prop('runtime.version')
    rows += tr 'Auth domain',     ApiProxy.getCurrentEnvironment.getAuthDomain
    rows += tr 'App id',          prop('application.id')
    rows += tr 'App version',     prop('application.version')
    response.getWriter.write("<table><tbody>#{rows}</tbody></table>")
  end 

  def build_info(tool:String)
    out = String[2]
    props = Properties.new
    begin
      props.load(FileInputStream.new("config/build.properties"))
      out[0] = props.getProperty("#{tool}.version.commit").substring(0,7)
      out[1] = props.getProperty("#{tool}.version.time").substring(0,10)
    rescue
      out[0] = 'unknown'; out[1] = ""
    end
    out
  end

  def prop(s:String)
    s = "com.google.appengine.#{s}" unless s.startsWith('java.')
    System.getProperty(s) || ""
  end

  def tr(key:String, val:String)
    "<tr><td>#{key}</td><td colspan='2'>#{val}</td></tr>"
  end

  def tr(key:String, val:String, ext:String)
    "<tr><td>#{key}</td><td class='mono'>#{val}</td><td>#{ext}</td></tr>"
  end

  def tr(key:String, val:String[])
    tr(key, val[0], val[1])
  end
end
