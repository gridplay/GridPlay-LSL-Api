default {
	touch_end(integer nd) {
		key toucher = llDetectedKey(0);
		if (llSameGroup(toucher)) {
			llGiveInventory(toucher, llGetInventoryName(INVENTORY_OBJECT,0));
		}
	}
}
