class Cidade {
  String city_name;
  String date;
  String description;

  Cidade({this.city_name, this.date, this.description});

  Cidade.fromJson(Map<String, dynamic> json) {
    city_name = json['city_name'];
    date = json['date'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_name'] = this.city_name;
    data['date'] = this.date;
    data['description'] = this.description;
    return data;
  }
}