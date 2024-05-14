import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MainController extends GetxController {
  var counter = 0.obs;
  var mnemonic = [].obs;
  var address = "".obs;
  void setMnemonic(List _mnemonic){
    mnemonic.value = _mnemonic;
  }
  void setAddress(String _address){
    address.value = _address;
  }
  void increment() {
    counter.value++;
  }
}