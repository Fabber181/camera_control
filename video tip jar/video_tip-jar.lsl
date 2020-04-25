/* --------------- Tip Jar video - Oeil-Viseul ------------------
Conception : fabtoupet3@gmail.com
Use : Tip jar with a video with pre-load
*/

// Atttention limite à 4 texture animés
list data = [
    "e61b5ac6-5861-5807-bebe-8adae0e261b1",
    "fdfa97d0-d5c7-4698-9e85-e1c0751de638",
    "1ffabc8c-f863-fcd0-4b75-ce45e7c737dd",
    "a19d6408-e0ef-b255-3fd4-66029f027873",
    "7514ed84-fc09-912a-95a0-dba2181ebeca",
    "e152dcd5-975d-cad6-fff7-8bb17d12b064",
    "bd1e55fe-266e-1fcf-0d43-e1b4ae3f2d44",
    "b147bf8f-f55e-d5e7-8935-b6ae216fed84"
    ];
integer curentTexture = 0;
key TEXTURE_TEST = "bbc281a3-d4c9-6c72-6657-b5935d621905";
key TEXTURE_THX = "dbf67e3d-4f49-cf76-52b7-73154d6c703f";
integer sum = 0;
string thxTemplate;
list thx ;

/* -- Script qui permet de setter une texture -- */
setTexture (integer prims,integer face, key id)
{
    llSetLinkPrimitiveParams( prims, [ PRIM_TEXTURE, face, id, <1.0, 1.0, 0.0>, <1.0, 1.0, 0.0>, 0.0 ]);
}

/* Script qui load toutes les texture sur le preload */
updatePreload()
{
    setTexture(4,0,TEXTURE_TEST);

    integer nbFace = llGetListLength(data);
    integer i;
    setAnim(FALSE);
    for(i=0;i<nbFace;i++)
    {
        setTexture(2, i+1, llList2Key(data, i));
    }
}

/* Active l'animation */
setAnim(integer animation)
{
    if (animation == TRUE)
    {
        llSetLinkTextureAnim(4, ANIM_ON | LOOP |PING_PONG , ALL_SIDES, 6, 6, 0, 36, 10);
    }
    else
    {
        llSetLinkTextureAnim(4, FALSE, ALL_SIDES, 1, 1, 0.0, 0.0, 0.1);
    }
}

/* Etat en mode lecture */
changerEtatLecture()
{
    if( 1 == 1 )
    {
        state lecture;
    }
}

fadeIn()
{
    llSetLinkTextureAnim(5, ANIM_ON , ALL_SIDES, 1, 60, 0, 60, 30);
}

fadeOut()
{
        llSetLinkTextureAnim(5, ANIM_ON | REVERSE, ALL_SIDES , 1, 60, 0, 60, 30);
}

/* -- Changement de texture -- */
changementTexture()
{
    fadeIn();
    integer next = (integer) llFrand(llGetListLength(data)) - 1;
    while(next == curentTexture)
    {
        next = (integer) llFrand(llGetListLength(data)) - 1;
    }
    llSleep(2);
    setTexture(4,0,llList2Key(data, next));
    fadeOut();


    curentTexture = next;
}

changementTextureThx()
{
	llSetTimerEvent(0);
	fadeIn();
	llSleep(2);
	setTexture(4,0,TEXTURE_THX);
	fadeOut();
	llSetTimerEvent(15);
}

updateText(integer active)
{
	if(active)
		llSetText("Tip-jar \n Veecky \n " + (string) sum + "l$", <1.0,1.0,1.0>,1.0);
	else
		llSetText("",<1.0,1.0,1.0>,1.0);
}

default
{
    state_entry()
    {
    	updateText(FALSE);
        updatePreload();
        fadeOut();
        state attenteActivation;
    }
}

state attenteActivation
{
	state_entry()
	{
		llOwnerSay("
		================================
		         Video Tip Jar - READY -
		             Click to start
		===============================");
		llSetClickAction(CLICK_ACTION_TOUCH);
	}
	touch(integer num_detected)
    {
        if(llDetectedKey(0) == llGetOwner())
            changerEtatLecture();
    }
}

state lecture
{
	on_rez(integer start_param)
	{
		llResetScript();
	}
    state_entry()
    {
    	updateText(TRUE);
        llSetTimerEvent(15);
        setAnim(TRUE);
        changementTexture();
        llSetPayPrice(PAY_DEFAULT, [50, 100, 150, 200]);
        llSetClickAction(CLICK_ACTION_PAY);
    }
    timer()
    {
        changementTexture();
    }
    money(key id, integer amount)
    {
    	sum = sum + amount;
    	updateText(TRUE);
    	changementTextureThx();
    }
}