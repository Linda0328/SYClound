cordova.define("shengyuan-plugin-module.SharePlugin", function(require, exports, module) {

	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		init : function(title, describe, pic, url) {
			exec(null, null, "SharePlugin", "share", [title, describe, pic, url]);
		}
	};
});