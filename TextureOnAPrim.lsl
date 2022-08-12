/*
License: meh i mean MIT
Author: GridPlay Productions 2022
HowTo: Drop in the root prim, set the paintingprim to your canvas, drop in your textures
*/
integer imgplace = 0;
list imgs = [];
key owner;
string paintingprim = "OliviaArtRoom-Canvas";
integer primname2id(string name) {
    integer i = llGetNumberOfPrims();
    for (; i >= 0; --i) {
        if (llGetLinkName(i) == name) {
            return i;
        }
    }
    return -1;
}
gettextures() {
	imgs = [];
	integer i = 0;
	integer inv = llGetInventoryNumber(INVENTORY_TEXTURE);
	for(i; i < inv; i++) {
		string tname = llGetInventoryName(INVENTORY_TEXTURE, i);
		imgs += [tname];
	}
}
changeimg() {
	++imgplace;
	if (imgplace == llGetListLength(imgs)) {
		imgplace = 0;
	}
	string img = llList2String(imgs, imgplace);
	llSetLinkPrimitiveParamsFast(primname2id(paintingprim), [PRIM_TEXTURE, ALL_SIDES, img, <1,1,1>, <0,0,0>, 0]);
}
default {
	state_entry() {
		owner = llGetOwner();
		gettextures();
	}
	touch_end(integer num_detected) {
		if (llDetectedKey(0) == owner) {
			changeimg();
		}
	}
	changed(integer c) {
		if (c & CHANGED_INVENTORY) {
			gettextures();
		}
	}
}