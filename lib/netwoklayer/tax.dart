class Tax extends Object {
  static int item_queue_id = 1;

  String tax_item_id;
  String tax_item_queue_id;
  String tax_queue_session;

  String tax_type_id;
  String tax_type;
  String tax_name;

  String tax_commodity_id;
  String tax_commodity_name;
  String tax_commodity_description;

  String vehicle_number;
  String weight;
  String unit;
  String quantity;
  String source_location;
  String destination_location;
  String distance;
  String total_tax;
  /*
  Tax(){
    this.tax_type_id;
    this.tax_type;
    this.tax_commodity_id = "";
    this.tax_commodity_name = "";
    this.tax_commodity_description = "";
    this.vehicle_number = "";
    this.weight = "";
    this.unit = "";
    this.quantity = "";
    this.source_location = "";
    this.destination_location = "";
    this.distance = "";
    this.total_tax = "";
  }
  */

  Tax({

    this.tax_item_id = "",
    this.tax_item_queue_id = "",
    this.tax_queue_session = "",

    this.tax_type_id = "",
    this.tax_type = "",
    this.tax_name = "",
    this.tax_commodity_id = "",
    this.tax_commodity_name = "",
    this.tax_commodity_description = "",
    this.vehicle_number = "",
    this.weight = "0",
    this.unit = "",
    this.quantity = "0",
    this.source_location = "",
    this.destination_location = "",
    this.distance = "0",
    this.total_tax = "0",
  });

  flush() {
    this.tax_item_id = "";
    this.tax_item_queue_id = "";
    this.tax_queue_session = "";

    this.tax_type_id = "";
    this.tax_type = "";
    this.tax_name = "";
    this.tax_commodity_id = "";
    this.tax_commodity_name = "";
    this.tax_commodity_description = "";
    this.vehicle_number = "";
    this.weight = "0";
    this.unit = "";
    this.quantity = "0";
    this.source_location = "";
    this.destination_location = "";
    this.distance = "0";
    this.total_tax = "0.0";
  }

  factory Tax.fromJson(Map<String, dynamic> json) {
    return new Tax(
      tax_item_id: ((json['tax_item_id']).toString()).toString() as String,
      tax_item_queue_id: (json['tax_item_queue_id']).toString() as String,
      tax_queue_session: (json['tax_queue_session']).toString() as String,

    tax_type_id: json['tax_type_id'] as String,
    tax_type: json['tax_type_name'] as String,
    tax_commodity_id: json['tax_commodity_id'] as String,
    tax_commodity_name: json['tax_commodity_name'] as String,
    tax_commodity_description: json['tax_commodity_description'] as String,
    vehicle_number: json['tax_vehicle_number'] as String,
    weight: (json['tax_item_weight']).toString() as String,
    unit: (json['tax_item_weight_units']).toString() as String,
    quantity: json['tax_item_quantity'] as String,
    source_location: json['tax_item_source_location'] as String,
    destination_location: json['tax_item_destination_location'] as String,
    distance: (json['tax_item_distanceinkm']).toString() as String,
    total_tax: (json['tax_item_tax_amount']).toString() as String,
    );
  }

}