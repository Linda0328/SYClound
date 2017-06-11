cordova.define("shengyuan-plugin-module.PaymentCloudPlugin", function(require, exports, module) {
	var exec = require('cordova/exec');
	var platform = require('cordova/platform');

	module.exports = {
		paymentCode : function(paycode,success) {
			exec(success, function(err) {
				alert(err);
			}, "PaymentCloudPlugin", "paymentCode", [paycode]);
		},
		paymentScan : function(qrcode, success) {
			exec(success, function(err) {
				alert(err);
			}, "PaymentCloudPlugin", "paymentScan", [ qrcode ]);
		},
		paymentImmed : function(merchantId, amount, desc, coupon,payAmount,success) {
			exec(success, function(err) {
				alert(err);
			}, "PaymentCloudPlugin", "paymentImmed", [ merchantId, amount, desc,coupon,payAmount]);
		},
		paymentPwd : function(title, url, pwdKey, params, success) {
			exec(success, function(err) {
				alert(err);
			}, "PaymentCloudPlugin", "paymentPwd", [ title, url, pwdKey, params ]);
		}
	};
});
