cjs.Base = (function(){
	'use strict';

	function Base() {


	}


	Base.prototype.$open = function(callback, error) {
		var _this = this;
		this.constructor.openById(this.$id, onReceived, error);
		function onReceived(obj) {
			if (callback) callback(obj);
		}
	}

	Base.prototype.$save = function(callback, error) {
		cjs.connector.save(this, callback, error)
	}

	Base.prototype.$delete = function() {
		console.log("delete");
	}

	return Base;
})();