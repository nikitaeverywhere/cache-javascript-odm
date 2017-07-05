/**
 * Created by Anton Gnibeda on 9/17/2015.
 */

var cache;





function demo1() {
	console.clear();

	// Создаем новый объект
	var p = new cache.School2015.Participant();
	p.Name = "Anton";
	p.Surname = "Gnibeda";

	p.$save(function(obj) {
		console.log(obj);
	});
}












function demo2() {
	console.clear();

	// Выбираем существующий
	cache.School2015.Group.openById(1, function(p) {
		console.log("Points: " + p.Points);
	});
}













function demo3() {
	console.clear();

	// Выполняем метод класса
	cache.School2015.Group.AddPoints(1, 1);
}














function demo4() {
	console.clear();

	// Выполняем метод объекта
	cache.School2015.Group.openById(1, function(g) {
		g.PrintInfo(function(res){ console.log(res); });
	});
}













function demo5() {
	console.clear();

	// Выполняем linq-like запросы
	cache.School2015.Participant
		.query()
		.where("Name = 'Anton'")
		.exec(function(res) { console.table(res);});
}












function demo6() {
	console.clear();

	// Выполняем linq-like запросы
	cache.School2015.Participant
		.query()
		.orderBy("Surname")
		.exec(function(res) { console.table(res);});
}














function demo7() {
	console.clear();

	// Выполняем linq-like запросы
	cache.School2015.Participant
		.query()
		.count()
		.exec(function(res) { console.log(res[0]);});

	cache.School2015.Participant
		.query()
		.sum("Carma")
		.exec(function(res) { console.log(res[0]);});
}












function demo8() {
	console.clear();

	// Выполняем linq-like запросы
	cache.School2015.Participant
		.query()
		.where("Carma < 100 OR Carma > 140")
		.where("$id > 10")
		.orderByDesc("Carma")
		.orderBy("Name")
		.exec(function(res) { console.table(res);});
}











 ///////////////////////////////////////////////////////////////////////
 ///////////////////////// THE END /////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////













cjs.connector.connect("http://" + location.hostname + ":57772/", "USER", ["School2015"], function(cacheRes) {
	$("#conn").text("Connected!");
	$("#demo1").click(demo1);
	$("#demo2").click(demo2);
	$("#demo3").click(demo3);
	$("#demo4").click(demo4);
	$("#demo5").click(demo5);
	$("#demo6").click(demo6);
	$("#demo7").click(demo7);
	$("#demo8").click(demo8);
	cache = cacheRes;
});