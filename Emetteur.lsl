// ======================================================
// Constantes
// ======================================================
    integer modeDebug = TRUE;
    integer modeInfo = TRUE;
    // -- Identifiant des boutons
    // Synchro on
    integer boutonSynchro = 24;
    integer boutonDeSyncrho = 29;
    integer boutonTestCam = 25;
    integer boutonTesCam2 = 27;
    integer infoSynchro = 28;
    
    // Couleur
    vector couleur_bleu = <0.000, 0.455, 0.851>;
    vector couleur_rouge = 	<1.000, 0.255, 0.212>;
    vector couleur_vert = <0.180, 0.800, 0.251> ;
    

// - debug
debug(string message)
{
    if (modeDebug = TRUE)
    {
        llOwnerSay("/me [Debug] - " + message);
    }
}

info(string message)
{
    if (modeInfo)
    {
        llOwnerSay("/me [Info] - " + message
        );
    }
}

// =============================================
// Fonction
// =============================================

// Resset
/* Fonction qui permet de réinitilialise rl'affichage
*/
reset()
{
     couleur(infoSynchro, couleur_rouge); 
}

// --------------- Synchro
/* Fonction qui permet de donner les droits de la caméra au HD */
synchro(integer perm)
{
	// Gestion des droits de la camera
	if (perm & PERMISSION_CONTROL_CAMERA)
		debug("PERMISSION_CONTROL_CAMERA - Vous avez déjà les droit");
	else
		llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA);
	
	// Gestion des droits de tracking de la camera
	if (perm & PERMISSION_TRACK_CAMERA)
		debug("PERMISSION_TRACK_CAMERA - Vous avez déjà les droit");
	else
		llRequestPermissions(llGetOwner(), PERMISSION_TRACK_CAMERA);
}

/* Permet de revoque rles droits de l'utilisateur */
deSynchro(integer perm)
{
    if (perm & PERMISSION_CONTROL_CAMERA)
    {
    	debug("deSynchro - révocation des droits");
   	 	llSetCameraParams([CAMERA_ACTIVE, 0]);
    	llClearCameraParams();
    }
    else 
    	debug("deSynchro - Droit déjà révoqués");
    couleur(infoSynchro, couleur_rouge);    
}

/* --- Couleur -- */
couleur(integer prims, vector couleur)
{
	llSetLinkPrimitiveParams(prims, [PRIM_COLOR, ALL_SIDES, couleur, 1.0]);
}

testCamera(integer perms)
{
    if ( perms & PERMISSION_CONTROL_CAMERA )
    {
            debug(" fonction  testCamera - Droit valides");
    }
}

testCamera2(integer perms)
{
    if ( perms & PERMISSION_CONTROL_CAMERA)
    {
             debug(" fonction  testCamera 2 - Droit valides");
    }
}


default
{
    state_entry()
    {
        info("Reset - script");
        reset();
    }

    touch_start(integer total_number)
    {
        integer touchedButton = llDetectedLinkNumber(0);
        integer perm = llGetPermissions();

        //debug("Touched -" + (string) touchedButton);
        if (touchedButton == boutonSynchro)// --------------Synchro
        {
            synchro(perm);
        }
        else if (touchedButton == boutonDeSyncrho)// ------Désynchro
        {
            deSynchro(perm);

        }
        else if (touchedButton == boutonTestCam) // ------Cam 1
        {
            testCamera(perm);
        }
        else if (touchedButton == boutonTesCam2)// ------- cam 2
        {
        	testCamera2(perm);
        }
    }
     run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_CONTROL_CAMERA)
        {
             debug("run_time_permissions - PERMISSION_CONTROL_CAMERA : OK"+(string) perm);
             couleur(infoSynchro, couleur_vert);
        }
        if (perm & PERMISSION_TRACK_CAMERA)
        {
        	debug("run_time_permissions - PERMISSION_TRACK_CAMERA : OK"+(string) perm);
        	couleur(infoSynchro, couleur_vert);
        }
    }
}