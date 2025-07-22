import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

late EthereumAddress adminAddress;
late String donorAddress;
late EthereumAddress patientAddress;
late String adminPrivateKey;
late String donorPrivateKey;
late String patientPrivateKey;

class UserPreferences {
  // Save private key with email as the key
  // Save user details
  static Future<void> saveUser(String email, String privateKey, String name,
      String contact, String bloodGroup) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(email, privateKey);
    await prefs.setString("${email}_name", name);
    await prefs.setString("${email}_contact", contact);
    await prefs.setString("${email}_bloodGroup", bloodGroup);
  }

  // Retrieve Ethereum address using email
  static Future<String?> getAddress(String email) async {
    final prefs = await SharedPreferences.getInstance();
    String? privateKey = prefs.getString(email);
    if (privateKey != null) {
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address.hex;
      return address;
    }
    return null;
  }

  // Retrieve private key using email
  static Future<String?> getPrivateKey(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(email);
  }

  // Retrieve user name
  static Future<String?> getName(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("${email}_name");
  }

  // Retrieve user contact
  static Future<String?> getContact(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("${email}_contact");
  }

  // Retrieve user blood group
  static Future<String?> getBloodGroup(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("${email}_bloodGroup");
  }
}

class GlobalData {
  static String? address;
  static String? privatekey;
  static String? name;
  static String? contact;
  static String? bg;
}
