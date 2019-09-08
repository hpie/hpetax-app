class Taxtype extends Object {
  String tax_type_id;
  String tax_type_name;
  String tax_type_description;
  String tax_type_status;
  String created_by;
  String created_dt;
  String modified_by;
  String modified_dt;

  Taxtype({
    this.tax_type_id,
    this.tax_type_name,
    this.tax_type_description,
    this.tax_type_status
  });

  factory Taxtype.fromJson(Map<String, dynamic> json) {
    return new Taxtype(
      tax_type_id: json['tax_type_id'] as String,
        tax_type_name: json['tax_type_name'] as String,
      tax_type_description: json['tax_type_description'] as String,
      tax_type_status: json['tax_type_status'] as String
    );
  }
}