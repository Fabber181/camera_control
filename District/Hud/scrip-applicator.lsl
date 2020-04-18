/* Script qui permet de retourner l'index du prims touché : 
# =======================================================
# Auteur - Fabber Resident
# Contact - fabtoupet3@gmail.com
# Objectif du script : Retourne l'identifiant du prims et d ela face concerné par l'objet touché 
*/


default
{
    touch_start(integer total_number)
    {
        key owner = llGetOwner();
        
        /* -- Si la personne qui touche le script est bien le owner de l'obet -- */ 
        if (llDetectedKey(0) == owner)
        {
            // récupération de l'ID de l'objet
            integer prim = llDetectedLinkNumber(0);
            // Récupération de l'ID de la face 
            integer face = llDetectedTouchFace(0);
            
            // Retours du prims et de la face au owner 
            llOwnerSay("Identifiant du prims : " + (string) prim  + " identifiant de la face " + (string) face);
        }
    }
}
