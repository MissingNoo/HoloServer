var type_event = ds_map_find_value(async_load, "type");
var i;
switch (type_event) {
    case network_type_connect:
		//socket = ds_map_find_value(async_load, "socket");
        //ds_list_add(socketList, socket);
		//buffer_seek(serverBuffer, buffer_seek_start, 0);
		//buffer_write(serverBuffer, buffer_u8, Network.IsHost);
		//if (socket == 1) {    
		//	buffer_write(serverBuffer, buffer_string, "host");
		//}else{
		//	buffer_write(serverBuffer, buffer_string, "client");
		//}
		//network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
        break;
		
	case network_type_disconnect:
		socket = ds_map_find_value(async_load, "socket");
		for (var i = 0; i < array_length(rooms); ++i) {
		    for (var j = 0; j < array_length(rooms[i][$"players"]); ++j) {
			    if (rooms[i][$"players"][j][$"socket"] == socket) {
				    array_delete(rooms[i][$"players"], j, 1);
					rooms[i][$"totalplayers"] -= 1;
					//if (rooms[i][$"totalplayers"] == 0){
					//	array_delete(rooms, i, 1);
					//}
				}
			}
		}
		//ds_map_delete(socketList, socket);
		//players[socket] = -1;
		break;
		
	case network_type_data:
		buffer = ds_map_find_value(async_load, "buffer");
		socket = ds_map_find_value(async_load, "id");
		buffer_seek(buffer, buffer_seek_start, 0);
		receivedPacket(buffer, socket);
		break;
}