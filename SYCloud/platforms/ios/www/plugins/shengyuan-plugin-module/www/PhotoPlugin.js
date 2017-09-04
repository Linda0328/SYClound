cordova.define("shengyuan-plugin-module.PhotoPlugin", function(require, exports, module) {

	var exec = require('cordova/exec');
	var platform = require('cordova/platform');
              
	module.exports = {
		show : function(imgs, index) {
			exec(null, null, "PhotoPlugin", "show", [imgs, index]);
		}
	};
});
