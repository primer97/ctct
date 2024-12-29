class Def
{
	constructor()
	{
	}
	
	static cargoRate = {}; // une table (associatif) des rates
	static cargoDiv = {}; // une table (associatif) des diviseurs
//	static vectorType= {};
	static extCargo = [];
	static baseCargo = [];
	static isAnalysed = false; // analyze complete, ready to compute ?
//	static isVectorFormed = false;
	
	
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
			//Def.vectorType[v.cargo] <- v.type;
		}
//		Def.isVectorFormed <- true;
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
		trace(1,"Cargos detection and analysis...");
		local climat = GSGame.GetLandscape(); // LT_TEMPERATE, LT_ARCTIC, LT_TROPIC, LT_TOYLAND 
		trace(4,"Climat : " + climat);

		local selector = GSController.GetSetting("Cargo_Selector");
		trace(4,"Cargo Selector : " + selector);

		local lc=GSCargoList();
		foreach(cargo,_ in lc)
		{
			local lab = GSCargo.GetCargoLabel(cargo);
			
			local towneffect=GSCargo.GetTownEffect(cargo);
			
			if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_PASSENGERS)
			{
				Def.baseCargo.append({ cargo=cargo, rate=2.8, div=6});
				trace(3,"BASE cargo> Passengers town Effect: "+lab);
				continue;
			}
			
			if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_MAIL)
			{
				if(selector==2)
				{
					Def.extCargo.append({ cargo = cargo, rate = 2.6, div = 3 });
					trace(3, "EXT cargo> Mail town effect: " + lab);
				}
				else
				{
					Def.baseCargo.append({ cargo = cargo, rate = 2.6, div = 3 });
					trace(3, "BASE cargo> Mail town effect: " + lab);
				}
				continue;
			}

			if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_GOODS || lab=="GOOD")
				{
				if(selector==3)
				{
					Def.baseCargo.append({ cargo=cargo, rate=3, div=2});
					trace(3, "BASE cargo> Goods: "+lab + " = "+ GSCargo.GetName(cargo));
				}
				else
				{
					Def.extCargo.append({ cargo=cargo, rate=3, div=2});
					trace(3, "EXT cargo> Goods: "+lab + " = "+ GSCargo.GetName(cargo));
				}
					continue;
			}

			if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_WATER)
			{
				if(selector==3)
				{
					Def.baseCargo.append({ cargo=cargo, rate=2.5, div=3});
					trace(3, "BASE cargo> Goods: "+lab + " = "+ GSCargo.GetName(cargo));
				}
				else
				{
					Def.extCargo.append({ cargo=cargo, rate=2.5, div=3});
					trace(3, "EXT cargo> Water town effect: "+lab + " = "+ GSCargo.GetName(cargo));
					continue;
				}
			}

			if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_FOOD || lab=="FOOD")
			{
				if(selector==3)
				{
					Def.baseCargo.append({ cargo=cargo, rate=3, div=8});
					trace(3, "BASE cargo> Goods: "+lab + " = "+ GSCargo.GetName(cargo));
				}
				else
				{
					Def.extCargo.append({ cargo=cargo, rate=3, div=8});
					trace(3, "EXT cargo> Food: "+lab + " = "+ GSCargo.GetName(cargo));
				}
				continue;
			}

			if(lab=="VALU" || lab=="GOLD" || lab=="DIAM")
			{
				Def.extCargo.append({ cargo=cargo, rate=4.5, div=2});
				trace(3,"EXT cargo> Bank item: "+lab + " = "+ GSCargo.GetName(cargo));
				continue;
			}
			if(lab=="BDMT")
			{
				Def.extCargo.append({ cargo=cargo, rate=3, div=7});
				trace(3,"EXT cago> BuildMat: "+lab + " = "+ GSCargo.GetName(cargo));
				continue;
			}
			if(lab=="BEER")
			{
				Def.extCargo.append({ cargo=cargo, rate=3.5, div=7});
				trace(3,"EXT cargo> Alcohol: "+lab + " = "+ GSCargo.GetName(cargo));
				continue;
			}
			if(lab=="FRVG" || lab=="FRUT")
			{
				Def.extCargo.append({ cargo=cargo, rate=3, div=7});
				trace(3,"EXT cargo> Fruit: "+lab + " = "+ GSCargo.GetName(cargo));
				continue;
			}
			if(lab=="VEHI") //ECS
			{
				Def.extCargo.append({ cargo=cargo, rate=3, div=7});
				trace(3,"EXT cargo> Vehicule: "+lab + " = "+ GSCargo.GetName(cargo));
				continue;
			}
			if(lab=="FMSP")  // ECS arctic
			{
				Def.extCargo.append({ cargo=cargo, rate=3, div=7});
				trace(3,"EXT cargo> Farm Supply: "+lab + " = "+ GSCargo.GetName(cargo));
				continue;
			}
//			if(GSCargo.IsValidTownEffect(cargo)) //--futur
//			{
//				Def.extCargo.append({ cargo=cargo, rate=3, div=7});
//				trace(3,"EXT cargo> other towneffect: "+lab);
//				continue;
//			}
			// + "Name:"+ GSCargo.GetName(cargo)
			trace(4,"Unaffected "+lab+" cargo ("+cargo+") effect:"+towneffect);
		}
		trace(3,"-----------------------------------");
	} //note : re-order sequence, use sort() as https://developer.electricimp.com/squirrel/array/sort

	function getNextExtCargo()
	{
		trace(4,"Request for next ext cargo...");
		//var_dump("ext:",Def.extCargo);
		if(Def.extCargo.len()<1) return {cargo=0};
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
//		if(!Def.isVectorFormed) Def.GetFeatCargo();
		return Def.cargoRate;
	}
function GetCargoDiv()
{
//todo check is init ?
///	if(!Def.isVectorFormed) Def.GetFeatCargo();
	return Def.cargoDiv;
}

function GetDifficultyRate()
	{
	switch(GSController.GetSetting("Difficulty_level"))
		{
		case 1: return 1.75;
		case 2: return 1.5;
		case 3: return 1.35;
		case 4: return 1.2;
		case 5: return 1.0;
		case 6: return 0.85;
		case 7: return 0.7;
		default: return 1;
		}
	}
}