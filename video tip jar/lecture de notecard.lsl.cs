//c#
/** 
*  Do not remove //c# from the first line of this script.
*
*  This is OpenSim CSharp code, CSharp scripting must be enabled on the server to run.
*
*  Please note this script does not support being reset, because a constructor was not generated.
*  Compile using the server side script option to generate a script constructor.
*
*  This code will run on an unmodified OpenSim server, however script resets will not reset global variables,
*  and OpenSim will be unable to save the state of this script as its global variables are created in an object container.
*
*/ 


//Compiled by LibLSLCC, Date: 25/04/2020 18:30:57


//============================
//== Compiler Utility Class ==
//============================
private static class UTILITIES
{
    public static void ForceStatement<T>(T val) {}

    public static bool ToBool(LSL_Types.LSLString str)
    {
        return str.Length != 0;
    }

    public static LSL_Types.Quaternion Negate(LSL_Types.Quaternion rot)
    {
        rot.x=(-rot.x);
        rot.y=(-rot.y);
        rot.z=(-rot.z);
        rot.s=(-rot.s);
        return rot;
    }
    public static LSL_Types.Vector3 Negate(LSL_Types.Vector3 vec)
    {
        vec.x=(-vec.x);
        vec.y=(-vec.y);
        vec.z=(-vec.z);
        return vec;
    }
}


//===============================
//== Global Variable Container ==
//===============================
private class GLOBALS
{
	public LSL_Types.list V_listThx;
	public LSL_Types.LSLString V_notecard;
	public LSL_Types.LSLInteger V_indexLigneNotecard;
	public LSL_Types.LSLInteger V_length;
	public LSL_Types.LSLString V_getReadRequest;
	public LSL_Types.LSLString V_getLength;
	public GLOBALS()
	{
		this.V_listThx = (new LSL_Types.list());
		this.V_notecard = "TEMPLATE_THX";
		this.V_indexLigneNotecard = new LSL_Types.LSLInteger(0);
		this.V_length = 0;
		this.V_getReadRequest = "";
		this.V_getLength = "";
	}
}


GLOBALS Globals = new GLOBALS();



//==================================
//== Default State Event Handlers ==
//==================================


public void default_event_state_entry()
{
	this.Globals.V_getLength = this.llGetNumberOfNotecardLines(this.Globals.V_notecard);
}

public void default_event_dataserver(LSL_Types.LSLString PM_requested, LSL_Types.LSLString PM_data)
{
	if(_o727(PM_requested,this.Globals.V_getLength))
	{
		this.Globals.V_length = (LSL_Types.LSLInteger)(PM_data);
		this.Globals.V_getReadRequest = this.llGetNotecardLine(this.Globals.V_notecard,this.Globals.V_indexLigneNotecard);
	}
	else if(_o717(this.Globals.V_getReadRequest,PM_requested))
	{
		return;
	}
	if(_o676(this.Globals.V_length,this.Globals.V_indexLigneNotecard))
	{
		this.Globals.V_getReadRequest = this.llGetNotecardLine(this.Globals.V_notecard,this.Globals.V_indexLigneNotecard++);
	}
	else
	{
		this.llSay(0,"Sortie de la boucle");
	}
	PM_data = this.llStringTrim(PM_data,STRING_TRIM);
	if(((bool)(_o525("#",this.llGetSubString(PM_data,0,0)))) | ((bool)(_o525("",PM_data))))
	{
		return;
	}
	this.Globals.V_listThx = _o3245(PM_data,this.Globals.V_listThx);
}

public void default_event_touch(LSL_Types.LSLInteger PM_num_detected)
{
	LSL_Types.LSLInteger LV1_i = 0;
	for(LV1_i = 0;_o676(this.llGetListLength(this.Globals.V_listThx),LV1_i);LV1_i++)
	{
		this.llSay(0,this.llList2String(this.Globals.V_listThx,LV1_i));
	}
}



//===========================
//== Binary Operator Stubs ==
//===========================


private LSL_Types.LSLInteger _o727(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left==right;
}


private LSL_Types.LSLInteger _o717(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left!=right;
}


private LSL_Types.LSLInteger _o676(LSL_Types.LSLInteger right, LSL_Types.LSLInteger left)
{
	return left<=right;
}


private LSL_Types.LSLInteger _o525(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left==right;
}


private LSL_Types.list _o3245(LSL_Types.LSLString right, LSL_Types.list left)
{
	return left+right;
}
