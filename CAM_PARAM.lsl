//#################################################
//         Gestion des caméra (objet)
//###############################################
/*
Les caméra son uniquement visuelle et servent de 'stockage'.
Script destiné au caméra in world. Il permet de faire plusieurs choses :
- Définir les positionnement automatiquement à la pose des caméra
- Envoys au HUD / Table de controle les position des caméras et leurs angles
- Positionner les camera automatiquement avec le HUD de config
- ( A faire ) Afficher un voyant rouge quand elles filment
- ( A faire ) les rendre transparente automatiquement
*/
// --------------------------------------------
//               Debug et test
// -------------------------------------------
integer modeDebug = TRUE;
integer modeDebugTouch = FALSE;

/* Fonction de debug si activé */
debug(string message)
{
    if (modeDebug)
        llOwnerSay(message);
}

// --------------------------------------------
//                Constantes
// -------------------------------------------

// Indexation des caméra / com
integer indexCam;
string indexCamCom;
integer indexCamMax = 20;
integer indexCamMin = 0;
integer channel = 2830;
list nombre = [0.43999, -0.44998, -0.36989, -0.26979,-0.16967,-0.06959,0.03051,0.14062,0.23071, 0.33081];
integer dizaineActuelle =0;

// Boutons
integer boutonCam = 4;
integer faceCamPlus = 5;
integer faceCamMoins = 1;
integer primsLcd = 2;
integer primxLcdDisaine = 3;

// Constante de lectures
string INSTANCE_ALL = "ALL";
string ACTOIN_GET_INFO = "GET_INFO";
string ACTION_SET_INFO= "SET_INFO";
string ACTION_FIV_INFO= "GIV_INFO";
string ACTION_SHOW= "CAM_SHOW";
string ACTION_HIDE= "CAM_HIDE";

// --------------------------------------------
//                  Fonctions
// --------------------------------------------
/* Mise à jours de l'écran LCD / de l'index de communication */
updateLCD()
{
    // Mise à jours de l'index
    if(indexCam <10)
        indexCamCom = "00"+ (string) indexCam;
    else if (indexCam>=10)
        indexCamCom = "0"+ (string) indexCam;
        
    // calcul de la dizaine 
    integer dizaine =(integer) llFloor(indexCam/10);
    integer unite = indexCam - 10*dizaine;

    // Mise à jours du LCD
    llSetLinkPrimitiveParamsFast( primsLcd, [ PRIM_TEXTURE, ALL_SIDES, "2b64590b-8827-a506-b50e-8dc272ae6af8", <0.1, 0.5, 0.0>, <llList2Float(nombre, unite), 0.19999, 0.0>, 0 ]);
    if(dizaine != dizaineActuelle)
    {
    	dizaineActuelle = dizaine;
    	llSetLinkPrimitiveParamsFast( primxLcdDisaine, [ PRIM_TEXTURE, ALL_SIDES, "2b64590b-8827-a506-b50e-8dc272ae6af8", <0.1, 0.5, 0.0>, <llList2Float(nombre, dizaine), 0.19999, 0.0>, 0 ]);
    }
}

/* -- Mise à jours si bouton plus -- */
identifiantCamPlus()
{
    // Si identifiant inférieur au max
    if(indexCam<indexCamMax)
        indexCam += 1;
    updateLCD();
}

/* -- Mise à jours si bouton moins-- */
identifiantCamMoins()
{
    // Si identifiant supérieur au mini
    if(indexCam>indexCamMin)
        indexCam -= 1;
    updateLCD();
}

/* -- Envois les informations de la camera -- */
infoPositionRotation()
{
    llSleep(indexCam);
    llShout(channel, "CAM_"+indexCamCom+"_GIV_INFO P1 " + (string) llGetPos() + "                     R1 " + (string) llGetRot());
}

setNouvelleCoordonnees(string message)
{
    // Lecture des coorodonées
    vector pos = (vector) llGetSubString(message, 20 , 59);
    integer debutAngle = llSubStringIndex(message, "R1") + 3;
    rotation rot = (rotation) llGetSubString(message, debutAngle , debutAngle+ 60);
    debug("setNouvelleCoordonnees() | POS : "+ (string) pos  + " Rot : " +(string) rot ) ;


    // Mise en place des nouvelles coordonées
    llSetRot(rot);
   llSetPos(pos);

}

/* ---       Visibilité des camera            ---- */
// permet d'afficher la camera
showCamera()
{
	llSetLinkPrimitiveParams(LINK_SET ,[PRIM_COLOR, ALL_SIDES, <1.0,1.0,1.0>, 1.0]);
}

// Permet de cacher la camera
hideCamera()
{
	llSetLinkPrimitiveParams(LINK_SET ,[PRIM_COLOR, ALL_SIDES, <1.0,1.0,1.0>, 0.0]);
}



// * -------------------------- ----------------------------
//                       Etats
// --------------------------------------------------------

//                 !!! Default !!!
default
{
	on_rez(integer start_param)
	{
		llResetScript();
	}
	
    state_entry()
    {
        // initalisation du script
        indexCam = 0;
        updateLCD();

        // Ajout d'écouteurs
        llListen(channel, "", NULL_KEY, "");
    }


    touch_start(integer num_detected)
    {
        integer touchPrim = llDetectedLinkNumber(0);
        // Si la caméra est touchée
        if (touchPrim == boutonCam)
        {
            integer touchFace = llDetectedTouchFace(0);
            // Bouton +
            if (touchFace == faceCamPlus)
                identifiantCamPlus();
            // Bouton -
            else if (touchFace == faceCamMoins)
                identifiantCamMoins();
        }
    }
     listen(integer channel, string name, key id, string message)
    {
        //Décompilation du message
        string instance = llGetSubString(message, 4 , 6);
        string instancePropriete = llGetSubString(message, 8 , 15);

        // Si concerne tous
        if (instance == INSTANCE_ALL)
        {
            // Si get Info
            if(instancePropriete == ACTOIN_GET_INFO)
                infoPositionRotation();
        }
        else
        {
            // Récupération de l'idenfitiant de la cam
            integer instanceIdCam = (integer)instance;
            debug("instance ID Cam : " + (string) instanceIdCam + " Action : " + (string) instancePropriete + " Attendu : " + (string) ACTION_SET_INFO) ;

            // Si l'ID de la camera correspond
            if ((integer) instanceIdCam == indexCam)
            {
                // Si mise à jours des informations
                if(instancePropriete == ACTION_SET_INFO)
                    setNouvelleCoordonnees(message);
                if(instancePropriete == ACTION_SHOW)
					showCamera();
				if(instancePropriete == ACTION_HIDE)
					hideCamera();     
            }
        }
    }
}