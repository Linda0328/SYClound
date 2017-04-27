cordova.define("shengyuan-plugin-module.PaymentCloudPlugin", function(require, exports, module) {
	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		paymentCode : function(success) {
			exec(success, function(err) {
				alert(err);
			}, "PaymentCloudPlugin", "paymentCode", []);
		},
		paymentScan : function(qrcode, success) {
			exec(success, function(err) {
				alert(err);
			}, "PaymentCloudPlugin", "paymentScan", [ qrcode ]);
		},
		paymentImmed : function(merchantId, amount, desc, success) {
			exec(success, function(err) {
				alert(err);
			}, "PaymentCloudPlugin", "paymentImmed", [ merchantId, amount, desc ]);
		},
		paymentPwd : function(title, url, pwdKey, params, success) {
			exec(success, function(err) {
				alert(err);
			}, "PaymentCloudPlugin", "paymentPwd", [ title, url, pwdKey, params ]);
		}
	};
});