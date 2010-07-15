package dubious;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;
import javax.servlet.http.HttpServletRequest;

// Fetch the attributes for a given model using rails conventions.
// We need to do this in Java because getParameterMap uses generics.
// We currently only support one lever: foo[bar] but not foo[bar][baz].
// We currently only pull the first value, so no support for checkboxes
public class ScopedParameterMap {
    public static Map params(HttpServletRequest req, String model) {
        Map<String, Object> scoped = new HashMap<String, Object>();
        Map params = req.getParameterMap();
        Iterator i = params.keySet().iterator();
        while (i.hasNext()) {
            String attr = (String) i.next();
            if (attr.startsWith(model + "[") && attr.endsWith("]")) {
                String key = attr.split("\\[|\\]")[1];
                String val = ((String[]) params.get(attr))[0];
                scoped.put(key, val);
                // TODO: when multiple values, set a List instead
            }
        }
        return scoped;
    }
}
