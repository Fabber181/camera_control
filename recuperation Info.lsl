integer listenHandle;
// Propriete 
string INSTANCE_ALL = "ALL";
string ACTOIN_GET_INFO = "GET_INFO";
string ACTION_SET_INFO= "SET_INFO";
string ACTION_GIV_INFO= "GIV_INFO";
integer indexCam = 1;

/* -- Fonction qui récupère les information des caméra -- */
recupereInfo(string message, integer instanceIdCam)
{
	vector pos = (vector) llGetSubString(message, 20 , 59);
	integer debutAngle = llSubStringIndex(message, "R1") + 3;
	rotation angle = (rotation) llGetSubString(message, debutAngle , debutAngle+ 60);
}

default
{
    state_entry()
    {
        listenHandle = llListen(2830, "", NULL_KEY, "");
    }

    listen(integer channel, string name, key id, string message)
    {
        llOwnerSay( name + " said: " + message);
        
        //Décompilation du message
        string instance = llGetSubString(message, 4 , 6);
        string instancePropriete = llGetSubString(message, 8 , 15);
        
        llOwnerSay(instancePropriete + " - " + ACTION_GIV_INFO);
        
         // Si c'est une instance de caméra précise
         if (instancePropriete == ACTION_GIV_INFO)
        {
        	integer instanceIdCam = (integer)instance;
            recupereInfo(message, instanceIdCam);
        }
    }

}