/* 
* Always define varables BEFORE the default state
*/
integer localChannel;
integer channelListen;
key toucher;
// Always define custom functions between the varables and default state
mainmenu()
{
	// creates a random number in the negative to listen on
	localChannel = -(llRound(llFrand(999999)) + 99999);
	// listens on the number above for whatever TOUCHER says
	channelListen = llListen(localChannel, "", toucher, "");
	// opens a dialog box to the TOUCHER to choose options in
	// remember, a dialog box can only have up to 12 buttons
	llDialog(toucher, "Please select a option", ["EXIT", "RESET", "MENU", "Funny"], localChannel);
}
// we can even have functions that returns a varable type like string or integer
// lets return a string
string saysomething()
{
	return "Cortona is so dumb she had to google herself";
	// ok so not very funny but its a good example
	// wait does Cortona even know how to use google?
}
default
{
	touch_end(integer nd)
	{
		// get the uuid of the avatar who touched this prim
		toucher = llDetectedKey(0);
		// go to the function above and do that operation
		mainmenu();
	}
	listen(integer channel, string name, key id, string message)
	{
		// check to make sure what we heard is on the right channel
		// and by the right avatar
		if (channel == localChannel && id == toucher)
		{
			// close the listen since we dont need it any more
			// SL limits the number of channels a script can listen on at one time
			llListenRemove(channelListen);
			// EXIT doesnt really have to be in here
			if (message == "EXIT")
			{
				// sends a instant message to the TOUCHER after selecting EXIT
				llInstantMessage(id, "OK i'll stop pulling a Alexa");
			}
			if (message == "RESET")
			{
				// lets reset the script for good messure
				llResetScript();
			}
			if (message == "MENU")
			{
				// lets reuse that function again
				// this time we use ID in this event as the toucher
				toucher = id;
				mainmenu();
			}
			if (message == "Funny")
			{
				// lets say something funny
				llSay(0, saysomething());
				// notice we put a function inside a function
				// oh ya llSay will say whatever saysomething returns on a given channel
				// in this case it will show up in local chat because channel zero is local
			}
		}
	}
}