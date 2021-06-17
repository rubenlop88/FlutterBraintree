@JS()
library data_collector;

import 'package:flutter_braintree_web/classes/client.dart';
import 'package:js/js.dart';

@JS()
@anonymous
class DataCollector {
  external String Function() get getDeviceData;

  external factory DataCollector({String Function() getDeviceData});
}

@JS()
@anonymous
external String getDeviceData();

@JS('braintree.dataCollector.create')
external DataCollector create(Options options);

@JS()
@anonymous
class Options {
  external Client get client;

  external factory Options({Client client});
}
