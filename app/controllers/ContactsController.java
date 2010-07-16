// Generated from controllers/contacts_controller.duby
package controllers;
public class ContactsController extends controllers.ApplicationController {
  private models.Contact[] contacts;
  private models.Contact contact;
  public static void main(java.lang.String[] argv) {
  public java.lang.Object index() {
    this.contacts = models.Contact.all().run();
    return this.render(this.index_erb(), this.main_erb());
  }
  public java.lang.Object show() {
    this.contact = models.Contact.get(this.params().id());
    return this.render(this.show_erb(), this.main_erb());
  }
  public java.lang.Object new() {
    this.contact = new models.Contact();
    return this.render(this.new_erb(), this.main_erb());
  }
  public java.lang.Object edit() {
    this.contact = models.Contact.get(this.params().id());
    return this.render(this.edit_erb(), this.main_erb());
  }
  public java.lang.Object delete() {
    models.Contact.delete(models.Contact.get(this.params().id()).key());
    return this.redirect_to(this.params().index());
  }
  public java.lang.Object create() {
    new models.Contact().update(this.params().for("contact")).save();
    return this.redirect_to(this.params().index());
  }
  public java.lang.Object update() {
    models.Contact.get(this.params().id()).update(this.params().for("contact")).save();
    return this.redirect_to(this.params().show());
  }
  public void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {
    this.action_response(response, this.action_request(request, "get"));
  }
  public void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {
    this.action_response(response, this.action_request(request, "post"));
  }
  public java.lang.String index_erb() {
    java.lang.StringBuilder _edbout = new java.lang.StringBuilder();
    _edbout.append("<h1>Listing contacts</h1>\n\n<table>\n  <tr>\n    <th>Title</th>\n    <th>Summary</th>\n    <th>Url</th>\n    <th>Address</th>\n    <th>Phone</th>\n  </tr>\n\n");
    int __xform_tmp_1 = 0;
    models.Contact[] __xform_tmp_2 = this.contacts;
    label1:
    while ((__xform_tmp_1 < __xform_tmp_2.length)) {
      models.Contact contact = __xform_tmp_2[__xform_tmp_1];
      label2:
       {
        _edbout.append("\n  <tr>\n    <td>");
        _edbout.append(this.h(contact.title()));
        _edbout.append("</td>\n    <td>");
        _edbout.append(this.h(contact.summary()));
        _edbout.append("</td>\n    <td>");
        _edbout.append(this.h(contact.url()));
        _edbout.append("</td>\n    <td>");
        _edbout.append(this.h(contact.address()));
        _edbout.append("</td>\n    <td>");
        _edbout.append(this.h(contact.phone()));
        _edbout.append("</td>\n    <td>");
        _edbout.append(this.link_to("Show", this.params().show(contact.key().getId())));
        _edbout.append("</td>\n    <td>");
        _edbout.append(this.link_to("Edit", this.params().edit(contact.key().getId())));
        _edbout.append("</td>\n    <td>");
        _edbout.append(this.link_to("Delete", this.params().delete(contact.key().getId())));
        _edbout.append("</td>\n  </tr>\n");
      }
      __xform_tmp_1 = (__xform_tmp_1 + 1);
    }
    _edbout.append("\n</table>\n\n<br />\n\n");
    _edbout.append(this.link_to("New contact", this.params().new()));
    _edbout.append("\n");
    return _edbout.toString();
  }
  public java.lang.String show_erb() {
    java.lang.StringBuilder _edbout = new java.lang.StringBuilder();
    _edbout.append("<p>\n  <b>Title:</b>\n  ");
    _edbout.append(this.h(this.contact.title()));
    _edbout.append("\n</p>\n\n<p>\n  <b>Summary:</b>\n  ");
    _edbout.append(this.h(this.contact.summary()));
    _edbout.append("\n</p>\n\n<p>\n  <b>Url:</b>\n  ");
    _edbout.append(this.h(this.contact.url()));
    _edbout.append("\n</p>\n\n<p>\n  <b>Address:</b>\n  ");
    _edbout.append(this.h(this.contact.address()));
    _edbout.append("\n</p>\n\n<p>\n  <b>Phone:</b>\n  ");
    _edbout.append(this.h(this.contact.phone()));
    _edbout.append("\n</p>\n\n");
    _edbout.append(this.link_to("Edit", this.params().edit()));
    _edbout.append(" |\n");
    _edbout.append(this.link_to("Back", this.params().index()));
    _edbout.append("\n");
    return _edbout.toString();
  }
  public java.lang.String new_erb() {
    java.lang.StringBuilder _edbout = new java.lang.StringBuilder();
    _edbout.append("<h1>New contact</h1>\n\n");
    dubious.FormHelper f = this.form_for(this.contact);
    _edbout.append("\n  ");
    _edbout.append(f.start_form());
    _edbout.append("\n  ");
    _edbout.append(f.error_messages());
    _edbout.append("\n  <p>\n    ");
    _edbout.append(f.label("title"));
    _edbout.append("<br />\n    ");
    _edbout.append(f.text_field("title"));
    _edbout.append("\n  </p>\n  <p>\n    ");
    _edbout.append(f.label("summary"));
    _edbout.append("<br />\n    ");
    _edbout.append(f.text_area("summary"));
    _edbout.append("\n  </p>\n  <p>\n    ");
    _edbout.append(f.label("url"));
    _edbout.append("<br />\n    ");
    _edbout.append(f.text_field("url"));
    _edbout.append("\n  </p>\n  <p>\n    ");
    _edbout.append(f.label("address"));
    _edbout.append("<br />\n    ");
    _edbout.append(f.text_field("address"));
    _edbout.append("\n  </p>\n  <p>\n    ");
    _edbout.append(f.label("phone"));
    _edbout.append("<br />\n    ");
    _edbout.append(f.text_field("phone"));
    _edbout.append("\n  </p>\n  <p>\n    ");
    _edbout.append(f.submit("Create"));
    _edbout.append("\n  </p>\n  ");
    _edbout.append(f.end_form());
    _edbout.append("\n\n");
    _edbout.append(this.link_to("Back", this.params().index()));
    _edbout.append("\n");
    return _edbout.toString();
  }
  public java.lang.String edit_erb() {
    java.lang.StringBuilder _edbout = new java.lang.StringBuilder();
    _edbout.append("<h1>Editing contact</h1>\n\n");
    dubious.FormHelper f = this.form_for(this.contact);
    _edbout.append("\n  ");
    _edbout.append(f.start_form());
    _edbout.append("\n  ");
    _edbout.append(f.error_messages());
    _edbout.append("\n  <p>\n    ");
    _edbout.append(f.label("title"));
    _edbout.append("<br />\n    ");
    _edbout.append(f.text_field("title"));
    _edbout.append("\n  </p>\n  <p>\n    ");
    _edbout.append(f.label("summary"));
    _edbout.append("<br />\n    ");
    _edbout.append(f.text_area("summary"));
    _edbout.append("\n  </p>\n  <p>\n    ");
    _edbout.append(f.label("url"));
    _edbout.append("<br />\n    ");
    _edbout.append(f.text_field("url"));
    _edbout.append("\n  </p>\n  <p>\n    ");
    _edbout.append(f.label("address"));
    _edbout.append("<br />\n    ");
    _edbout.append(f.text_field("address"));
    _edbout.append("\n  </p>\n  <p>\n    ");
    _edbout.append(f.label("phone"));
    _edbout.append("<br />\n    ");
    _edbout.append(f.text_field("phone"));
    _edbout.append("\n  </p>\n  <p>\n    ");
    _edbout.append(f.submit("Update"));
    _edbout.append("\n  </p>\n  ");
    _edbout.append(f.end_form());
    _edbout.append("\n\n");
    _edbout.append(this.link_to("Show", this.params().show()));
    _edbout.append(" |\n");
    _edbout.append(this.link_to("Back", this.params().index()));
    _edbout.append("\n");
    return _edbout.toString();
  }
  public java.lang.String main_erb() {
    java.lang.StringBuilder _edbout = new java.lang.StringBuilder();
    _edbout.append("<!DOCTYPE html>\n<head>\n  <meta charset=\"UTF-8\" /> \n  <meta name=\"csrf-param\" content=\"authenticity_token\"/>\n  <meta name=\"csrf-token\" content=\"123\"/>\n  <title>Contacts: ");
    _edbout.append(this.params().action());
    _edbout.append("</title>\n  ");
    _edbout.append(this.stylesheet_link_tag("scaffold"));
    _edbout.append("\n  ");
    _edbout.append(this.javascript_include_tag("http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"));
    _edbout.append("\n  ");
    _edbout.append(this.javascript_include_tag("jquery.rails.min"));
    _edbout.append("\n</head>\n<body>\n\n<p style=\"color: green\">");
    _edbout.append(this.flash_notice());
    _edbout.append("</p>\n\n");
    _edbout.append(this.yield_body());
    _edbout.append("\n\n</body>\n</html>\n");
    return _edbout.toString();
  }
}
