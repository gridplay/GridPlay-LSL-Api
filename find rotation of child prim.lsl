list wheels = ["Wheel 1", "Wheel 2", "etc", "etc"];
default {
	touch_end(integer nd) {
		if (llDetectedKey(0) == llGetOwner()) {
			integer i = llGetNumberOfPrims();
		    for (; i >= 0; --i) {
		    	integer found = llListFindList(wheels, [llGetLinkName(i)]);
		        if (found != -1) {
		        	string st = llGetLinkName(i)+" rotation data";
		        	list lp = llGetLinkPrimitiveParams(i, [PRIM_ROTATION, PRIM_ROT_LOCAL]);
		        	st += "\nMain Rotation is "+(string)llList2Rot(lp, 0);
		        	st += "\nLocal Rotation is "+(string)llList2Rot(lp, 1);
		        	llOwnerSay(st);
		        }
		    }
		}
	}
}