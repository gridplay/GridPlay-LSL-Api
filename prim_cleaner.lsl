default {
	state_entry() {
		integer i = llGetNumberOfPrims();
	    for (; i >= 0; --i) {
	        llSetLinkPrimitiveParams(i, [PRIM_TEXT, "", <0,0,0>, 0.0]);
	    }
	    llRemoveInventory(llGetScriptName());
	}
}