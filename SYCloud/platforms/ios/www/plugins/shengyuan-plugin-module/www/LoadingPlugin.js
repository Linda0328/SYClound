cordova.define("shengyuan-plugin-module.LoadingPlugin", function(require, exports, module) {
	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		show : function(msg, time, callback) {
			var _msg = (msg || "加载中");
			var _time = (time || 0);
			exec(callback, null, "LoadingPlugin", "show", [ msg, time ]);
		},
		hide : function(callback) {
			exec(callback, null, "LoadingPlugin", "hide", []);
		},
		update : function(callback) {
			exec(callback, null, "LoadingPlugin", "update", []);
		}
	};
});