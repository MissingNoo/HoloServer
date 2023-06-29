var offset = 0;
//for (var i = 1; i < array_length(players); ++i) {
//	if (is_struct(players[i])) {
//	    draw_text(10,10+offset, players[i].username);
//	}
//    offset+=20;
//}


for (var i = 0; i < array_length(rooms); ++i) {
	if (array_length(rooms) > 0 and is_struct(rooms[i])) {
	    draw_text(10,10+offset, rooms[i][$"name"] + " " + string(rooms[i][$"totalplayers"]) + "/2");
	    draw_text(30,30+offset, rooms[i][$"players"]);
		offset+=40;
	}
}

