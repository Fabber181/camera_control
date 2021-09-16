// #######################################################################################
// Script utilsié pour le chargement des position de caméra 
// -------------------------------------------------------------
// Les position de caméras sont stockés dans une notecard pour être ensuite mise dans une list

// ==================================== Constantes =========================

/* - Debug - */
integer DEBUG = FALSE;
integer DEBUG_LOCAL = TRUE;

/* - Communication - */
integer CANAL_INFORMATION = 2830;
integer CANAL_DEBUG  = 930;
integer CANAL_ECOUTEUR_INFO;

/* !!! Méthode de debug !!! */
debug(string message)
{
    integer canal = CANAL_DEBUG;
    if(DEBUG_LOCAL == TRUE)
        canal = 0;

    if(DEBUG == TRUE)
        llSay(canal, message);
}
// ====================================== Get et set ===========================

// --                                Méthodes Get 

// --                                Méthodes Set 

// ==================================== Autres méthode ============================
propagationEcouteur(string message)
{
    llMessageLinked(LINK_THIS, 0, message ,llDetectedKey(0));
}

lancementCommande(string message)
{
    debug("Racine - Partage du chat " + message);
    llMessageLinked(LINK_THIS,5,message,llDetectedKey(0));
}

default
{
    state_entry()
    {
        llListen(CANAL_INFORMATION, "", NULL_KEY, "");
    }
   touch_start( integer num_detected )
   {
       if(llDetectedKey(0) == llGetOwner())
       {
          propagationEcouteur(llGetLinkName(llDetectedLinkNumber(0)));
       }
   }
   listen( integer channel, string name, key id, string message )
   {
      lancementCommande(message);
   }
}
