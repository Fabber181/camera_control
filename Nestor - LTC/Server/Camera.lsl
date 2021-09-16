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

/* - Suppression - */
integer activationSuppression = FALSE;

/* - Data - */
string dataNotecard = "data_cam";
integer dataIndexLecture;
integer dataTaille;
key dataKeyNotecard;
key dataKeyRequete;

list listCameraInfo = [
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 0
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 1
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 2
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 3
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 4
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 5
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 6
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 7
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 8
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 9
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 10
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 11
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 12
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 13
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 14
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 15
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 16
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 17
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 18
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 19
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 20
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 21
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 22
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 23
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 24
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 25
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 26
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 27
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 28
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 29
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 30
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 31
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 32
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 33
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 34
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 35
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 36
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 37
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 38
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 39
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 40
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 41
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 42
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 43
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 44
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 45
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 46
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 47
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>, // Camera 48
    <0.0,0.0,0.0> , <0.0,0.0,0.0,0.0>  // Camera 49
];

/* !!! Méthode de debug !!! */
debug(string message)
{
    integer canal = CANAL_DEBUG;
    if(DEBUG_LOCAL == TRUE)
        canal = 0;

    if(DEBUG == TRUE)
        llSay(canal, message);
}

setColor(string color, string element)
{
     llMessageLinked(LINK_THIS, 1,  color +"_"+element ,llDetectedKey(0));
}
// ====================================== Get et set ===========================

// --                                Méthodes Get 

// --                                Méthodes Set 

// ==================================== Autres méthode ============================
 /* -- Méthode qui renvois les position des cameras -- */
 lectureListCam()
 {
     debug("Lancement du chargement des données    blop ? ");
    integer listCameraLength = llGetListLength(listCameraInfo);

    if(listCameraLength>0)
    {
        integer i =0 ;
        integer listCameraInfoIndex = 0;
        integer listCameraNbCam = listCameraLength/2;
        debug("Je suis ici i" + (string) i + " listCameraInfoIndex - " + (string) listCameraInfoIndex + " Nombre de camera - " + (string) listCameraNbCam);
        debug(llDumpList2String(listCameraInfo, " | "));
        for(i=0;i <=listCameraNbCam;i++)
        {
            listCameraInfoIndex = i*2;
            vector positionCamera = llList2Vector(listCameraInfo, listCameraInfoIndex);
            rotation rotationCamera = llList2Rot(listCameraInfo, listCameraInfoIndex +1);
            string indexCamText = (string) i;

            // Génération de l'index de la camera
            if(i<10)
                indexCamText  = "0" + indexCamText;
            
            //debug("Chargement de la camera en indentifiat - " + (string) i + " pour l'index " + (string) listCameraInfoIndex + " Position " + (string) positionCamera + " rotation camera " + (string) rotationCamera);
            //debug ("Camera - list camera info " + llDumpList2String(listCameraInfo, "-"));
            if(positionCamera.z != 0)
            {
                // Generation de la requête 
                string requete = "CAM_" + indexCamText + "_GIV_INFO P1 " +(string) positionCamera + "                        R1 " + (string) rotationCamera;

                llSleep(0.25);
                debug(requete);
                llRegionSay(CANAL_INFORMATION, requete);
            }
        }
    }
 }


/* Récupère les données de la notecard pour les charger dans la liste */
telechargementNotecard()
{
    debug("Chargement des données");
    setColor("ZERO", "");
    dataIndexLecture =0;
    dataKeyNotecard = llGetNumberOfNotecardLines(dataNotecard);
}

recuperationInformations(string message)
{
    if (message != "")
    {

        integer messageIndexIde = llSubStringIndex(message, "SVG_CAM_") + 8;
        integer messageIndexPos = llSubStringIndex(message, "P1") + 3;
        integer messageIndexRot = llSubStringIndex(message, "R1") + 3;
        
        integer cameraId = (integer) llGetSubString(message, messageIndexIde, messageIndexIde+1);
        vector cameraPosition = (vector) llGetSubString(message, messageIndexPos, messageIndexPos+40);
        rotation cameraRotation = (rotation) llGetSubString(message, messageIndexRot, messageIndexRot+60);

        //debug("camera - resultat : Id Camera " + (string) cameraId + " Index message position : " + (string) messageIndexPos + " Index message rotation : " + (string) messageIndexRot +
        //     "\n Donnée de position : " + (string) cameraPosition + "Donnée de rotation : " + (string) cameraRotation) ; 

        integer listCameraInfoIndex = cameraId * 2;
        listCameraInfo = llListReplaceList(listCameraInfo, [cameraPosition, cameraRotation], listCameraInfoIndex, listCameraInfoIndex+1);

        if (cameraPosition.z != 0)
        {
            string idIndexCam = (string)cameraId;
            if(cameraId < 10)
                idIndexCam = "0" + idIndexCam;

            debug("Chargement de la couleur sur "+ "CAM_"+idIndexCam);
            setColor("BLEU", "CAM_"+idIndexCam);
        }
    }
}

miseAjourCamera(string message)
{
    integer messageIndexIde = llSubStringIndex(message, "UPD_CAM_") + 8;
    integer messageIndexPos = llSubStringIndex(message, "P1") + 3;
    integer messageIndexRot = llSubStringIndex(message, "R1") + 3;
    
    integer cameraId = (integer) llGetSubString(message, messageIndexIde, messageIndexIde+1);
    vector cameraPosition = (vector) llGetSubString(message, messageIndexPos, messageIndexPos+40);
    rotation cameraRotation = (rotation) llGetSubString(message, messageIndexRot, messageIndexRot+60);

    debug("camera - resultat : Id Camera " + (string) cameraId + " Index message position : " + (string) messageIndexPos + " Index message rotation : " + (string) messageIndexRot +
             "\n Donnée de position : " + (string) cameraPosition + "Donnée de rotation : " + (string) cameraRotation) ; 

    integer listCameraInfoIndex = cameraId * 2;
    listCameraInfo = llListReplaceList(listCameraInfo, [cameraPosition, cameraRotation], listCameraInfoIndex, listCameraInfoIndex+1);

     if (cameraPosition.z != 0)
        {
            string idIndexCam = (string)cameraId;
            if(cameraId < 10)
                idIndexCam = "0" + idIndexCam;

            debug("Chargement de la couleur sur "+ "CAM_"+idIndexCam);
            setColor("ROUG", "CAM_"+idIndexCam);
        }
}

/* Programe de sauvegarde pour la noce */
sauvegarde()
{
    integer indexListCam;
    float nbCam = llGetListLength(listCameraInfo)/2;

    debug("Sauvegard - Lacement de la sauvegarde avec "+ (string) nbCam + " éléments");   

    for (indexListCam=0; indexListCam <= nbCam; indexListCam++)
    {
        string textIndexCam = (string) indexListCam;
        integer listCameraInfoIndex = indexListCam*2;
        
        if(indexListCam < 10)
            textIndexCam = "0" + textIndexCam;

        llSay(0, "SVG_CAM_" + textIndexCam + "  P1 " + llList2String(listCameraInfo, listCameraInfoIndex) + "                                        R1 " + llList2String(listCameraInfo, listCameraInfoIndex+1));
    }
}

ouvertureSuppression(integer active)
{
    if(active == TRUE)
    {
        activationSuppression = TRUE;
        setColor("ROUG", "BIN");
        //debug("activation de la suppression");
    }
    else 
    {
        activationSuppression = FALSE;
        setColor("BLAN", "BIN");
    }
}

suppression(integer cameraIndex)
{
    debug("Suppression de la camera " + (string) cameraIndex);
    integer listIndex = cameraIndex*2;
    listCameraInfo = llListReplaceList(listCameraInfo, ["<0.0,0.0,0.0>", "<0.0,0.0,0.0,0.0>"], listIndex, listIndex+1);

    string indexTextCamera = (string) cameraIndex;
    if(cameraIndex <10)
        indexTextCamera = "0" + indexTextCamera;

    setColor("BLAN", "CAM_" + indexTextCamera);
    setColor("BLAN", "BIN");
    activationSuppression = FALSE;
}

default
{
   link_message( integer sender_num, integer num, string str, key id )
   {
       // Ecouteur sur les boutons
       if(num == 0)
       {    
            if (activationSuppression == TRUE)
            {
                if (llGetSubString(str, 0, 2) == "CAM")
                   suppression((integer) llGetSubString(str, 4, 5));
            }

           //debug("Pression de bouton sur " + str + " En position " + (string) num);
            if(str == "RELOAD")
                telechargementNotecard();
            else if(str == "SAVE")
                sauvegarde();
            else if (str == "BIN")
                ouvertureSuppression(!activationSuppression);
       }
 
       // Ecouteur dans le chat
       if (num == 5)
       {
           // Si mise à jours de la base de donnée
           integer updateCam = llSubStringIndex(str, "UPD_CAM");
           if(updateCam >= 0)
           {
                miseAjourCamera(str);
                return;
           }

           integer requeteData = llSubStringIndex(str, "REQUEST_CAM_INFO");
           if(requeteData >=0)
           {
               lectureListCam();
               return;
           }
            
       }
   }
   dataserver(key requested, string data)
    {
        if(requested == dataKeyNotecard)
        {
            dataTaille = (integer)data;
            dataKeyRequete = llGetNotecardLine(dataNotecard,dataIndexLecture);
            return;
        }
        else if ( requested != dataKeyRequete)
        {
            return;
        }

         recuperationInformations(data);

         if(dataIndexLecture <= dataTaille)
         {
             dataKeyRequete =  llGetNotecardLine(dataNotecard,dataIndexLecture++);
         }
         else
         {
             debug("Racine - sortie de boucle");
             return;
         }

    }
    changed( integer change )
    {
        if(change & CHANGED_INVENTORY)
        {
            telechargementNotecard();
        }
    }
}
