// ######################################################
// Camera
//
// A faire :
// - Gestion de la numerotaiton de la camera
// - chat :
//         - Si recoit un message "UPDATE_CAM" envois sa position et sa rotation sous a forme suivante : CAM_UPDATE %id% %position% %Vecteur%
//         - Si recoit un message FILMING_CAM_%id% Passe en rouge si l'ID correspond à la numérotation de la camera, sinon, elle passe en vert

// ###############################################
// Constantes
// ##############################################
list nombre =
    [0.43999,//0
     -0.44998,//1
     -0.36989,//2
     -0.26979,//3
     -0.16967,//4
     -0.06959,//5
     0.03051,//6
     0.14062,//7
     0.23071,//8
     0.33081];//9
integer indexCam;
integer indexCamMax = 9;
integer indexCamMin = 0;

// ##########################################
// Fonctions
// #########################################
updateNumber()
{
    llSetLinkPrimitiveParams( 3, [ PRIM_TEXTURE, ALL_SIDES, "2b64590b-8827-a506-b50e-8dc272ae6af8", <0.1, 0.5, 0.0>, <llList2Float(nombre, indexCam), 0.19999, 0.0>, 0 ]);
}

default
{
    state_entry()
    {
        indexCam = 0;
        updateNumber();
    }
    touch_start(integer num_detected)
    {
        integer touchPrim = llDetectedLinkNumber(0);
        // Si la caméra est touchée
        if (touchPrim=2)
        {
            integer touchFace = llDetectedTouchFace(0);
            // SI bouton plus touché
            if (touchFace == 5)
            {
                if (indexCam<indexCamMax)
                     indexCam = indexCam +1;
                updateNumber();
            }
            // Si bouton - touché
            else if (touchFace == 1)
            {
            	if (indexCam>0)
               		indexCam = indexCam -1;
                updateNumber();
            }
        }
    }
}