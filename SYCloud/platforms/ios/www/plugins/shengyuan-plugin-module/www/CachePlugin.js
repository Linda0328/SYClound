cordova.define("shengyuan-plugin-module.CachePlugin", function(require, exports, module) {
	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		get : function(key, success) {
			exec(success, function(e) {
				alert(e);
			}, "CachePlugin", "get", [ key ]);
		},
		set : function(key, val, success) {
			exec(success, function(e) {
				alert(e);
			}, "CachePlugin", "set", [ key, val ]);
		}
	};
});