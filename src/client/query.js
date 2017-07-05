cjs.Query = (function(){
	'use strict';

	function Query(parent) {
		// Private
		var wheres = [];
		var orders = [];
		var agr = "";

		// Public methods
		this.exec = exec;
		this.where = where;
		this.orderBy = orderBy;
		this.count = count;
		this.orderByDesc = orderByDesc;
		this.min = min;
		this.max = max;
		this.avg = avg;
		this.sum = sum;

		this.parent = parent;

		/////////////////////////////////////////////////////////////////////////////////////////////

		function count() {
			agr = "Count(*)";
			return this;
		}

		function min(condition) {
			agr = "MIN(" + condition + ")";
			return this;
		}

		function max(condition) {
			agr = "MAX(" + condition + ")";
			return this;
		}
		

		function avg(condition) {
			agr = "AVG(" + condition + ")";
			return this;
		}

		function sum(condition) {
			agr = "SUM(" + condition + ")";
			return this;
		}

		function where(condition) {
			wheres.push(condition);
			return this;
		}

		function orderBy(condition) {
			orders.push(condition);
			return this;
		}

		function orderByDesc(condition) {
			orders.push(condition + " DESC");
			return this;
		}

		function exec(callback, error) {
			// TODO: pass connection
			cjs.connector.query(this.parent.className, orders, wheres, agr, callback, error)
		}
	}

	return Query;

})();