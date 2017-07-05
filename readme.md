# JavaScript ODM for InterSystems Caché

JavaScript Object Data Model - easiest workflow with InterSystems Caché objects from client JavaScript or NodeJS.

### Note

This project is a result of InterSystems Innovations School hackathon which had its place 2015, by the team of [Anton Gnibeda](https://github.com/gnibeda), [Irene Mychailova](https://github.com/Gra-ach) and [Nikita Savchenko](https://github.com/ZitRos). The code in this repository is provided "as-is" and is not ready for potential production use. For any further info, questions or requests please, submit [an issue](https://github.com/ZitRos/isc-cache-node/issues).

### Usage

1. Include the scripts to your application (see [src/index.html](src/index.html) example file);
2. Import and compile [DemoInstaller.xml](DemoInstaller.xml) to Caché (or import from sources, [src](src) directory);
3. A new web application named "CJS" will be created during compilation;
4. Now, serve the [src/client](src/client) directory and check the demo. Demo defaults to localhost and port number 57772, see [test.js](src/client/test.js).

### Features

```js
// .connect("Server address and port", "Namespace", [Any Packages/classes], callback())
// Note: all the callbacks represented here are asynchronous and may be triggered in any order.
cjs.connector.connect("http://localhost:57772", "USER", ["School2015"], function (cache) {

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
