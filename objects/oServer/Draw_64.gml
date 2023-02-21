var offset = 0;
for (var i = 1; i < array_length(players); ++i) {
	if (is_struct(players[i])) {
	    draw_text(10,10+offset, players[i].username);
	}
    offset+=20;
}
