cordova.define("shengyuan-plugin-module.Version", function(require, exports, module) {
	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		getInfo : function(completeCallback) {
			exec(completeCallback, null, "VersionPlugin", "getInfo", []);
		},
		setToken : function(token, completeCallback) {
			exec(completeCallback, null, "VersionPlugin", "setToken", [ token ]);
		},
		setNeedPush : function(isNeed, completeCallback) {
			exec(completeCallback, null, "VersionPlugin", "setNeedPush", [ isNeed ]);
		}
	};
});
