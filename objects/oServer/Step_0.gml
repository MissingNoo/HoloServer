if (keyboard_check_pressed(ord("R"))) {
	ds_list_clear(socketList);
	show_message_async("list reset");
}