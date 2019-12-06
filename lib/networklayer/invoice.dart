class Invoice extends Object {
  static int item_queue_id = 1;

  String id;
  String invoice_no;
  String invoice_date;

  String invoice_amount;
  String vehicle_number;
  String transaction_type;

  String consigner_gst;
  String firm_name;
  String firm_address;

  String consignee_gst;
  String consignee_firm_name;
  String bill_to;
  String ship_to;

  String identification_type;
  String identification_number;
  String is_registered;
  String created_by;

  Invoice({

    this.id = "",
    this.invoice_no = "",
    this.invoice_date = "",

    this.invoice_amount = "",
    this.vehicle_number = "",
    this.transaction_type = "",
    this.consigner_gst = "",
    this.firm_name = "",
    this.firm_address = "",
    this.consignee_gst = "",
    this.consignee_firm_name = "0",
    this.bill_to = "",
    this.ship_to = "0",

  this.identification_type = "",
    this.identification_number = "",
  this.is_registered = "",
  this.created_by = "",
  });

  flush() {
    this.id = "";
    this.invoice_no = "";
    this.invoice_date = "";

    this.invoice_amount = "";
    this.vehicle_number = "";
    this.transaction_type = "";
    this.consigner_gst = "";
    this.firm_name = "";
    this.firm_address = "";
    this.consignee_gst = "";
    this.consignee_firm_name = "";
    this.bill_to = "";
    this.ship_to = "";

    this.identification_type = "";
    this.identification_number = "";
    this.is_registered = "";
    this.created_by = "";
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return new Invoice(
      id: ((json['id']).toString()).toString() as String,
      invoice_no: (json['invoice_no']).toString() as String,
      invoice_date: (json['invoice_date']).toString() as String,

      invoice_amount: json['invoice_amount'] as String,
      vehicle_number: json['vehicle_number'] as String,
      transaction_type: json['transaction_type'] as String,
      consigner_gst: json['consigner_gst'] as String,
      firm_name: json['firm_name'] as String,
      firm_address: json['firm_address'] as String,
      consignee_gst: (json['consignee_gst']).toString() as String,
      consignee_firm_name: (json['consignee_firm_name']).toString() as String,
      bill_to: json['bill_to'] as String,
      ship_to: json['ship_to'] as String,


        identification_type: json['identification_type'] as String,
        identification_number: json['identification_number'] as String,
        is_registered: json['is_registered'] as String,
        created_by: json['created_by'] as String,
    );
  }

}