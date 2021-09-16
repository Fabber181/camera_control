// ===================================================================
// Racine du projet
// Nom : Racine
// Auteur : Fabrice TOUPET
// Doc : Détecte les click et lis le chat local sur le channel 2830 pour 
// Envoyer en link param les informations. 
// ===================================================================


// Variable de debug 
integer DEBUG_ACTIF = 1;
integer DEBUG_CHANNEL_DEBUG = DEBUG_CHANNEL; 

// Constantes pour les noms de boutons
string BOUTON_FAST = "FAST";

// Gestion du cameraFast 
integer CAMERA_FAST_ACTIF = 0;
integer CAMERA_EN_SELECTION = 0;


// EGestion des communications
integer listen_handle;
integer chanel_ecoute = 2830;

// ======================================= DEBUG =========================== 
debug (string methode, string message)
{
    if (DEBUG_ACTIF == TRUE)
    {
        llSay(DEBUG_CHANNEL_DEBUG, "[Racine] " + methode + " : ");
    }
}

// =================================== COMMUNICATION =========================== 

/* Permet de generrer les écouturs.*/
ecouteurClick()
{
    string linkName = llGetLinkName(llDetectedLinkNumber(0));

    llMessageLinked(LINK_THIS, 0, linkName ,llDetectedKey(0));

    // Si c'est le reaload on relance les couleurs
    if(linkName == "RELOAD")
    {
        llMessageLinked(3, 2, linkName ,llDetectedKey(0));   
    }
}

/* Permet d'écouter les ordres en local */
ecouteurChat(string message)
{
      llMessageLinked(LINK_THIS, 0, message ,llDetectedKey(0));
}

// ========================================================================================================
// ----------------------------- Etat par défaut -------------------------------------------------------
// ========================================================================================================
default
{
    state_entry()
    {
        listen_handle = llListen(chanel_ecoute, "", NULL_KEY, "");
    }
    touch_start(integer num_detected)
    {
        ecouteurClick();
    }
    listen( integer channel, string name, key id, string message )
    {
        ecouteurChat(message);
    }
}
