cordova.define("shengyuan-plugin-module.SecurePlugin", function(require, exports, module) {

	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		sign : function(param, completeCallback) {
			exec(completeCallback, function(e) {
				alert(e);
			}, "SecurePlugin", "sign", [ param ]);
		}
	};
});