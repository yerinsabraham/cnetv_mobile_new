import '../models/user.dart';
import '../models/wallet.dart';
import 'dummy_data_loader.dart';

Future<void> testUserParsing() async {
  final jsonData = await DummyDataLoader.loadJson('assets/json/user.json');
  User user = User.fromJson(jsonData);
  print('User Name: ${user.name}');
  print('Wallet Balance: ${user.walletBalance}');
}

Future<void> testWalletParsing() async {
  final jsonData = await DummyDataLoader.loadJson('assets/json/wallet.json');
  Wallet wallet = Wallet.fromJson(jsonData);
  print('Wallet Balance: ${wallet.balance}');
  wallet.transactions.forEach((tx) {
    print('Transaction: ${tx.type} - ${tx.amount}');
  });
}
