//##########################################
// Script destiné au paramétrage des camera 
//##########################################
/* 
Permet de sélectionner une camera à paramétrer. 
Envois le code et la nouvelle position de la camera à partir de la position de la camera de l'utilisateur
*/

integer modeDebug = TRUE;
integer modeDebugTouth = FALSE;

/* -- Fonction de debug -- */
debug(string message)
{
    if(modeDebug)
        llOwnerSay(message);
}

// ----------------------------------
//        Constantes
// ----------------------------------

// Indexation des identifiants de camera / com
integer indexCam ;
string indexCamCom;
integer indexMax = 9 ;
integer indexMin  = 0;
integer channel = 2830;
list nombre = [0.43999, -0.44998, -0.36989,-0.26979,-0.16967,-0.06959, 0.03051,0.14062,0.23071, 0.33081];

// Gestion des boutons 
integer boutonCamPlus = 9;
integer boutonCamMoins = 8;
integer boutonSynchro = 25;
integer primsLcd = 19;


// Constante de lectures
string INSTANCE_ALL = "ALL";
string ACTOIN_GET_INFO = "GET_INFO";
string ACTION_SET_INFO= "SET_INFO";
string ACTION_FIV_INFO= "GIV_INFO";

// -------------------------------
//          Fonction 
// -------------------------------
/* Mise à jours du panneau LCD et indexCamCom */
updateLCD()
{
    // Mise à jours de l'index
    if(indexCam<10)
        indexCamCom = "00"+(string)indexCam;
    if(indexCam>=10)
        indexCamCom = "0"+(string)indexCam;
        
    // Mise à jours du LCD
    llSetLinkPrimitiveParams( primsLcd, [ PRIM_TEXTURE, ALL_SIDES, "2b64590b-8827-a506-b50e-8dc272ae6af8", <0.1, 0.5, 0.0>, <llList2Float(nombre, indexCam), 0.19999, 0.0>, 0 ]);
    
}

/* -- Ouverture des droits de tracking --*/
droitTracking()
{
	llRequestPermissions(llGetOwner(), PERMISSION_TRACK_CAMERA);
}

/* -- Mise à jours si bouton plus -- */
identifiantCamPlus()
{
    // Si identifiant inférieur au max
    if(indexCam<indexMax)
        indexCam += 1;
    updateLCD();
}

/* -- Mise à jours si bouton moins-- */
identifiantCamMoins()
{
    // Si identifiant supérieur au mini
    if(indexCam>indexMin)
        indexCam -= 1;
    updateLCD();
}

/* -- Envois Coordonées -- */
// Envois dans le chat local pour positionner la camera sous la forme suivante
// CAM_%indexCamCom%_SET_INFO-R1-%pos%----------------R2-%rot%
envoisCoo(integer perm)
{
	if(perm & PERMISSION_TRACK_CAMERA)
	{
		string coo =  "CAM_"+indexCamCom+"_"+ ACTION_SET_INFO +" P1 " + (string) llGetCameraPos() + "                     R1 " + (string) llGetCameraRot();
		llShout(channel, coo);
	}
	else
		debug("envoisCoo : Vous n'avez pas les droits sur les coordonées");
}

// * -------------------------- ----------------------------
//                       Etats 
// --------------------------------------------------------

//                 !!! Default !!!

default
{
    state_entry()
    {
        indexCam = 0;
        updateLCD();
        droitTracking();
    }
    touch_start(integer num_detected)
    {
        integer toutchPrim = llDetectedLinkNumber(0);
        integer perm = llGetPermissions();
        if(modeDebugTouth)
			debug("touch_start : Prims touché : " + (string) toutchPrim);
        
        // Index cam +1
        if(toutchPrim == boutonCamPlus)
			identifiantCamPlus();
        // Index cam -1
        else if(toutchPrim == boutonCamMoins)
			identifiantCamMoins();
        // Synchro
        else if(toutchPrim == boutonSynchro)
			envoisCoo(perm);
    }
}

