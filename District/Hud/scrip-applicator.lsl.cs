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


//Compiled by LibLSLCC, Date: 18/04/2020 22:49:45


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



//==================================
//== Default State Event Handlers ==
//==================================


public void default_event_touch_start(LSL_Types.LSLInteger PM_total_number)
{
	LSL_Types.LSLString LV1_owner = this.llGetOwner();
	if(_o727(LV1_owner,this.llDetectedKey(0)))
	{
		LSL_Types.LSLInteger LV2_prim = this.llDetectedLinkNumber(0);
		LSL_Types.LSLInteger LV2_face = this.llDetectedTouchFace(0);
		this.llOwnerSay(_o5245((LSL_Types.LSLString)(LV2_face),_o5245(" identifiant de la face ",_o5245((LSL_Types.LSLString)(LV2_prim),"Identifiant du prims : "))));
	}
}



//===========================
//== Binary Operator Stubs ==
//===========================


private LSL_Types.LSLInteger _o727(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left==right;
}


private LSL_Types.LSLString _o5245(LSL_Types.LSLString right, LSL_Types.LSLString left)
{
	return left+right;
}
