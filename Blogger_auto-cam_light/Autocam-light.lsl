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
integer time = 15;
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
list nombre = [ -0.44998, -0.36989,-0.26979,-0.16967,-0.06959, 0.03051,0.14062,0.23071, 0.34083, 0.43999];

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
	integer newTime = time + modif;
	if(newTime > 2 &&  newTime < 91)
	{
		time = time + modif;
	}
	updateLCD(0);
}

/* -- mise à jours de l'écran LCD--*/
updateLCD(integer reset)
{   
    // calcul de la dizaine 
    integer dizaine =(integer) llFloor(time/10);
    integer unite = time - 10*dizaine;
    
    // Mise à jours du LCD
    llSetLinkPrimitiveParamsFast( 28, [ PRIM_TEXTURE, ALL_SIDES, "039868ac-a165-af3a-450c-60240ad7d2fd", <0.1, 1.0, 0.0>, <llList2Float(nombre, unite), 0.0, 0.0>, 0 ]);
    if (unite == 0 || reset == 1 || unite == 9)
    llSetLinkPrimitiveParamsFast( 26, [ PRIM_TEXTURE, ALL_SIDES, "039868ac-a165-af3a-450c-60240ad7d2fd", <0.1, 1.0, 0.0>, <llList2Float(nombre, dizaine), 0.0, 0.0>, 0 ]);
    
}

default
{
	
	
    state_entry()
    {
    	DroitCameraOn();
    	updateLCD(1);
    }
    
    touch_start(integer num_detected)
    {
	    string detectedElement = llGetLinkName(llDetectedLinkNumber(0));
	    string element = llGetSubString(detectedElement,0,3);
	    //debug(detectedElement +" " + element);
	    
	    // Si update 
	    if (element == "UPDA")
	    	updateCamInfo(getIndexFromElement(detectedElement));
	    else if (element == "PLAY")
	    	setCameraPosition(getIndexFromElement(detectedElement));
	    else if (detectedElement == "TIME_+")
			updateTimer(1);
		 else if (detectedElement == "TIME_-")
			updateTimer(-1);
    }
}