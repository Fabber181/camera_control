/* Script compsant du HUD
# =======================================================
# Auteur - Fabber Resident 
# Contact - fabtoupet3@gmail.com
# Norme : d'après les standard Java et LSL. Normes personalisés
# Objectif du script : 
# Si un des bouton touché porte le nom exture, à partir de l'identifiant, le script va cehrcher et retourner les informations de la note carts faisant partie de la texture
*/


/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
                          Constantes
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. */



/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
                          Fonctions
-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. */
// Définit si le primx touché est bine une texture 
isTypeTextureTouched(integer idPrims)
{
	string nomPrim = llGetLinkName(idPrims);
	llSay(0,"Touche de  : " + nomPrim);
	if (llSubStringIndex(nomPrim, "TEXTURE") != -1)
	{
		llSay(0, "c'est une texture");
	}
	else
	{
		llSay(0, "Je peux pas c'est tartiflette ! ");
	}
}


default
{
    touch(integer num_detected)
    {
        // Si touché par le proprio
        if (llDetectedKey(0) == llGetOwner())
        {
        	isTypeTextureTouched(llDetectedLinkNumber(0));
        }
    }
}