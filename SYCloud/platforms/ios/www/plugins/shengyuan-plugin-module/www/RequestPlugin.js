cordova.define("shengyuan-plugin-module.RequestPlugin", function(require, exports, module) {
	var exec = require('cordova/exec');
	var platform = require('cordova/platform');


	module.exports = {
		ajax : function(url, type, params, success, fail, error) {
			exec(function(message) {
				if (message.code == "000000") {
					if (success && typeof success == "function") {
						success(message.result);
					}
                 } else if (message.code == "300000") {
                        syapp.auth.login();
                 }else {
					if (fail && typeof fail == "function") {
						fail(message.code, message.msg);
					}
				}
			}, function(e) {
				if (error && typeof error == "function") {
					error(e);
				} else {
					app.error.show("数据请求加载失败");
				}
			}, "RequestPlugin", "ajax", [ url, type, params ]);
		},
		safeAjax : function(url, type, params, success, fail, error) {
			exec(function(message) {
				if (message.code == "000000") {
					if (success && typeof success == "function") {
						success(message.result);
					}
                 } else if (message.code == "300000") {
                        syapp.auth.login();
                 } else {
					if (fail && typeof fail == "function") {
						fail(message.code, message.msg);
					}
				}
			}, function(e) {
				if (error && typeof error == "function") {
					error(e);
				} else {
					app.error.show("数据请求加载失败");
				}
			}, "RequestPlugin", "safeAjax", [ url, type, params ]);
		},
		upload : function(url, fileSrc, success, fail, error) {
			exec(function(message) {
				if (message.code == "000000") {
					if (success && typeof success == "function") {
						success(message.result);
					}
				} else {
					if (fail && typeof fail == "function") {
						fail(message.code, message.msg);
					}
				}
			}, function(e) {
				if (error && typeof error == "function") {
					error(e);
				} else {
					app.error.show("文件上传处理失败");
				}
			}, "RequestPlugin", "upload", [ url, fileSrc ]);
		}
	};
});
