cordova.define("shengyuan-plugin-module.ScanPlugin", function(require, exports, module) {

	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		getCode : function(completeCallback) {
			exec(completeCallback, null, "ScanPlugin", "getCode", []);
		}
	};
});