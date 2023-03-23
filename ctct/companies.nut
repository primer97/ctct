class companies
{
	comp = {}; 	// la table des companies (associatif)
				/*       - - -  S t r u c t u r e  - - -
				comp['compID']= {
								'HQTile' - > le tileID où se trouve le HQ
								'town'   - > le townID de la ville claimed
								'sign'   - > le signID du panneau indicatif
								'goal'   - > le goalID pour cette companie
								'etat'   - > un code de status : 0=nouv(pas_de_hq)  1=hq_ok  20 à 10=hq_pas_ok
								}
				*/
	goalval = null;
	compete_goal = GSGoal.GOAL_INVALID;
	constructor()
	{
		trace(4,"Companies constructor");
	}
	function SetGoalVal(val)
	{
		trace(4,"Goal de companie, valeur = " + val );
		if(val==null) return;
		local quick=GSController.GetSetting("Quicker_Achivement");
		if(quick)
		{
			local niv=GSController.GetSetting("Difficulty_level");
			local div=(11-niv)/2; // de /5 à /2
			trace(2,"Quick_Achivement mode, company goal divided by " + div );
			val = val / div;
		}
		companies.goalval<-val;
	}
	
	function NewCompany(cid)
	{
		//TODO : controler si cid n'a pas déjà été utilisé par le passé ?
		companies.comp[cid] <- { HQTile=GSMap.TILE_INVALID, town=null, sign=null, goal=GSGoal.GOAL_INVALID, etat=0};
		if(def_m.extCargo.len()>0)
			GSGoal.Question(1,cid,GSText(GSText.STR_CLAIMMODE_WELCOME),GSGoal.QT_INFORMATION,GSGoal.BUTTON_OK );
		else
			GSGoal.Question(1,cid,GSText(GSText.STR_CLAIMMODE_WELCOME_NOEXT),GSGoal.QT_INFORMATION,GSGoal.BUTTON_OK );
	}

	function DelCompany(cid)
	{
		companies.endorse_RemoveHQ(cid);
		//TODO : supprimer la ligne cid de .comp
	}
	
	// controle tous les HQ
	function checkHQ()
	{
		trace(4,"Check HQ...");
		foreach(cid, company in companies.comp) 
		{
			local HQ = GSCompany.GetCompanyHQ(cid);
			if(HQ != company.HQTile) // HQ changé
			{
				trace(3,"company "+ cid +" changed his HQ to "+HQ);
				
				companies.endorse_RemoveHQ(cid); // supprime le HQ de l'ancienne ville.
				if(companies.check_PlaceHQ(cid, HQ))
				{ // ok
					companies.endorse_PlaceHQ(cid, HQ);
				}
				else
				{ // pas bon
					trace(3,"company "+ cid+" asked for an already reserved city !!! ");
					companies.dissuasion(cid);
				}
			}
		}
	}
	
	
	function dissuasion(cid)
	{
		local av = companies.comp[cid].etat;
		if(av < 10)
			{
				companies.comp[cid].etat <- 20; 
				av=19;
				local reqtown = GSTile.GetClosestTown(GSCompany.GetCompanyHQ(cid));
				GSGoal.Question(1,cid,GSText(GSText.STR_CLAIMMODE_DISSUASION_FIRST,reqtown) ,GSGoal.QT_WARNING,GSGoal.BUTTON_OK );
				return;
			}
		if(av == 10)
			{
				local amende = max(5000,GSCompany.GetBankBalance(cid)/2);
				GSCompany.ChangeBankBalance(cid,-amende,GSCompany.EXPENSES_OTHER);
				GSGoal.Question(1,cid,GSText(GSText.STR_CLAIMMODE_DISSUASION_PENALTY,amende) ,GSGoal.QT_ERROR,GSGoal.BUTTON_OK );
				companies.comp[cid].etat <- 20;
			}
		else
			{
				GSGoal.Question(1,cid,GSText(GSText.STR_CLAIMMODE_DISSUASION_REMINDER,20-av) ,GSGoal.QT_WARNING,GSGoal.BUTTON_OK );
				companies.comp[cid].etat <- av - 1;
			}
	}
	

	// verifie si le HQ est placé dans une ville possédant déjà un HQ
	// retour true:ok  false:sinon.
	function check_PlaceHQ(cid, tile)
	{
		local reqtown = GSTile.GetClosestTown(GSCompany.GetCompanyHQ(cid));
		trace(3,"Check Place HQ "+ cid +" req town:"+reqtown);
		foreach	(cp, data in companies.comp)
			{
				if(cp != cid && data.town == reqtown) return false; // déjà occupé par un autre !
			}
		trace(3,"Check Place HQ town is free");
		return true;
	}
	
	
	// enterrine le positionement du HQ : crée le sign, enregistre la position...
	function endorse_PlaceHQ(cid, tile)
	{
		companies.comp[cid].HQTile <- tile; // position enregistrée
		companies.comp[cid].etat <- 1;

		local town = GSTile.GetClosestTown(GSCompany.GetCompanyHQ(cid));
		companies.comp[cid].town <- town;
		trace(3,"Place HQ "+ cid+" town:"+town);

		local txt= "["+ (GSController.GetSetting("owned_city_display")%2==1?GSCompany.GetPresidentName(cid):GSCompany.GetName(cid) )+ "]";
		
		if(GSController.GetSetting("owned_city_display")<3)
		{
			if(isVer14())
			{
				GSTown.SetName(town , GSTown.GetName(town)+" "+txt);
			}
			companies.comp[cid].sign <- null;
		}
		else
		{
				local sign = GSSign.BuildSign(GSTown.GetLocation(town), txt);
				companies.comp[cid].sign <- sign;
				trace(3,"le sign "+ companies.comp[cid].sign);
		}
		// crée un nouveau goal
		trace(3,"goaltxt = "+ GSText.STR_CLAIMMODE_TOWNGOAL);
		trace(3,"goalval = "+ companies.goalval);
		if(companies.goalval!=null) // pour ne pas planter si aucun goal n'est défini (par ex si aucun cargo ext n'est en attente)
		{
			local gtxt=GSText(GSText.STR_CLAIMMODE_TOWNGOAL,town,companies.goalval);
			companies.comp[cid].goal <- GSGoal.New(cid,gtxt,GSGoal.GT_COMPANY,cid);	
		}
	}
	
	
	
	// enterrine la suppression du HQ
	function endorse_RemoveHQ(cid)
	{
		trace(3,"Remove HQ "+ cid);
		companies.comp[cid].HQTile <- GSMap.TILE_INVALID;
		if(companies.comp[cid].etat <10) companies.comp[cid].etat <- 0;
		trace(3,"le sign "+ companies.comp[cid].sign);
		if(companies.comp[cid].sign!=null && GSSign.IsValidSign(companies.comp[cid].sign))
		{
			// supprimer le sign
			trace(3,"Remove sign "+ companies.comp[cid].sign);
			GSSign.RemoveSign(companies.comp[cid].sign);
			companies.comp[cid].sign <- null ;
		}
		
		if(isVer14())
		{
			local town = companies.comp[cid].town;
			if( GSController.GetSetting("owned_city_display")<3 && town!= null && GSTown.IsValidTown(town))		GSTown.SetName(town , null);
		}
		companies.comp[cid].town <- null ;
		 
		// supprime l'ancien goal ?
		trace(2,"Remove goal : "+ companies.comp[cid].goal);
		if(companies.comp[cid].goal != GSGoal.GOAL_INVALID)
		{
			trace(2,"Remove goal "+ companies.comp[cid].goal);
			GSGoal.Remove(companies.comp[cid].goal);
			companies.comp[cid].goal <- GSGoal.GOAL_INVALID;
		}
	}
	
	function checkCompetition()
	{
		local winner=-1;
		local win_inhab=0;
		local win_town=0;
		
		foreach(cp, data in companies.comp)
		{
			if(data.etat==1)
			{
				local inhab=GSTown.GetPopulation(data.town);
				if(isVer14()) GSGoal.SetProgress(data.goal,GSText(GSText.STR_GOAL_PROGRESS,(100*inhab/companies.goalval).tointeger()));
				if(inhab > win_inhab)
				{
					trace(3,"chkCompet : inhab " + inhab + " -> winner :" + cp);
					winner=cp;
					win_inhab=inhab;
					win_town=data.town;
				}
			}
		}
		
		if(winner==-1) // pas de vainqueur
		{
			if (companies.compete_goal == GSGoal.GOAL_INVALID) return; // il n'y avait pas de goal
			GSGoal.Remove(companies.compete_goal);
			companies.compete_goal <- GSGoal.GOAL_INVALID;
			return;
		}
		GSGoal.Remove(companies.compete_goal);
		companies.compete_goal <- GSGoal.GOAL_INVALID;
		local prc=(100*win_inhab/companies.goalval).tointeger();
		companies.compete_goal <- GSGoal.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_CLAIMMODE_COMPETITION,winner,win_town,prc), GSGoal.GT_NONE, 0);
		//GSGoal.SetProgress(towns._goals[towns._etape+1],GSText(GSText.STR_GOAL_REACHED));
	}
};

