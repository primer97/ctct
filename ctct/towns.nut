class towns
{
	_featCargo= []; // list of cargos we want to track deliveries.

	// figures involved in inpact computtion : rate, lindiv (linean divider)
	_cargoRate= {}; // associative array cargo=>rate   , provided by defines.nut
	_cargoDiv= {};  // associative array cargo=>lindiv , provided by defines.nut
	_nbcargo=0;     // count of current cargos

	_prevQty = {};  // history of delivery per town and cargo (associative array) => included in savegame
	_etape = 0;     // step (number of cargo unlocked) - common goals   => included in savegame
	_limites = {};  // limits for each steps               => included in savegame
	_toreach = {};  // count of town to be reached         => included in savegame
	_goals = {};    // current global goals                => included in savegame
	_diffRate =0;   // difficult rate.
	_cargosetRate =1;	// cargoset specific multiplier

	_avg_habparmaison=0; // density : average inhab per house, computed from the whole map.

	_traces="";  // to carry trace information across several methods. (to get one line trace)

	constructor()
	{
	    towns._diffRate <- 100;
		towns._cargosetRate <- 1;
		towns._traces <-"";
		trace(4,"Towns:constructor");
	}

	/**
	 * Initialize cargos information for each town, from define.nut
	 * Called only on new game.
	 */
	function NewGame()	// cette fonction est appelle dans le cas d'une nouvelle partie uniquement
	{
		trace(2,"New Game");
		towns._prevQty <- def_m.GetPrevQtyList();
	}

	/**
	 * Initialize data from define.nut : featured cargos, rate, lindiv, # of unlocked cargos
	 * Unlock cargos if needed, compute density, update town grow rate.
	 * Called at game start, or at gamesave load.
	 */
	function Start(newgame)
	{
		trace(4,"Towns Start");
		towns._featCargo <- def_m.GetFeatCargo();
		towns._nbcargo <- towns._featCargo.len();
		towns._cargoRate <- def_m.GetCargoRate();
		towns._cargoDiv <- def_m.GetCargoDiv();

		towns.updateDiffRate();

		if(towns._etape>0) towns.forwardToExt();
		towns.ComputeAvgHab();
		if(newgame) towns.Update();
	}

	/**
	 * Check and update difficulty rate
	 */
	function updateDiffRate()
	{
		local diff = def_m.GetDifficultyRate();
		if(diff != towns._diffRate)
		{
			towns._diffRate <- diff;
			trace(1,"difficulty rate: cargos at "+towns._diffRate+"%");
		}
	}

	/**
	 * Genuinely create global goals.
	 * populate _limites array. (list of limit to reach to unlock)
	 * populate _toreach array. (number of town to unlock next cargo)
	 *
	 * returns : final goal for a company winner
	 *
	 * Only called at game start, golas are part of save game, no need to call at savegame load.
	 */
	function createGoals()
	{
		local n=def_m.extCargo.len(); // number of cargos waiting...
		if(n<1)
		{
			trace(4,"createGoals : no cargos, no goals !");
			return;
		}
		local nbcarg=towns._featCargo.len(); // receiving nbcarg cargos.
		for(local i=0;i<n;i++)
		{
			local cargo=def_m.extCargo[n-i-1].cargo;
			local lim=towns.calc_lim(i);

			local nbtoreach=min(max(n-i,1),4);
			towns._goals[i+1] <- GSGoal.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_GOAL_GROW,nbtoreach,lim,1<<cargo), GSGoal.GT_NONE, 0);
			towns._limites[i+1] <- lim;
			towns._toreach[i+1] <- nbtoreach;
			trace(4,"createGoals(" + i + ") new Goal set  (lim:" + lim + ", nb_to_reach:" + nbtoreach +")");
		}
		return towns.calc_lim(nbcarg+n+((GSController.GetSetting("Difficulty_level")>5)?1:0));
	}

	/**
	 * Compute a target, from a count of cargo.
	 * take into account settings : unlocking_speed
	 *
	 * returns : target (population)
	 */
	function calc_lim(nbcargo)
	{
		local selectorStep = GSController.GetSetting("Unlocking_speed");
		local step=5000;
		local init=8000;
		switch(selectorStep)
		{
			 case 1: step=3000; init=7000; break;
			 case 2: step=5000; init=8000; break;
			 case 3: step=7000; init=9000; break;
		}
		local calc = init+(nbcargo)*step;
		trace(4,"calc_lim(" + nbcargo + ") step:" + step + ", init: " + init + " computed:" + calc);
		return calc;
	}

	/**
	 * compute density : average from the whole map.
	 * update : _avg_habparmaison
	 */
	function ComputeAvgHab()
	{
		trace(4,"######################### Towns : Avg Inhab/House #########################");
		local all_towns = GSTownList();
		local x=0;
		local nb=0;
		foreach (town, _ in all_towns)
		{
			x += GSTown.GetPopulation(town) / GSTown.GetHouseCount(town).tofloat();
			nb++;
		}
		towns._avg_habparmaison <- x / nb;
		trace(4,"map avg :"+towns._avg_habparmaison);
	}

	/**
	 * Update the grow rate for every towns
	 */
	function Update()
	{
		trace(4,"######################### Towns : Update #########################");
		local all_towns = GSTownList();
		foreach (town, _ in all_towns)
		{
			towns.CheckTown(town);
		}
	}

	/**
	 * returns level (0 to 6) based upon impact figure
	 * 0-150:1   150-400:2   400-1000:3   1000-2000:4(good)   2000-4000:5   4000-...:6
	 */
	function impactlevel(imp)
	{
		if(imp==0)   return 0; // none
		if(imp<150)  return 1; // vlow
		if(imp<400)  return 2; // low
		if(imp<1000) return 3; // medium
		if(imp<2000) return 4; // good/well
		if(imp<4000) return 5; // high
		return 6;              // vhigh
	}

	function getLevelTxt(lvl,cargos)
	{
		switch(lvl)
		{
		case 0:		return GSText(GSText.STR_IMP_NONE,cargos);
		case 1:		return GSText(GSText.STR_IMP_VLOW,cargos);
		case 2:		return GSText(GSText.STR_IMP_LOW,cargos);
		case 3:		return GSText(GSText.STR_IMP_MED,cargos);
		case 4:		return GSText(GSText.STR_IMP_GOOD,cargos);
		case 5:		return GSText(GSText.STR_IMP_HIGH,cargos);
		case 6:		return GSText(GSText.STR_IMP_VHIGH,cargos);
		}
	}

	function CheckTown(town)
	{
		local info = GSTown.GetName(town);

		local impact=0;
		local levels= {};    // cargos per level of quality
		local bonus=0;	     // number of delivered cargos (for bonus)
		local debug="calc>"; // for debug trace

		foreach (cargo in towns._featCargo) // for each featured cargos
		{
			towns._traces <- "";
			local del=towns.DeliveredCargo(town,cargo,impact); // compute delivered qty and keep delivered history
			local imp=towns.calcImpact(cargo,del); 	// compute cargo delivery impact.
			local lvl=towns.impactlevel(imp);			// compute effect level for that impact
			local c=1<<cargo;
			if(levels.rawin(lvl)) levels[lvl]+=c;
			else levels[lvl] <- c;
			if(towns._traces!="") trace(3,towns._traces);

			if(lvl>1)bonus++;
			impact+=imp;
		}
		towns._traces <- "";
		if(impact>1)
		{
			debug+=" impact:"+impact;
			if(GSTown.IsCity(town))
			{
				impact*=1.6; // 60% bonus for cities
				impact=impact.tointeger();
				debug+="  [city bonus +60%]:"+impact;
			}
		}
		local bonusMsg=null;
		bonusMsg=GSText(GSText.STR_NOBONUS, "");
		if(bonus>2)
		{
			local nbcargo=towns._featCargo.len();
			local bonusboost=towns.CalcBoostBonus(bonus,nbcargo)
			if(bonusboost>0)
			{
				bonusMsg=GSText(GSText["STR_BONUS"+bonus],nbcargo);
				impact+=bonusboost;
				debug+="  [bonus boost +"+bonusboost+"]";
			}
		}

		impact*=1.2*towns._diffRate/100;

		impact=impact.tointeger();
		if(towns._diffRate!=1) debug+="  * Difficulty_Rate("+towns._diffRate+"%)";

		if(impact>0)
			towns._traces <- debug + "  final target ===> "+impact;

		local total=towns.MakeTownGrowth(town,impact);

		towns.DisplayTownTexts(town,levels,total,bonusMsg,impact);
		towns._traces <- "";
	}

	function DisplayTownTexts(town,levels,totalhab,bonusMsg,impact)
	{
		local levelinfo= {};
		local nblvl=levels.len();
		local i=0;
		local ii=0;
		while(ii<nblvl)
		{
			if(levels.rawin(i))
				{
				levelinfo[ii++] <- towns.getLevelTxt(i,levels[i]);
				}
			i++;
		}
		// prepare le texte
		local head=GSText((impact==0)? GSText.STR_TOWN_NOT : GSText.STR_TOWN_HEAD);
		local txt=null;
		switch(nblvl)
		{
		case 1:
			txt=GSText(GSText.STR_TOWN_L1,head,levelinfo[0],bonusMsg,totalhab); // 1 + (1+1) + (1+1) = 5 param
			break;
		case 2:
			txt=GSText(GSText.STR_TOWN_L2,head,levelinfo[1],levelinfo[0],bonusMsg,totalhab); // 1 + (1+1)*2 + (1+1) = 7 param
			break;
		case 3:
			txt=GSText(GSText.STR_TOWN_L3,head,levelinfo[2],levelinfo[1],levelinfo[0],bonusMsg,totalhab);
			break;
		case 4:
			txt=GSText(GSText.STR_TOWN_L4,head,levelinfo[3],levelinfo[2],levelinfo[1],levelinfo[0],bonusMsg,totalhab);
			break;
		case 5:
			txt=GSText(GSText.STR_TOWN_L5,head,levelinfo[4],levelinfo[3],levelinfo[2],levelinfo[1],levelinfo[0],bonusMsg,totalhab);
			break;
		case 6:
			txt=GSText(GSText.STR_TOWN_L6,head,levelinfo[5],levelinfo[4],levelinfo[3],levelinfo[2],levelinfo[1],levelinfo[0],bonusMsg,totalhab);
			break;
		}

		GSTown.SetText(town,txt);
	}

function MakeTownGrowth(town,impact)
{
	local inhab = GSTown.GetPopulation(town);
	local maisonact = GSTown.GetHouseCount(town); // nombre de maison actuellement dans cette ville
	if(impact>inhab)
	{ /* croissance */
		local habparmaison = (towns._avg_habparmaison + inhab/maisonact.tofloat())/2; // moyene hab/maison de la ville et de la carte complete
		local need_maison=(impact-inhab)/habparmaison;
		need_maison=max(need_maison.tointeger(),1); // nombre de maisons manquantes
		
		local vtss0=40.0/need_maison; // nombre de construction par mois. :a 80% - comme si on avait 40 jours par mois.
		local vtss=vtss0.tointeger();
		if(vtss<1) vtss=1;//fast, grow every day
		if(vtss>40) vtss=40; // very slow
		
		GSTown.SetGrowthRate(town,vtss); //vtss = Set the amount of days between town growth
		towns._traces <- towns._traces + "  Require "+(impact-inhab)+" inhab ("+need_maison+" houses), growthRate set to a new house every "+vtss+" day(s)";
		trace(4,towns._traces);

		if(vtss<3 && need_maison> 6)
		{
			local newmaison=need_maison*0.33; // do not build all houses at once, limit to 33%
			newmaison=max(1,newmaison.tointeger());
			GSTown.ExpandTown(town,newmaison);
			trace(4,"Need a power boost, immediate building of "+newmaison+" house. inhab/house:"+habparmaison);
		}
		return GSText(GSText.STR_TOWN_GROW,impact);
	}
	else
	{ /* not growing */
		if(towns._traces!="") trace(4,towns._traces + "  (Stalled)");
		towns.townStalled(town); // prevent town from growing
		stab_m.checkNoDecreasing(town,maisonact); // check if anyone destroyed a bloc, and rebuild to void decreasing
		return GSText(GSText.STR_TOWN_NOGROW,impact);
	}

}

	/**
	 * This town should not grow.
	 */
	function townStalled(town)
	{
		local infinity = "TOWN_GROWTH_NONE" in GSTown ? GSTown.TOWN_GROWTH_NONE : 30000;
		GSTown.SetGrowthRate(town, infinity); // ottd 1.3 -> grow every 1000 years => not growing
	}

	/**
	 * Compute impact for that cargo type,
	 * cargo : the cargoid
	 * del : delivered quantity
	 */
	function calcImpact(cargo,del)
	{
		if(del<=0) return 0;

		local i=0;
		local div=towns._cargoDiv[cargo]; // divider for linear part
		local rate=towns._cargoRate[cargo]; // gobal rate
		local cst=100+(rate*10); // static linear boost
		i=(log(del/5)*100+del/div)*rate*towns._cargosetRate; //log neper
		i=cst+i.tointeger();
		if(i<1)
		{
			i=1;
		}
		if(GSController.GetSetting("log_level")>=4)
			towns._traces <- towns._traces + " compute:[rate "+rate+", gsrate "+towns._cargosetRate+", lin.div "+div+"] ==> "+i;
		return i;
	}

	function DeliveredCargo(town, cargo,townnameshown)
	{
		local amount = 0;
		for(local company_id = GSCompany.COMPANY_FIRST; company_id < GSCompany.COMPANY_LAST; company_id++)
		{
			amount +=  GSCargoMonitor.GetTownDeliveryAmount(company_id, cargo, town, true);
		}
		// compute and shift history
		local indices = towns._prevQty[town][cargo]; // [0:n-1  1:n-2  2:n-3]
		local q1=indices[0]; // n-1
		local q2=indices[1]; // n-2
		towns._prevQty[town][cargo]<-[amount,q1,q2];  // [0:n   1:n-1  2:n-2]
		local avg=(q1+q2+amount)/3;
		if(avg>0)
		{
		if(townnameshown==0)
			{
				local info = GSTown.GetName(town);
				trace(3,"===================== "+info+" =====================");
			}
		if(GSController.GetSetting("log_level")>=3)
			towns._traces <- "Inbound "+GSCargo.GetCargoLabel(cargo)+" last-delv:["+q2+", "+q1+", "+amount+"] avg:"+ avg;

		}
		return avg;
	}



	// indique dans quel zone de qualite le cargo se situe.
	function zone(qte)
	{
		return min(7,qte/200); // paliers de 200 maintenant.
	}

	function checkNextCargo()
	{
		trace(4,"************************************** Town computation **************************************");
		if(GSController.GetSetting("Cargo_Selector")>2) return; // mode "in game later" uniquement
		trace(3,"nb cargo ext :"+def_m.extCargo.len());
		if(def_m.extCargo.len()==0) return; // plus aucun cargo a ajouter...
		if(towns._limites.len()<=towns._etape)
		{
			trace(2,"Unexpected cargo index to unlock",true);
			return;
		}
		local limite = towns._limites[towns._etape+1];
		local nbtoreach = towns._toreach[towns._etape+1];
		trace(4,"check if "+nbtoreach+" towns reach limit "+limite);

		local all_towns = GSTownList();
		local nbtown=0;
		foreach (town, _ in all_towns)
		{
			if(GSTown.GetPopulation(town)>limite)
				{
				nbtown++;
				trace(4,"- town "+GSTown.GetName(town)+" > limit ("+limite+")");
				}
		}
		if(nbtown>=nbtoreach)
		{
			// current goal is completed
			local annee=GSDate.GetYear(GSDate.GetCurrentDate());
			trace(3,"Update global cargo goal "+ towns._goals[towns._etape+1] +" towns reached, (year "+ annee +")...");
			GSGoal.SetProgress(towns._goals[towns._etape+1],GSText(GSText.STR_GOAL_REACHED,annee));
			GSGoal.SetCompleted(towns._goals[towns._etape+1],true);

			local added=def_m.getNextExtCargo();
			//var_dump("ajout du cargo",added);
			if(added.cargo!=-1)
			{
				towns.extendWithCargo(added.cargo,limite,nbtown,added.rate,added.div,true);
				towns._etape <- towns._etape + 1;
				trace(2,"Step for town-progress : "+towns._etape);
			}
		}
		else
		{
			GSGoal.SetProgress(towns._goals[towns._etape+1],GSText(GSText.STR_GOAL_PROGRESS,(100*nbtown/nbtoreach).tointeger()));
		}
	}

	function forwardToExt()
	{
		local n=0;
		trace(4,"Extend to "+towns._etape);
		while(n<towns._etape)
		{
			trace(4,"Step "+n);
			local added=def_m.getNextExtCargo();
			//var_dump("add cargo",added);
			if(added.cargo!=-1)
			{
				towns.extendWithCargo(added.cargo,0,0,added.rate,added.div,false);
			}
		n++;
		}
	}

	// unlock next cargo, keep trace into _featCargo and update _nbcargo
	// store empty cargo history to all towns, provide cargo rate and divider, notify user
	function extendWithCargo(cargo,limite,nbtown,rate,div,user)
	{
		// notify
		local annee=GSDate.GetYear(GSDate.GetCurrentDate());
		trace(1,"A new cargo is unlocked "+GSCargo.GetCargoLabel(cargo)+", year "+annee);
		if(user)
		{
			local info=GSText(GSText.STR_NEW_CARGO_AVAIL,nbtown,limite,1<<cargo);
			GSNews.Create(GSNews.NT_GENERAL,info,GSCompany.COMPANY_INVALID,GSNews.NR_NONE,0);
		}

		// keep trace and store parameters
		towns._featCargo.append(cargo);
		towns._nbcargo <- towns._featCargo.len(); // nb
		towns._cargoRate[cargo] <- rate;
		towns._cargoDiv[cargo] <- div;


		if(!user) return;

		// store empty cargo history for all towns
		local all_towns = GSTownList();
		foreach (town, _ in all_towns)
		{
			towns._prevQty[town][cargo]<-[0, 0, 0];
		}
	}

	/**
	 *  initiate all empty cargo history (base and ex cargos) for a newly founded town.
	 *  history depth is 3 months
	 */
	function InitiateCargoHist_FoundedTown(town)
	{
		towns._prevQty[town] <- {}; // prepare town structure.
		foreach(cargo in towns._featCargo)
		{
			towns._prevQty[town][cargo]<-[0, 0, 0];
		}
	}

	// check for bonus eligibility, return bonus boost
	function CalcBoostBonus(bonus,nbcargo)
	{
		if(bonus==3 && nbcargo>2 && nbcargo<5)
			{
			return 1500;
			}
		if(bonus==4 && nbcargo>3 && nbcargo<7)
			{
			return 2200;
			}
		if(bonus==5 && nbcargo>4  && nbcargo<8)
			{
			return 3000;
			}
		if(bonus==6 && nbcargo>5 && nbcargo<9)
			{
			return 5000;
			}
		if(bonus==7 && nbcargo>6 && nbcargo<10)
			{
			return 7000;
			}
		if(bonus>=8 && nbcargo>7 && nbcargo<11)
			{
			return 10000;
			}
		return 0;
	}

	// a new touwn, initiate its stabilizer and empty its history.
	function newTown(id)
	{
		trace(3,"New Town "+id);
		towns.InitiateCargoHist_FoundedTown(id) // empty all cargo history
		stab_m.newTown(id);
	}

};

