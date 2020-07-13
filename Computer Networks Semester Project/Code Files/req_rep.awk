BEGIN {
	route_requested = 0;
	route_replied = 0;
	outRequest = "Request.log";
	outReply = "Reply.log";
}

{

req = $25;
reply = $23;
time = $2;


	if ( req == "(REQUEST)" ) {
		route_requested++;
	}

	if ( reply == "(REPLY)" ) {
		route_replied++;

	}
}
END {
	printf("\n\nNumber of Route Request : %d\n", route_requested);
	printf("\nNumber of  Route Replies recieved : %d\n\n" , route_replied);
}
