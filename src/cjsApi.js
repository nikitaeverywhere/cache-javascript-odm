/*var ndo = require("../../index.js").ndo,
    proto = require("../proto.js");



ndo.register("Sample.User.dsd", {
    name: {
        type: "property"
    },
    method: {
        type: "method",
        params: ["a"]
    }
});
*/
var cache = {};
var cjsApi = (function() {
    function CjsApi() {
        this.register = function (cls, desc) {
            var obj = cache;
            var constructor = function () {
                createProperties(this, desc);
            };
            var p = cls.split(".");
            for (var i = 0; i < p.length; i++) {
                 if (i === p.length - 1) obj[p[i]] = constructor;
                 else if (!obj[p[i]]) obj[p[i]] = {};
                 obj = obj[p[i]];
            }
            constructor.__proto__ = cjs;
        };


        function createProperties(obj, desc) {
            for (var p in desc) {
                switch (desc[p].type.toLowerCase()) {
                    case "property": {
                        obj[p] = "";
                    }
                }
            }
        }
    }
    return new CjsApi();
})();
