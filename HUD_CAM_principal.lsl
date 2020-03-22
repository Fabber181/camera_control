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
integer boutonManuelStatic = 15;

// Camera
integer cam0_bouton = 25; 
integer cam1_bouton = 27;
integer cam2_bouton = 26;
integer cam3_bouton= 21;
integer cam4_bouton= 14;
integer cam5_bouton= 6;
integer cam6_bouton= 12;
integer cam7_bouton= 23;
integer cam8_bouton= 3;
integer cam9_bouton= 16;

// Camera - Directe
integer infoSynchro = 28;
integer boutonInfoUpdate = 19;

/*         ------------ Variables --------             */
integer camSelectionne;

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
vector couleur_orange= 	<1.000, 0.522, 0.106>;
vector couleur_vert = <0.180, 0.800, 0.251> ;
vector couleur_blanc=	<1.000, 1.000, 1.000>;

// --------------------------------------------
//                Fonctions
// -------------------------------------------

/*         ------   Droits    ------               */

/* Donne les droits au controle de la camera */
DroitCameraOn(integer perm)
{
    // Si pas de droit
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

// Passe les couleurs des caméra en blanc 
resetCouleurCamera()
{
	couleur(cam0_bouton, couleur_blanc);
	couleur(cam1_bouton, couleur_blanc);
	couleur(cam2_bouton, couleur_blanc);
	couleur(cam3_bouton, couleur_blanc);
	couleur(cam4_bouton, couleur_blanc);
	couleur(cam5_bouton, couleur_blanc);
	couleur(cam6_bouton, couleur_blanc);
	couleur(cam7_bouton, couleur_blanc);
	couleur(cam8_bouton, couleur_blanc);
	couleur(cam9_bouton, couleur_blanc);
}
/*         ------ Donnée -----           */
// Appel les caméra à se mètre à jours
appelInfoUpdate()
{
    llShout(channel, "CAM_" + INSTANCE_ALL + "_" + ACTION_GET_INFO);
    resetCouleurCamera();
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
	{
		cam0_param = [pos, rot];
		couleur(cam0_bouton, couleur_bleu);
	}
	else if(indexCamera == 1)
	{
		cam1_param = [pos, rot]; 
		couleur(cam1_bouton, couleur_bleu);
	}
	else if(indexCamera == 2)
	{
		cam2_param= [pos, rot];
		couleur(cam2_bouton, couleur_bleu);		
	}
	else if(indexCamera == 3)
	{
		cam3_param= [pos, rot];
		couleur(cam3_bouton, couleur_bleu);		
	}
	else if(indexCamera == 4)
	{
		cam4_param= [pos, rot];
		couleur(cam4_bouton, couleur_bleu);		
	}
	else if(indexCamera == 5)
	{
		cam5_param= [pos, rot];
		couleur(cam5_bouton, couleur_bleu);		
	}
	else if(indexCamera == 6)
	{
		cam6_param= [pos, rot];
		couleur(cam6_bouton, couleur_bleu);		
	}
	else if(indexCamera == 7)
	{
		cam7_param= [pos, rot];
		couleur(cam7_bouton, couleur_bleu);		
	}
	else if(indexCamera == 8)
	{
		cam8_param= [pos, rot];
		couleur(cam8_bouton, couleur_bleu);		
	}
		else if(indexCamera == 9)
	{
		cam9_param= [pos, rot];
		couleur(cam9_bouton, couleur_bleu);		
	}
}


/*            ---- Camera  | Programmé -------       */


// Charge la position de la caméra
updateCamera(list parametre, integer bouton)
{
	vector pos = llList2Vector(parametre,0);
	rotation rot = llList2Rot(parametre,1);
	
	llOwnerSay("UpdateCamera() - Position " +(string) pos + " rotation : "+(string) rot );
	 llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
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



/*            ---- Camera | Manual ---              */
// Envoie la coordoné de la camera au bot sous la forme standard. 
sendCameraStaticManual()
{
	string coo =  "CAM_201_"+ ACTION_SET_INFO +" P1 " + (string) llGetCameraPos() + "                     R1 " + (string) llGetCameraRot();
	debug(coo);
}



default
{
    
    state_entry()
    {
        info("Reset - script");
        llListen(channel, "", NULL_KEY, "");
        resetCouleurCamera();
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
        else if(touchedButton == boutonInfoUpdate)
            appelInfoUpdate();
        else if(touchedButton == cam0_bouton)
			updateCamera(cam0_param, cam0_bouton);
		else if (touchedButton == cam1_bouton)
			updateCamera(cam1_param, cam1_bouton);
		else if (touchedButton == cam2_bouton)
			updateCamera(cam2_param, cam2_bouton);
		else if (touchedButton == cam2_bouton)
			updateCamera(cam2_param, cam2_bouton);
		else if (touchedButton == cam3_bouton)
			updateCamera(cam3_param, cam3_bouton);
		else if (touchedButton == cam4_bouton)
			updateCamera(cam4_param, cam4_bouton);
		else if (touchedButton == cam5_bouton)
			updateCamera(cam5_param, cam5_bouton);
		else if (touchedButton == cam6_bouton)
			updateCamera(cam6_param, cam6_bouton);
		else if (touchedButton == cam7_bouton)
			updateCamera(cam7_param, cam7_bouton);
		else if (touchedButton == cam8_bouton)
			updateCamera(cam8_param, cam8_bouton);
		else if (touchedButton == cam9_bouton)
			updateCamera(cam9_param, cam9_bouton);
		/*         ----- Manuelle -------         */
		else if (touchedButton == boutonManuelStatic)
			sendCameraStaticManual();
}
    
    
     run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_CONTROL_CAMERA)
        {
             couleur(infoSynchro, couleur_bleu);
             llOwnerSay("Camera Ouvert");
        }
        if (perm & PERMISSION_TRACK_CAMERA)
        {
            couleur(infoSynchro, couleur_bleu);
            llOwnerSay("tracking ouvert");
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