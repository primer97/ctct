class companies
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
    winner_txt="";
	constructor()
	{
	}
	function SetGoalVal(val)
	{
		if(val==null)
		{
			trace(4,"Can't set any Company Goal...");
			return;
		}
		trace(4,"Company Goal, target pop = " + val );
		companies.goalval<-val;
	}
	
	function NewCompany(cid)
	{
		//TODO : controler si cid n'a pas deja ete utilise par le passe ?
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
		if(GSGame.IsPaused())
			return;

		trace(4,"Check HQ...");
		foreach(cid, company in companies.comp) 
		{
			local HQ = GSCompany.GetCompanyHQ(cid);
			if(HQ != company.HQTile) // HQ change
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
				if(cp != cid && data.town == reqtown) return false; // deja occupe par un autre !
			}
		trace(4,"Claimed town is free");
		return true;
	}
	
	
	// endorse new HQ location : create sign, create goal, store location...
	function endorse_PlaceHQ(cid, tile)
	{
		if(GSCompany.ResolveCompanyID(cid)==GSCompany.COMPANY_INVALID) return; //la companie a place son HQ juste avant de mourir :) - faut-il essayer de nettoyer .comp[cid] ?

		companies.comp[cid].HQTile <- tile; // store location (tile)
		companies.comp[cid].etat <- 1;

		local town = GSTile.GetClosestTown(GSCompany.GetCompanyHQ(cid));
		companies.comp[cid].town <- town;
		trace(1,GSTown.GetName(town)+" is now claimed by "+GSCompany.GetName(cid)+", pop:"+GSTown.GetPopulation(town));

		local txt= "["+ (GSController.GetSetting("owned_city_display")%2==1?GSCompany.GetPresidentName(cid):GSCompany.GetName(cid) )+ "]";

		if(town!=null) // place a sign at claimed city
		{
			if(GSController.GetSetting("owned_city_display")<3)
			{
				GSTown.SetName(town , GSTown.GetName(town)+" "+txt);
				companies.comp[cid].sign <- null;
			}
			else
			{
					local sign = GSSign.BuildSign(GSTown.GetLocation(town), txt);
					companies.comp[cid].sign <- sign;
			}
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
		if(GSCompany.ResolveCompanyID(cid)==GSCompany.COMPANY_INVALID) return; // n'existe deja plus...
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
			if(data.etat==1) // a HQ have been set
			{
				local inhab=GSTown.GetPopulation(data.town);
				GSGoal.SetProgress(data.goal,GSText(GSText.STR_GOAL_PROGRESS,(100*inhab/companies.goalval).tointeger()));
				if(inhab > win_inhab)
				{
					trace(4,"chkCompetition  pop:" + inhab + " -> current leader :" + cp);
					winner=cp; //leader
					win_inhab=inhab;
					win_town=data.town;
				}
			}
		}
		
		if(winner==-1) // no winer
		{
			companies.winner_txt <- "";
			if (companies.compete_goal == GSGoal.GOAL_INVALID) return; // no goal
			GSGoal.Remove(companies.compete_goal);
			companies.compete_goal <- GSGoal.GOAL_INVALID;
			return;
		}
		companies.winner_txt <- "Competition result : "+GSCompany.GetName(winner)+" leads the game with population " + win_inhab +" !";
		trace(2, companies.winner_txt);
		//todo : end_of_game_winer_set !!!

		//update global goal.
		GSGoal.Remove(companies.compete_goal);
		companies.compete_goal <- GSGoal.GOAL_INVALID;
		local prc=(100*win_inhab/companies.goalval).tointeger();
		companies.compete_goal <- GSGoal.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_CLAIMMODE_COMPETITION,winner,win_town,prc), GSGoal.GT_NONE, 0);
		//GSGoal.SetProgress(towns._goals[towns._etape+1],GSText(GSText.STR_GOAL_REACHED));
	}

	function reportCompetition(year)
	{
		if(companies.winner_txt != "")
			trace(1, year + " : "+ companies.winner_txt);
		else
			trace(1, year + " : competition didn't started yet...");
	}
};

