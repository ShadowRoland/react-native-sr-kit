
import {NativeModules, Platform, DeviceEventEmitter} from 'react-native';
const RNKit = NativeModules.SRRNKit;
if (process.env.NODE_ENV === 'production') {
  RNKit.env = 2;
} else {
  RNKit.env = 1;
}

const RNLogger = NativeModules.SRRNLogger;
module.exports.RNKit = RNKit;
module.exports.RNLogger = RNLogger;
