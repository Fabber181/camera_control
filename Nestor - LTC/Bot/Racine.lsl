// #################################################################################################################################################################
// Sript de mise en place du bot 
// =================================================================================================================================================================
// name : Racine
// Description : Ce script prend le controle du bot et affiche la camera en fonction de la camera. 
// il atend vers le script de degradé pour animer le dégrader en cas de camera bot
// #################################################################################################################################################################

// ================= Constantes =================

/* -------------------- Debug ------------------- */ 
integer DEBUG_ACTIVE = TRUE;     // Permet de savoir si le debug ets actif
integer DEBUG_TO_OWNER = TRUE;  // Permet d'envoyer les messages au owner
integer DEBUG_CHANEL = 0;        // Channel de debug

/* ------------------ Cannaux ------------------- */ 
integer CANNAL_ECOUTE;
integer CANNAL_INFO = 2830;     // Cannal d'information

/* --------------- Commandes  --------- */ 
string COMMANDE_UPDATE_CAM = "REQUEST_CAM_INFO";
string COMMANDE_UPDATE_CAM_INFO = "GIV_INFO";
string COMMANDE_CAM_ACTIV = "CAM_ACTIV_CAM_";
string COMMANDE_CAM_MAN = "CAM_ACTIV_MAN";
string COMMANDE_CAM_BOT = "CAM_AVTIV_BOT";

/* --------------- Bot Cam ------------ */
list BOT_1_LIST_CAM = [31 , 32 , 33 , 34 , 35 ];
list BOT_2_LIST_CAM = [36 , 37 , 38 , 39 , 40 ];
list BOT_CAM_EN_COUR = [-1];
integer BOT_LAST_CAM = -1;
integer BOT_NB_CAM = 1;
integer BOT_ACTIVE = FALSE;


/* -------------------- Camera ------------------- */ 
vector cameraOffset = <1.0000,0.0000,0.0000>; // Calcul de l'offset
list cameraListParams = [
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
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 20
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 21
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 22
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 23
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 24
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 25
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 26
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 27
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 28
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 29
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 30
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 31
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 32
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 33
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 34
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 35
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 36
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 37
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 38
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 39
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 40
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 41
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 42
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 43
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>, // Cam 44
    <0.0, 0.0, 0.0>, <0.0,0.0,0.0,0.0>  // Cam 45
];

// ================ Fonctions ==================

/* ------------------- Debug ------------------- */
/* Fonction de debug : Le debug est seulement activé si le mdoe debug est actif */
debug(string methode, string message)
{
    string info =  "/me - [Racine] - " + methode + " : " + message ;
    if(DEBUG_ACTIVE == TRUE)
    {
        if (DEBUG_TO_OWNER == TRUE)
            llOwnerSay(info);
        else
            llSay(DEBUG_CHANEL, info);
    }
}


/* ----------------- Camera Mise à jour ------------------ */
/* Méthode qui lance la commande sur le serveur pour lancer la mise à jour */
sendCameraUpdate()
{
    llRegionSay(CANNAL_INFO, COMMANDE_UPDATE_CAM);
}

/* Méthode qui à partir du message des positions de caméra prend en compte les 
positions des camera*/
setCameraData(string code)
{
    integer indexCamera = (integer) llGetSubString(code, 4, 5);
    integer indexList = indexCamera *2;
    list cameraPositionRotation = extrairePositionRotation(code);

    debug("setCameraData",  "Informations de camera : " + 
        "\n  - Index Camera : " +  llGetSubString(code, 4, 5) + 
        "\n  - Position de camera : " + llList2String(cameraPositionRotation, 0) + 
        "\n  - Rotation de camera : " + llList2String(cameraPositionRotation, 1));

    cameraListParams = llListReplaceList(cameraListParams, [llList2Vector(cameraPositionRotation,0), llList2Rot(cameraPositionRotation,1)], indexList, indexList+1);
} 

/* Méthode qui extrait la position et la rotation du code de position */
list extrairePositionRotation(string code)
{
    integer indexPosition = llSubStringIndex(code, "P1") + 3;
    integer indexRotation = llSubStringIndex(code, "R1") + 3;

    return [(vector) llGetSubString(code, indexPosition, indexPosition+ 40), (rotation) llGetSubString(code, indexRotation, indexRotation+ 45)];
}

/* ----------------- Camera position depuis la liste  ------------------ */


/* ------------------- Gestions de droit ------------------- */
/* Cette méthode permet de setter les droit si il ne sont pas setté. */ 
getDroitCamera()
{
    llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA | PERMISSION_TRACK_CAMERA);
    llSetCameraParams([CAMERA_ACTIVE, 1]);
}

// ================ Camera ==================================
/* ------------ Gestion camera List --------------- */ 
/* gestion de la camera depuis la camera list */
activerCamera(string code)
{
    integer codeIndex = llStringLength(COMMANDE_CAM_ACTIV);
    //debug("activerCamera()", "Index de la camera : " + (string) llGetSubString(code, codeIndex, codeIndex+1));
    
    integer indexCamera = (integer) llGetSubString(code, codeIndex, codeIndex+1);
    setPositionRotationCameraList(indexCamera);
    llSetTimerEvent(0);
}

/* ------------ Gestion camera man --------------- */ 
/* Permet de gerre la position de la camera manuelle */ 
activerCameraManuelle(string code)
{
    list cameraPositionRotation = extrairePositionRotation(code);
    setPositionRotationCamera(llList2Vector(cameraPositionRotation,0) , llList2Rot(cameraPositionRotation,1));
    llSetTimerEvent(0);
}

/* ------------ Gestion camera bot --------------- */ 
/* Camera qui active le bot */
activerCameraBot(string code)
{
    integer codeIndex = llStringLength(COMMANDE_CAM_BOT);
    integer indexBot = (integer) llGetSubString(code, codeIndex, codeIndex);
    //debug("activerCameraBot", "Activation du bot en activation de " + llGetSubString(code, codeIndex, codeIndex));
    
    BOT_ACTIVE = 1;
    if(indexBot == 1)
        BOT_CAM_EN_COUR = BOT_1_LIST_CAM;
    else if(indexBot == 2)
        BOT_CAM_EN_COUR = BOT_2_LIST_CAM;
    BOT_NB_CAM = llGetListLength(BOT_CAM_EN_COUR)  - 1 ;
    BOT_LAST_CAM = -1;
    setRandomCamera();
    llSetTimerEvent(12);
}

/* Met une camera random */ 
setRandomCamera()
{
    BOT_LAST_CAM++;
    if(BOT_LAST_CAM > BOT_NB_CAM)
        BOT_LAST_CAM = 0;

    llSetLinkTextureAnim(2, ANIM_ON , ALL_SIDES, 1, 120, 0, 120, 45);
    llSleep(4);
    setPositionRotationCameraList(llList2Integer(BOT_CAM_EN_COUR, BOT_LAST_CAM));
    llSetLinkTextureAnim(2, ANIM_ON | REVERSE , ALL_SIDES, 1, 120, 0, 120, 40);
}

/* --------------- Utilitaire ------------------ */
/* Méthode qui récupère les position des camera dans la list */
setPositionRotationCameraList(integer indexCamera)
{
    vector pos = llList2Vector(cameraListParams, indexCamera*2);
    rotation rot = llList2Rot(cameraListParams, (indexCamera*2) +1);

    setPositionRotationCamera(pos, rot);
}

/* Méthode qui permet de setter la position de la camera */
setPositionRotationCamera(vector pos, rotation rot)
{
     llSetCameraParams([
        CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 0.0, // ( 0.5 to 10) meters
        CAMERA_FOCUS, convertionFocus(pos, rot),
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

/* Méthode qui permet de calculer le focus */
vector convertionFocus(vector pos, rotation camera)
{
    vector rot=llRot2Euler(camera);
    camera = llEuler2Rot(rot);
    return pos + cameraOffset*camera;
}

fadein()
{

}

// ================= Etats =====================
/* ----- Etat par défaut -----*/
default
{
    state_entry()
    {
        getDroitCamera();
        sendCameraUpdate();
        CANNAL_ECOUTE = llListen(CANNAL_INFO, "", NULL_KEY, "");
    }

    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_CONTROL_CAMERA && PERMISSION_TRACK_CAMERA)
           debug("run_time_permissions", "Ouverture des droits");
        else   
            debug("run_time_permissions", "Droit refulsé");
    }

    listen( integer channel, string name, key id, string message )
    {
        //debug("listen", "Ecouteur remonte : " + message + " code comparer " + COMMANDE_CAM_ACTIV  + " l'index renvois : " + (string) llSubStringIndex(message, COMMANDE_CAM_ACTIV)  );

        // Set position Camera (depuis la list d'info)
        if(llSubStringIndex(message, COMMANDE_CAM_ACTIV) >= 0 )
            activerCamera(message);
        // set position manuelle
        else if(llSubStringIndex(message, COMMANDE_CAM_MAN) >= 0)
            activerCameraManuelle(message);
        // Set camera bot
        else if (llSubStringIndex(message, COMMANDE_CAM_BOT) >= 0)
            activerCameraBot(message);
        // Mise à jours camera
        else if (llSubStringIndex(message, COMMANDE_UPDATE_CAM_INFO) >= 0)
            setCameraData(message);
        
    
    }

    timer()
    {
        debug("timer()", "Lancgement du log");
        setRandomCamera();
    }

    on_rez( integer start_param)
    {
        llResetScript();
    }
}
