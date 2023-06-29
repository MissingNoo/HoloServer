// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum Network {
	Move,
	Message,
	PlayerMoved,
	PlayerConnect,
	PlayerJoined,
	PlayerDisconnect,
	Spawn,
	SpawnUpgrade,
	DestroyUpgrade,
	UpdateUpgrade,
	Destroy,
	HostDisconnected,
	LobbyConnect,
	IsHost,
	StartGame,
	CreateRoom,
	ListRooms,
	JoinRoom
}
function receivedPacket(_buffer, _socket){
	msgid = buffer_read(_buffer, buffer_u8);
	var _vars;
	var i;
	var _s;
	var _x;
	var _y;
	var _spr;
	var _spd;
	var _dir;
	var _angle;
	switch (msgid) {
		case Network.Destroy:{
			var _id = buffer_read(_buffer, buffer_u16);
			var _room = buffer_read(_buffer, buffer_string);
			
			for (var i = 0; i < array_length(rooms); ++i) {
			    if (rooms[i][$"name"] == _room) {
				    for (var j = 0; j < array_length(rooms[i][$"players"]); ++j) {
						if (_socket != rooms[i][$"players"][j][$"socket"]) {
						    buffer_seek(serverBuffer, buffer_seek_start, 0);
							buffer_write(serverBuffer, buffer_u8, Network.Destroy);
							buffer_write(serverBuffer, buffer_u16, _id);
							network_send_packet(rooms[i][$"players"][j][$"socket"], serverBuffer, buffer_tell(serverBuffer));
						}						
					}
				}
			}
			i = 0;
			repeat (ds_list_size(socketList)) {
				socket = ds_list_find_value(socketList, i);
				
				network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
				i++;
			}
	        break;}
		
		case Network.DestroyUpgrade:{
			var _id = buffer_read(_buffer, buffer_u16);
			var _room = buffer_read(_buffer, buffer_string);
			
			for (var i = 0; i < array_length(rooms); ++i) {
			    if (rooms[i][$"name"] == _room) {
				    for (var j = 0; j < array_length(rooms[i][$"players"]); ++j) {
						if (_socket != rooms[i][$"players"][j][$"socket"]) {
							buffer_seek(serverBuffer, buffer_seek_start, 0);
							buffer_write(serverBuffer, buffer_u8, Network.DestroyUpgrade);
							buffer_write(serverBuffer, buffer_u16, _id);
							network_send_packet(rooms[i][$"players"][j][$"socket"], serverBuffer, buffer_tell(serverBuffer));
						}						
					}
				}
			}
	        break;}
			
		case Network.UpdateUpgrade:{
			var owner = buffer_read(_buffer, buffer_u8);
			_id = buffer_read(_buffer, buffer_u16);
			_x = buffer_read(_buffer, buffer_u16);
			_y = buffer_read(_buffer, buffer_u16);
			_dir = buffer_read(_buffer, buffer_u16);
			_angle = buffer_read(_buffer, buffer_u16);
			i = 0;
			repeat (ds_list_size(socketList)) {
				socket = ds_list_find_value(socketList, i);
				buffer_seek(serverBuffer, buffer_seek_start, 0);
				buffer_write(serverBuffer, buffer_u8, Network.UpdateUpgrade);
				buffer_write(serverBuffer, buffer_u8, owner);
				buffer_write(serverBuffer, buffer_u16, _id);
				buffer_write(serverBuffer, buffer_u16, _x);
				buffer_write(serverBuffer, buffer_u16, _y);
				buffer_write(serverBuffer, buffer_u16, _dir);
				buffer_write(serverBuffer, buffer_u16, _angle);
				network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
				i++;
			}
	        break;}
		
		case Network.SpawnUpgrade:{
			_s = buffer_read(_buffer, buffer_u8);
			_x = buffer_read(_buffer, buffer_u16);
			_y = buffer_read(_buffer, buffer_u16);
			_spr = buffer_read(_buffer, buffer_u16);
			//_spd = buffer_read(_buffer, buffer_u16);
			_dir = buffer_read(_buffer, buffer_s16);
			_angle = buffer_read(_buffer, buffer_s16);
			var _speed  = buffer_read(_buffer, buffer_u8);
			_vars = buffer_read(_buffer, buffer_string);
			var _upgid = buffer_read(_buffer, buffer_u8);
			
			var _room = buffer_read(_buffer, buffer_string);
			
			for (var i = 0; i < array_length(rooms); ++i) {
			    if (rooms[i][$"name"] == _room) {
				    for (var j = 0; j < array_length(rooms[i][$"players"]); ++j) {
						if (_socket != rooms[i][$"players"][j][$"socket"]) {
						    buffer_seek(serverBuffer, buffer_seek_start, 0);
							buffer_write(serverBuffer, buffer_u8, Network.SpawnUpgrade);
							buffer_write(serverBuffer, buffer_u8, _socket);
							buffer_write(serverBuffer, buffer_u16, _x);
							buffer_write(serverBuffer, buffer_u16, _y);
							buffer_write(serverBuffer, buffer_u16, _spr);
							//buffer_write(serverBuffer, buffer_u16, _spd);
							buffer_write(serverBuffer, buffer_s16, _dir);
							buffer_write(serverBuffer, buffer_s16, _angle);
							buffer_write(serverBuffer, buffer_u8, _speed);
							buffer_write(serverBuffer, buffer_string, _vars);
							buffer_write(serverBuffer, buffer_u8, _upgid);
							network_send_packet(rooms[i][$"players"][j][$"socket"], serverBuffer, buffer_tell(serverBuffer));
						}						
					}
				}
			}
			
			//if (_s == 1) {
				//i = 0;
				//repeat (ds_list_size(socketList)) {
				//	socket = ds_list_find_value(socketList, i);
				   
				//	i++;
				//}
			//}
	        break;}
		
		case Network.Spawn:{
			_s = buffer_read(_buffer, buffer_u8);
			_x = buffer_read(_buffer, buffer_u16);
			_y = buffer_read(_buffer, buffer_u16);
			_vars = buffer_read(_buffer, buffer_string);
			var _room = buffer_read(_buffer, buffer_string);
			
			for (var i = 0; i < array_length(rooms); ++i) {
			    if (rooms[i][$"name"] == _room) {
				    for (var j = 0; j < array_length(rooms[i][$"players"]); ++j) {
						if (_socket != rooms[i][$"players"][j][$"socket"]) {
						    buffer_seek(serverBuffer, buffer_seek_start, 0);
							buffer_write(serverBuffer, buffer_u8, Network.Spawn);
							buffer_write(serverBuffer, buffer_u8, _s);
							buffer_write(serverBuffer, buffer_u16, _x);
							buffer_write(serverBuffer, buffer_u16, _y);
							buffer_write(serverBuffer, buffer_string, _vars);
							network_send_packet(rooms[i][$"players"][j][$"socket"], serverBuffer, buffer_tell(serverBuffer));
						}						
					}
				}
			}
	        break;}
		
		case Network.Message:{
			_s = buffer_read(_buffer, buffer_u8);
			var message = buffer_read(_buffer, buffer_string);
			show_message(message);
			//buffer_seek(serverBuffer, buffer_seek_start, 0);
			//buffer_write(serverBuffer, buffer_u8, Network.Message);
			//buffer_write(serverBuffer, buffer_u8, _s);
			//buffer_write(serverBuffer, buffer_string, message);
			//network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
			
			break;}
			
	    case Network.Move:{
			_s = buffer_read(_buffer, buffer_u8);
			_x = buffer_read(_buffer, buffer_u16);
			_y = buffer_read(_buffer, buffer_u16);
			_spr = buffer_read(_buffer, buffer_u16);
			_scale = buffer_read(_buffer, buffer_s8);			
			var _room = buffer_read(_buffer, buffer_string);
			for (var i = 0; i < array_length(rooms); ++i) {
			    if (rooms[i][$"name"] == _room) {
				    for (var j = 0; j < array_length(rooms[i][$"players"]); ++j) {
						if (_socket != rooms[i][$"players"][j][$"socket"]) {
						    buffer_seek(serverBuffer, buffer_seek_start, 0);
							buffer_write(serverBuffer, buffer_u8, Network.PlayerMoved);
							buffer_write(serverBuffer, buffer_u8, _s);
							buffer_write(serverBuffer, buffer_u16, _x);
							buffer_write(serverBuffer, buffer_u16, _y);
							buffer_write(serverBuffer, buffer_u16, _spr);
							buffer_write(serverBuffer, buffer_s8, _scale);
							buffer_write(serverBuffer, buffer_u8, _socket);
							network_send_packet(rooms[i][$"players"][j][$"socket"], serverBuffer, buffer_tell(serverBuffer));
						}						
					}
				}
			}
			
			i = 0;
			repeat (ds_list_size(socketList)) {
				socket = ds_list_find_value(socketList, i);
			    buffer_seek(serverBuffer, buffer_seek_start, 0);
				buffer_write(serverBuffer, buffer_u8, Network.PlayerMoved);
				
				network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
				i++;
			}
			
			//show_debug_message(sucess);
			ds_map_set(socketToInstanceID, string(socket) + "X", _x); 
			ds_map_set(socketToInstanceID, string(socket) + "Y", _y); 
	        break;}
			
		case Network.LobbyConnect:{
			var _username = buffer_read(_buffer, buffer_string);
			var _character = buffer_read(_buffer, buffer_u8);
			i = 0;
			players[_socket] = {};
			players[_socket].username = _username;
			players[_socket].character = _character;
			var _json = json_stringify(players);
			repeat (ds_list_size(socketList)) {
				socket = ds_list_find_value(socketList, i);
			    buffer_seek(serverBuffer, buffer_seek_start, 0);
				buffer_write(serverBuffer, buffer_u8, Network.LobbyConnect);
				buffer_write(serverBuffer, buffer_string, _json);
				network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
				i++;
			}
			break;}
	    
		case Network.StartGame:{
			var _room = buffer_read(_buffer, buffer_string);
			for (var i = 0; i < array_length(rooms); ++i) {
			    if (rooms[i][$"name"] == _room) {
					for (var j = 0; j < array_length(rooms[i][$"players"]); ++j) {
						buffer_seek(serverBuffer, buffer_seek_start, 0);
						buffer_write(serverBuffer, buffer_u8, Network.StartGame);
						network_send_packet(rooms[i][$"players"][j][$"socket"], serverBuffer, buffer_tell(serverBuffer));
					}
				}
			}
			break;}
		
		case Network.PlayerConnect:{
			var _room = buffer_read(_buffer, buffer_string);
			for (var i = 0; i < array_length(rooms); ++i) {
			    if (rooms[i][$"name"] == _room) {
				    for (var j = 0; j < array_length(rooms[i][$"players"]); ++j) {
						if (_socket != rooms[i][$"players"][j][$"socket"]) {
						    buffer_seek(serverBuffer, buffer_seek_start, 0);
							buffer_write(serverBuffer, buffer_u8, Network.PlayerJoined);
							buffer_write(serverBuffer, buffer_u8, _socket);
							network_send_packet(rooms[i][$"players"][j][$"socket"], serverBuffer, buffer_tell(serverBuffer));
						}						
					}
				}
			}
			//i = 0;
			//repeat (ds_list_size(socketList)) {
			//    var _sock = ds_list_find_value(socketList, i);
			//	if (_sock != socket) {
			//	    buffer_seek(serverBuffer, buffer_seek_start, 0);
			//		buffer_write(serverBuffer, buffer_u8, Network.PlayerJoined);
					
			//		network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
			//	}
			//	i += 1;
			//}
		
			//i = 0;
			//repeat (ds_list_size(socketList)) {
			//    var _sock = ds_list_find_value(socketList, i);
			//	if (_sock != socket) {
			//	    buffer_seek(serverBuffer, buffer_seek_start, 0);
			//		buffer_write(serverBuffer, buffer_u8, Network.PlayerJoined);
			//		buffer_write(serverBuffer, buffer_u8, socket);
			//		network_send_packet(_sock, serverBuffer, buffer_tell(serverBuffer));
			//	}
			//	i += 1;
			//}
		
			break;}
			
		case Network.ListRooms:{
			var _json = json_stringify(rooms);
			buffer_seek(serverBuffer, buffer_seek_start, 0);
			buffer_write(serverBuffer, buffer_u8, Network.ListRooms);
			buffer_write(serverBuffer, buffer_string, _json);
			network_send_packet(_socket, serverBuffer, buffer_tell(serverBuffer));			
			break;
		}
		
		case Network.JoinRoom:{
			var _username = buffer_read(_buffer, buffer_string);
			var _character = buffer_read(_buffer, buffer_u8);
			var _room = buffer_read(_buffer, buffer_string);
			for (var i = 0; i < array_length(rooms); ++i) {
			    if (rooms[i][$"name"] == _room and rooms[i][$"totalplayers"] < 2) {
					show_debug_message_ext("add player: {0}", [rooms[i][$"totalplayers"]]);
					var _ishost = false;					
					rooms[i][$"players"][rooms[i][$"totalplayers"]] = {socket : _socket, username : _username, character : _character};
					rooms[i][$"totalplayers"] += 1;
					for (var j = 0; j < array_length(rooms[i][$"players"]); ++j) {
						buffer_seek(serverBuffer, buffer_seek_start, 0);
						buffer_write(serverBuffer, buffer_u8, Network.JoinRoom);
						buffer_write(serverBuffer, buffer_string, rooms[i][$"name"]);
						var _json = json_stringify(rooms[i][$"players"]);
						buffer_write(serverBuffer, buffer_string, _json);
						if (rooms[i][$"players"][j][$"socket"] == rooms[i][$"players"][0][$"socket"]) {
						    _ishost = true;
						}
						else{
							_ishost = false;
						}
						buffer_write(serverBuffer, buffer_u8, _ishost);
					    network_send_packet(rooms[i][$"players"][j][$"socket"], serverBuffer, buffer_tell(serverBuffer));
					}
					
				}
			}
			break;
		}
		
		case Network.CreateRoom:{
			var _name = buffer_read(_buffer, buffer_string);
			rooms[array_length(rooms)] = {
				name : _name,
				totalplayers : 0,
				players : []
			}
			var _json = json_stringify(rooms);
			buffer_seek(serverBuffer, buffer_seek_start, 0);
			buffer_write(serverBuffer, buffer_u8, Network.ListRooms);
			buffer_write(serverBuffer, buffer_string, _json);
			network_send_packet(_socket, serverBuffer, buffer_tell(serverBuffer));
		}
	}
}