Sy = {
	version : '1.0'
};
Sy.ns = function() {
	var a = arguments,
		o = null,
		i,
		j,
		d,
		rt;
	for (i = 0; i < a.length; ++i) {
		d = a[i].split(".");
		rt = d[0];
		eval('if (typeof ' + rt + ' == "undefined"){' + rt + ' = {};}; o = ' + rt + ';');
		for (j = 1; j < d.length; ++j) {
			o[d[j]] = o[d[j]] || {};
			o = o[d[j]];
		}
	}
};

Sy.ns('app.error');
(function(error) {
	var error_ftl = '<div class="cz-bat"><div class="bat-img"><img src="img/nanguo.png"></div><p class="bat-txt"><%=msg%>，请点击重试。</p></div>';
	error.show = function(msg, func) {
		var _msg = (msg || '');
		var render = template.compile(error_ftl);
		var error_html = render({
			msg : _msg
		});
		$("body").html(error_html);
		if (func && typeof func == 'function') {
			$("body").tap(func);
		} else {
			$("body").tap(function() {
				location.reload();
			});
		}
	};
})(app.error);

jQuery.cachedScript = function(url, callback, cache) {
	try {
		$.ajax({
			type : 'GET',
			url : url,
			success : callback,
			error : function() {
				app.request.loadTimeout("数据加载失败");
			},
			dataType : 'script',
			ifModified : true,
			cache : cache
		});
	} catch (e) {
		app.request.loadTimeout("数据加载异常");
	}
};

jQuery.cachedStyle = function(url, callback, cache) {
	var cssref = null;
	var timestamp = new Date().getTime();
	cssref = document.createElement('link');
	cssref.href = url + (cache ? "" : "&t=" + timestamp);
	cssref.type = "text/css";
	cssref.rel = "stylesheet";
	document.getElementsByTagName('head')[0].appendChild(cssref);

	cssref.onload = cssref.onreadystatechange = function() {
		if (!this.readyState || 'loaded' === this.readyState || 'complete' === this.readyState) {
			callback();
		}
	};
};

Sy.ns('app.version');
Sy.ns('app.request');
(function(request) {
	var req = {};
	var loadeds = 0;
	var resLoadTime = 0;

	function loadedCallback() {
		loadeds = loadeds + 1;
		if (loadeds == 3) {
			clearTimeout(resLoadTime);
			eval('app.page.' + (req['pg'] ? req['pg'] + "." : "") + req['act'] + '.init(req)');
		}
	}

	request.loadTimeout = function(msg) {
		loadeds = 99;
		clearTimeout(resLoadTime);
		app.error.show(msg);
	};

	request.initHead = function() {
		// check url has package
		req = {};
		window.location.search.substr(1).replace(/(\w+)=([^;]+)/ig, function(a, b, c) {
			req[b] = decodeURI(c);
		});

		// init loadeds to 0
		loadeds = 0;
		// load timeout handle
		resLoadTime = setTimeout("app.request.loadTimeout('网络不给力')", 10000);
		
		// load remote base css
		$.cachedStyle(app.version.remoteUrl + "/app_resources/style/base.css?v=" + app.version.pageVersion, function() {
			loadedCallback();
		}, app.version.formal);

		// load remote common js
		$.cachedScript(app.version.remoteUrl + "/app_resources/js/common.js?v=" + app.version.pageVersion, function() {
			loadedCallback();
		}, app.version.formal);

		// load romte page js
		$.cachedScript(app.version.remoteUrl + "/app_resources/js/" + (req['pg'] ? req['pg'] + "/" : "") + req['act'] + ".js?v=" + app.version.pageVersion, function() {
			loadedCallback();
		}, app.version.formal);
	};

	request.loadResource = function() {
		// load version plugin
		syapp.version.getInfo(function(info) {
			app.version = info;
			request.initHead();
		});
	};
})(app.request);

document.addEventListener('deviceready', app.request.loadResource, false);
