class Def
{
	constructor()
	{
	}
	
	static cargoRate = {}; // une table (associatif) des rates
	static cargoDiv = {}; // une table (associatif) des diviseurs
	static extCargo = [];
	static baseCargo = [];
	static isAnalysed = false; // analyze complete, ready to compute ?

	function Ready() // ready to compute cargos ?
	{
		return Def.isAnalysed;
	}
	
/* ==== La liste des villes ==== */
	function GetTowns()
	{
		local r = [];
		local all_towns = GSTownList();
		foreach (town, _ in all_towns)
		{
			r.append(town);
		}
		return r;
	}

	
/* ==== Les cargos interressants ==== */
	function GetFeatCargo()
	{
		Def.checkAnalysed();
		local cargos = [];
		foreach(k,v in Def.baseCargo)
		{
			cargos.append(v.cargo);
			Def.cargoRate[v.cargo] <- v.rate;
			Def.cargoDiv[v.cargo] <- v.div;
		}
		return cargos;
	}

	// effectue l'analyse de base des cargos si besoin.
	function checkAnalysed()
	{
	if(!Def.isAnalysed)
		{
		Def.isAnalysed <- true;
		Def.AnalyseCargo();
		}
	}
	
	function AnalyseCargo()
	{
		cs_mgr.guess();

		Def.infoCargos();

		return;
		// possible methods on Def.extCargo :
		// .len() , .append()=push(), .insert(), .extend(merge), .pop(), .top(), .remove(), .sort(), .reverse(), .slice(), .clear(), .map, .apply, .reduce, .filter, .find
		//note : re-order sequence, use sort() as https://developer.electricimp.com/squirrel/array/sort
	}


	function infoCargos()
	{

		local more=GSController.GetSetting("log_level")>=4 ? true : false;

		if(GSController.GetSetting("log_level")>=3)
		{
			trace(3, Def.baseCargo.len() + " cargos already unlocked :")
			foreach(cargo,obj in Def.baseCargo)
			{
				trace(3, " - " + (obj.cargo<10 ? " ":"") + obj.cargo + ": " + GSCargo.GetCargoLabel(obj.cargo) + (more ?" (rate :"+obj.rate + " div:"+ obj.div+")" : ""));
			}
			trace(3, Def.extCargo.len() + " cargos to unlock :")
			foreach(cargo,obj in Def.extCargo)
			{
				trace(3, " - " + (obj.cargo<10 ? " ":"") + obj.cargo + ": " + GSCargo.GetCargoLabel(obj.cargo) + (more ? " (rate :"+obj.rate + " div:"+ obj.div+")" : ""));
			}
		}

		if(more)
		{
			trace(4,"CargoSet Full list :");
			local lc=GSCargoList();
			foreach(cargo,_ in lc)
			{
				local lab = GSCargo.GetCargoLabel(cargo);
				local te=GSCargo.GetTownEffect(cargo);
				trace(4," - "+ (cargo<10 ? " ":"") + cargo + ": "+lab+" " + (te ? "[TE]":"....") + " '"+ GSCargo.GetName(cargo)+"'");
			}
		}
	}
	function getNextExtCargo()
	{
		trace(4,"Request for next ext cargo...");
		//var_dump("ext:",Def.extCargo);
		if(Def.extCargo.len()<1) return {cargo=-1};
		local x= Def.extCargo.pop();
		return x;
	}
	
	function GetPrevQtyList()
	{
		Def.checkAnalysed();
		local r = {};
		local all_towns = GSTownList();
		foreach (town, _ in all_towns)
		{
			r[town] <- Def.initCargo();
		}
		return r;
	}
	
	// retourne la liste des historiques initiale pour une ville : pour chaque cargo et chaque histo.
	function initCargo()
	{
		local c= {};
		foreach(cargo in Def.baseCargo)
		{
			local mois =[0, 0, 0];
			c[cargo.cargo] <- mois;
		}
		return c;
	}
	
function GetCargoRate()
	{
	//todo check is init ?
		return Def.cargoRate;
	}
function GetCargoDiv()
{
//todo check is init ?
	return Def.cargoDiv;
}

function GetDifficultyRate()
	{
	switch(GSController.GetSetting("Difficulty_level"))
		{
		case 1: return 1.75; // +46%   //todo : change rate 150
		case 2: return 1.5;  // +25%                        125
		case 3: return 1.35; // + 12.5 %                    115
		case 4: return 1.2;  // normal difficulty           100
		case 5: return 1.0;  // -16%                         85
		case 6: return 0.85; // -29%                         75
		case 7: return 0.7;  // -41%                         60
		default: return 1;
		}
	}
}