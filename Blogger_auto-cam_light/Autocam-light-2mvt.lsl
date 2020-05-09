// =============================== Blogger Autocam =====================================
// This hud could be used by blgger and manage automaticaly 4 camera fixe and 2 mooving camera. It's including a radient effect and ca be reseting easily
// Author : Fabber Resident (Fabrice TOUPET)
// Mail : fabtoupet3@gmail.com
// Commercial : Can be sold or give by Oeil-Visuel


// ==========================================================================
//                        Viarables
// ==========================================================================
integer modeDebug = 1; // 1 if activate 0 if not
integer time = 5; // Minimum time HUD could accept
integer degrade = TRUE; // Value of radient
integer lecture = FALSE; // If sequence is in play
integer camEnCours = 0; // Camera in read

// For Fix camera
list data_pos =[  <0.0, 0.0, 0.0>, // Position Data of camera
    <0.0, 0.0, 0.0>,
    <0.0, 0.0, 0.0>,
    <0.0, 0.0, 0.0>];
list data_rot =[ <0.0,0.0,0.0,0.0>, // Rotation of Camera
    <0.0,0.0,0.0,0.0>,
    <0.0,0.0,0.0,0.0>,
    <0.0,0.0,0.0,0.0>];

// For Mooving camera
// Cam A
list data_pos_1 =[  <0.0, 0.0, 0.0>, // Position Data of camera
   <0.0, 0.0, 0.0> ];
list data_rot_1 =[ <0.0,0.0,0.0,0.0>, // Rotation of Camera
    <0.0,0.0,0.0,0.0>];
// Cam B
list data_pos_2 =[  <0.0, 0.0, 0.0>, // Position Data of camera
   <0.0, 0.0, 0.0> ];
list data_rot_2 =[ <0.0,0.0,0.0,0.0>, // Rotation of Camera
    <0.0,0.0,0.0,0.0>];


vector offsetCamera =  <1.0, 0.0, 0.0>; // Camera Offset

// Other           0           1        2       3         4       5        6       7        8        9
list nombre = [ -0.44998, -0.36989,-0.26979,-0.16967,-0.06959, 0.03051,0.14062,0.23071, 0.34083, 0.43999]; // LCD Values
vector COULEUR_VERT =     <0.239, 0.600, 0.439>; // Green color
vector COULEUR_BLANC = <1.000, 1.000, 1.000>; // White color


// ==========================================================================
//                              Function
// ==========================================================================
// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
//                        Using tools
// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

// Debug Mode
debug(string message)
{
    if(modeDebug == 1)
    {
        llSay(0,message);
    }
}

// Gestion de la couleur sur un prim
couleur(integer prims, vector couleur)
{
    llSetLinkPrimitiveParamsFast(prims, [PRIM_COLOR, ALL_SIDES, couleur, 1.0]);
}


// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
//                        Getter et Setter
// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.


// ----------------------------- GET ----------------------------
// Get the camera index from prims title
integer getStaticCameraIndexFromElement(string detectedElement)
{
    return (integer) llGetSubString(detectedElement, 5,6);
}

// Get the camera index from prims title
string getMoovingCameraIndexFromElement(string detectedElement)
{
    return (string) llGetSubString(detectedElement, 7,8);
}

// --------------------------- SET -----------------------------
// Set the camera information
setStaticCamInfo(integer indexCam)
{
    debug((string)llGetCameraPos() + " " + (string) indexCam);
    data_pos = llListReplaceList(data_pos, [llGetCameraPos()], indexCam, indexCam);
    data_rot = llListReplaceList(data_rot, [llGetCameraRot()], indexCam, indexCam);
}

// Set the param for mooving camera
setMoovingCamInfo(integer indexCam, string increment)
{
    debug((string)llGetCameraPos() + " " + (string) indexCam + " " + (string) increment);
    if(indexCam == 1)
    {
        if (increment == "A")
        {
            data_pos_1 = llListReplaceList(data_pos_1, [llGetCameraPos()], 0, 0);
            data_rot_1 = llListReplaceList(data_rot_1, [llGetCameraRot()], 0, 0);
        }
        else
        {
            data_pos_1 = llListReplaceList(data_pos_1, [llGetCameraPos()], 1, 1);
            data_rot_1 = llListReplaceList(data_rot_1, [llGetCameraRot()], 1, 1);
        }
    }
    else
    {
        if (increment == "A")
        {
            data_pos_2 = llListReplaceList(data_pos_2, [llGetCameraPos()], 0, 0);
            data_rot_2 = llListReplaceList(data_rot_2, [llGetCameraRot()], 0, 0);
        }
        else
        {
            data_pos_2 = llListReplaceList(data_pos_2, [llGetCameraPos()], 1, 1);
            data_rot_2 = llListReplaceList(data_rot_2, [llGetCameraRot()], 1, 1);
        }
    }

}

setStaticCameraPosition(integer indexCam)
{
    vector pos = llList2Vector(data_pos, indexCam);
    rotation rot = llList2Rot(data_rot, indexCam);
    cameraRightOn();

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
        camEnCours = indexCam;
}
// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
//                           Fonctions
// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

// Right of the hud session
cameraRightOn()
{
    if(llGetPermissions()!=PERMISSION_CONTROL_CAMERA)
    {
        // if rights
        llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA | PERMISSION_TRACK_CAMERA);
        llSetCameraParams([CAMERA_ACTIVE, 1]);
    }
}

/* --  Set une camera random   -- */
updateRandomCamera()
{
    integer indexCam = (integer)llFrand(24.0)/4;
    debug("Entrée - Camen en cours = " + (string )  camEnCours  + " - " + (string) indexCam);
    while(camEnCours == indexCam)
    {
        indexCam = (integer)llFrand(24.0)/4;
        debug( "Boucle " + (string) indexCam);
    }
    debug( "Final " + (string) indexCam);
    if(degrade)
        llSetLinkTextureAnim(21, ANIM_ON , ALL_SIDES, 1, 60, 0, 60, 30);
    llSleep(2);
    setStaticCameraPosition(indexCam);
    if (degrade)
    {
        llSleep(0.5);
        llSetLinkTextureAnim(21, ANIM_ON | REVERSE , ALL_SIDES, 1, 60, 0, 60, 30);
    }

}

/* -- Clear cam -- */
clearCam()
{
    llClearCameraParams();
}


// ===================== Mise aux normes =================================


// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
//                        Fonctions
// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.




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
    llSetTimerEvent(time);
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

// lancement de l'autoPLay
activeAutoplay()
{
    if(lecture == FALSE)
    {
        couleur(27, COULEUR_VERT);
        llSetTimerEvent(time);
    }
    else
    {
        couleur(27, COULEUR_BLANC);
        llSetTimerEvent(0);

    }
    lecture = !lecture;

}

// lancement de l'autoPLay
activeDegrade()
{
    if(degrade == FALSE)
    {
        couleur(22, COULEUR_VERT);
    }
    else
    {
        couleur(22, COULEUR_BLANC);
    }
    degrade = !degrade;

}



default
{

    on_rez(integer start_param)
    {
        cameraRightOn();
    }
    state_entry()
    {
        cameraRightOn();
        updateLCD(1);
    }

    touch_start(integer num_detected)
    {
        string detectedElement = llGetLinkName(llDetectedLinkNumber(0));
        string element = llGetSubString(detectedElement,0,3);
        debug(detectedElement +" " + element);

        // Si update
        if (element == "UPDA")
            setStaticCamInfo(getStaticCameraIndexFromElement(detectedElement));
        else if (element == "PLAY")
            setStaticCameraPosition(getStaticCameraIndexFromElement(detectedElement));
        else if (detectedElement == "TIME_+")
            updateTimer(1);
         else if (detectedElement == "TIME_-")
            updateTimer(-1);
        else if (detectedElement == "RUN")
            activeAutoplay();
        else if (element == "RESE")
            clearCam();
        else if (element == "DEGR")
            activeDegrade();
    }
    timer()
    {
        updateRandomCamera();
    }
}