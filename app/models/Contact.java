// Generated from models/contacts.duby
package models;
public class Contact extends com.google.appengine.ext.duby.db.Model {
  private java.lang.String title;
  private java.lang.String summary;
  private java.lang.String url;
  private java.lang.String address;
  private java.lang.String phone;
  public  Contact() {
    super();
  }
  public  Contact(java.lang.String key_name) {
    super(key_name);
  }
  public  Contact(com.google.appengine.ext.duby.db.Model parent) {
    super(parent);
  }
  public  Contact(com.google.appengine.api.datastore.Key parent) {
    super(parent);
  }
  public  Contact(com.google.appengine.ext.duby.db.Model parent, java.lang.String key_name) {
    super(parent, key_name);
  }
  public  Contact(com.google.appengine.api.datastore.Key parent, java.lang.String key_name) {
    super(parent, key_name);
  }
  public static models.Contact get(com.google.appengine.api.datastore.Key key) {
    try {
      models.Contact m = new models.Contact();
      models.Contact temp$1 = m;
      temp$1._read_from(com.google.appengine.ext.duby.db.Model._datastore().get(key));
      return m;
    }
    catch (com.google.appengine.api.datastore.EntityNotFoundException tmp$ex) {
      return null;
    }
  }
  public static models.Contact get(java.lang.String key_name) {
    return models.Contact.get(com.google.appengine.api.datastore.KeyFactory.createKey("Contact", key_name));
  }
  public static models.Contact get(long id) {
    return models.Contact.get(com.google.appengine.api.datastore.KeyFactory.createKey("Contact", id));
  }
  public static models.Contact get(com.google.appengine.api.datastore.Key parent, java.lang.String key_name) {
    return models.Contact.get(com.google.appengine.api.datastore.KeyFactory.createKey(parent, "Contact", key_name));
  }
  public static models.Contact get(com.google.appengine.api.datastore.Key parent, long id) {
    return models.Contact.get(com.google.appengine.api.datastore.KeyFactory.createKey(parent, "Contact", id));
  }
  public static models.Contact get(com.google.appengine.ext.duby.db.Model parent, java.lang.String key_name) {
    return models.Contact.get(com.google.appengine.api.datastore.KeyFactory.createKey(parent.key(), "Contact", key_name));
  }
  public static models.Contact get(com.google.appengine.ext.duby.db.Model parent, long id) {
    return models.Contact.get(com.google.appengine.api.datastore.KeyFactory.createKey(parent.key(), "Contact", id));
  }
  public static models.Contact.Query all() {
    return new models.Contact.Query();
  }
  public void _read_from(com.google.appengine.api.datastore.Entity e) {
    this.entity_set(e);
    java.lang.Object __xform_tmp_1 = e.getProperty("title");
    this.title = ((java.lang.String)(__xform_tmp_1));
    java.lang.Object __xform_tmp_2 = e.getProperty("summary");
    this.summary = (__xform_tmp_2 != null) ? (((com.google.appengine.api.datastore.Text)(__xform_tmp_2)).getValue()) : (((java.lang.String)(null)));
    java.lang.Object __xform_tmp_3 = e.getProperty("url");
    this.url = (__xform_tmp_3 != null) ? (((com.google.appengine.api.datastore.Link)(__xform_tmp_3)).getValue()) : (((java.lang.String)(null)));
    java.lang.Object __xform_tmp_4 = e.getProperty("address");
    this.address = (__xform_tmp_4 != null) ? (((com.google.appengine.api.datastore.PostalAddress)(__xform_tmp_4)).getAddress()) : (((java.lang.String)(null)));
    java.lang.Object __xform_tmp_5 = e.getProperty("phone");
    this.phone = (__xform_tmp_5 != null) ? (((com.google.appengine.api.datastore.PhoneNumber)(__xform_tmp_5)).getNumber()) : (((java.lang.String)(null)));
  }
  public java.util.Map properties() {
    java.util.Map result = super.properties();
    result.put("title", this.title());
    result.put("summary", this.summary());
    result.put("url", this.url());
    result.put("address", this.address());
    result.put("phone", this.phone());
    return result;
  }
  public models.Contact update(java.util.Map properties) {
    if (properties.containsKey("title")) {
      this.title_set(properties.get("title"));
    }
    if (properties.containsKey("summary")) {
      this.summary_set(properties.get("summary"));
    }
    if (properties.containsKey("url")) {
      this.url_set(properties.get("url"));
    }
    if (properties.containsKey("address")) {
      this.address_set(properties.get("address"));
    }
    if (properties.containsKey("phone")) {
      this.phone_set(properties.get("phone"));
    }
    return this;
  }
  public void _save_to(com.google.appengine.api.datastore.Entity e) {
    com.google.appengine.api.datastore.Entity temp$1 = e;
    temp$1.setProperty("title", this.title);
    com.google.appengine.api.datastore.Entity temp$2 = e;
    temp$2.setProperty("summary", (this.summary != null) ? (new com.google.appengine.api.datastore.Text(this.summary)) : (null));
    com.google.appengine.api.datastore.Entity temp$3 = e;
    temp$3.setProperty("url", (this.url != null) ? (new com.google.appengine.api.datastore.Link(this.url)) : (null));
    com.google.appengine.api.datastore.Entity temp$4 = e;
    temp$4.setProperty("address", (this.address != null) ? (new com.google.appengine.api.datastore.PostalAddress(this.address)) : (null));
    com.google.appengine.api.datastore.Entity temp$5 = e;
    temp$5.setProperty("phone", (this.phone != null) ? (new com.google.appengine.api.datastore.PhoneNumber(this.phone)) : (null));
  }
  public java.lang.String title() {
    return this.title;
  }
  public java.lang.String title_set(java.lang.String value) {
    return this.title = value;
  }
  public java.lang.String title_set(java.lang.Object value) {
    return this.title_set(this.coerce_string(value));
  }
  public java.lang.String summary() {
    return this.summary;
  }
  public java.lang.String summary_set(java.lang.String value) {
    return this.summary = value;
  }
  public java.lang.String summary_set(java.lang.Object value) {
    return this.summary_set(this.coerce_string(value));
  }
  public java.lang.String url() {
    return this.url;
  }
  public java.lang.String url_set(java.lang.String value) {
    return this.url = value;
  }
  public java.lang.String url_set(java.lang.Object value) {
    return this.url_set(this.coerce_string(value));
  }
  public java.lang.String address() {
    return this.address;
  }
  public java.lang.String address_set(java.lang.String value) {
    return this.address = value;
  }
  public java.lang.String address_set(java.lang.Object value) {
    return this.address_set(this.coerce_string(value));
  }
  public java.lang.String phone() {
    return this.phone;
  }
  public java.lang.String phone_set(java.lang.String value) {
    return this.phone = value;
  }
  public java.lang.String phone_set(java.lang.Object value) {
    return this.phone_set(this.coerce_string(value));
  }
  public static class Query extends com.google.appengine.ext.duby.db.DQuery {
    public  Query() {
    }
    public java.lang.String kind() {
      return "Contact";
    }
    public models.Contact first() {
      java.util.Iterator it = this._prepare().asIterator();
      if (it.hasNext()) {
        com.google.appengine.api.datastore.Entity e = ((com.google.appengine.api.datastore.Entity)(it.next()));
        models.Contact m = new models.Contact();
        models.Contact temp$1 = m;
        temp$1._read_from(e);
        return m;
      }
      else {
        return ((models.Contact)(null));
      }
    }
    public models.Contact[] run() {
      java.util.List entities = this._prepare().asList(this._options());
      models.Contact[] models = new models.Contact[entities.size()];
      java.util.Iterator it = entities.iterator();
      int i = 0;
      label1:
      while (it.hasNext()) {
        label2:
         {
          com.google.appengine.api.datastore.Entity e = ((com.google.appengine.api.datastore.Entity)(it.next()));
          models.Contact m = new models.Contact();
          models.Contact temp$3 = m;
          temp$3._read_from(e);
          models[i] = m;
          i = (i + 1);
        }
      }
      return models;
    }
    public models.Contact.Query sort(java.lang.String name) {
      return this.sort(name, false);
    }
    public models.Contact.Query sort(java.lang.String name, boolean descending) {
      this._sort(name, descending);
      return this;
    }
    public void title(java.lang.String value) {
      this._query().addFilter("title", this._eq_op(), value);
    }
    public void summary(java.lang.String value) {
      this._query().addFilter("summary", this._eq_op(), (value != null) ? (new com.google.appengine.api.datastore.Text(value)) : (null));
    }
    public void url(java.lang.String value) {
      this._query().addFilter("url", this._eq_op(), (value != null) ? (new com.google.appengine.api.datastore.Link(value)) : (null));
    }
    public void address(java.lang.String value) {
      this._query().addFilter("address", this._eq_op(), (value != null) ? (new com.google.appengine.api.datastore.PostalAddress(value)) : (null));
    }
    public void phone(java.lang.String value) {
      this._query().addFilter("phone", this._eq_op(), (value != null) ? (new com.google.appengine.api.datastore.PhoneNumber(value)) : (null));
    }
  }
}
