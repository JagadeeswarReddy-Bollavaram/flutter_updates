import 'package:appwrite/appwrite.dart';

class CustomerAccount {
  static Account _getAccount() {
    Client client = Client()
        .setEndpoint("https://nyc.cloud.appwrite.io/v1")
        .setProject("68a0318c003afb94e167");
    Account account = Account(client);
    return account;
  }

  static Account get account => _getAccount();
}
