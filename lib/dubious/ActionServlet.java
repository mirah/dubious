package dubious;

// A place for synchronized methods
public class ActionServlet extends javax.servlet.http.HttpServlet {
    private dubious.Params params_obj;

    public synchronized void set_params(Params params) {
        this.params_obj = params;
    }
    public synchronized Params params() {
    return this.params_obj;
    }
}
