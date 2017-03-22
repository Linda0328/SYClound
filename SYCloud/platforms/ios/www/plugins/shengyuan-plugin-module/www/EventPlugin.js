cordova.define("shengyuan-plugin-module.EventPlugin", function(require, exports, module) {

	var exec = require('cordova/exec');
	var platform = require('cordova/platform');
	var channel = require('cordova/channel');

	module.exports = {
		bind : function(btnEvent, completeCallback) {
			exec(completeCallback, function(e) {
				alert(e);
			}, "EventPlugin", "bind", [ btnEvent ]);
		}
	};
});