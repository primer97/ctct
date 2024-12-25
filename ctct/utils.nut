
function trace(niv,txt,high=false)
{
	if(GSController.GetSetting("log_level")>=niv)
	{
	if(high)
		GSLog.Warning(txt);
	else
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
		}
		return txt+"]";
	case "table":
		local txt="(tbl){";
		if(obj.len()>0)
		{
			foreach(k,v in obj)
				txt+=k+" => "+dump(v)+", ";
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

