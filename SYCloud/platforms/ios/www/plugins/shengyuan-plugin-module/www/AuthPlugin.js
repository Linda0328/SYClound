cordova.define("shengyuan-plugin-module.AuthPlugin", function(require, exports, module) {

	var exec = require('cordova/exec');
	var platform = require('cordova/platform');
	var channel = require('cordova/channel');

	module.exports = {
		login : function(success) {
			exec(success, function() {}, "AuthPlugin", "login", []);
		}
	};
});