class AchatTransModel{
  late String id;
  late DateTime date;
  late String designation;
  late double montant;
  late double solde;


  AchatTransModel({
    this.id = "",
    required this.solde,
    required this.montant,
    required this.designation
});


  AchatTransModel.fromsJson(Map<String,dynamic> json){
    id = json['id'];
    date = json['date'];
    designation = json['designation'];
    montant = json['montant'];
    solde = json['solde'];
  }

  Map<String, dynamic> toMap(){
    final _data = Map<String,dynamic>();
    _data['id'] = id;
    _data['date'] = date;
    _data['montant'] = montant;
    _data['designation'] = designation;
    _data['solde'] = solde;
    return _data;
  }

}