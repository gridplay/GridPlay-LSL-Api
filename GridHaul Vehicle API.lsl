/*
** DISCLIAMER **
** VENKELLIE WILL NOT HELP IF THE BASE CODE OF THIS SCRIPT HAS BEEN MODIFIED **
*/
/*
vt = vehicle type = suggested grid grams
------------------------------
ap = Airplane = 20
hp = Helipad = 5
rd = Road = 4
ft = Foot = 2
rr = RailRoad = 12
bo = Boat = 15
sa = Space = 40
am = Amphibian = 39 (road + boat + airplane)
*/
string vt = "rd";
/*
max grid grams your vehicle can haul
or set to 0 (zero) if you want the server to set the size
or -1 to use the cubic meter calculation that is in the state_entry event
list box = llGetBoundingBox(llGetKey());
vector vsize = llList2Vector(box, 1) - llList2Vector(box, 0);
maxgg = (llRound(vsize.x) + llRound(vsize.y) + llRound(vsize.z));
maxgg += llGetNumberOfPrims();
*/
integer maxgg = -1;
/* channel number for link_message */
integer lmchan = 30;
// OPEN API channel
integer OPENAPI = 47434285;
// We should not assume that every possible vehicle has a valid llAcvatarOnSitTarget() (CarlaWetter)
integer target;
integer FindSitTarget() {
// function to scan for the first valid sit target in the vehicle linkset
    integer prims = llGetObjectPrimCount(llGetKey()); // number of prims, no seated avis
    if (prims > 1) {
        integer i = 1;
        while ((target == 0)&&(i <= prims)) {
            i++;
            if (llList2Integer(llGetLinkPrimitiveParams(i, [PRIM_SIT_TARGET]),0) == 1) {
                target = i;
            }
        }
    }else if (prims == 1) {
        target = 0;
    }
    return target;
}
// Back to our regular schedule
sendlink(list jl) {
    string json = llList2Json(JSON_OBJECT,jl);
    llMessageLinked(LINK_SET,lmchan,json,NULL_KEY);
}
unloading(string cargo) {
    // do your unloading code here
    list jl = ["status","unloading"];
    jl += ["cargo", cargo];
    sendlink(jl);
}
loading(string cargo) {
    // do your loading code here
    list jl = ["status","loading"];
    jl += ["cargo", cargo];
    sendlink(jl);
}
/* dont worry about everything below */
integer ghchan = -47434285; // GRIDHAUL on any phone keypad
key owner;
key hudkey = NULL_KEY;
apisay(string uri, list other) {
    other += ["uri",uri];
    string js = llList2Json(JSON_OBJECT,other);
    string bs = llStringToBase64(js);
    if (hudkey == NULL_KEY) {
        hudkey = owner;
    }
    llRegionSayTo(hudkey,ghchan,bs);
}
string NumberFormat(integer number) {
    string output;
    integer x = 0;
    string numberString = (string)number;
    integer numberStringLength = llStringLength(numberString);
    integer z = (numberStringLength + 2) % 3;
    for(;x < numberStringLength; ++x) {
        output += llGetSubString(numberString, x, x);
        if ((x % 3) == z && x != (numberStringLength - 1)) {
            output += ",";
        }
    }
    return output;
}
default {
    state_entry() {
        target = FindSitTarget(); // scan for first valid sit target in linkest on init
        if (maxgg == -1) {
            list box = llGetBoundingBox(llGetKey());
            vector vsize = llList2Vector(box, 1) - llList2Vector(box, 0);
            maxgg = (llRound(vsize.x) + llRound(vsize.y) + llRound(vsize.z));
            maxgg += (llGetNumberOfPrims() / 2);
        }
        llOwnerSay("Maximum cargo capacity: "+NumberFormat(maxgg)+" GridGrams");
        owner = llGetOwner();
        llListen(ghchan,"","","");
        llListen(OPENAPI,"","","");
    }
    listen(integer chan, string name, key id, string msg) {
        if (chan == OPENAPI && llGetOwnerKey(id) != owner) {
            string parcel_uuid = llJsonGetValue(msg,["parcel_uuid"]);
            string vuri = llJsonGetValue(msg,["uri"]);
            string cargo = llJsonGetValue(msg,["cargo"]);
            if (vuri == "loading") {
                loading(cargo);
            }
            if (vuri == "unloading") {
                unloading(cargo);
            }
        }
        if (chan == ghchan && llGetOwnerKey(id) == owner) {
            string bs = llBase64ToString(msg);
            string json = llUnescapeURL(bs);
            string parcel_uuid = llJsonGetValue(json,["parcel_uuid"]);
            if (llJsonValueType(json,["uri"]) != JSON_INVALID) {
                string vuri = llJsonGetValue(json,["uri"]);
                string cargo = llJsonGetValue(json,["cargo"]);
                if (vuri == "loading") {
                    loading(cargo);
                }
                if (vuri == "unloading") {
                    unloading(cargo);
                }
            }
        }
    }
    link_message(integer sn, integer num, string str, key id) {
        if (num == 0) {
            if (str == "driver_getin") {
                apisay("sit",["vt",vt,"maxgg",maxgg]);
            }
            if (str == "SPT_SEATED, DRIVER" && id == owner) {
                apisay("sit",["vt",vt,"maxgg",maxgg]);
            }
            if (str == "starter_abandon") {
                apisay("stand",["vt","ft"]);
            }
            if (str == "SPT_SEATED, DRIVER" && id == NULL_KEY) {
                apisay("stand",["vt","ft"]);
            }
        }
    }
    changed(integer c) {
        if (c & CHANGED_LINK) {
            key sa = llAvatarOnLinkSitTarget(target);
            // obviously we can not use llAvatarOnSitTarget() any more
            if (sa) {
                apisay("sit",["vt",vt,"maxgg",maxgg]);
            }else{
                key sabu = llAvatarOnSitTarget();
                // Should still check for it just incase
                if (sabu) {
                    apisay("sit",["vt",vt,"maxgg",maxgg]);
                }else{
                    apisay("stand",["vt","ft"]);
                }
            }
        }
        if (c & CHANGED_INVENTORY || c & CHANGED_OWNER) {
            llResetScript();
        }
    }
    on_rez(integer sp) {
        llResetScript();
    }
}
