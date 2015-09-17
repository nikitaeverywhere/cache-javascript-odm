function NDO () {



}

/**
 * Register a new class.
 */
NDO.prototype.register = function (className, data) {

    var path = className.split("."),
        property,
        obj = this;

    while (path.length > 1) {
        property = path.splice(0,1)[0];
        if (!obj[property]) obj[property] = {};
        obj = obj[property];
    }



};

module.exports = {
    connection: require("./Connection"),
    ndo: new NDO()
};

require("./cls");