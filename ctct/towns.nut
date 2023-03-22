class towns
{
	_featCargo= []; // la liste des cargo interessants
	_cargoRate= {}; // la table (asociatif) cargo=>rate
	_vectorType= {}; // la table (asso) cargo=> n� vecteur
	_VectCst= {}; // la table de vecteur des constantes
	_VectAlpha = {}; // la table de vecteur des coef
	_nbcargo=0; // le nombre de cargo
	_prevQty = {}; // l'historique des livraisons par ville et cargo.=> fait partie de la sauvegarde (V1)
	_etape = 0; // etape d'evolution de croissance de la ville. 	 => fait partie de la sauvegarde (V1)
	_limites = {}; // les limites pour chacunes des �tapes			 => fait partie de la sauvegarde (V3)
	_toreach = {}; // le nombre de ville o� la limite dois �tre atteinte => fait partie de la sauvegarde (V3)
	_goals = {};   // les goals (globaux) en cours 					 => fait partie de la sauvegarde (V3)
	_diffRate =0; // difficult rate.
	_avg_habparmaison=0; // nombre d'habitant par maison, en moyenne, sur toute la carte...
	
	constructor()
	{
	towns._diffRate <- 1;
	}


function NewGame()	// cette fonction est appell� dans le cas d'une nouvelle partie uniquement
{
	trace(2,"New Game");
	towns._prevQty <- def_m.GetPrevQtyList();
//	var_dump("prevQty",towns._prevQty);
}

function Start(newgame)	// cette fonction est appell� au chargement de la sauvegarde ou dans le cas d'une nouvelle partie
{
	trace(2,"Towns Start");
	towns._featCargo <- def_m.GetFeatCargo();
	towns._nbcargo <- towns._featCargo.len(); // nb
	towns._cargoRate <- def_m.GetCargoRate();
	towns._vectorType <- def_m.GetVectorType();
	
	towns._VectCst[1] <- def_m.GetVectCst80();
	towns._VectCst[2] <- def_m.GetVectCst70();
	towns._VectCst[3] <- def_m.GetLVectCst();
	
	towns._VectAlpha[1] <- def_m.GetVectAlpha80();
	towns._VectAlpha[2] <- def_m.GetVectAlpha70();
	towns._VectAlpha[3] <- def_m.GetLVectAlpha();
	
	towns.updateDiffRate();
	
	if(towns._etape>0) towns.forwardToExt();
	towns.ComputeAvgHab();
	if(newgame) towns.Update();
}

function updateDiffRate()
{
	local diff = def_m.GetDifficultyRate();
	if(diff != towns._diffRate)
	{
		towns._diffRate <- diff;
		trace(1,"difficulty rate :"+towns._diffRate);
	}
}

function createGoals() // cette fonction est appell� pour cr�er les goals, elle est lanc� au lancement d'une nouvelle partie uniquement. (les goals sont sauvegard� tout seul)
{					// cette fonction calcule _limite et _toreach
	local n=def_m.extCargo.len(); // le nombre de cargo en attente
	if(n<1) 
	{
		trace(4,"createGoals : pas de cargo! pas de goal");
		return; // pas de cargo en attente...
	}
	local nbcarg=towns._featCargo.len(); // nombre de cargo en cours de reception.
	var_dump("Liste des cargos etendus :",def_m.extCargo);
	for(local i=0;i<n;i++)
	{
		local cargo=def_m.extCargo[n-i-1].cargo;
		local lim=towns.calc_lim(nbcarg+i);
		local quick=GSController.GetSetting("Quicker_Achivement");
		if(quick)
		{
			local niv=GSController.GetSetting("Difficulty_level");
			local div=3; 
			if(niv<4) div=4;
			trace(3,"Quick_Achivement mode, cargo goal divided by " + div );
			lim = lim / div;
		}
		
		local nbtoreach=min(max(n-i,1),4);
		towns._goals[i+1] <- GSGoal.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_GOAL_GROW,nbtoreach,lim,1<<cargo), GSGoal.GT_NONE, 0);
		towns._limites[i+1] <- lim;
		towns._toreach[i+1] <- nbtoreach;
		trace(4,"createGoals(" + i + ") Goal cr��  (lim:" + lim + ", nb_to_reach:" + nbtoreach +")");
	}
	return towns.calc_lim(nbcarg+n+((GSController.GetSetting("Difficulty_level")>5)?1:0));
}

function calc_lim(nbcargo) // calcules les limites pour debloquer un cargo (glob goal) : 3k, 7k, 11k, 16k, 21k, 27k, 33k, 40k.
{
	local n4=max(min(nbcargo,3)-1,0); // nombre de cargo dont le coef est 4k
	local n5=max(min(nbcargo,5)-3,0); // nombre de cargo dont le coef est 5k
	local n6=max(min(nbcargo,7)-5,0); // nombre de cargo dont le coef est 6k
	local n7=max(min(nbcargo,15)-7,0); // nombre de cargo dont le coef est 7k
	trace(4,"calc_limit(" + nbcargo +") crt4:"+ n4 +", crt5:"+ n5 +", crt6:"+ n6 +", crt7:"+ n7);
	return 3000+4000*n4+5000*n5+6000*n6+7000*n7;
}

// calcule le nombre d'habitant par maison, en faisant la moyenne sur toute la carte.
// met � jour la var : _avg_habparmaison
function ComputeAvgHab()
{
	trace(2,"######################### Towns : Avg Inhab/House #########################");
	local all_towns = GSTownList();
	local x=0;
	local nb=0;
	foreach (town, _ in all_towns)
	{
		x += GSTown.GetPopulation(town) / GSTown.GetHouseCount(town).tofloat();
		nb++;
	}
	towns._avg_habparmaison <- x / nb;
	trace(3,"map avg :"+towns._avg_habparmaison);
}

// mets � jour les taux de croissances des villes
function Update()
{
	trace(2,"######################### Towns : Update #########################");
	local all_towns = GSTownList();
	foreach (town, _ in all_towns)
	{
		towns.CheckTown(town);
	}
}
function impactlevel(imp) //0-150:1   150-400:2   400-1000:3   1000-2000:4(good)   2000-4000:5   4000-...:6
{
	if(imp==0) return 0; // none
	if(imp<150) return 1; // vlow
	if(imp<400) return 2; // low
	if(imp<1000) return 3; // medium
	if(imp<2000) return 4; // good/well
	if(imp<4000) return 5; // high
	return 6; // vhigh
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
	//trace(5,"===================== "+info+" =====================");

	local impact=0;
	local levels= {}; // les cargo par niveau de qualit�
	local bonus=0;	// le nombre de cargo livr� (pour le calcul du bonus)
	
	foreach (cargo in towns._featCargo) // calcul pour chacun des cargos
	{
		local del=towns.DeliveredCargo(town,cargo,impact); // compute delivered qty and keep delivered history
		local imp=towns.calcImpact(cargo,del)*towns._cargoRate[cargo]; 	// calcule l'effet de cette livraison
		local lvl=towns.impactlevel(imp);								// calcule le niveau de l'effet
		local c=1<<cargo;
		if(levels.rawin(lvl)) levels[lvl]+=c;
		else levels[lvl] <- c;

		if(lvl>1)bonus++;
		impact+=imp.tointeger();
		if(imp>1) trace(3," cargo "+GSCargo.GetCargoLabel(cargo)+ "("+cargo+") del:"+del+" at rate x"+towns._cargoRate[cargo]+" = impact:"+imp+" (lvl:"+lvl+")");
	}
	if(impact>1)
	{
		trace(2," global impact:"+impact);
		if(GSTown.IsCity(town)) 
		{
			impact*=1.6; // bonus de 60% pour les "city"
			impact=impact.tointeger();
			trace(2," +60% city bonus, new impact:"+impact);
		}
	}
	local bonusMsg=null;
	bonusMsg=GSText(GSText.STR_NOBONUS,0);
	if(bonus>2)
	{
		local nbcargo=towns._featCargo.len();
		local lebonus=towns.DoBonus(bonus,nbcargo)
		if(lebonus>0)
		{
			bonusMsg=GSText(GSText["STR_BONUS"+bonus],nbcargo);
			impact+=lebonus;
			trace(3," +Bonus impact, new impact:"+impact);
		}
	}
	
	impact*=towns._diffRate;
	
	impact=impact.tointeger()
	
	if(impact>0 && towns._diffRate!=1)
		trace(3," with "+ towns._diffRate+ " difficulty rate, final impact:"+impact);
		
	local total=towns.MakeTownGrowth(town,impact);

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
		txt=GSText(GSText.STR_TOWN_L1,head,levelinfo[0],bonusMsg,total); // 1 + (1+1) + (1+1) = 5 param
		break;
	case 2:
		txt=GSText(GSText.STR_TOWN_L2,head,levelinfo[1],levelinfo[0],bonusMsg,total); // 1 + (1+1)*2 + (1+1) = 7 param
		break;
	case 3:
		txt=GSText(GSText.STR_TOWN_L3,head,levelinfo[2],levelinfo[1],levelinfo[0],bonusMsg,total);
		break;
	case 4:
		txt=GSText(GSText.STR_TOWN_L4,head,levelinfo[3],levelinfo[2],levelinfo[1],levelinfo[0],bonusMsg,total);
		break;
	case 5:
		txt=GSText(GSText.STR_TOWN_L5,head,levelinfo[4],levelinfo[3],levelinfo[2],levelinfo[1],levelinfo[0],bonusMsg,total);
		break;
	case 6:
		txt=GSText(GSText.STR_TOWN_L6,head,levelinfo[5],levelinfo[4],levelinfo[3],levelinfo[2],levelinfo[1],levelinfo[0],bonusMsg,total);
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
		local habparmaison = (towns._avg_habparmaison + inhab/maisonact.tofloat())/2; // moyene avec la valeur de la carte
		local maison=(impact-inhab)/habparmaison;
		maison=max(maison.tointeger(),1); // nombre de maisons manquantes
		local vtss0=40.0/maison; // nombre de construction par mois. :� 80%
		local vtss=vtss0.tointeger();
		if(vtss<1) vtss=1;
		if(vtss>40) vtss=40;
		
		GSTown.SetGrowthRate(town,vtss);
		if(vtss<3 && maison> 6)
		{
			local newmaison=maison*0.33; // ne construit pas toutes les maisons d'un coup... seulement 1/3
			newmaison=max(1,newmaison.tointeger());
			GSTown.ExpandTown(town,newmaison);
			trace(4,maison+"need a boost, immediate building of "+newmaison+" house. inhab/house:"+habparmaison);
		}
		trace(4,"impact:"+impact +", -> town expansion: "+vtss0+" rounded to :"+vtss);
		return GSText(GSText.STR_TOWN_GROW,impact);
	}
	else
	{ /* ne crois pas */
		towns.townStalled(town); // empeche la croissance de cette ville.
		stab_m.checkNoDecreasing(town,maisonact); // controle si qq a detruit un bloc de ville, le reconstruit pour eviter qu'elle diminue...
		return GSText(GSText.STR_TOWN_NOGROW,impact);
	}

}

// cette ville ne doit pas croitre.
function townStalled(town)
{
	local infinity = "TOWN_GROWTH_NONE" in GSTown ? GSTown.TOWN_GROWTH_NONE : 30000;
	GSTown.SetGrowthRate(town, infinity); // ottd 1.3 -> grow every 1000 years => not growing
}

function calcImpact(cargo,del)
{
	if(del<=0) return 0;
	local z=towns.zone(del);
	local i=0;
	switch(towns._vectorType[cargo])
	{
	case 1: // std curve 70%
		i= del*towns._VectAlpha[1][z]+towns._VectCst[1][z];
		trace(5," cal_type_1 (lvl "+z+"): "+del+" * "+towns._VectAlpha[1][z]+" + "+towns._VectCst[1][z] +" = "+i);
		break;
	case 2: // std curve 80%
		i= del*towns._VectAlpha[2][z]+towns._VectCst[2][z];
		trace(5," cal_type_2 (lvl "+z+"): "+del+" * "+towns._VectAlpha[2][z]+" + "+towns._VectCst[2][z] +" = "+i);
		break;
	case 3: // lin 50% + curve 80%
		i= del*towns._VectAlpha[3][z]+towns._VectCst[3][z];
		trace(5," cal_type_3 (lvl "+z+"): "+del+" * "+towns._VectAlpha[3][z]+" + "+towns._VectCst[3][z] +" = "+i);
		break;
	}
	return i;
}

function DeliveredCargo(town, cargo,townnameshown)
{
	local amount = 0;
	for(local company_id = GSCompany.COMPANY_FIRST; company_id < GSCompany.COMPANY_LAST; company_id++)
	{
		amount +=  GSCargoMonitor.GetTownDeliveryAmount(company_id, cargo, town, true);
	}
	// compute and shit
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

		trace(3," hist("+cargo+")  n:"+amount+" n-1:"+q1+" n-2:"+q2+"  -->  avg:"+ avg);
//		if(GSController.GetSetting("log_level")>3)
//			var_dump("qty c:"+cargo,towns._prevQty[town][cargo]);
	}
	return avg;
}



// indique dans quel zone de qualit� le cargo se situe.
function zone(qte)
{
	return min(7,qte/200); // paliers de 200 maintenant.
}

function checkNextCargo()
{
	trace(2,"************************************** Town computation **************************************");
	if(GSController.GetSetting("Cargo_Selector")>2) return; // mode "in game later" uniquement
	trace(3,"nb cargo ext :"+def_m.extCargo.len());
	if(def_m.extCargo.len()==0) return; // plus aucun cargo � ajouter...
	local limite = towns._limites[towns._etape+1];
	local nbtoreach = towns._toreach[towns._etape+1];
	trace(3,"check if "+nbtoreach+" towns reach limit "+limite);
	
	local all_towns = GSTownList();
	local nbtown=0;
	foreach (town, _ in all_towns)
	{
		if(GSTown.GetPopulation(town)>limite)
			{
			nbtown++;
			trace(3,"- town "+GSTown.GetName(town)+" > limit ("+limite+")");
			}
	}
	if(nbtown>=nbtoreach)
	{
		// on doit passer � l'etape suivante...
		if(isVer14()) // ok goal version 1.4+
		{
			local annee=GSDate.GetYear(GSDate.GetCurrentDate());
			trace(3,"Mise � jour du goal "+ towns._goals[towns._etape+1] +", ann�e "+ annee +"...");
			GSGoal.SetProgress(towns._goals[towns._etape+1],GSText(GSText.STR_GOAL_REACHED,annee));
			GSGoal.SetCompleted(towns._goals[towns._etape+1],true);
		}		
		local added=def_m.getNextExtCargo();
		var_dump("ajout du cargo",added);
		if(added.cargo)
		{
			towns.extendWithCargo(added.cargo,limite,nbtown,added.rate,added.type,true);
			towns._etape <- towns._etape + 1;
			trace(2,"Step for town-progress : "+towns._etape);
		}
	}
	else
	{
	if(isVer14()) 
		{
			GSGoal.SetProgress(towns._goals[towns._etape+1],GSText(GSText.STR_GOAL_PROGRESS,(100*nbtown/nbtoreach).tointeger()));
		}
	}
}

function forwardToExt()
{
	local n=0;
	trace(3,"Extend to "+towns._etape);
	while(n<towns._etape)
	{
		trace(3,"Step "+n);
		local added=def_m.getNextExtCargo();
		var_dump("add cargo",added);
		if(added.cargo)
		{
			towns.extendWithCargo(added.cargo,0,0,added.rate,added.type,false);
		}
	n++;
	}
}

function extendWithCargo(cargo,limite,nbtown,rate,type,user)
{
	local info=GSText(GSText.STR_NEW_CARGO_AVAIL,nbtown,limite,1<<cargo);
	if(user) GSNews.Create(GSNews.NT_GENERAL,info,0);

	towns._featCargo.append(cargo);
	var_dump("featcargo",towns._featCargo);
	towns._nbcargo <- towns._featCargo.len(); // nb
	towns._cargoRate[cargo] <- rate;
	towns._vectorType[cargo] <- type;
	if(!user) return;
	local all_towns = GSTownList();
	foreach (town, _ in all_towns)
	{
		towns._prevQty[town][cargo]<-[0, 0, 0];
	}
}

function DoBonus(bonus,nbcargo)
{
	trace(3,"check for bonus eligibility ? b="+bonus+" cargo#:"+nbcargo);
	if(bonus==3 && nbcargo>2 && nbcargo<5)
		{
		return 1000;
		trace(2,"bonus3");
		}
	if(bonus==4 && nbcargo>3 && nbcargo<7)
		{
		return 1000;
		trace(2,"bonus4");
		}
	if(bonus==5 && nbcargo>4  && nbcargo<8)
		{
		return 2000;
		trace(2,"bonus5");
		}
	if(bonus==6 && nbcargo>5 && nbcargo<9)
		{
		return 3000;
		trace(2,"bonus6");
		}
	if(bonus==7 && nbcargo>6 && nbcargo<10)
		{
		return 4000;
		trace(2,"bonus7");
		}
	if(bonus==8 && nbcargo>7 && nbcargo<11)
		{
		return 5000;
		trace(2,"bonus8");
		}
	return 0;
}

// une nouvelle ville
function newTown(id)
{
	trace(3,"New Town "+id);
	towns._prevQty[id] <- def_m.initCargo();
	stab_m.newTown(id);
}

};

