/**
 * Created by Anton Gnibeda on 9/17/2015.
 */
/* 
cjs.api.register("Sample.User.dsd", {
    propertyName: {
        type: "property"
    },
    methodName: {
        type: "method",
        params: ["a"]
    }
});
*/
cjs.api = (function() {
    'use strict';

    function CjsApi() {
        // Public methods
        this.register = register;
        this.createObject = createObject;
        this.findClass = findClass;
        this.fillObject = fillObject;
        ////////////////////////////////////////////////////////////////////////////////////////////

        function findClass(connection, className) {
            var p = className.split(".");
            var obj = connection;
            for (var i = 0; i < p.length; i++) {
                if (!obj) return;
                obj = obj[p[i]];
            }
            return obj;
        }

        function fillObject(connection, obj, desc) {
            for (var p in desc) {                
                if (obj[p] === undefined && p.charAt(0) !== "_") continue; // Only  exists fields will be filled
                if (desc[p] instanceof Array) {
                    obj[p] = [];
                    for (var j = 0; j < desc[p].length; j++) {
                        if (typeof desc[p][j] === "object" && desc[p][j])
                             obj[p].push(this.createObject(connection, desc[p][j]));
                         else 
                            obj[p].push(desc[p][j]);
                    }
                    continue;
                }

                if (typeof desc[p] === "object" && desc[p] !== null) {
                    obj[p] = this.createObject(connection, desc[p]);
                    continue;
                }

                
                var key = p;
                if (key.charAt(0) === "_") key = "$" + key.substring(1, key.length);
                obj[key] = desc[p];
            }
            return obj;
        }

        function createObject(connection, desc) {
            if (!desc._class) throw new Error("No class in response " + desc);
            var cls = this.findClass(connection, desc._class);
            if (!cls) throw new Error("Class " + desc._class + " was not found in connection");
            var obj = this.fillObject(connection, new cls(), desc);
            return obj;
        }

        function register(ns, cls, desc) {
            // Save namespace
            var obj = ns;
            // Create constructor
            var constructor = function () {
                this.$class = this.constructor.className;
                createProperties(this, desc);
                cjs.Base.call(this);
            };
            createStaticMethods(constructor, desc);
            // Extend from base
            extend(constructor, cjs.Base);

            // Create objects
            var p = cls.split(".");
            for (var i = 0; i < p.length; i++) {
                 if (i === p.length - 1) obj[p[i]] = constructor;
                 else if (!obj[p[i]]) obj[p[i]] = {};
                 obj = obj[p[i]];
            }

            // Register static methods
            constructor.openById = openById;
            constructor.query = query;
            constructor.className = cls;
        }

        function query() {
            return new cjs.Query(this);
        }

        function openById(id, callback, error) {
            var cls = this.className;
            cjs.connector.openById(id, cls, callback, error)
        }

        function createProperties(obj, desc) {
            for (var p in desc) {
                switch (desc[p].type.toLowerCase()) {
                    case "property": {
                        obj[p] = "";
                        break;
                    }
                    case "method": {
                        obj[p] = (function(o, method) {
                            return function() {
                                cjs.connector.exec(o.constructor.className, method, o.$id, arguments)
                            }
                        })(obj, p);
                        break;
                    }
                }
            }
        }

          function createStaticMethods(obj, desc) {
            for (var p in desc) {
                switch (desc[p].type.toLowerCase()) {
                    case "classmethod": {
                        obj[p] = (function(o, method) {
                            return function() {
                                cjs.connector.exec(o.className, method, null, arguments)
                            }
                        })(obj, p);
                        break;
                    }
                }
            }
        }

        function extend(Child, Parent) {
            var F = function() { };
            F.prototype = Parent.prototype;
            Child.prototype = new F();
            Child.prototype.constructor = Child;
            Child.superclass = Parent.prototype;
        }
    }

    return new CjsApi();

})();
