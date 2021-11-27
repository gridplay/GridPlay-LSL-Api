// Define varables here
vector WHITE = <1.0,1.0,1.0>; // sets the text colour to white
float alpha = 1.0; // sets how visible the text is 0 = not seen, 1 = fully seen

// default state
default {
	state_entry() {
		// lets put a message in text above this prim
		llSetText("Hello mom", WHITE, alpha);
	}
	touch_end() {
		// check to see if the toucher is the owner of this prim
		if (llDetectedKey(0) == llGetOwner()) {
			// lets switch state
			state tutorial;
		}
	}
}

// new state
state tutorial {
	state_entry() {
		llSetText("I am a tutorial", WHITE, alpha);
		llSetTimerEvent(30.0); // we set the timer to 30 seconds
	}
	timer() {
		// stop timer and switch back to the default state
		llSetTimerEvent(0.0);
		state default;
	}
}
