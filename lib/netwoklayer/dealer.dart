class Dealer extends Object {

  String tax_dealer_id;
  String tax_dealer_name;
  String tax_dealer_code;
  String tax_dealer_password;

  String tax_dealer_tin;
  String tax_dealer_tin_expiry;
  String tax_dealer_mobile;

  String tax_dealer_pan;
  String tax_dealer_aadhar;
  String tax_dealer_security_q;

  String tax_dealer_security_a;
  String tax_dealer_email;
  String tax_dealer_lastlogin;
  String tax_delaer_status;
  String created_by;
  String created_dt;
  String modified_by;
  String modified_dt;


  Dealer({

    this.tax_dealer_id = "",
    this.tax_dealer_name = "",
    this.tax_dealer_code = "",
    this.tax_dealer_password = "",

    this.tax_dealer_tin = "",
    this.tax_dealer_tin_expiry = "",
    this.tax_dealer_mobile = "",
    this.tax_dealer_pan = "",
    this.tax_dealer_aadhar = "",
    this.tax_dealer_security_q = "",
    this.tax_dealer_security_a = "",
    this.tax_dealer_email = "0",
    this.tax_dealer_lastlogin = "",
    this.tax_delaer_status = "0",
    this.created_by = "",
    this.created_dt = "",
    this.modified_by = "0",
    this.modified_dt = "0",
  });

  flush() {
    this.tax_dealer_id = "";
    this.tax_dealer_name = "";
    this.tax_dealer_code = "";
    this.tax_dealer_password = "";

    this.tax_dealer_tin = "";
    this.tax_dealer_tin_expiry = "";
    this.tax_dealer_mobile = "";
    this.tax_dealer_pan = "";
    this.tax_dealer_aadhar = "";
    this.tax_dealer_security_q = "";
    this.tax_dealer_security_a = "";
    this.tax_dealer_email = "";
    this.tax_dealer_lastlogin = "";
    this.tax_delaer_status = "";
    this.created_by = "";
    this.created_dt = "";
    this.modified_by = "";
    this.modified_dt = "";
  }

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return new Dealer(
      tax_dealer_id: ((json['tax_dealer_id']).toString()).toString() as String,
      tax_dealer_name: ((json['tax_dealer_name']).toString()).toString() as String,
      tax_dealer_code: (json['tax_dealer_code']).toString() as String,
      tax_dealer_password: (json['tax_dealer_password']).toString() as String,

      tax_dealer_tin: json['tax_dealer_tin'] as String,
      tax_dealer_tin_expiry: json['tax_dealer_tin_expiry'] as String,
      tax_dealer_mobile: json['tax_dealer_mobile'] as String,
      tax_dealer_pan: json['tax_dealer_pan'] as String,
      tax_dealer_aadhar: json['tax_dealer_aadhar'] as String,
      tax_dealer_security_q: json['tax_dealer_security_q'] as String,
      tax_dealer_security_a: (json['tax_dealer_security_a']).toString() as String,
      tax_dealer_email: (json['tax_dealer_email']).toString() as String,
      tax_dealer_lastlogin: json['tax_dealer_lastlogin'] as String,
      tax_delaer_status: json['tax_delaer_status'] as String,
      created_by: json['created_by'] as String,
      created_dt: (json['created_dt']).toString() as String,
      modified_by: (json['modified_by']).toString() as String,
        modified_dt: (json['modified_dt']).toString() as String
    );
  }

}