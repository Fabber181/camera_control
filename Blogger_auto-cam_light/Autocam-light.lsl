// HUD de control de la camera

//
//
//
integer modeDebug = 1;
debug(string message)
{
	if(modeDebug == 1)
	{
    	llSay(0,message);
    }
}


// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
//                        Variables 
// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
integer time = 10;
integer decrade = 1;
list data_pos =[  <0.0, 0.0, 0.0>,  
	<0.0, 0.0, 0.0>, 
	<0.0, 0.0, 0.0>,  
	<0.0, 0.0, 0.0>,  
	<0.0, 0.0, 0.0>,  
	<0.0, 0.0, 0.0>];
list data_rot =[ <0.0,0.0,0.0,0.0>, 
	<0.0,0.0,0.0,0.0>, 
	<0.0,0.0,0.0,0.0>, 
	<0.0,0.0,0.0,0.0>, 
	<0.0,0.0,0.0,0.0>, 
	<0.0,0.0,0.0,0.0>];
vector offsetCamera =  <1.0, 0.0, 0.0>;

// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
//                        Fonctions
// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.


/*
 Méthode qui prend les droits si nécessaire :
*/
DroitCameraOn()
{
    // Si pas de droit
    llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA | PERMISSION_TRACK_CAMERA);
    llSetCameraParams([CAMERA_ACTIVE, 1]);
}

/*
	Récupère l'index de la camera
*/
integer getIndexFromElement(string detectedElement)
{
	return (integer) llGetSubString(detectedElement, 5,6);
}

/* 
	Met à jours la position de la camera
*/
updateCamInfo(integer indexCam)
{
	debug((string)llGetCameraPos() + " " + (string) indexCam);
	data_pos = llListReplaceList(data_pos, [llGetCameraPos()], indexCam, indexCam);
	data_rot = llListReplaceList(data_rot, [llGetCameraRot()], indexCam, indexCam);
}

/*
	Camera 
*/
setCameraPosition(integer indexCam)
{
	vector pos = llList2Vector(data_pos, indexCam);
	rotation rot = llList2Rot(data_rot, indexCam);
	
	 llSetCameraParams([
        CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 0.0, // ( 0.5 to 10) meters
        CAMERA_FOCUS, convertionFocus(pos, rot), // region relative position
        CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, TRUE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        //CAMERA_PITCH, 80.0, // (-45 to 80) degrees
        CAMERA_POSITION, pos, // region relative position
        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, TRUE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, ZERO_VECTOR // <-10,-10,-10> to <10,10,10> meters	
        ]);
}

/* -- Convertion de rotation en focus -- */
vector convertionFocus(vector position, rotation camera)
{
    vector rot=llRot2Euler(camera);
    camera = llEuler2Rot(rot);
    return position + offsetCamera*camera;
}

/* -- update timer -- */
updateTimer (integer modif)
{
	if(time + modif > 2)
	{
		time = time + modif;
	}
	debug((string) time);
}

default
{
    state_entry()
    {
    	DroitCameraOn();
    }
    
    touch_start(integer num_detected)
    {
	    string detectedElement = llGetLinkName(llDetectedLinkNumber(0));
	    string element = llGetSubString(detectedElement,0,3);
	    debug(detectedElement +" " + element);
	    
	    // Si update 
	    if (element == "UPDA")
	    	updateCamInfo(getIndexFromElement(detectedElement));
	    else if (element == "PLAY")
	    	setCameraPosition(getIndexFromElement(detectedElement));
	    else if (detectedElement == "TIME_+")
			updateTimer(1);
		 else if (detectedElement == "TIME_-")
			updateTimer(-1);
	    else if (element =="RUN")
	    {
	    	
	    }
    }
}