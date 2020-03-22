// ######################################################################################
//               Gestion des Camera - HUD Assistant
// ######################################################################################
/* 
Ce hud est utilisé par l'assistant, il lui permet de se synchroniser sur les camera et de prendre le controle du Hud Camera 
 - (A faire) Permet à l'operateur de tester les plans de cadrages disponnibles
 - (A faire)Permet à l'operateur d'envoyer un plan au cadreur
 - (A faire) Permet à l'opérateur de cadrer des plans fixes et de les envoyer à l'opérateur
 - (A faire) permet à l'opérateur de faire des plans movible de 10 secondes
*/

// --------------------------------------------
//               Debug et test
// -------------------------------------------
integer modeDebug = TRUE;
integer modeInfo = TRUE;
integer getToutchedPrim = FALSE;
    
/* Fonction de Debug */
debug(string message)
{
    if (modeDebug = TRUE)
    {
        llOwnerSay("/me [Debug] - " + message);
    }

}

/* Fonction d'information */
info(string message)
{
    if (modeInfo)
    {
        llOwnerSay("/me [Info] - " + message
        );
    }
}

// --------------------------------------------
//                Constantes
// -------------------------------------------

/*        ------ Calculs / parama -----             */
// Divers
integer channel = 2830;
vector offsetCamera = <1.0000,0.0000,0.0000>; // Calcul de l'offset

// Communication
list comPositionIndexCamera = [4,6];
list comPositionInfoAction = [8,15];
list comPositionPos = [20,59];

string INSTANCE_ALL = "ALL";
string ACTION_GET_INFO = "GET_INFO";
string ACTION_SET_INFO= "SET_INFO";
string ACTION_GIV_INFO= "GIV_INFO";

/*         ------   Boutons    ------               */
// Permissions
integer boutonSynchro = 24;
integer boutonDeSyncrho = 29;

// Camera
integer cam0_bouton; 
integer cam1_bouton;
integer cam2_bouton;
integer cam3_bouton;
integer cam4_bouton;
integer cam5_bouton;
integer cam6_bouton;
integer cam7_bouton;
integer cam8_bouton;
integer cam9_bouton;

integer boutonTestCam = 25;
integer boutonGetCameraPosition = 22;
integer boutonTesCam2 = 27;
integer infoSynchro = 28;

integer camInfoUpdate = 19;
integer camSendId ;

/*         ------   Camera    ------               */
// Mémoire
// - Camera 1
vector cam_1_position = <222.45987, 80.80021, 29.07231>;
rotation cam_1_rotation =  <0.05568, 0.33002, -0.15678, 0.92920>;

// - Camera 2
vector cam_2_position = <239.90578, 72.87510, 21.77446>;
rotation cam_2_rotation =  <-0.05836, 0.07662, 0.60313, 0.79180>;

// Lis de mémoires
list cam0_param;
list cam1_param;
list cam2_param;
list cam3_param;
list cam4_param;
list cam5_param;
list cam6_param;
list cam7_param;
list cam8_param;
list cam9_param;

integer cam_curent;

/*         ------   Couleurs    ------               */
vector couleur_bleu = <0.000, 0.455, 0.851>;
vector couleur_rouge = <1.000, 0.255, 0.212>;
vector couleur_vert = <0.180, 0.800, 0.251> ;

// --------------------------------------------
//                Fonctions
// -------------------------------------------

/*         ------   Droits    ------               */

/* Donne les droits au controle de la camera */
DroitCameraOn(integer perm)
{
    // Si pas de droit
    if (!(perm & PERMISSION_CONTROL_CAMERA))
        llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA);
    couleur(infoSynchro, couleur_bleu);
}

/* Permet de revoque rles droits de l'utilisateur */
DroitCameraOff(integer perm)
{
    // Si il y a des droits de donnés
    if (perm & PERMISSION_CONTROL_CAMERA)
    {
        debug("deSynchro - révocation des droits");
        llSetCameraParams([CAMERA_ACTIVE, 0]);
        llClearCameraParams();
    }
    couleur(infoSynchro, couleur_rouge);
}

/*         ------   Affichage    ------               */
/*  Gestion de la couleu des prims */
couleur(integer prims, vector couleur)
{
    llSetLinkPrimitiveParams(prims, [PRIM_COLOR, ALL_SIDES, couleur, 1.0]);
}

/* -- COnvertion de rotation en focus -- */
vector convertionFocus(vector position, rotation camera)
{
    vector rot=llRot2Euler(camera);
    camera = llEuler2Rot(rot);
    return position + offsetCamera*camera;
}

/*         ------ Donnée -----           */
// Appel les caméra à se mètre à jours
appelInfoUpdate()
{
    llShout(channel, "CAM_" + INSTANCE_ALL + "_" + ACTION_GET_INFO);
}

// Récuperation des informations
recupereInformation(string message)
{
    // Récuperation de l'index de la camera
    integer indexCamera = (integer) llGetSubString(message, llList2Integer(comPositionIndexCamera, 0) , llList2Integer(comPositionIndexCamera,1));
    // Récupération de La position
    vector pos = (vector) llGetSubString(message, llList2Integer(comPositionPos, 0) , llList2Integer(comPositionPos, 1));
    // Récupération de la rotation
    integer debutAngle = llSubStringIndex(message, "R1") + 3;
    rotation rot = (rotation) llGetSubString(message, debutAngle , debutAngle+ 60);
    
    // Enfin on va setter les informations dans la camera correspondante
    debug("recupereInformation() | Idenfifiant "+ (string) indexCamera +"| POS : "+ (string) pos  + " Rot : " +(string) rot ) ;
 		
	// Gestion des caméra de 1 à 10
	if(indexCamera == 0)
		cam0_param = [pos, rot];
	else if(indexCamera == 1)
		cam1_param = [pos, rot]; 
	else if(indexCamera == 2)
		cam2_param= [pos, rot]; 
}
/*        ---- Camera -------     */
// Charge la position de la caméra

// Extraction indentifiant camera;

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
        CAMERA_FOCUS,  convertionFocus(cam_2_position, cam_2_rotation), // region relative position
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


default
{
    
    state_entry()
    {
        info("Reset - script");
        llListen(channel, "", NULL_KEY, "");
    }

    touch_start(integer total_number)
    {
        integer touchedButton = llDetectedLinkNumber(0);
        integer perm = llGetPermissions();
        if(getToutchedPrim)
            debug("Touched -" + (string) touchedButton);
         
        /*         ---- Droit ---            */
        // Camera On
        if (touchedButton == boutonSynchro)
            DroitCameraOn(perm);
        // Camera off
        else if (touchedButton == boutonDeSyncrho)// ------Désynchro
            DroitCameraOff(perm);
        /*         ---- Camera ---          */   
        // Camera 1 
        else if (touchedButton == boutonTestCam)
            testCamera(perm);
        // Camera 2 
        else if (touchedButton == boutonTesCam2)
            testCamera2(perm);
        else if(touchedButton == camInfoUpdate)
            appelInfoUpdate();
    }
    
    
     run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_CONTROL_CAMERA)
        {
             couleur(infoSynchro, couleur_bleu);
        }
        if (perm & PERMISSION_TRACK_CAMERA)
        {
            couleur(infoSynchro, couleur_bleu);
        }
    }
    
    
    listen(integer channel, string name, key id, string message)
    {
        // Recuperation de l'action
        string action = llGetSubString(message, llList2Integer(comPositionInfoAction,0) , llList2Integer(comPositionInfoAction,1));
        
        if(action == ACTION_GIV_INFO)
            recupereInformation(message);
    }
}


/*getCameraPosition(integer perm)
{
    vector cam_position = llGetCameraPos();
    rotation cam_rotation = llGetCameraRot();

    debug("Position de la camera : " + (string) cam_position + " Rotatation de la camera : " + (string) cam_rotation);
}*/