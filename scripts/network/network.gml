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
	StartGame
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
			_id = buffer_read(_buffer, buffer_u16);
			i = 0;
			repeat (ds_list_size(socketList)) {
				socket = ds_list_find_value(socketList, i);
				buffer_seek(serverBuffer, buffer_seek_start, 0);
				buffer_write(serverBuffer, buffer_u8, Network.Destroy);
				buffer_write(serverBuffer, buffer_u16, _id);
				network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
				i++;
			}
	        break;}
		
		case Network.DestroyUpgrade:{
			_id = buffer_read(_buffer, buffer_u16);
			i = 0;
			repeat (ds_list_size(socketList)) {
				socket = ds_list_find_value(socketList, i);
				buffer_seek(serverBuffer, buffer_seek_start, 0);
				buffer_write(serverBuffer, buffer_u8, Network.DestroyUpgrade);
				buffer_write(serverBuffer, buffer_u16, _id);
				network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
				i++;
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
			_spd = buffer_read(_buffer, buffer_u16);
			_dir = buffer_read(_buffer, buffer_s16);
			_angle = buffer_read(_buffer, buffer_s16);
			
			
			_vars = buffer_read(_buffer, buffer_string);
			//var _upginfo = buffer_read(_buffer, buffer_string);
			//if (_s == 1) {
				i = 0;
				repeat (ds_list_size(socketList)) {
					socket = ds_list_find_value(socketList, i);
				    buffer_seek(serverBuffer, buffer_seek_start, 0);
					buffer_write(serverBuffer, buffer_u8, Network.SpawnUpgrade);
					buffer_write(serverBuffer, buffer_u8, _s);
					buffer_write(serverBuffer, buffer_u16, _x);
					buffer_write(serverBuffer, buffer_u16, _y);
					buffer_write(serverBuffer, buffer_u16, _spr);
					buffer_write(serverBuffer, buffer_u16, _spd);
					buffer_write(serverBuffer, buffer_s16, _dir);
					buffer_write(serverBuffer, buffer_s16, _angle);
					
					buffer_write(serverBuffer, buffer_string, _vars);
					//buffer_write(serverBuffer, buffer_string, _upginfo);
					network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
					i++;
				}
			//}
	        break;}
		
		case Network.Spawn:{
			_s = buffer_read(_buffer, buffer_u8);
			_x = buffer_read(_buffer, buffer_u16);
			_y = buffer_read(_buffer, buffer_u16);
			_vars = buffer_read(_buffer, buffer_string);
			//if (_s == 1) {
				i = 0;
				repeat (ds_list_size(socketList)) {
					socket = ds_list_find_value(socketList, i);
				    buffer_seek(serverBuffer, buffer_seek_start, 0);
					buffer_write(serverBuffer, buffer_u8, Network.Spawn);
					buffer_write(serverBuffer, buffer_u8, _s);
					buffer_write(serverBuffer, buffer_u16, _x);
					buffer_write(serverBuffer, buffer_u16, _y);
					buffer_write(serverBuffer, buffer_string, _vars);
					network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
					i++;
				}
			//}
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
			global.px[_s] = _x;
			global.py[_s] = _y;
			i = 0;
			repeat (ds_list_size(socketList)) {
				socket = ds_list_find_value(socketList, i);
			    buffer_seek(serverBuffer, buffer_seek_start, 0);
				buffer_write(serverBuffer, buffer_u8, Network.PlayerMoved);
				buffer_write(serverBuffer, buffer_u8, _s);
				buffer_write(serverBuffer, buffer_u16, _x);
				buffer_write(serverBuffer, buffer_u16, _y);
				buffer_write(serverBuffer, buffer_u16, _spr);
				buffer_write(serverBuffer, buffer_s8, _scale);
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
			i = 0;
			repeat (ds_list_size(socketList)) {
				socket = ds_list_find_value(socketList, i);
			    buffer_seek(serverBuffer, buffer_seek_start, 0);
				buffer_write(serverBuffer, buffer_u8, Network.StartGame);
				network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
				i++;
			}
			break;}
		
		case Network.PlayerConnect:{
			i = 0;
			repeat (ds_list_size(socketList)) {
			    var _sock = ds_list_find_value(socketList, i);
				if (_sock != socket) {
				    buffer_seek(serverBuffer, buffer_seek_start, 0);
					buffer_write(serverBuffer, buffer_u8, Network.PlayerJoined);
					buffer_write(serverBuffer, buffer_u8, _sock);
					network_send_packet(socket, serverBuffer, buffer_tell(serverBuffer));
				}
				i += 1;
			}
		
			i = 0;
			repeat (ds_list_size(socketList)) {
			    var _sock = ds_list_find_value(socketList, i);
				if (_sock != socket) {
				    buffer_seek(serverBuffer, buffer_seek_start, 0);
					buffer_write(serverBuffer, buffer_u8, Network.PlayerJoined);
					buffer_write(serverBuffer, buffer_u8, socket);
					network_send_packet(_sock, serverBuffer, buffer_tell(serverBuffer));
				}
				i += 1;
			}
		
			break;}
	}
}