import javax.servlet.http.HttpServlet
import com.google.apphosting.api.ApiProxy

class SimpleDuby < HttpServlet

  def doGet(req, resp)
    env = ApiProxy.getCurrentEnvironment
    raw_ver = env.getVersionId
    version = raw_ver.substring(0, raw_ver.lastIndexOf("."))
    # print out some stuff
    message = <<EOF
app_id:  #{env.getAppId}
version: #{version} 
domain:  #{env.getAuthDomain}

RequestURI:  #{req.getRequestURI}
PathInfo:    #{req.getPathInfo || "nil"}
ServletPath: #{req.getServletPath}
EOF
    resp.setContentType("text/plain")
    resp.getWriter.println(message)
  end

end
