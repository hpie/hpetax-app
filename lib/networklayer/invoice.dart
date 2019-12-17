class Invoice extends Object {
  static int item_queue_id = 1;


  String tax_edt_invoice_id;
  String invoice_no;
  String invoice_date;
  String invoice_amount;
  String vehicle_number;
  String transaction_type;
  String consigner_gst;
  String consigner_firm_name;
  String consigner_firm_address;
  String consignee_gst;
  String consignee_firm_name;
  String consignee_bill_to;
  String consignee_ship_to;
  String identification_type;
  String identification_number;
  String is_registered;
  String tax_dealer_code;
  String inspected_date;
  String tax_employee_code;
  String created_by;
  String created_date;



  Invoice({

      this.tax_edt_invoice_id = "",
    this.invoice_no = "",
    this.invoice_date = "",
    this.invoice_amount = "",
    this.vehicle_number = "",
    this.transaction_type = "",
    this.consigner_gst = "",
    this.consigner_firm_name = "",
    this.consigner_firm_address = "",
    this.consignee_gst = "",
    this.consignee_firm_name = "",
    this.consignee_bill_to = "",
    this.consignee_ship_to = "",
    this.identification_type = "",
    this.identification_number = "",
    this.is_registered = "",
    this.tax_dealer_code = "",
    this.inspected_date = "",
    this.tax_employee_code = "",
    this.created_by = "",
    this.created_date = ""
  });

  flush() {
    this.tax_edt_invoice_id = "";
    this.invoice_no = "";
    this.invoice_date = "";
    this.invoice_amount = "";
    this.vehicle_number = "";
    this.transaction_type = "";
    this.consigner_gst = "";
    this.consigner_firm_name = "";
    this.consigner_firm_address = "";
    this.consignee_gst = "";
    this.consignee_firm_name = "";
    this.consignee_bill_to = "";
    this.consignee_ship_to = "";
    this.identification_type = "";
    this.identification_number = "";
    this.is_registered = "";
    this.tax_dealer_code = "";
    this.inspected_date = "";
    this.tax_employee_code = "";
    this.created_by = "";
    this.created_date = "";
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return new Invoice(
        tax_edt_invoice_id: ((json['tax_edt_invoice_id']).toString()).toString() as String,
        invoice_no: ((json['invoice_no']).toString()).toString() as String,
        invoice_date: ((json['invoice_date']).toString()).toString() as String,
        invoice_amount: ((json['invoice_amount']).toString()).toString() as String,
        vehicle_number: ((json['vehicle_number']).toString()).toString() as String,
        transaction_type: ((json['transaction_type']).toString()).toString() as String,
        consigner_gst: ((json['consigner_gst']).toString()).toString() as String,
        consigner_firm_name: ((json['consigner_firm_name']).toString()).toString() as String,
        consignee_gst: ((json['consignee_gst']).toString()).toString() as String,
        consignee_firm_name: ((json['consignee_firm_name']).toString()).toString() as String,
        consignee_bill_to: ((json['consignee_bill_to']).toString()).toString() as String,
        consignee_ship_to: ((json['consignee_ship_to']).toString()).toString() as String,
        identification_type: ((json['identification_type']).toString()).toString() as String,
        identification_number: ((json['identification_number']).toString()).toString() as String,
        is_registered: ((json['is_registered']).toString()).toString() as String,
        tax_dealer_code: ((json['tax_dealer_code']).toString()).toString() as String,


        inspected_date: ((json['inspected_date']).toString()).toString() as String,
        tax_employee_code: ((json['tax_employee_code']).toString()).toString() as String,
        created_by: ((json['created_by']).toString()).toString() as String,
        created_date: ((json['created_date']).toString()).toString() as String
    );
  }

}