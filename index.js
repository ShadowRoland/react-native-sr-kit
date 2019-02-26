import {NativeModules, Platform, DeviceEventEmitter} from 'react-native';
const RNKit = NativeModules.SRRNKit;
const RNLogger = NativeModules.SRRNLogger;
if (process.env.NODE_ENV === 'production') {
  RNKit.setEnv(2);
} else {
  RNKit.setEnv(0);
}
module.exports.RNKit = RNKit;
module.exports.RNLogger = RNLogger;
