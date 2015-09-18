cjs.connector = (function() {
	'use strict';

	function Connector() {
		// Public properties
		this.url = "";	
		this.namespace = "Samples";	
		this.connection = null;

		// Public methods
		this.connect = connect;
		this.exec = exec;
		this.save = save;
		this.query = query;
		this.openById = openById;

		/////////////////////////////////////////////////////////////////////
		function query(className, orders, wheres, agr, callback, error) {
			var _this = this;
			sendRequest(this.url + "CJS/query?className="+ className + "&aggr=" + encodeURIComponent(agr) + "&where=" + encodeURIComponent(wheres.join(",")) + "&order=" + encodeURIComponent(orders.join(",")) + "&NS=" + this.namespace, "GET", "", onReceive, error)
			function onReceive(xhr) {
				var o = null;
				try {
					o = JSON.parse(xhr.responseText);
				} catch (e) {
					console.error(e);
				}
				if (!o) throw new Error("Wrong response");
				if (agr) {
					if (callback) callback(o.children);
					return;
				}
				var res = [];
				for (var i = 0; i < o.children.length; i++) {
					o.children[i]._id = o.children[i].ID;
					delete o.children[i].ID;
					o.children[i]._class = className;
					res.push(cjs.api.createObject(_this.connection, o.children[i]))
				}
				if (callback) callback(res);
			}
		}

		function save(obj, callback, error) {
			var _this = this;
			sendRequest(this.url + "CJS/save?className="+ obj.constructor.className + "&object=" + JSON.stringify(obj) + "&NS=" + this.namespace, "GET", "", onSave, error)
			function onSave(xhr) {
				var o = null;
				try {
					o = JSON.parse(xhr.responseText);
				} catch (e) {
					console.error(e);
				}
				if (!o) throw new Error("Wrong response");
				if (callback) callback(cjs.api.createObject(_this.connection, o));
			}
		}	


		function openById(id, className, callback, error) {
			var _this = this;
			sendRequest(this.url + "CJS/open?className="+ className + "&id=" + id + "&NS=" + this.namespace, "GET", "", onOpen, error);

			function onOpen(xhr) {
				var o = null;
				try {
					o = JSON.parse(xhr.responseText);
				} catch (e) {
					console.error(e);
				}
				if (!o) throw new Error("Wrong response");
				if (callback) callback(cjs.api.createObject(_this.connection, o));
			}
		}

		function exec(className, method, id, params) {
			// Get callback from last parameter
			var _this = this;
			var callback;
			if (params && params.length !== 0) {
				callback = Array.prototype.splice.call(params, params.length - 1, 1)[0];
			}
			// TODO: make error callback
			sendRequest(this.url + "CJS/exec?className=" + className + "&method=" + method + "&id=" + id + "&params=" +  Array.prototype.join.call(params, ",") + "&NS=" + this.namespace, "GET", "", onExec);
			function onExec(xhr) {
				var o = null;
				try {
					o = JSON.parse(xhr.responseText);
				} catch (e) {
					console.error(e);
				}
				if (!o) throw new Error("Wrong response");
				if (callback && (typeof callback === "function")) callback(o);
			}
		}

		function connect(url, namespace, classList, callback, errorCallback) {
			var _this = this;
			this.namespace = namespace || this.namespace;
			if (url && url.charAt(url.length - 1) !== "/") url += "/";
			this.url = url;
			console.log("Connecting to " + url);
			sendRequest(this.url + "CJS/connect?classList=" + classList.join(",") + "&NS=" + this.namespace, "GET", "", onConnected, errorCallback);

			function onConnected(xhr) {
				var o = null;
				try {
					o = JSON.parse(xhr.responseText);
				} catch (e) {
					console.error(e);
				}
				if (!o) throw new Error("Wrong response");
				if (!o.classes) new Error("No classes in JSON");
				var ns = {};
				for (var k in o.classes) {
					cjs.api.register(ns, k, o.classes[k]);
				}
				_this.connection = ns;
				if (callback) callback(ns);
			}		
		}
 


		function sendRequest(url, type, data, callback, errorCallback) {
			var xhr = new XMLHttpRequest();
			xhr.open(type, url);
			xhr.onload = onLoad;
			xhr.send(data);

			function onLoad(e) {
  				if (xhr.readyState === 4) {
    				if (xhr.status === 200) {
      					if (callback) callback(xhr);
    				} else {
      					if (errorCallback) errorCallback(xhr);
   					}
 				}
			}
		}
	}

	return new Connector();
})();