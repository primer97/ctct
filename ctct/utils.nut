
function trace(niv,txt)
{
	if(GSController.GetSetting("log_level")>=niv)
	{
	GSLog.Info(txt);
	}
}
function dbg(info)
{
	GSNews.Create(GSNews.NT_GENERAL,info,0);
}

function var_dump(txt,obj)
{
	trace(3,txt+":"+dump(obj));
}

// dump function to get object exploded for displaying. return text.
function dump(obj)
{
	switch (typeof(obj))
	{
	case "instance":
		return "(instance)?";
	case "array":
		local txt="(arr)[";
		if(obj.len()>0)
		{
			foreach(k,v in obj)
				txt+="idx:"+k+": "+dump(v)+", ";
		//	txt.slice(0, txt.len()-2); // ne marche pas
		}
		return txt+"]";
	case "table":
		local txt="(tbl){";
		if(obj.len()>0)
		{
			foreach(k,v in obj)
				txt+=k+" => "+dump(v)+", ";
		//	txt.slice(0, txt.len()-2); // ne marche pas
		}
		return txt+"}";
	case "string":
		return "'"+obj+"'";
	case  "integer":
		return obj;
	case  "float":
		return "(flt)"+obj;
	default:
		return "?("+typeof(obj)+")";
	}
}

// version 1.4 ou superieur ?
function isVer14()
{
 return ("SetProgress" in GSGoal);
//	local v=GetOTTDVer();
//	if(v.Major>1 || (v.Major==1 && v.Minor>=4)) return true;
//	return false;
}

function GetOTTDVer()
{
	local v = GSController.GetVersion();
	local tmp =
	{
		Major = (v & 0xF0000000) >> 28, /* x._ */
		Minor = (v & 0x0F000000) >> 24  /* _.y */
	}
	return tmp;
}