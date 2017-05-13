cordova.define("shengyuan-plugin-module.IntentPlugin", function(require, exports, module) {

	var exec = require('cordova/exec');
	var platform = require('cordova/platform');
	var channel = require('cordova/channel');

               
    module.exports = {
    open : function(url, completeCallback) {
    exec(completeCallback, null, "IntentPlugin", "open", [ url ]);
    },
    start : function(url, finish, reload, titleBar, bottomBar, completeCallback) {
    var _titleBar = (titleBar || "");
    var _bottomBar = (bottomBar || "");
    exec(completeCallback, null, "IntentPlugin", "start", [ url, finish, reload, _titleBar, _bottomBar ]);
    }
   };
	
});
