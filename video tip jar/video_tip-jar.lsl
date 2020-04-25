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

/* -- Script qui permet de setter une texture -- */
setTexture (integer prims,integer face, key id)
{
    llSetLinkPrimitiveParams( prims, [ PRIM_TEXTURE, face, id, <1.0, 1.0, 0.0>, <1.0, 1.0, 0.0>, 0.0 ]);
}

/* Script qui load toutes les texture sur le preload */
updatePreload()
{
    llSay(0, "preload");
    setTexture(3,0,TEXTURE_TEST);

    integer nbFace = llGetListLength(data);
    integer i;
    setAnim(FALSE);
    for(i=0;i<nbFace;i++)
    {
        setTexture(4, i+1, llList2Key(data, i));
    }
}

/* Active l'animation */
setAnim(integer animation)
{
    if (animation == TRUE)
    {
        llSetLinkTextureAnim(3, ANIM_ON | LOOP |PING_PONG , ALL_SIDES, 6, 6, 0, 36, 10);
    }
    else
    {
        llSetLinkTextureAnim(3, FALSE, ALL_SIDES, 1, 1, 0.0, 0.0, 0.1);
    }
}

/* Etat en mode lecture */
changerEtatLecture()
{
    llSay(0,"Changement etata");
    if( 1 == 1 )
    {
        state lecture;
    }
}

fadeIn()
{
    llSetLinkTextureAnim(1, ANIM_ON , ALL_SIDES, 1, 60, 0, 60, 30);
}

fadeOut()
{
        llSetLinkTextureAnim(1, ANIM_ON | REVERSE, ALL_SIDES , 1, 60, 0, 60, 30);
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
    setTexture(3,0,llList2Key(data, next));
    fadeOut();


    curentTexture = next;
}

/* -- Merci -- */

default
{
    state_entry()
    {
        updatePreload();
        fadeOut();
    }
    touch_start(integer num_detected)
    {
        llSay(0, "touché ");
        if(llDetectedKey(0) == llGetOwner())
        	changerEtatLecture();
    }
}

state lecture
{
    state_entry()
    {
        llSay(0, "animation");
        llSetTimerEvent(15);
        setAnim(TRUE);
        changementTexture();
        llSetPayPrice(PAY_DEFAULT, [50, 100, 150, 200]);
    }
    timer()
    {
        fadeIn();
        changementTexture();
    }
    money(key id, integer amount)
    {
    	llSay(0, " " + (string) llGet);
    }
}