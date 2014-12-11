// ORM class for table 'null'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Fri Nov 21 18:03:27 CST 2014
// For connector: org.apache.sqoop.manager.MySQLManager
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapred.lib.db.DBWritable;
import com.cloudera.sqoop.lib.JdbcWritableBridge;
import com.cloudera.sqoop.lib.DelimiterSet;
import com.cloudera.sqoop.lib.FieldFormatter;
import com.cloudera.sqoop.lib.RecordParser;
import com.cloudera.sqoop.lib.BooleanParser;
import com.cloudera.sqoop.lib.BlobRef;
import com.cloudera.sqoop.lib.ClobRef;
import com.cloudera.sqoop.lib.LargeObjectLoader;
import com.cloudera.sqoop.lib.SqoopRecord;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class QueryResult extends SqoopRecord  implements DBWritable, Writable {
  private final int PROTOCOL_VERSION = 3;
  public int getClassFormatVersion() { return PROTOCOL_VERSION; }
  protected ResultSet __cur_result_set;
  private Integer EPG_id;
  public Integer get_EPG_id() {
    return EPG_id;
  }
  public void set_EPG_id(Integer EPG_id) {
    this.EPG_id = EPG_id;
  }
  public QueryResult with_EPG_id(Integer EPG_id) {
    this.EPG_id = EPG_id;
    return this;
  }
  private String channel_name;
  public String get_channel_name() {
    return channel_name;
  }
  public void set_channel_name(String channel_name) {
    this.channel_name = channel_name;
  }
  public QueryResult with_channel_name(String channel_name) {
    this.channel_name = channel_name;
    return this;
  }
  private String program_name;
  public String get_program_name() {
    return program_name;
  }
  public void set_program_name(String program_name) {
    this.program_name = program_name;
  }
  public QueryResult with_program_name(String program_name) {
    this.program_name = program_name;
    return this;
  }
  private java.sql.Date epg_date;
  public java.sql.Date get_epg_date() {
    return epg_date;
  }
  public void set_epg_date(java.sql.Date epg_date) {
    this.epg_date = epg_date;
  }
  public QueryResult with_epg_date(java.sql.Date epg_date) {
    this.epg_date = epg_date;
    return this;
  }
  private java.sql.Timestamp start_time;
  public java.sql.Timestamp get_start_time() {
    return start_time;
  }
  public void set_start_time(java.sql.Timestamp start_time) {
    this.start_time = start_time;
  }
  public QueryResult with_start_time(java.sql.Timestamp start_time) {
    this.start_time = start_time;
    return this;
  }
  private java.sql.Timestamp end_time;
  public java.sql.Timestamp get_end_time() {
    return end_time;
  }
  public void set_end_time(java.sql.Timestamp end_time) {
    this.end_time = end_time;
  }
  public QueryResult with_end_time(java.sql.Timestamp end_time) {
    this.end_time = end_time;
    return this;
  }
  private Integer authorized;
  public Integer get_authorized() {
    return authorized;
  }
  public void set_authorized(Integer authorized) {
    this.authorized = authorized;
  }
  public QueryResult with_authorized(Integer authorized) {
    this.authorized = authorized;
    return this;
  }
  private Integer copyright;
  public Integer get_copyright() {
    return copyright;
  }
  public void set_copyright(Integer copyright) {
    this.copyright = copyright;
  }
  public QueryResult with_copyright(Integer copyright) {
    this.copyright = copyright;
    return this;
  }
  private Integer clip_length;
  public Integer get_clip_length() {
    return clip_length;
  }
  public void set_clip_length(Integer clip_length) {
    this.clip_length = clip_length;
  }
  public QueryResult with_clip_length(Integer clip_length) {
    this.clip_length = clip_length;
    return this;
  }
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof QueryResult)) {
      return false;
    }
    QueryResult that = (QueryResult) o;
    boolean equal = true;
    equal = equal && (this.EPG_id == null ? that.EPG_id == null : this.EPG_id.equals(that.EPG_id));
    equal = equal && (this.channel_name == null ? that.channel_name == null : this.channel_name.equals(that.channel_name));
    equal = equal && (this.program_name == null ? that.program_name == null : this.program_name.equals(that.program_name));
    equal = equal && (this.epg_date == null ? that.epg_date == null : this.epg_date.equals(that.epg_date));
    equal = equal && (this.start_time == null ? that.start_time == null : this.start_time.equals(that.start_time));
    equal = equal && (this.end_time == null ? that.end_time == null : this.end_time.equals(that.end_time));
    equal = equal && (this.authorized == null ? that.authorized == null : this.authorized.equals(that.authorized));
    equal = equal && (this.copyright == null ? that.copyright == null : this.copyright.equals(that.copyright));
    equal = equal && (this.clip_length == null ? that.clip_length == null : this.clip_length.equals(that.clip_length));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.EPG_id = JdbcWritableBridge.readInteger(1, __dbResults);
    this.channel_name = JdbcWritableBridge.readString(2, __dbResults);
    this.program_name = JdbcWritableBridge.readString(3, __dbResults);
    this.epg_date = JdbcWritableBridge.readDate(4, __dbResults);
    this.start_time = JdbcWritableBridge.readTimestamp(5, __dbResults);
    this.end_time = JdbcWritableBridge.readTimestamp(6, __dbResults);
    this.authorized = JdbcWritableBridge.readInteger(7, __dbResults);
    this.copyright = JdbcWritableBridge.readInteger(8, __dbResults);
    this.clip_length = JdbcWritableBridge.readInteger(9, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeInteger(EPG_id, 1 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeString(channel_name, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(program_name, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeDate(epg_date, 4 + __off, 91, __dbStmt);
    JdbcWritableBridge.writeTimestamp(start_time, 5 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeTimestamp(end_time, 6 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeInteger(authorized, 7 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(copyright, 8 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(clip_length, 9 + __off, 4, __dbStmt);
    return 9;
  }
  public void readFields(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.EPG_id = null;
    } else {
    this.EPG_id = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.channel_name = null;
    } else {
    this.channel_name = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.program_name = null;
    } else {
    this.program_name = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.epg_date = null;
    } else {
    this.epg_date = new Date(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.start_time = null;
    } else {
    this.start_time = new Timestamp(__dataIn.readLong());
    this.start_time.setNanos(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.end_time = null;
    } else {
    this.end_time = new Timestamp(__dataIn.readLong());
    this.end_time.setNanos(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.authorized = null;
    } else {
    this.authorized = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.copyright = null;
    } else {
    this.copyright = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.clip_length = null;
    } else {
    this.clip_length = Integer.valueOf(__dataIn.readInt());
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.EPG_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.EPG_id);
    }
    if (null == this.channel_name) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, channel_name);
    }
    if (null == this.program_name) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, program_name);
    }
    if (null == this.epg_date) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.epg_date.getTime());
    }
    if (null == this.start_time) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.start_time.getTime());
    __dataOut.writeInt(this.start_time.getNanos());
    }
    if (null == this.end_time) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.end_time.getTime());
    __dataOut.writeInt(this.end_time.getNanos());
    }
    if (null == this.authorized) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.authorized);
    }
    if (null == this.copyright) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.copyright);
    }
    if (null == this.clip_length) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.clip_length);
    }
  }
  private static final DelimiterSet __outputDelimiters = new DelimiterSet((char) 44, (char) 10, (char) 0, (char) 0, false);
  public String toString() {
    return toString(__outputDelimiters, true);
  }
  public String toString(DelimiterSet delimiters) {
    return toString(delimiters, true);
  }
  public String toString(boolean useRecordDelim) {
    return toString(__outputDelimiters, useRecordDelim);
  }
  public String toString(DelimiterSet delimiters, boolean useRecordDelim) {
    StringBuilder __sb = new StringBuilder();
    char fieldDelim = delimiters.getFieldsTerminatedBy();
    __sb.append(FieldFormatter.escapeAndEnclose(EPG_id==null?"null":"" + EPG_id, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(channel_name==null?"null":channel_name, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(program_name==null?"null":program_name, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(epg_date==null?"null":"" + epg_date, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(start_time==null?"null":"" + start_time, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(end_time==null?"null":"" + end_time, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(authorized==null?"null":"" + authorized, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(copyright==null?"null":"" + copyright, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(clip_length==null?"null":"" + clip_length, delimiters));
    if (useRecordDelim) {
      __sb.append(delimiters.getLinesTerminatedBy());
    }
    return __sb.toString();
  }
  private static final DelimiterSet __inputDelimiters = new DelimiterSet((char) 44, (char) 10, (char) 0, (char) 0, false);
  private RecordParser __parser;
  public void parse(Text __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharSequence __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(byte [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(char [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(ByteBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  private void __loadFromFields(List<String> fields) {
    Iterator<String> __it = fields.listIterator();
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EPG_id = null; } else {
      this.EPG_id = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.channel_name = null; } else {
      this.channel_name = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.program_name = null; } else {
      this.program_name = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.epg_date = null; } else {
      this.epg_date = java.sql.Date.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.start_time = null; } else {
      this.start_time = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.end_time = null; } else {
      this.end_time = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.authorized = null; } else {
      this.authorized = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.copyright = null; } else {
      this.copyright = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.clip_length = null; } else {
      this.clip_length = Integer.valueOf(__cur_str);
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  public Object clone() throws CloneNotSupportedException {
    QueryResult o = (QueryResult) super.clone();
    o.epg_date = (o.epg_date != null) ? (java.sql.Date) o.epg_date.clone() : null;
    o.start_time = (o.start_time != null) ? (java.sql.Timestamp) o.start_time.clone() : null;
    o.end_time = (o.end_time != null) ? (java.sql.Timestamp) o.end_time.clone() : null;
    return o;
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new TreeMap<String, Object>();
    __sqoop$field_map.put("EPG_id", this.EPG_id);
    __sqoop$field_map.put("channel_name", this.channel_name);
    __sqoop$field_map.put("program_name", this.program_name);
    __sqoop$field_map.put("epg_date", this.epg_date);
    __sqoop$field_map.put("start_time", this.start_time);
    __sqoop$field_map.put("end_time", this.end_time);
    __sqoop$field_map.put("authorized", this.authorized);
    __sqoop$field_map.put("copyright", this.copyright);
    __sqoop$field_map.put("clip_length", this.clip_length);
    return __sqoop$field_map;
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if ("EPG_id".equals(__fieldName)) {
      this.EPG_id = (Integer) __fieldVal;
    }
    else    if ("channel_name".equals(__fieldName)) {
      this.channel_name = (String) __fieldVal;
    }
    else    if ("program_name".equals(__fieldName)) {
      this.program_name = (String) __fieldVal;
    }
    else    if ("epg_date".equals(__fieldName)) {
      this.epg_date = (java.sql.Date) __fieldVal;
    }
    else    if ("start_time".equals(__fieldName)) {
      this.start_time = (java.sql.Timestamp) __fieldVal;
    }
    else    if ("end_time".equals(__fieldName)) {
      this.end_time = (java.sql.Timestamp) __fieldVal;
    }
    else    if ("authorized".equals(__fieldName)) {
      this.authorized = (Integer) __fieldVal;
    }
    else    if ("copyright".equals(__fieldName)) {
      this.copyright = (Integer) __fieldVal;
    }
    else    if ("clip_length".equals(__fieldName)) {
      this.clip_length = (Integer) __fieldVal;
    }
    else {
      throw new RuntimeException("No such field: " + __fieldName);
    }
  }
}
