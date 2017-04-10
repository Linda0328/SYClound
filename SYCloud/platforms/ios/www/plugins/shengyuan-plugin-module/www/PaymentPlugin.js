cordova.define("shengyuan-plugin-module.PaymentPlugin", function(require, exports, module) {
	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		alipay : function(data, success, fail) {
			exec(success, fail, "PaymentPlugin", "alipay", [ data ]);
		},
		wxpay : function(data, success, fail) {
			exec(success, fail, "PaymentPlugin", "wxpay", [ data ]);
		},

	};
});
