global.px = array_create(3,0);
global.py = array_create(3,0);
port = 64198;
maxClients = 999;

rooms = [];
//rooms[0] = {
//	name : "teste",
//	totalplayers : 0,
//	players : []
//	}
//rooms[1] = {
//	name : "teste2",
//	totalplayers : 2,
//	players : []
//	}
	
	
	
	
server = network_create_server(network_socket_tcp, port, maxClients);
if (server != 0) {
	var answer = show_question("Error starting server, retry?");
	if (answer) {
		network_destroy(server);
		server = undefined;
	    game_restart();
	}
	else {
	    game_end();
	}
}
socket = noone;
buffer = noone;
serverBuffer = buffer_create(4098, buffer_fixed, 1);
socketList = ds_list_create();
players = [noone, noone, noone];
socketToInstanceID = ds_map_create();
playerSpawn = [1895, 1880];