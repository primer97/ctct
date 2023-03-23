
function trace(niv,txt,max=0)
{
	if(GSController.GetSetting("log_level")>=niv)
	{
		if(max>0)
		{
		if(GSController.GetSetting("log_level")>max)
		return;
		}
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

