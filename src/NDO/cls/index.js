require("fs").readdirSync(__dirname).forEach(function(file) {
    if (file !== "index.js") require("./obj/" + file);
});