import 'package:ggc_desktop/API/api_service.dart';

class NotificationModel{
    late String id;
    late String id_cot;
    late String id_client;
    late String id_mise;
    late DateTime dateNotif;

    NotificationModel.fromJson(Map<String,dynamic> json){
      id = json["id"];
      id_cot = json["id_cot"];
      id_client = json["id_client"];
      id_mise = json['id_mise'];
      dateNotif = json["date"];
    }

    Map<String,dynamic>toMap(){
      final _data = Map<String,dynamic>();
      _data['id'] = id;
      _data['id_cot'] = id_cot;
      _data['id_client'] = id_mise;
      _data['id_mise'] = id_mise;
      _data['data'] = dateNotif;
      return _data;
    }

    static void getNotif() async{
      var res = await MongoDatabase.insertNotification();
    }
}