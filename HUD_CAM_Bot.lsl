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
integer camMouvementManuel = FALSE;
integer camEnCours;
integer iteration = 0;
integer veille = 0;

// Communication
list comPositionIndexCamera = [4,6];
list comPositionInfoAction = [8,15];
list comPositionPos = [20,59];
list comBotInfo = [0,7];
list comBotIndexCam = [9,12];

string INSTANCE_ALL = "ALL";
string ACTION_GET_INFO = "GET_INFO";
string ACTION_SET_INFO= "SET_INFO";
string ACTION_GIV_INFO= "GIV_INFO";
string ACTION_SET_CAME= "SET_CAME";
string ACTION_BOT_MFIX= "BOT_MFIX";
string ACTION_BOT_MMOV= "BOT_MMOV";
string ACTION_BOT_CAME= "BOT_CAME";

/*         ------   Boutons    ------               */
// Permissions
integer boutonSynchro = 24;
integer boutonDeSyncrho = 29;

// Camera
list cameraBouton = [
    "c0", "p25", //Cam 0
    "c1", "p27", //Cam 1
    "c2", "p26", //Cam 2
    "c3", "p21", //Cam 3
    "c4", "p14", //Cam 4
    "c5", "p6",  //Cam 5
    "c6", "p12", //Cam 6
    "c7", "p23", //Cam 7
    "c8", "p3",  //Cam 8
    "c9", "p16", //Cam 9
    "c10", "p13",//Cam 10
    "c11", "p18",//Cam 11
    "c12", "p2", //Cam 12
    "c13", "p5", //Cam 13
    "c14", "p17",//Cam 14
    "c15", "p7", //Cam 15
    "c16", "p11",//Cam 16
    "c17", "p8", //Cam 17
    "c18", "p9", //Cam 18
    "c19", "p20",//Cam 19
    "c20", "p22" //Cam 20
    ];

// Camera - Directe
integer infoSynchro = 28;
integer boutonInfoUpdate = 19;

/*         ------------ Variables --------             */

/*         ------   Camera    ------               */
// Mémoire
list cameraParams = [
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 0
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 1
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 2
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 3
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 4
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 5
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 6
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 7
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 8
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 9
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 10
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 11
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 12
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 13
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 14
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 15
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 16
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 17
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 18
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 19
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0> // Cam 20
];

/*         ------   Couleurs    ------               */
vector couleur_bleu = <0.000, 0.455, 0.851>;
vector couleur_rouge = <1.000, 0.255, 0.212>;
vector couleur_orange=     <1.000, 0.522, 0.106>;
vector couleur_vert = <0.180, 0.800, 0.251> ;
vector couleur_blanc=    <1.000, 1.000, 1.000>;

// --------------------------------------------
//                Fonctions
// -------------------------------------------

// --------------------------------------------
//               Getter et setter
// -------------------------------------------

/*         ------- Lecture de données -------       */

// recherche l'identifiant d'un bouton à partir de l'idenfiant d'une camera
integer getBoutonFromCameraIndex(integer cameraIndex)
{
    string resultat = llList2String(cameraBouton, (cameraIndex*2) +1);
    //debug("test - " + (string) llGetSubString(resultat, 1,2));
    return (integer) llGetSubString(resultat, 1,2);
}

// récupère les rotation
rotation getRotation(integer indexCam)
{
    //debug("getRotation() : "+(string)llList2Rot(cameraParams, indexCam*2));
    return llList2Rot(cameraParams, indexCam*2);
}

// récupère les positions
vector getVector(integer indexCam)
{
    //debug("getVector() : "+(string)llList2Vector(cameraParams, (indexCam*2)+1));
    return  llList2Vector(cameraParams, (indexCam*2)+1);
}

// Set un nouvelle rotation
setRotation(integer indexCam, rotation rot)
{
    integer indexList = indexCam * 2;
    cameraParams = llListReplaceList(cameraParams, [rot], indexList, indexList);
}

// Set une nouvelle position
setPosition (integer indexCam, vector pos)
{
    integer indexList = (indexCam*2) + 1;
    cameraParams = llListReplaceList(cameraParams, [pos], indexList, indexList);
}

// Récupère l'action à partir d'un message
string getMessageAction(string message)
{
    return llGetSubString(message, llList2Integer(comPositionInfoAction,0), llList2Integer(comPositionInfoAction,1));
}

// Retourne les informations si elles concernent le bot
string getMessageBotInfo(string message)
{
    return llGetSubString(message, llList2Integer(comBotInfo,0), llList2Integer(comBotInfo,1));
}

// Retourne l'index de la camera quand bot info
string getMessageBotInfoIndexCam(string message)
{
    return llGetSubString(message, llList2Integer(comBotIndexCam,0), llList2Integer(comBotIndexCam,1));
}



// --------------------------------------------
//               Gestion des droits
// -------------------------------------------

/*         ------   Droits    ------               */
/* Donne les droits au controle de la camera */
DroitCameraOn()
{
    // Si pas de droit
    llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA | PERMISSION_TRACK_CAMERA);
     llSetCameraParams([CAMERA_ACTIVE, 1]);
    couleur(infoSynchro, couleur_bleu);
}

/* Permet de revoque rles droits de l'utilisateur */
DroitCameraOff(integer perm)
{
    // Si il y a des droits de donnés
    if (perm & PERMISSION_CONTROL_CAMERA)
    {
        //debug("deSynchro - révocation des droits");
        llSetCameraParams([CAMERA_ACTIVE, 0]);
        llClearCameraParams();
    }
    couleur(infoSynchro, couleur_rouge);
}

/*         ------   Affichage    ------               */
/*  Gestion de la couleu des prims */
couleur(integer prims, vector couleur)
{
    llSetLinkPrimitiveParamsFast(prims, [PRIM_COLOR, ALL_SIDES, couleur, 1.0]);
}

// Passe les couleurs des caméra en blanc
resetCouleurCamera()
{
    integer nbBouton = (integer) llGetListLength(cameraBouton) /2;
    integer i;
    for(i=1;i<=nbBouton;++i)
        couleur(getBoutonFromCameraIndex(i-1), couleur_blanc);
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
    //debug("recupereInformation() | Idenfifiant "+ (string) indexCamera +"| POS : "+ (string) pos  + " Rot : " +(string) rot ) ;

   setRotation(indexCamera, rot);
   setPosition(indexCamera, pos);

   //debug("getIndexCamFromBouton(indexCamera)" + (string) getBoutonFromCameraIndex(indexCamera));
   couleur(getBoutonFromCameraIndex(indexCamera), couleur_bleu);

}
// Charge la position de la caméra
updateCamera(integer indexCam, integer transition )
{
    debug("Lancement fondu");
    vector pos = getVector(indexCam);
    rotation rot = getRotation(indexCam);
    float tempsFondu = 0;
    veille = 0;
       
    if(transition > 0) 
         tempsFondu =(integer) transition /2;
         
    debug("Lancement du fondu");
            
    /* -- Si fondu au noir -- */
    if (tempsFondu > 0 )
    {
         llSetLinkTextureAnim(1, ANIM_ON , ALL_SIDES, 1, 60, 0, 60, 60/tempsFondu);
         llSleep(tempsFondu-1);
         debug("attente");
    }


    //debug("UpdateCamera() - Position " +(string) pos + " rotation : "+(string) rot );
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
         
    /* -- Si fondu au noir sortie --*/
    if(transition> 0)
    {
        llSleep(0.02);
        llSetLinkTextureAnim(1, ANIM_ON | REVERSE , ALL_SIDES, 1, 60, 0, 60, 60/tempsFondu);
        llSleep(tempsFondu);
    }

    infoCam(indexCam);
}
/* -- En vois un message dans le local avec l'ancienne camera utilsié / Nouvelle -- */
infoCam(integer indexCam)
{
    llRegionSay(channel, "INF_CAM      ON_"+(string) indexCam + "     OFF_"+ (string) camEnCours);

    couleur(getBoutonFromCameraIndex(indexCam), couleur_vert);
    couleur(getBoutonFromCameraIndex(camEnCours), couleur_bleu);
    camEnCours = indexCam;
}

/* -- Convertion de rotation en focus -- */
vector convertionFocus(vector position, rotation camera)
{
    vector rot=llRot2Euler(camera);
    camera = llEuler2Rot(rot);
    return position + offsetCamera*camera;
}

/* --  Set une camera random   -- */
updateRandomCamera()
{
    llSetLinkTextureAnim(1, ANIM_ON , ALL_SIDES, 1, 60, 0, 60, 30);
    integer indexCam = (integer)llFrand(40.0)/2;
    if (indexCam == camEnCours)
        indexCam = (integer)llFrand(40.0)/2;
    integer indexBoutonCam = getBoutonFromCameraIndex(indexCam);
    llSleep(2);
    updateCamera(indexCam,4);
    llSleep(0.5);
    llSetLinkTextureAnim(1, ANIM_ON | REVERSE , ALL_SIDES, 1, 60, 0, 60, 30);
    
}

/* -- Permet de faire une transition sur le mode  -- */
etatManuelStatic(integer indexCam)
{
    updateCamera(indexCam,0);
    veille = 0;
    if(TRUE)
        state manuelStatic;
}

/* -- permet de revenir sur l'état manuel  -- */
etatAutomatique()
{
    if(TRUE)
        state default;
}

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        DroitCameraOn();
        llListen(channel, "", NULL_KEY, "");
        llSleep(1);
        appelInfoUpdate();
        llSetTimerEvent(9);
    }

    listen(integer channel, string name, key id, string message)
    {
         string action = llGetSubString(message, llList2Integer(comPositionInfoAction,0) , llList2Integer(comPositionInfoAction,1));
         string botInfo = llGetSubString(message, llList2Integer(comBotInfo,0) , llList2Integer(comBotInfo,1));

        
         debug((string) botInfo + " - " + ACTION_BOT_CAME);

        /* -- Récupération des données -- */
        if(action == ACTION_GIV_INFO)
        {    
            debug("rentré dans info");
            recupereInformation(message);
        }
        else if (botInfo == ACTION_BOT_CAME || botInfo == ACTION_BOT_MFIX)
        {    
            integer indexCamBot =(integer) llGetSubString(message, llList2Integer(comBotIndexCam,0), llList2Integer(comBotIndexCam,1));
            debug("entré dans cam " + (string) indexCamBot + "chaine : " +  (string) indexCamBot);
            etatManuelStatic(indexCamBot);
        }

    }

    timer()
    {
        updateRandomCamera();
    }

}
state manuelStatic
{
     on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        debug("changement d'etat");
        llListen(channel, "", NULL_KEY, "");
        veille = 0;
        llSetTimerEvent(30);

        debug("Passage en manuel static");
    }

    listen(integer channel, string name, key id, string message)
    {
         string indexCam = getMessageBotInfoIndexCam(message);
         string botOrder = getMessageBotInfo(message);
         
         if(botOrder == ACTION_BOT_CAME)
         {
             updateCamera((integer)indexCam,0);
         }
    }

    timer()
    {
        veille = veille+1;
        
        if (veille => 2 )
            etatAutomatique();
    }
}