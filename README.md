# JavaScript ODM for InterSystems Caché
JavaScript Object Data Model - easiest access to InterSystems Caché database from JavaScript.

### Note
This project is a subject of InterSystems innovations school 2015. The code in this repository is provided "as-is" and is not ready for potential production use. For any further info, questions or requests please, submit [an issue](issues).

### Usage
1. Include to your application script that are included in src/index.html file;
2. Import src/cls/CJS.xml file into Caché (src/cls/School2015.xml is a demo package);
3. Create new WEB application named "CJS" via system management portal, select CJS.REST.cls file as REST broker;
4. Now you are able to use it! Connect to Caché using appropriate URL as in src/test.js file and try all the features.

### Features
```js
// .connect("Server address and port", "Namespace", [Any Packages/classes], callback())
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
