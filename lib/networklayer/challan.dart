class Challan extends Object {

  String tax_challan_id;
  String queue_session;
  String tax_challan_title;
  String tax_depositors_name;
  String tax_depositors_phone;
  String tax_depositors_address;
  String tax_challan_location;
  String tax_challan_duration;
  String tax_challan_from_dt;
  String tax_challan_to_dt;
  String tax_challan_purpose;
  String tax_challan_amount;
  String tax_transaction_no;
  String tax_transaction_status;
  String tax_challan_status;
  String tax_type_id;
  String created_by;
  String created_dt;
  String modified_by;
  String modified_dt;

  Challan({
    this.tax_challan_id = "",
    this.queue_session = "",
    this.tax_challan_title = "",
    this.tax_depositors_name = "",
    this.tax_depositors_phone = "",
    this.tax_depositors_address = "",
    this.tax_challan_location = "",
    this.tax_challan_duration = "",
    this.tax_challan_from_dt = "",
    this.tax_challan_to_dt = "",
    this.tax_challan_purpose = "",
    this.tax_challan_amount = "",

    this.tax_transaction_no = "",
    this.tax_transaction_status = "",
    this.tax_challan_status = "",
    this.tax_type_id = "",
    this.created_by = "",
    this.created_dt = "",
    this.modified_by = "",
    this.modified_dt = ""
  });

  flush() {
    this.tax_challan_id = "";
    this.queue_session = "";
    this.tax_challan_title = "";
    this.tax_depositors_name = "";
    this.tax_depositors_phone = "";
    this.tax_depositors_address = "";
    this.tax_challan_location = "";
    this.tax_challan_duration = "";
    this.tax_challan_from_dt = "";
    this.tax_challan_to_dt = "";
    this.tax_challan_purpose = "";
    this.tax_challan_amount = "";

    this.tax_transaction_no = "";
    this.tax_transaction_status = "";
    this.tax_challan_status = "";
    this.tax_type_id = "";
    this.created_by = "";
    this.created_dt = "";
    this.modified_by = "";
    this.modified_dt = "";
  }

  factory Challan.fromJson_challan(Map<String, dynamic> json) {
    return new Challan(
        tax_challan_id: ((json['tax_challan_id']).toString()).toString() as String,
        queue_session: (json['queue_session']).toString() as String,
        tax_challan_title: (json['tax_challan_title']).toString() as String,

        tax_depositors_name: json['tax_depositors_name'] as String,
        tax_depositors_phone: json['tax_depositors_phone'] as String,
        tax_depositors_address: json['tax_depositors_address'] as String,
        tax_challan_location: json['tax_challan_location'] as String,
        tax_challan_duration: json['tax_challan_duration'] as String,
        tax_challan_from_dt: json['tax_challan_from_dt'] as String,
        tax_challan_to_dt: (json['tax_challan_to_dt']).toString() as String,
        tax_challan_purpose: (json['tax_challan_purpose']).toString() as String,
        tax_challan_amount: (json['tax_challan_amount']).toString() as String,

        tax_transaction_no: (json['tax_transaction_no']).toString() as String,
        tax_transaction_status: json['tax_transaction_status'] as String,
        tax_challan_status: json['tax_challan_status'] as String,
        tax_type_id: (json['tax_type_id']).toString() as String,
        created_by: (json['created_by']).toString() as String,
        created_dt: json['created_dt'] as String,
        modified_by: (json['modified_by']).toString() as String,
        modified_dt: json['modified_dt'] as String
    );
  }
}