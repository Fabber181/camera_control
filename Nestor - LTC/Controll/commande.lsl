// ===================================================================
// utilitaire/Script qui envois les commande simples 
// Nom : Commande 
// Auteur : Fabrice TOUPET
// Doc : Envois les commandes dans le chat local
// ===================================================================

integer chanel = 2830;

// Constante Debug 
integer DEBUG_MODE = TRUE;
integer DEBUG_LOCAL = TRUE;

// Constantes des noms des boutons
string BOUTON_FAST = "FAST";
string BOUTON_SEND = "SEND";
string BOUTON_TEMPLATE_CAM = "CAM_";
string BOUTON_MANUELLE = "CAM_MA";

// Constantes pour la gestion des cameras
integer cameraFastActive = 0;
string cameraEnCour = "-1";

// Message 
string COMMUNICATION_CAM_ACTIVE  = "CAM_ACTIV_CAM_" ;
string COMMUNICATION_CAM_MANUELL = "CAM_AVTIV_MAN"  ;
string COMMUNICATION_BOT         = "CAM_AVTIV_BOT"  ;



// ===================================================== DEBUG =======================================

debug(string methode, string message)
{
    if(DEBUG_MODE == TRUE)
    {
        integer chanel = 0;
        if(DEBUG_LOCAL == FALSE)
            chanel = DEBUG_CHANNEL;

        llSay(chanel, "[control - commande] " + methode + " : " + message);
    }
}

// =========================================== Autres méthodes =========================================

/* -------------------- Gestions des caméras-------------------- */

/* Méthode qui permet de gerrer les paramètres de si la camera est en mode rapide ou non */
gestionCameraRapide()
{
    cameraFastActive = !cameraFastActive;

    // Camera rapide activée
    if (cameraFastActive == TRUE)
        colorBotton("VERT", "FAST");
    // Camera rapide désactivée
    else 
        colorBotton("BLAN", "FAST");

}

/* Méthode qui permet de gerrer l'index de la camera :
- Si mode fast : On envois tous de suite l'index de la camera. 
- Si non       : On stock l'index de la page.  
*/
inscriptionCamera(string codeCam)
{
    //debug("inscription camera", " Inscription de la camera " + codeCam);
    
    // Camera en base
    if ((integer) codeCam > 0 )
        changementCamera((integer) codeCam);
    // Camera Bot
    else if (codeCam == "B1" || codeCam == "B2" || codeCam == "B3" || codeCam == "B4" || codeCam == "B5") 
        changementCameraBot(codeCam);
    // CameraManuelle
    else if (codeCam == "MA")
        changementCameraMan();
}

// ------------- Changement Manuelle ----------------
/* Méthode qui permet de changer la couleur pour la camera manuelle */
changementCameraMan()
{
    colorBotton("ORAN" , BOUTON_MANUELLE);
    llSleep(0.5);
    colorBotton("BLAN" , BOUTON_MANUELLE);
}


// -------------- Changement Bot ------------------------
/* Méthode qui permet de passer sur les camera automatique : 
Prend en compte les index des camera depuis la console */
changementCameraBot(string codeCam)
{
    cameraEnCour = codeCam; 
    envoisBot(llGetSubString(codeCam, 1,2));
    colorBotton("ORAN" , "CAM_"+ cameraEnCour);
    llSleep(0.5);
    colorBotton("BLAN" , "CAM_"+ cameraEnCour);
    debug("changementCameraBot()", "CAM_"+ cameraEnCour);

}

/* Permet d'envoyer la camera avec son index.  */ 
envoisBot(string indexCam)
{
    llRegionSay(chanel, COMMUNICATION_BOT + (string) indexCam);
    //debug("envoisBot()", "Chargement du bot en position " +  indexCam);
}


// ---------------- Changement Camera ------------------
/* Méthode qui permet de changer de camera :
Méthode qui permet d'envoyer la camera d'après le code d'activation de la camera */
changementCamera(integer indexCam)
{
    colorBotton("BLEU" , "CAM_"+ cameraEnCour);
    cameraEnCour = generateurIndexCam(indexCam);
    if (cameraFastActive == TRUE)
        envoisCam();
    colorBotton("VERT" , "CAM_"+ generateurIndexCam((integer) cameraEnCour));
}

/* Méthode qui permet d'envoyer l'identifiant de la caméra */ 
 envoisCam()
 {
    llRegionSay(chanel, "CAM_ACTIV_CAM_" + generateurIndexCam((integer) cameraEnCour)); 
 }

// ================================================= gestion des couleurs ===================================
colorBotton (string couleur , string codeBoutton)
{
   //debug("colorBotton", "couleur " + couleur + " code Bouton " + codeBoutton);
    llMessageLinked(3, 1, couleur + "-" + codeBoutton , llDetectedKey(0));
}

/* Méthode qui permet de générer une couleur  */
string generateurIndexCam(integer indexCam)
{
    string indexCamText = (string) indexCam;
    if (indexCam < 10)
        indexCamText = "0" + indexCamText;
    return indexCamText ;
}
// ================================================= Etats par défauts ===================================
default
{

    link_message( integer sender_num, integer num, string str, key id )
    {
        //llSay(0, str);
        // ==== Gestion des droits
        if(str == "RELOAD")
            llRegionSay(chanel, "REQUEST_CAM_INFO");
            
    } 
    touch_start( integer num_detected )
    {
        // Récuperation de l'uidentifiant du prims touché 
        string bouton = llGetLinkName(llDetectedLinkNumber(0));
        
        // Mise en palce du bouton fast
        if(bouton == BOUTON_FAST)
            gestionCameraRapide();
        else if (bouton == BOUTON_SEND )
            envoisCam();
        else if(llGetSubString(bouton, 0, 3) == "CAM_" )
            inscriptionCamera(llGetSubString(bouton, 4, 5));

    }
}