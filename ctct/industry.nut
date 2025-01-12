class industriesMgr
{
	signs = {};      // signs
	etat = false ;   // display industry sign

	/**
	 * An industry is deleted
	 */
	function delIndustry(indus)
	{
		if(!industriesMgr.etat) return;
		local sign_id = industriesMgr.signs[indus]; // todo use "in"/ rowin() to check if indus index is present
		if (sign_id!=null) GSSign.RemoveSign(sign_id);
		trace(4,"Industry Deletion: "+indus);
		industriesMgr.signs[indus]=null;
		//industriesMgr.signs.remove(indus); //todo, check why it does not work...
	}

	/**
	 * An industry is created
	 */
	function newIndustry(indus)
	{
		if(!industriesMgr.etat) return;
		if (industriesMgr.signs.rawin(indus)) return; // already set
		local name = "("+GSIndustryType.GetName(GSIndustry.GetIndustryType(indus))+")"; // build a name
		local tile_index = GSIndustry.GetLocation(indus); // industry location
		local sign_id = GSSign.BuildSign(tile_index, name); // create the sign
		trace(4,"New Industry "+indus+" name"+name+", sign"+sign_id);
		if(sign_id!=null) industriesMgr.signs[indus] <- sign_id;
	}

	/**
	 * check if we need to create industry sign, and effectively create if settings request it.
	 *
	 * Called at game creation and savegame load.
	 */
	function Init()
	{
		if(industriesMgr.signs.len()>0) return; // savegame already loaded it
		industriesMgr.etat<-GSController.GetSetting("industry_signs");
		if(industriesMgr.etat)
		{
			industriesMgr.CollectIndustryForSign();
		}
	}

	/**
	 * Fetch all industries, and threat them as beeing new ones
	 */
	function CollectIndustryForSign()
	{
		local inds = GSIndustryList();
		foreach(ind_id, _ in inds)
		{
			industriesMgr.newIndustry(ind_id);
		}
	}

	/**
	 * Check if "industry_sign" settings got changed,
	 * Note : not usefull while setting cannot be updated durring gameplay.
	 */
	function Update()
	{
		local nouv_etat = GSController.GetSetting("industry_signs");
		if(nouv_etat==industriesMgr.etat) return; // no changes
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

	/**
	 * Delete all industry signs.
	 * target signs from registrered ones.
	 */
	function RAZ()
	{
		trace(4,"Remove all registered industry signs");
		foreach(sign_id in industriesMgr.signs)
		{
			if (sign_id!=null && GSSign.IsValidSign(sign_id))
				GSSign.RemoveSign(sign_id);
		}
		industriesMgr.signs.clear();
		industriesMgr.etat<-false;
	}

};

