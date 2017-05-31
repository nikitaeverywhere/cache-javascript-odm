# JavaScript ODM for InterSystems Caché

JavaScript Object Data Model - easiest workflow with InterSystems Caché objects from client JavaScript or NodeJS.

### Note

This project is a result of InterSystems Innovations School hackathon which had its place 2015, by the team of [Anton Gnibeda](https://github.com/gnibeda), [Irene Mychailova](https://github.com/Gra-ach) and [Nikita Savchenko](https://github.com/ZitRos). The code in this repository is provided "as-is" and is not ready for potential production use. For any further info, questions or requests please, submit [an issue](https://github.com/ZitRos/isc-cache-node/issues).

### Usage

1. Include the script to your application (see [src/index.html](src/index.html) example file);
2. Import [src/cls/CJS.xml](src/cls/CJS.xml) file to Caché ([src/cls/School2015.xml](src/cls/School2015.xml) is a demo package);
3. Create new web application named "CJS" via system management portal, put CJS.REST.cls as a dispatch class there;
4. Now you are ready to use it! Connect to Caché using appropriate URL as in src/test.js file and try all the features.

### Features

```js
// .connect("Server address and port", "Namespace", [Any Packages/classes], callback())
// Note: all the callbacks represented here are asynchronous and may be triggered in any order.
cjs.connector.connect("http://172.16.2.172:57776/", "Samples", ["School2015"], function (cache) {

  // creating a new object
  var p = new cache.School2015.Participant();
  p.Name = "Anton";
  p.Surname = "Gnibeda";
  p.$save(function(obj) {
    console.log("Participant with name " + obj.name + " saved!");
  });
	
  // opening existing object
  cache.School2015.Group.openById(1, function (group) {
    console.log("Points: " + group.Points);
  });
	
  // executing class method
  cache.School2015.Group.AddPoints(1, 1);

  // executing instance method
  cache.School2015.Group.openById(1, function (group) {
    group.PrintInfo(function (res) {
      console.log(res);
    });
  });
	
	// executing linq-like queries
  cache.School2015.Participant
    .query()
    .where("Carma < 100 OR Carma > 140")
    .where("$id > 10")
    .orderByDesc("Carma")
    .orderBy("Name")
    .exec(function(res) {
      console.table(res);
    });

});
```
