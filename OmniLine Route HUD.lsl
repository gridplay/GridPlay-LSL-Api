/*
COPYRIGHT 2021 GRIDPLAY.NET
To be used inside the root prim of a HUD
MIT LICENSE
*/
integer API_CHAN = -6664;
integer lchan;
integer glc;
integer tchan;
integer tlc;
list defaultbtns = ["EXIT", "SET NUM", "SET TEXT"];
key owner;
integer texttype = 0; // 1 = NUM, 2 = TXT;
default {
	state_entry() {
		owner = llGetOwner();
	}
	touch_end(integer num_detected) {
		lchan = -(llRound(llFrand(999999)) + 99999);
        glc = llListen(lchan, "", owner, "");
        llDialog(owner, "Please select a option", defaultbtns, lchan);
	}
	listen(integer chan, string name, key id, string msg) {
		if (chan == lchan && id == owner) {
			llListenRemove(glc);
			if (msg == "EXIT") {/* DO NOTHING */}
			if (msg == "SET NUM") {
				texttype = 1;
				tchan = -(llRound(llFrand(999999)) + 99999);
        		tlc = llListen(tchan, "", owner, "");
        		llTextBox(owner,"Please type in a 2 digit number", tchan);
			}
			if (msg == "SET TEXT") {
				texttype = 2;
				tchan = -(llRound(llFrand(999999)) + 99999);
        		tlc = llListen(tchan, "", owner, "");
        		llTextBox(owner,"Please type in a 14 character route name", tchan);
			}
		}
		if (chan == tchan && id == owner) {
			string uri = "";
			if (texttype == 1) {
				uri = "num";
			}
			if (texttype == 2) {
				uri = "text";
			}
			string js = llList2Json(JSON_OBJECT,["uri",uri, "msg",msg]);
			llSay(API_CHAN, llStringToBase64(js));
		}
	}
}