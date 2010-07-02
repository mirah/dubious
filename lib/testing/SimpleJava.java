package testing;
import java.io.IOException;
import javax.servlet.http.*;
import com.google.apphosting.api.ApiProxy;
import com.google.apphosting.api.ApiProxy.Environment;

public class SimpleJava extends HttpServlet {

  public void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws IOException {
    Environment env = ApiProxy.getCurrentEnvironment();
    String raw_ver = env.getVersionId();
    String version = raw_ver.substring(0,raw_ver.lastIndexOf("."));
    // print out some stuff
    String message = "app_id:  " + env.getAppId() +
              "\n" + "version: " + version +
              "\n" + "domain:  " + env.getAuthDomain();
    resp.setContentType("text/plain");
    resp.getWriter().println(message);
  }

}
