class Commodity extends Object {

  String tax_commodity_id;
  String tax_commodity_name;
  String tax_commodity_description;
  double tax_commodity_rate;
  int tax_commodity_rate_unit;
  String tax_commodity_unit_measure;
  String tax_commodity_taxcalculation;
  String tax_commodity_isdistancedependent;

   String tax_commodity_subhead;
  String tax_commodity_status;
  String tax_type_id;
  String created_by;
  String created_dt;
  String modified_by;
  String modified_dt;

  Commodity({
    this.tax_commodity_id,
    this.tax_commodity_name,
    this.tax_commodity_description,
    this.tax_commodity_rate,
    this.tax_commodity_rate_unit,
    this.tax_commodity_unit_measure,
    this.tax_commodity_taxcalculation,
    this.tax_commodity_isdistancedependent,
    this.tax_commodity_subhead,
    this.tax_commodity_status,
    this.tax_type_id,
    this.created_by,
    this.created_dt,
    this.modified_by,
    this.modified_dt
  });

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return new Commodity(
        tax_commodity_id: json['tax_commodity_id'] as String,
        tax_commodity_name: json['tax_commodity_name'] as String,
        tax_commodity_description: json['tax_commodity_description'] as String,
        tax_commodity_rate: double.parse(json['tax_commodity_rate'].toString()),
        tax_commodity_rate_unit: json['tax_commodity_rate_unit'] as int,
        tax_commodity_taxcalculation: json['tax_commodity_taxcalculation'] as String,
        tax_commodity_isdistancedependent: json['tax_commodity_isdistancedependent'] as String,
        tax_commodity_subhead: json['tax_commodity_subhead'] as String,
        tax_commodity_status: json['tax_commodity_status'] as String,

        tax_type_id: json['tax_type_id'] as String,
        created_by: json['created_by'] as String,
        created_dt: json['created_dt'] as String,
        modified_by: json['modified_by'] as String,
        modified_dt: json['modified_dt'] as String
    );
  }


  Commodity.flash(Map<String, dynamic> json) {
    this.tax_commodity_id = "";
    this.tax_commodity_name = "";
    this.tax_commodity_description = "";
    this.tax_commodity_rate = null;
    this.tax_commodity_rate_unit = null;
    this.tax_commodity_unit_measure = "";
    this.tax_commodity_taxcalculation = "";
    this.tax_commodity_isdistancedependent = "";

    this.tax_commodity_status = "";
    this.tax_type_id = "";
    this.created_by = "";
    this.created_dt = "";
    this.modified_by = "";
    this.modified_dt = "";
  }

  data(Map<String, dynamic> json) {
    this.tax_commodity_id = json['tax_commodity_id'] as String;
    this.tax_commodity_name = json['tax_commodity_name'] as String;
    this.tax_commodity_description = json['tax_commodity_description'] as String;
    this.tax_commodity_rate = double.parse( (json['tax_commodity_rate']).toString()) as double;
    this.tax_commodity_rate_unit = json['tax_commodity_rate_unit'] as int;
    this.tax_commodity_unit_measure = json['tax_commodity_unit_measure'] as String;
    this.tax_commodity_taxcalculation = json['tax_commodity_taxcalculation'] as String;
    this.tax_commodity_isdistancedependent = json['tax_commodity_isdistancedependent'] as String;

    this.tax_commodity_subhead = json['tax_commodity_subhead'] as String;

    this.tax_commodity_status = json['tax_commodity_status'] as String;
    this.tax_type_id = json['tax_type_id'] as String;
    this.created_by = json['created_by'] as String;
    this.created_dt = json['created_dt'] as String;
    this.modified_by = json['modified_by'] as String;
    this.modified_dt = json['modified_dt'] as String;
  }
}