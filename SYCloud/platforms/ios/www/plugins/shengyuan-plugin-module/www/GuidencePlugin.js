cordova.define("shengyuan-plugin-module.GuidencePlugin", function(require, exports, module) {

	var exec = require('cordova/exec');
	var platform = require('cordova/platform');
	var channel = require('cordova/channel');

	module.exports = {
		show : function(imgs, success) {
			exec(success, function(e) {
				alert(e);
			}, "GuidencePlugin", "show", [ imgs ]);
		}
	};
});