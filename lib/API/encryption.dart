import 'package:encrypt/encrypt.dart' as encrypt;
// Class de cripatage de mot de passe
class Encryption{

  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));


  static String EncryptPassword(String mdp){
    final encrypted = encrypter.encrypt(mdp,iv: iv);
    print(encrypted.base16);
    return encrypted.base16;
  }

  static DecryptPassword(mdp){
    var dMdp = mdp;
    final decrypted = encrypter.decrypt16(dMdp, iv: iv);
    return decrypted;
  }
}