// Generated from dubious/action_controller.duby
package dubious;
public class ActionController extends javax.servlet.http.HttpServlet {
  private dubious.Params params_obj;
  private java.lang.String flash_str;
  private dubious.AssetTimestampsCache asset_timestamps_cache;
  private static java.util.regex.Pattern escape_pattern;
  private static java.util.HashMap escaped;
  public static void main(java.lang.String[] argv) {
  public java.lang.Object index() {
    return ((java.lang.Object)(java.lang.Integer.valueOf(404)));
  }
  public java.lang.Object show() {
    return ((java.lang.Object)(java.lang.Integer.valueOf(404)));
  }
  public java.lang.Object new() {
    return ((java.lang.Object)(java.lang.Integer.valueOf(404)));
  }
  public java.lang.Object edit() {
    return ((java.lang.Object)(java.lang.Integer.valueOf(404)));
  }
  public java.lang.Object delete() {
    return ((java.lang.Object)(java.lang.Integer.valueOf(404)));
  }
  public java.lang.Object create() {
    return ((java.lang.Object)(java.lang.Integer.valueOf(404)));
  }
  public java.lang.Object update() {
    return ((java.lang.Object)(java.lang.Integer.valueOf(404)));
  }
  public void set_params(dubious.Params params) {
    this.params_obj = params;
  }
  public dubious.Params params() {
    return this.params_obj;
  }
  public void set_flash_notice(java.lang.String content) {
    this.flash_str = content;
  }
  public java.lang.String flash_notice() {
    java.lang.String __xform_tmp_1 = this.flash_str;
    return (__xform_tmp_1 != null) ? (__xform_tmp_1) : ("");
  }
  public java.lang.String yield_body() {
    return "@@_YIELD_BODY_@@";
  }
  public java.lang.String render(java.lang.String content, java.lang.String layout) {
    java.lang.String[] wrapper = layout.split(this.yield_body());
    return (wrapper.length == 2) ? (((wrapper[0] + content) + wrapper[1])) : ((layout + "\n\n<!-- Oops, yield_body missing -->"));
  }
  public java.lang.String render(java.lang.String content) {
    return content;
  }
  public java.net.URI redirect_to(java.lang.String link) {
    return new java.net.URI(link);
  }
  public void action_response(javax.servlet.http.HttpServletResponse response, java.lang.Object payload) {
    if (payload instanceof java.net.URI) {
      java.lang.String location = payload.toString();
      boolean temp$1 = false;
      boolean __xform_tmp_2 = location.startsWith("http");
      temp$1 = __xform_tmp_2 ? (__xform_tmp_2) : (location.startsWith("/"));
      if (temp$1) {
        javax.servlet.http.HttpServletResponse temp$2 = response;
        temp$2.sendRedirect(location);
      }
      else {
        javax.servlet.http.HttpServletResponse temp$3 = response;
        temp$3.setStatus(500);
        java.io.PrintWriter temp$4 = response.getWriter();
        temp$4.write("Invalid redirect location");
      }
    }
    else {
      if (payload instanceof java.lang.String) {
        javax.servlet.http.HttpServletResponse temp$5 = response;
        temp$5.setContentType("text/html; charset=UTF-8");
        java.io.PrintWriter temp$6 = response.getWriter();
        temp$6.write(payload.toString());
      }
      else {
        if (payload instanceof java.lang.Integer) {
          javax.servlet.http.HttpServletResponse temp$7 = response;
          temp$7.setStatus(((java.lang.Integer)(payload)).intValue());
          javax.servlet.http.HttpServletResponse temp$8 = response;
          temp$8.sendRedirect("" + payload + ".html");
        }
        else {
          javax.servlet.http.HttpServletResponse temp$9 = response;
          temp$9.setStatus(500);
          java.io.PrintWriter temp$10 = response.getWriter();
          temp$10.write("Unsupported Response Type");
        }
      }
    }
  }
  public java.lang.Object action_request(javax.servlet.http.HttpServletRequest request, java.lang.String method) {
    this.set_params(new dubious.Params(request));
    java.lang.String temp$1 = null;
    java.lang.String __xform_tmp_3 = request.getParameter("_method");
    temp$1 = (__xform_tmp_3 != null) ? (__xform_tmp_3) : (method);
    method = temp$1;
    return method.equals("get") ? (this.params().action().equals("") ? (this.index()) : (this.params().action().equals("show") ? (this.show()) : (this.params().action().equals("new") ? (this.new()) : (this.params().action().equals("edit") ? (this.edit()) : (((java.lang.Object)(java.lang.Integer.valueOf(404)))))))) : (this.invalid_authenticity_token(request.getParameter("authenticity_token")) ? (((java.lang.Object)(java.lang.Integer.valueOf(422)))) : (method.equals("delete") ? (this.delete()) : (method.equals("post") ? (this.create()) : (method.equals("put") ? (this.update()) : (null)))));
  }
  private boolean invalid_authenticity_token(java.lang.String token) {
    return token.equals("") ? (true) : (false);
  }
  public dubious.FormHelper form_for(com.google.appengine.ext.duby.db.Model model) {
    return new dubious.FormHelper(model, this.params());
  }
  public java.lang.String tag(java.lang.String name, java.lang.String value, java.util.HashMap map) {
    java.lang.StringBuilder sb = new java.lang.StringBuilder("<" + name);
    java.lang.Object[] keys = map.keySet().toArray();
    java.util.Arrays.sort(keys);
    int __xform_tmp_4 = 0;
    java.lang.Object[] __xform_tmp_5 = keys;
    label1:
    while ((__xform_tmp_4 < __xform_tmp_5.length)) {
      java.lang.Object k = __xform_tmp_5[__xform_tmp_4];
      label2:
       {
        sb.append(" " + k + "=\"" + map.get(k) + "\"");
      }
      __xform_tmp_4 = (__xform_tmp_4 + 1);
    }
    java.lang.String tail = (value == null) ? (" />") : (">" + value + "</" + name + ">");
    sb.append(tail);
    return sb.toString();
  }
  public java.lang.String tag(java.lang.String name, java.util.HashMap map) {
    return this.tag(name, null, map);
  }
  public java.lang.String content_tag(java.lang.String name, java.lang.String value, java.util.HashMap map) {
    return this.tag(name, value, map);
  }
  public java.lang.String link_to(java.lang.String value, java.lang.String url) {
    java.util.HashMap options = new java.util.HashMap();
    options.put("href", url);
    return this.tag("a", value, options);
  }
  public java.lang.String link_to(java.lang.String value, java.util.HashMap options) {
    return this.tag("a", value, options);
  }
  public java.lang.String add_asset_timestamp(java.lang.String source) {
    return this.asset_timestamps_cache.get(source);
  }
  public java.lang.String image_path(java.lang.String source) {
    if (source.startsWith("/")) {
    }
    else {
      source = "/images/" + source;
    }
    return this.add_asset_timestamp(source);
  }
  public java.lang.String javascript_path(java.lang.String source) {
    if (source.endsWith(".js")) {
    }
    else {
      source = (source + ".js");
    }
    if (source.startsWith("/")) {
    }
    else {
      source = "/javascripts/" + source;
    }
    return this.add_asset_timestamp(source);
  }
  public java.lang.String stylesheet_path(java.lang.String source) {
    if (source.endsWith(".css")) {
    }
    else {
      source = (source + ".css");
    }
    if (source.startsWith("/")) {
    }
    else {
      source = "/stylesheets/" + source;
    }
    return this.add_asset_timestamp(source);
  }
  public java.lang.String image_tag(java.lang.String source, java.util.HashMap options) {
    options.put("src", this.image_path(source));
    if (options.containsKey("alt")) {
    }
    else {
      options.put("alt", "");
    }
    if (options.containsKey("size") ? (((java.lang.String)(options.get("size"))).matches("\\d+x\\d+")) : (false)) {
      java.lang.String[] values = ((java.lang.String)(options.get("size"))).split("x");
      options.put("width", values[0]);
      options.put("height", values[1]);
      options.remove("size");
    }
    return this.tag("img", options);
  }
  public java.lang.String image_tag(java.lang.String source) {
    return this.image_tag(source, new java.util.HashMap());
  }
  public java.lang.String javascript_include_tag(java.lang.String text) {
    if (text.startsWith("http")) {
    }
    else {
      text = this.javascript_path(text);
    }
    java.util.HashMap options = new java.util.HashMap();
    options.put("src", text);
    options.put("type", "text/javascript");
    return this.tag("script", "", options);
  }
  public java.lang.String stylesheet_link_tag(java.lang.String text) {
    if (text.startsWith("http")) {
    }
    else {
      text = this.stylesheet_path(text);
    }
    java.util.HashMap options = new java.util.HashMap();
    options.put("href", text);
    options.put("rel", "stylesheet");
    options.put("type", "text/css");
    options.put("media", "screen");
    return this.tag("link", options);
  }
  public void init(javax.servlet.ServletConfig config) throws javax.servlet.ServletException {
    this.asset_timestamps_cache = new dubious.AssetTimestampsCache();
  }
  public static void <clinit>() {
    ActionController.escape_pattern = java.util.regex.Pattern.compile("[<>&'\"]");
    ActionController.escaped = new java.util.HashMap();
    ActionController.escaped.put("<", "&lt;");
    ActionController.escaped.put(">", "&gt;");
    ActionController.escaped.put("&", "&amp;");
    ActionController.escaped.put("\"", "&quot;");
    ActionController.escaped.put("'", "&#39;");
  }
  public static java.lang.String html_escape(java.lang.String text) {
    if ((text != null)) {
    }
    else {
      return "";
    }
    java.util.regex.Matcher matcher = ActionController.escape_pattern.matcher(text);
    java.lang.StringBuffer buffer = new java.lang.StringBuffer();
    label1:
    while (matcher.find()) {
      label2:
       {
        java.lang.String replacement = ((java.lang.String)(ActionController.escaped.get(matcher.group())));
        matcher.appendReplacement(buffer, replacement);
      }
    }
    matcher.appendTail(buffer);
    return buffer.toString();
  }
  public static java.lang.String html_escape(java.lang.Object o) {
    if ((o != null)) {
    }
    else {
      return "";
    }
    return dubious.ActionController.html_escape(o.toString());
  }
  public java.lang.String h(java.lang.String text) {
    return dubious.ActionController.html_escape(text);
  }
  public java.lang.String h(java.lang.Object o) {
    return dubious.ActionController.html_escape(o);
  }
}
