// ===================================================================
// Racine du projet
// Nom : Camera
// Auteur : Fabrice TOUPET
// Doc : Garde en mémoire et fait toute les actions liés aux droits des 
// Camera. 
// ===================================================================


/* ---- Constantes  --------------*/ 
// Constante Debug 
integer DEBUG_MODE = TRUE;
integer DEBUG_LOCAL = TRUE;
integer DEBUG_CHANEL = 930;

// Canal d'information
integer CANNAL_INFO = 2830;

// Gestion des ajout
integer ajoutCamera = FALSE;

// Mémoire de spositions de camera
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
vector offsetCamera = <1.0000,0.0000,0.0000>; // Calcul de l'offset


// ===================================================== DEBUG =======================================

debug(string message)
{
    if(DEBUG_MODE == TRUE)
    {
        integer chanel = 0;
        if(DEBUG_LOCAL == FALSE)
            chanel = DEBUG_CHANEL;

        llSay(chanel, message);
    }
}

// ================================================= getter et setter ===================================

/* ---------------------------------------------------- SET ---------------------------------------------
/* Set les positions et les rotation dans la base de donnée*/
setPositionRotation(integer indexCamera, vector positionCam, rotation rotationCam)
{
    // Mise à jours des rotation
    integer indexListCamerParam = indexCamera*2;
    cameraParams = llListReplaceList(cameraParams, [positionCam], indexListCamerParam, indexListCamerParam);
    // Mise à jours des positions
    cameraParams = llListReplaceList(cameraParams, [rotationCam], indexListCamerParam +1, indexListCamerParam +1);
}

/* -- chargement des data envoyés par les cameraw -- */
chargementBdCam(string message)
{
    integer indexCam = (integer) llGetSubString(message, 4, 6);
    vector posCamera = (vector) llGetSubString(message, 19, 53);

    integer carracterRotation = llSubStringIndex(message, "R1") + 3;
    rotation rotationCamera = (rotation) llGetSubString(message, carracterRotation, carracterRotation+60);

    setPositionRotation(indexCam, posCamera, rotationCamera);
    //debug("Extraction des données : \n - index camera " + (string) indexCam + "\n -  Position - " + (string) posCamera + "\n -  rotation" + (string) rotationCamera);
    setColor("BLEU", getNomCamera(indexCam));
}

/* -- Méthode qui permet de gerre la couleur des prims --*/
setColor(string color, string element)
{
     llMessageLinked(3, 1,  color +"_"+element ,llDetectedKey(0));
}

/* -- Remplacement de la position de la camera -- */
setCameraParam(integer indexCamera)
{
    //debug("Lancement de l'index de camera " + (string) indexCamera);
    list positionRotation = getPositionRotation(indexCamera);
    //debug(llDumpList2String(positionRotation, "-"));
    
     llSetCameraParams([
        CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 0.0, // ( 0.5 to 10) meters
        CAMERA_FOCUS, convertionFocus(llList2Vector(positionRotation, 0), llList2Rot(positionRotation, 1)), // region relative position
        CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, TRUE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        //CAMERA_PITCH, 80.0, // (-45 to 80) degrees
        CAMERA_POSITION, llList2Vector(positionRotation, 0), // region relative position
        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, TRUE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, ZERO_VECTOR // <-10,-10,-10> to <10,10,10> meters
        ]);

}

vector convertionFocus(vector position, rotation camera)
{
    vector rot=llRot2Euler(camera);
    camera = llEuler2Rot(rot);
    return position + offsetCamera*camera;
}

/* ---------------------------------------------------- GET --------------------------------------------- */

/* Méthode qui permet de génerer l'identifiant de la camera*/
string getNomCamera(integer indexCam)
{
    string suiteCamera = (string) indexCam;
    if (indexCam <10)
        suiteCamera = "0"+suiteCamera;
    return "CAM_" + suiteCamera;
}

/* Méthode qui permet de retourner la position et la rotation de la camera*/
list getPositionRotation(integer indexCam)
{
    integer indexInformation = indexCam *2;
    //debug("Camera - getPositionRotation  - Positition"+  (string) llList2Vector(cameraParams, indexInformation) + " rotation " + (string) llList2Rot(cameraParams, indexInformation+1));
    //debug(llDumpList2String(cameraParams ,  " - "));

    return [llList2Vector(cameraParams, indexInformation), llList2Rot(cameraParams, indexInformation+1)];
}
// ================================================= Autres méthodes ===================================

/* Méthode qui permet de prendre les droit si ils ne sont pas pris */
ouvertureDroit()
{
    llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA | PERMISSION_TRACK_CAMERA);
    llSetCameraParams([CAMERA_ACTIVE, 1]);
}

/* Méthode qui permet de fermer les droits
Note : Pour révoquer les droit ou prend de nouvelles permissions. 
 */
fermetureDroit()
{
    llSetCameraParams([CAMERA_ACTIVE, 0]);
    llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
    llClearCameraParams();
    //debug("Revocation des droits");
}

/* -- Méthode qui permet d'ajouter une camera au serveur --  */
sauvegardeCamera()
{
    ajoutCamera = !ajoutCamera;
    //debug("Ajout de camera" + (string) ajoutCamera);

    if (ajoutCamera == TRUE)
    {
        setColor("ROUG", "SAVE_CAM");
    }
    else
    {
        setColor("BLAN", "SAVE_CAM");
    }
}

/* - Méthode qui envois la position de la camera - */
envoisPositionCam(integer indexCam)
{
    ajoutCamera =FALSE;

    string stringIndexCam = (string) indexCam;
    if(indexCam < 10)
        stringIndexCam = "0" + stringIndexCam;
    
    //debug("UPD_CAM_" + stringIndexCam + "  P1 "  + (string) llGetCameraPos() + "                     R1 " + (string) llGetCameraRot());
    llRegionSay(CANNAL_INFO, "UPD_CAM_" + stringIndexCam + "  P1 "  + (string) llGetCameraPos() + "                     R1 " + (string) llGetCameraRot());
    setColor("BLAN", "SAVE_CAM");
}

envoisCameraMan()
{
    llRegionSay(CANNAL_INFO, "CAM_ACTIV_MAN  P1 "  + (string) llGetCameraPos() + "                     R1 " + (string) llGetCameraRot());
}


// ================================================= gestion des couleurs ===================================
resetColorCam()
{
    llMessageLinked(LINK_THIS, 0, "COLOR_RESET",llDetectedKey(0));
}

colorBotton (string couleur , string codeBoutton)
{
     llMessageLinked(LINK_THIS, 0, couleur + "-" + codeBoutton ,llDetectedKey(0));
}

// ==================================================================================================================================
// ------------------------- Etat par défaut -------------------------
// =========================================================================================

default
{
    state_entry()
    {
        //debug( "Initialisation");
    }

    link_message( integer sender_num, integer num, string str, key id )
    {
        string sousTraitement = llGetSubString(str, 7, 14);
        //debug("Camera - Parametrage - " + sousTraitement + " str - "+ str);


        if(num == 0)
        {
            if (ajoutCamera == FALSE)
            {
                // Quand on sélectionne une des camera
                if(llGetSubString(str, 0, 2) == "CAM" && sousTraitement != "GIV_INFO" && str != "CAM_MA")
                    setCameraParam((integer) llGetSubString(str, 4, 5));
                // Ouverture des droits
                else if(str == "GET_RIGHT")
                    ouvertureDroit();
                // Libréation des droits
                else if (str == "RELEASE")
                    fermetureDroit();
                // Prise en compte des informations
                else if (sousTraitement == "GIV_INFO")
                    chargementBdCam(str);
                else if (str == "SAVE_CAM")
                    sauvegardeCamera();
                else if (str == "CAM_MA")
                    envoisCameraMan();
            }

            if(ajoutCamera == TRUE)
            {
                string sousTraitementCamera = llGetSubString(str,0,2);

                //debug("Sous traitement Camera" + sousTraitementCamera);
                // Si c'est une camra
                if (sousTraitementCamera == "CAM")
                {
                    debug("Modification de la camera" + (string) llGetSubString(str, 4, 5));
                    envoisPositionCam((integer) llGetSubString(str, 4, 5));
                }
            }
        }
            
    }

    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_CONTROL_CAMERA && PERMISSION_TRACK_CAMERA)
        {
           // debug("[Control] Ouvert");
            setColor("VERT", "GET_RIGHT");
        }
        else
            setColor("ROUG", "GET_RIGHT");

    }
}

 
