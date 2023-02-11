var offset = 0;
for (var i = 1; i < array_length(global.px); ++i) {
	draw_text(10,10+offset, global.px[i]);
	draw_text(10,30+offset, global.py[i]);
    offset+=40;
}
