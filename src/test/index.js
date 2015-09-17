var CConnection = require("../NDO").connection,
    cache = new CConnection("http://127.0.0.1:57776/NDO/");

var newUser = new cache.Sample.User({
    name: "Nikita",
    surname: "Savchenko",
    phone: "+380935093630",
    regDate: Date.now()
});

newUser.Method();

newUser.save(function (error, id) {
    console.log("Saved!");
});

newUser.delete();

cache.Sample.User.openById(function(err, user) { });
cache.Sample.User.query().exec(function(err, dataArray) {});
//cache.Sample.User.query().where(condition).where(condition).orderBy(expr).exec(callback);