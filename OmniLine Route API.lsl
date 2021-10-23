/*
COPYRIGHT 2021 GRIDPLAY.NET
To be used inside the root prim of the Lusch OmniLine bus
MIT LICENSE
*/
integer API_CHAN = -6664;
key owner;
// str = route_text, id = msg | 14 characters
setRouteName(string msg) {
	llMessageLinked(LINK_SET,0,"route_text", msg);
}
// str = route_number, id = number | 2 numbers
setRouteID(string num) {
	llMessageLinked(LINK_SET,0,"route_number", num);
}
default {
	state_entry() {
		owner = llGetOwner();
		llListen(API_CHAN,"","","");
	}
	listen(integer chan, string name, key id, string msg) {
		if (chan == API_CHAN && llGetOwnerKey(id) == owner) {
			string bs = llBase64ToString(msg);
			string uri = llJsonGetValue(bs,["uri"]);
			string jmsg = llJsonGetValue(bs,["msg"]);
			if (uri == "text") {
				setRouteName(jmsg);
			}
			if (uri == "num") {
				setRouteID(jmsg);
			}
		}
	}
}