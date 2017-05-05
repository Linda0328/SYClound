cordova.define("shengyuan-plugin-module.ResultPlugin", function(require, exports, module) {
	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		reload : function() {
			exec(null, null, "ResultPlugin", "reload", []);
		},
		refresh : function(isFinish) {
			exec(null, null, "ResultPlugin", "refresh", [ isFinish ]);
		},
		finish : function() {
			exec(null, null, "ResultPlugin", "finish", []);
		},
		exec : function(func, data) {
			var _data = (data || {});
			exec(null, null, "ResultPlugin", "exec", [ func, _data ]);
		}
	};
});