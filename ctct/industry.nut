class industriesMgr
{
	signs = {}; // les signes
	etat = false ; // affichage des signes
	
	function delIndustry(indus)
	{
		if(!industriesMgr.etat) return; // on ne gere pas les signes
		local sign_id = industriesMgr.signs[indus];
		if (sign_id!=null) GSSign.RemoveSign(sign_id);
		trace(4,"Industry Deletion: "+indus);
		industriesMgr.signs[indus]=null;
		//industriesMgr.signs.remove(indus); <- ne marche pas.
	}

	function newIndustry(indus)
	{
		if(!industriesMgr.etat) return; // on ne gere pas les signes
		if (industriesMgr.signs.rawin(indus)) return; // dejà existant
		local name = "("+GSIndustryType.GetName(GSIndustry.GetIndustryType(indus))+")"; // le nom
		local tile_index = GSIndustry.GetLocation(indus); // la position
		local sign_id = GSSign.BuildSign(tile_index, name); // le signe
		trace(4,"New Industry "+indus+" name"+name+", sign"+sign_id);
		if(sign_id!=null) industriesMgr.signs[indus] <- sign_id; // enregistre
	}

	function Init()
	{
		if(industriesMgr.signs.len()>0) return; // dejà charge grace à la sauvegarde
		//var_dump("[init] signes",industriesMgr.signs);
		industriesMgr.etat<-GSController.GetSetting("industry_signs");
		if(industriesMgr.etat)
		{
			industriesMgr.CollectIndustryForSign();
		}
	}
	
	function CollectIndustryForSign()
	{
		local inds = GSIndustryList();
		foreach(ind_id, _ in inds)
		{
			industriesMgr.newIndustry(ind_id);
		}
	}
	
	function Update()
	{
		local nouv_etat = GSController.GetSetting("industry_signs");
		if(nouv_etat==industriesMgr.etat) return; // no changements
		industriesMgr.etat <- nouv_etat;
		if(industriesMgr.etat)
		{
			industriesMgr.CollectIndustryForSign();
		}
		else
		{
			industriesMgr.RAZ();
		}
	}
	
	function RAZ()
	{
		foreach(sign_id in industriesMgr.signs)
		{
			if (sign_id!=null) GSSign.RemoveSign(sign_id);
		}
		industriesMgr.signs.clear();
		industriesMgr.etat<-false;
	}

};

