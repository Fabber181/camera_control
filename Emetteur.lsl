// ======================================================
// Constantes
// ======================================================
    integer modeDebug = TRUE;
    integer modeInfo = TRUE;
    integer getToutchedPrim = FALSE; 
    // -- Identifiant des boutons
    // Synchro on
    integer boutonSynchro = 24;
    integer boutonDeSyncrho = 29;
    integer boutonTestCam = 25;
    integer boutonGetCameraPosition = 22;
    integer boutonTesCam2 = 27;
    integer infoSynchro = 28;
    
    // -- vues : 
    vector offsetCamera = <1.0000,0.0000,0.0000>;
    // - Camera 1
    vector cam_1_position = <240.20906, 72.57046, 26.38088>;
    rotation cam_1_rotation = <-0.45480, 0.02716, 0.88860, 0.05307>;
    
    // - Camera 2
    vector cam_2_position = <225.32430, 69.60304, 21.15176>;
    rotation cam_2_rotation =  <-0.01418, 0.03966, 0.33636, 0.94079>;
    

    // Couleur
    vector couleur_bleu = <0.000, 0.455, 0.851>;
    vector couleur_rouge = <1.000, 0.255, 0.212>;
    vector couleur_vert = <0.180, 0.800, 0.251> ;


// - debug
debug(string message)
{
    if (modeDebug = TRUE)
    {
        llOwnerSay("/me [Debug] - " + message);
    }
}

info(string message)
{
    if (modeInfo)
    {
        llOwnerSay("/me [Info] - " + message
        );
    }
}

// =============================================
// Fonction
// =============================================

// Resset
/* Fonction qui permet de réinitilialise rl'affichage
*/
reset()
{
     couleur(infoSynchro, couleur_rouge);
}

// --------------- Synchro
/* Fonction qui permet de donner les droits de la caméra au HD */
synchro(integer perm)
{
    // Gestion des droits de la camera
    if (perm & PERMISSION_CONTROL_CAMERA)
        debug("PERMISSION_CONTROL_CAMERA - Vous avez déjà les droit");
    else
        llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA);

    // Gestion des droits de tracking de la camera
    if (perm & PERMISSION_TRACK_CAMERA)
        debug("PERMISSION_TRACK_CAMERA - Vous avez déjà les droit");
    else
        llRequestPermissions(llGetOwner(), PERMISSION_TRACK_CAMERA);
}

/* Permet de revoque rles droits de l'utilisateur */
deSynchro(integer perm)
{
    if (perm & PERMISSION_CONTROL_CAMERA)
    {
        debug("deSynchro - révocation des droits");
           llSetCameraParams([CAMERA_ACTIVE, 0]);
        llClearCameraParams();
    }
    else
        debug("deSynchro - Droit déjà révoqués");
    couleur(infoSynchro, couleur_rouge);
}

/* --- Couleur -- */
couleur(integer prims, vector couleur)
{
    llSetLinkPrimitiveParams(prims, [PRIM_COLOR, ALL_SIDES, couleur, 1.0]);
}

vector convertionFocus(vector position, rotation camera)
{
	vector rot=llRot2Euler(camera);
	camera = llEuler2Rot(rot);
	return position + offsetCamera*camera;
}

testCamera(integer perms)
{
    if ( perms & PERMISSION_CONTROL_CAMERA )
    {
		debug(" fonction  testCamera - Droit valides");
		 llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 0.0, // ( 0.5 to 10) meters
        CAMERA_FOCUS, convertionFocus(cam_1_position, cam_1_rotation), // region relative position
        CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, TRUE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
		//CAMERA_PITCH, 80.0, // (-45 to 80) degrees
        CAMERA_POSITION, cam_1_position, // region relative position
        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, TRUE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, ZERO_VECTOR // <-10,-10,-10> to <10,10,10> meters
    	]);
	
    }
}

testCamera2(integer perms)
{
    if ( perms & PERMISSION_CONTROL_CAMERA)
    {
    	debug(" fonction  testCamera 2 - Droit valides");
    	 llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 0.0, // ( 0.5 to 10) meters
        CAMERA_FOCUS,  convertionFocus(cam_1_position, cam_1_rotation), // region relative position
        CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, TRUE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
		//CAMERA_PITCH, 80.0, // (-45 to 80) degrees
        CAMERA_POSITION, cam_2_position, // region relative position
        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, TRUE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, ZERO_VECTOR // <-10,-10,-10> to <10,10,10> meters
        ]);
    }
}

getCameraPosition(integer perm)
{
	vector cam_position = llGetCameraPos();
	rotation cam_rotation = llGetCameraRot();
	
	debug("Position de la camera : " + (string) cam_position + " Rotatation de la camera : " + (string) cam_rotation);
}


default
{
    state_entry()
    {
        info("Reset - script");
        reset();
    }

    touch_start(integer total_number)
    {
        integer touchedButton = llDetectedLinkNumber(0);
        integer perm = llGetPermissions();
        if(getToutchedPrim)
            debug("Touched -" + (string) touchedButton);
        if (touchedButton == boutonSynchro)// --------------Synchro
        {
            synchro(perm);
        }
        else if (touchedButton == boutonDeSyncrho)// ------Désynchro
        {
            deSynchro(perm);

        }
        else if (touchedButton == boutonTestCam) // ------Cam 1
        {
            testCamera(perm);
        }
        else if (touchedButton == boutonTesCam2)// ------- cam 2
        {
            testCamera2(perm);
        }
        else if (touchedButton == boutonGetCameraPosition)
        {
        	getCameraPosition(perm);
        }
    }
     run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_CONTROL_CAMERA)
        {
             debug("run_time_permissions - PERMISSION_CONTROL_CAMERA : OK"+(string) perm);
             couleur(infoSynchro, couleur_bleu);
        }
        if (perm & PERMISSION_TRACK_CAMERA)
        {
            debug("run_time_permissions - PERMISSION_TRACK_CAMERA : OK"+(string) perm);
            couleur(infoSynchro, couleur_bleu);
        }
    }
}