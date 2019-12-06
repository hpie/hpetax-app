class Epayment extends Object {

  String tax_type;
  String person_name;
  String mobile_number;
  String email;
  String address;
  String location;
  String dealer_type;
  String tax_period_from;
  String tax_period_to;
  String purpose;
  String code;
  String amount;

  Epayment({
    this.tax_type = "",
    this.person_name = "",
    this.mobile_number = "",
    this.email = "",
    this.address = "",
    this.location = "",
    this.dealer_type = "",
    this.tax_period_from = "",
    this.tax_period_to = "",
    this.purpose = "",
    this.code = "",
    this.amount = ""
  });

  flush() {
    this.tax_type = "";
    this.person_name = "";
    this.mobile_number = "";
    this.email = "";
    this.address = "";
    this.location = "";
    this.dealer_type = "";
    this.tax_period_from = "";
    this.tax_period_to = "";
    this.purpose = "";
    this.code = "";
    this.amount = "";
  }

  factory Epayment.fromJson(Map<String, dynamic> json) {
    return new Epayment(
      //tax_type: ((json['tax_item_id']).toString()).toString() as String,
    );
  }

  factory Epayment.fromJson_challan(Map<String, dynamic> json) {
    return new Epayment(
      tax_type: ((json['tax_type']).toString()).toString() as String,
      person_name: (json['person_name']).toString() as String,
      mobile_number: (json['mobile_number']).toString() as String,

      email: json['email'] as String,
      address: json['address'] as String,
      location: json['location'] as String,
      dealer_type: json['dealer_type'] as String,
      tax_period_from: json['tax_period_from'] as String,
      tax_period_to: json['tax_period_to'] as String,
      purpose: (json['purpose']).toString() as String,
      code: (json['code']).toString() as String,
      amount: json['amount'] as String
    );
  }
}