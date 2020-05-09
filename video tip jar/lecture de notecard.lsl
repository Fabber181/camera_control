list listThx = [];
string notecard = "TEMPLATE_THX";

integer indexLigneNotecard =0;
integer length;
key getReadRequest;
key getLength; 



// script-wise, the first notecard line is line 0, the second line is line 1, etc.
 
default
{
	state_entry()
	{
		getLength = llGetNumberOfNotecardLines(notecard);
		
	}
	 dataserver(key requested, string data)
    {
    	if (getLength == requested)
    	{
    		length = (integer) data;
    		getReadRequest = llGetNotecardLine(notecard,indexLigneNotecard ); 	
    	}
    	else if( requested != getReadRequest)
    	{
    		return;
    	}
		
		if (indexLigneNotecard <= length)
			getReadRequest = llGetNotecardLine(notecard,indexLigneNotecard++);
		else
			llSay(0,"Sortie de la boucle");

		data = llStringTrim(data, STRING_TRIM);  
		if(data == "" || llGetSubString(data, 0, 0) == "#")
			return;
    	listThx += data;
    	
    }
    
	touch(integer num_detected)
	{
		integer i;
		for(i=0; i<= llGetListLength(listThx); i++)
			llSay(0, llList2String(listThx, i));

	}
    
}