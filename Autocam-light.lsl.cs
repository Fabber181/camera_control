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


//Compiled by LibLSLCC, Date: 23/04/2020 19:14:26


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
	public LSL_Types.LSLInteger V_modeDebug;
	public LSL_Types.list V_data_pos;
	public LSL_Types.list V_data_rot;
	public GLOBALS()
	{
		this.V_modeDebug = new LSL_Types.LSLInteger(1);
		this.V_data_pos = (new LSL_Types.list((new LSL_Types.Vector3(0.0, 0.0, 0.0)),(new LSL_Types.Vector3(0.0, 0.0, 0.0)),(new LSL_Types.Vector3(0.0, 0.0, 0.0)),(new LSL_Types.Vector3(0.0, 0.0, 0.0)),(new LSL_Types.Vector3(0.0, 0.0, 0.0)),(new LSL_Types.Vector3(0.0, 0.0, 0.0))));
		this.V_data_rot = (new LSL_Types.list((new LSL_Types.Quaternion(0.0, 0.0, 0.0, 0.0)),(new LSL_Types.Quaternion(0.0, 0.0, 0.0, 0.0)),(new LSL_Types.Quaternion(0.0, 0.0, 0.0, 0.0)),(new LSL_Types.Quaternion(0.0, 0.0, 0.0, 0.0)),(new LSL_Types.Quaternion(0.0, 0.0, 0.0, 0.0)),(new LSL_Types.Quaternion(0.0, 0.0, 0.0, 0.0))));
	}
}


GLOBALS Globals = new GLOBALS();


//============================
//== User Defined Functions ==
//============================


public void FN_debug(LSL_Types.LSLString PM_message)
{
	if(_o626(1,this.Globals.V_modeDebug))
	{
		this.llSay(0,PM_message);
	}
}


public void FN_DroitCameraOn()
{
	this.llRequestPermissions(this.llGetOwner(),_o6116(PERMISSION_TRACK_CAMERA,PERMISSION_CONTROL_CAMERA));
	this.llSetCameraParams((new LSL_Types.list(CAMERA_ACTIVE,new LSL_Types.LSLInteger(1))));
}


public LSL_Types.LSLInteger FN_getIndexFromElement(LSL_Types.LSLString PM_detectedElement)
{
	return (LSL_Types.LSLInteger)(this.llGetSubString(PM_detectedElement,5,6));
}


public void FN_updateCamInfo(LSL_Types.LSLInteger PM_indexCam)
{
	FN_debug(_o5245((LSL_Types.LSLString)(PM_indexCam),_o5245(" ",(LSL_Types.LSLString)(this.llGetCameraPos()))));
	this.Globals.V_data_pos = this.llListReplaceList(this.Globals.V_data_pos,(new LSL_Types.list(this.llGetCameraPos())),PM_indexCam,PM_indexCam);
	this.Globals.V_data_rot = this.llListReplaceList(this.Globals.V_data_rot,(new LSL_Types.list(this.llGetCameraRot())),PM_indexCam,PM_indexCam);
	FN_debug((LSL_Types.LSLString)(this.Globals.V_data_pos));
}


public void FN_setCameraPosition(LSL_Types.LSLInteger PM_indexCam)
{
	LSL_Types.Vector3 LV1_pos = this.llList2Vector(this.Globals.V_data_pos,PM_indexCam);
	LSL_Types.Quaternion LV1_rot = this.llList2Rot(this.Globals.V_data_rot,PM_indexCam);
	FN_debug(_o5245((LSL_Types.LSLString)(LV1_rot),_o5245(" - ",(LSL_Types.LSLString)(LV1_pos))));
}



//==================================
//== Default State Event Handlers ==
//==================================


public void default_event_state_entry()
{
	FN_DroitCameraOn();
}

public void default_event_touch_start(LSL_Types.LSLInteger PM_num_detected)
{
	LSL_Types.LSLString LV1_detectedElement = this.llGetLinkName(this.llDetectedLinkNumber(0));
	LSL_Types.LSLString LV1_element = this.llGetSubString(LV1_detectedElement,0,3);
	FN_debug(_o5245(LV1_element,_o5245(" ",LV1_detectedElement)));
	if(_o525("UPDA",LV1_element))
	{
		FN_updateCamInfo(FN_getIndexFromElement(LV1_detectedElement));
	}
	else if(_o525("PLAY",LV1_element))
	{
		FN_setCameraPosition(FN_getIndexFromElement(LV1_detectedElement));
	}
}



//===========================
//== Binary Operator Stubs ==
//===========================


private LSL_Types.LSLInteger _o626(LSL_Types.LSLInteger right, LSL_Types.LSLInteger left)
{
	return left==right;
}


private LSL_Types.LSLInteger _o6116(LSL_Types.LSLInteger right, LSL_Types.LSLInteger left)
{
	return left|right;
}


private LSL_Types.LSLString _o5245(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left+right;
}


private LSL_Types.LSLInteger _o525(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left==right;
}
