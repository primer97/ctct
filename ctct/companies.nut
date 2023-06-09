﻿class companies
{
	comp = {}; 	// compay table (asso table)
				/*       - - -  S t r u c t u r e  - - -
				comp['compID']= {
								'HQTile' - > location of HQ (tileID)
								'town'   - > claimed townID
								'sign'   - > signID of sign used to name
								'goal'   - > company goalID
								'etat'   - > status code : 0=no HQ    1=HQ set    20 to 10=HQ in conflict
								}
				*/
	goalval = null;
	compete_goal = GSGoal.GOAL_INVALID;
	constructor()
	{
	}
	function SetGoalVal(val)
	{
		trace(4,"Company Goal, target pop = " + val );
		if(val==null) return;
		local quick=GSController.GetSetting("Quicker_Achievement");
		if(quick)
		{
			local niv=GSController.GetSetting("Difficulty_level");
			local div=(11-niv)/2; // de /5 à /2
			trace(4,"Quick_Achievement mode, company goal divided by " + div );
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
				trace(4,"company "+ cid +" changed his HQ to "+HQ);
				
				companies.endorse_RemoveHQ(cid); // supprime le HQ de l'ancienne ville.
				if(companies.check_PlaceHQ(cid, HQ))
				{ // ok
					companies.endorse_PlaceHQ(cid, HQ);
				}
				else
				{ // pas bon
					trace(4,"Company "+ cid+" asked for an already reserved city !!! ");
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
				local amende = max(5000,GSCompany.GetBankBalance(cid)/3).tointeger();
				trace(2,"Penalty "+amende+" for staying at already claimed town, company "+GSCompany.GetName(cid));
				GSCompany.ChangeBankBalance(cid,-amende,GSCompany.EXPENSES_OTHER,GSMap.TILE_INVALID);
				GSGoal.Question(1,cid,GSText(GSText.STR_CLAIMMODE_DISSUASION_PENALTY,amende) ,GSGoal.QT_ERROR,GSGoal.BUTTON_OK );
				companies.comp[cid].etat <- 20;
			}
		else
			{
				GSGoal.Question(1,cid,GSText(GSText.STR_CLAIMMODE_DISSUASION_REMINDER,20-av) ,GSGoal.QT_WARNING,GSGoal.BUTTON_OK);
				companies.comp[cid].etat <- av - 1;
			}
	}
	

	// check if choosen town is already claimed. (claim = with HQ)
	// return true:safe  false:conflict.
	function check_PlaceHQ(cid, tile)
	{
		local reqtown = GSTile.GetClosestTown(GSCompany.GetCompanyHQ(cid));
		trace(4,"Check HQ for company:"+ cid +" claimed town:"+reqtown +" "+GSTown.GetName(reqtown));
		foreach	(cp, data in companies.comp)
			{
				if(cp != cid && data.town == reqtown) return false; // déjà occupé par un autre !
			}
		trace(4,"Claimed town is free");
		return true;
	}
	
	
	// endorse new HQ location : create sign, create goal, store location...
	function endorse_PlaceHQ(cid, tile)
	{
		companies.comp[cid].HQTile <- tile; // store location (tile)
		companies.comp[cid].etat <- 1;

		local town = GSTile.GetClosestTown(GSCompany.GetCompanyHQ(cid));
		companies.comp[cid].town <- town;
		trace(1,GSTown.GetName(town)+" is now claimed by "+GSCompany.GetName(cid)+", pop:"+GSTown.GetPopulation(town));

		local txt= "["+ (GSController.GetSetting("owned_city_display")%2==1?GSCompany.GetPresidentName(cid):GSCompany.GetName(cid) )+ "]";
		
		if(GSController.GetSetting("owned_city_display")<3)
		{
			GSTown.SetName(town , GSTown.GetName(town)+" "+txt);
			companies.comp[cid].sign <- null;
		}
		else
		{
				local sign = GSSign.BuildSign(GSTown.GetLocation(town), txt);
				companies.comp[cid].sign <- sign;
				//trace(3,"le sign "+ companies.comp[cid].sign);
		}

		//Create a new company goal
		trace(4,"goaltxt = "+ GSText.STR_CLAIMMODE_TOWNGOAL + "goalval = "+ companies.goalval);

		if(companies.goalval!=null) // in case no goal (no cargo to unlock)
		{
			local gtxt=GSText(GSText.STR_CLAIMMODE_TOWNGOAL,town,companies.goalval);
			companies.comp[cid].goal <- GSGoal.New(cid,gtxt,GSGoal.GT_COMPANY,cid);
		}
	}
	
	
	
	// endorse HQ Removal
	function endorse_RemoveHQ(cid)
	{
		if(GSCompany.ResolveCompanyID(cid)==GSCompany.COMPANY_INVALID) return; // n'existe déjà plus...
		trace(4,"Remove HQ for cie:"+ cid);
		companies.comp[cid].HQTile <- GSMap.TILE_INVALID;
		if(companies.comp[cid].etat <10) companies.comp[cid].etat <- 0;
		if(companies.comp[cid].sign!=null && GSSign.IsValidSign(companies.comp[cid].sign))
		{
			// supprimer le sign
			trace(4,"Remove sign "+ companies.comp[cid].sign);
			GSSign.RemoveSign(companies.comp[cid].sign);
			companies.comp[cid].sign <- null ;
		}
		
		local town = companies.comp[cid].town;
		if( GSController.GetSetting("owned_city_display")<3 && town!= null && GSTown.IsValidTown(town))		GSTown.SetName(town , null);

		companies.comp[cid].town <- null ;
		 
		if(companies.comp[cid].goal != GSGoal.GOAL_INVALID)
		{
			trace(4,"Remove goal "+ companies.comp[cid].goal);
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
				GSGoal.SetProgress(data.goal,GSText(GSText.STR_GOAL_PROGRESS,(100*inhab/companies.goalval).tointeger()));
				if(inhab > win_inhab)
				{
					trace(4,"chkCompetition  pop:" + inhab + " -> winner :" + cp);
					winner=cp;
					win_inhab=inhab;
					win_town=data.town;
					trace(1,"Competition result : "+GSCompany.GetName(cp)+" has won the game with population " + inhab +" !");
					//todo : winer_found !!!
				}
			}
		}
		
		if(winner==-1) // no winer
		{
			if (companies.compete_goal == GSGoal.GOAL_INVALID) return; // no goal
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

