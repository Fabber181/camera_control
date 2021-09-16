// ####################################################################################################
// ------------------------------ Gestion de la couleur -----------------------------------------------
 // ####################################################################################################

list listCouleur = [
    "BLAN", <1.0,1.0,1.0>,
    "BLEU" , <0.000, 0.455, 0.851>,
    "VERT" , <0.180, 0.800, 0.251>,
    "ROUG" , <1.000, 0.255, 0.212>
];

list listElements  = [];

setCouleur(string couleur, string prim)
{
    integer idPrim = llListFindList(listElements, [prim]);
    integer indexCouleur = llListFindList(listCouleur, [couleur]) +1;
    vector couleurRechercher = llList2Vector(listCouleur, indexCouleur);
    //llSay(0, "COuleur recherchée " + couleur + "| ID" + (string) indexCouleur);

    if (indexCouleur != -1 && idPrim != -1)
    {
        //llSay(0, "Mise en place de la couleur sur idPrim " + (string) idPrim + " La couleur " + (string) couleurRechercher);
        llSetLinkColor(idPrim, couleurRechercher, 4);
    }

}

/* -- Méthode qui permet d'initialiser la gestion des couleurs  -- */
initialiser()
{
    integer i;
    integer nbPrim =  llGetNumberOfPrims();
    list elementAjout;

    for (i=0; i <= nbPrim; i++)
    {
        listElements = listElements +  [llGetLinkName(i)];
        llSay(0, "Ajout de l'élément - " + (string) i + " - Nom " + llGetLinkName(i) ) ;
    }
}

/* -- Méthode qui permet de remètre à 0 la couleur des caméra -- */
remiseZeroCouleur()
{
    integer i;
    integer nbPrim = llGetListLength(listElements);
    integer indexCouleur = llListFindList(listCouleur, ["BLAN"]) +1;
    vector couleurBlanc =   llList2Vector(listCouleur, indexCouleur);

    for(i=0;i<=nbPrim;i++)
    {
        if(llGetSubString(llList2String(listElements, i),0,2) == "CAM") 
            llSetLinkColor(i, couleurBlanc, 4);
    }
}
 default
 {
     state_entry()
     {
        initialiser(); 
     }
    
    link_message( integer sender_num, integer num, string str, key id )
    {
        string couleur = llGetSubString(str, 0, 3);
        string prim = llGetSubString(str, 5, 50);
        //llSay(0, "couleur - couleur - " + (string) couleur + "| Prim -" + (string) prim + "|");   

        setCouleur(couleur, prim);

        if(couleur == "ZERO")
        {
            remiseZeroCouleur();
        }
    }
     

 }