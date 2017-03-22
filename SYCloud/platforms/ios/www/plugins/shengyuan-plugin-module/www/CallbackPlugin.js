cordova.define("shengyuan-plugin-module.CallbackPlugin", function(require, exports, module) {

	var exec = require('cordova/exec');
	var platform = require('cordova/platform');
	var channel = require('cordova/channel');

	channel.onCordovaReady.subscribe(function() {
		exec(function(msg) {
			if (msg != "") {
				console.log("CallbackPlugin View Exec Javacript：" + msg);
				eval(msg);
			}
		}, function(err) {
			console.log("CallbackPlugin View Exec Error：" + err);
		}, 'CallbackPlugin', 'listen', []);
	});
});