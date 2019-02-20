
import {NativeModules, Platform, DeviceEventEmitter} from 'react-native';
const RNKit = NativeModules.SRRNKit;
const RNLogger = NativeModules.SRRNLogger;
console.log("11111111111111");
console.log(RNKit);
console.log("22222222222222");
console.log(RNLogger);
if (process.env.NODE_ENV === 'production') {
  RNKit.env = 2;
} else {
  RNKit.env = 1;
}
module.exports.RNKit = RNKit;
module.exports.RNLogger = RNLogger;
