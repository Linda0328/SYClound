cordova.define("shengyuan-plugin-module.LocationPlugin", function(require, exports, module) {
	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		getPosition : function(success, fail) {
			var _fail = (fail || function(){});
			exec(success, _fail, "LocationPlugin", "position", [ ]);
		},
		
	};
});