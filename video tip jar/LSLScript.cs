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


//Compiled by LibLSLCC, Date: 25/04/2020 16:03:24


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
	public LSL_Types.LSLString V_gNotecard;
	public LSL_Types.LSLString V_gLineRequestID;
	public LSL_Types.LSLString V_gReadRequestID;
	public LSL_Types.LSLInteger V_gLineTotal;
	public LSL_Types.LSLInteger V_gLineIndex;
	public LSL_Types.list V_gDataLines;
	public LSL_Types.LSLString V_gStatus;
	public GLOBALS()
	{
		this.V_gNotecard = "Config";
		this.V_gLineRequestID = "";
		this.V_gReadRequestID = "";
		this.V_gLineTotal = 0;
		this.V_gLineIndex = 0;
		this.V_gDataLines = new LSL_Types.list();
		this.V_gStatus = "";
	}
}


GLOBALS Globals = new GLOBALS();



//==================================
//== Default State Event Handlers ==
//==================================


public void default_event_state_entry()
{
	if(new LSL_Types.key(this.llGetInventoryKey(this.Globals.V_gNotecard)))
	{
		this.Globals.V_gLineRequestID = this.llGetNumberOfNotecardLines(this.Globals.V_gNotecard);
	}
	else
	{
		this.llOwnerSay(_o5245("' does not exist or has no saved data",_o5245(this.Globals.V_gNotecard,"Notecard '")));
	}
}

public void default_event_changed(LSL_Types.LSLInteger PM_change)
{
	if(_o6126(CHANGED_INVENTORY,PM_change))
	{
		this.llResetScript();
	}
}

public void default_event_dataserver(LSL_Types.LSLString PM_requested, LSL_Types.LSLString PM_data)
{
	if(_o727(this.Globals.V_gLineRequestID,PM_requested))
	{
		this.Globals.V_gLineTotal = (LSL_Types.LSLInteger)(PM_data);
		this.Globals.V_gReadRequestID = this.llGetNotecardLine(this.Globals.V_gNotecard,this.Globals.V_gLineIndex);
		return;
	}
	if(_o717(this.Globals.V_gReadRequestID,PM_requested))
	{
		return;
	}
	if(_o525(EOF,(this.Globals.V_gStatus = PM_data)))
	{
		return;
	}
	this.Globals.V_gReadRequestID = this.llGetNotecardLine(this.Globals.V_gNotecard,++this.Globals.V_gLineIndex);
	PM_data = this.llStringTrim(PM_data,STRING_TRIM);
	if(((bool)(_o525("#",this.llGetSubString(PM_data,0,0)))) | ((bool)(_o525("",PM_data))))
	{
		return;
	}
	this.Globals.V_gDataLines = _o3245(PM_data,this.Globals.V_gDataLines);
}

public void default_event_touch_start(LSL_Types.LSLInteger PM_total_number)
{
	if(_o515(EOF,this.Globals.V_gStatus))
	{
		this.llOwnerSay("Please wait");
		return;
	}
	LSL_Types.LSLInteger LV1_count = (_o313((new LSL_Types.list()),this.Globals.V_gDataLines));
	this.llOwnerSay(_o5245(" contained data.",_o5245((LSL_Types.LSLString)(LV1_count),_o5245(" lines, of which ",_o5245((LSL_Types.LSLString)(this.Globals.V_gLineTotal),_o5245(" had a total of  ",this.Globals.V_gNotecard))))));
	LSL_Types.LSLInteger LV1_x = 0;
	for(;_o686(LV1_count,LV1_x);++LV1_x)
	{
		this.llOwnerSay(this.llList2String(this.Globals.V_gDataLines,LV1_x));
	}
	this.llOwnerSay("---- end of data ----");
}



//===========================
//== Binary Operator Stubs ==
//===========================


private LSL_Types.LSLString _o5245(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left+right;
}


private LSL_Types.LSLInteger _o6126(LSL_Types.LSLInteger right, LSL_Types.LSLInteger left)
{
	return left&right;
}


private LSL_Types.LSLInteger _o727(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left==right;
}


private LSL_Types.LSLInteger _o717(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left!=right;
}


private LSL_Types.LSLInteger _o525(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left==right;
}


private LSL_Types.list _o3245(LSL_Types.LSLString right, LSL_Types.list left)
{
	return left+right;
}


private LSL_Types.LSLInteger _o515(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left!=right;
}


private LSL_Types.LSLInteger _o313(LSL_Types.list right, LSL_Types.list left)
{
	return left!=right;
}


private LSL_Types.LSLInteger _o686(LSL_Types.LSLInteger right, LSL_Types.LSLInteger left)
{
	return left<right;
}
