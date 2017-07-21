cordova.define("shengyuan-plugin-module.PatternLockPlugin", function(require, exports, module) {
	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		open : function(success) {
			exec(success, function(e) {
				alert(e);
			}, "PatternLockPlugin", "open", []);
		},
		close : function(success) {
			exec(success, function(e) {
				alert(e);
			}, "PatternLockPlugin", "close", []);
		}
	};
});