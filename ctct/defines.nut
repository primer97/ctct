class Def
{
	constructor()
	{
	}
	
	static cargoRate = {}; // une table (associatif)
	static vectorType= {};
	static extCargo = [];
	static baseCargo = [];
	static isAnalysed = false;
	static isVectorFormed = false;
	
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
			Def.vectorType[v.cargo] <- v.type;
		}
		Def.isVectorFormed <- true;
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

/* types								impact pour : tres faible | faible  | moyen   | fort   | tres fort
1 : logarithmique forte (attenué à 70%)                 correct     correct   correct  bas        bas
2 : logarithmique faible (atténué à 80%)                correct     correct   bas      tres bas   tres bas
3 : lineaire faible, puis log forte (70%)               tres bas    tres bas  bas      correct    correct
*/

		local selector = GSController.GetSetting("Cargo_Selector");
		local lc=GSCargoList();
		foreach(cargo,_ in lc)
		{
			local lab = GSCargo.GetCargoLabel(cargo);
			
			local towneffect=GSCargo.GetTownEffect(cargo);
			trace(3,lab+"("+cargo+") effect:"+towneffect);
			
			
			if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_PASSENGERS)
			{
				Def.baseCargo.append({ cargo=cargo, rate=7, type=2});
				trace(2,"BASE> passengers :"+lab);
				continue;
			}
			
			if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_MAIL)
			{
				Def.baseCargo.append({ cargo=cargo, rate=9, type=1});
				trace(2,"BASE> mail :"+lab);
				continue;
			}
			if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_GOODS || lab=="GOOD")
			{
				if(selector==2)
				{
					Def.extCargo.append({ cargo=cargo, rate=9, type=3});
					trace(2,"EXT2> goods :"+lab);
				}
				else
				{
					Def.baseCargo.append({ cargo=cargo, rate=9, type=3});
					trace(2,"BASE> goods :"+lab);
				}
				continue;
			}
			if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_WATER)
			{
				if(selector==2)
				{
					Def.extCargo.append({ cargo=cargo, rate=8, type=1});
					trace(2,"EXT2> water :"+lab);
				}
				else
				{
					Def.baseCargo.append({ cargo=cargo, rate=8, type=1});
					trace(2,"BASE> water :"+lab);
				}
				continue;
			}
			if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_FOOD || lab=="FOOD")
			{
				if(selector==2)
				{
					Def.extCargo.append({ cargo=cargo, rate=9, type=3});
					trace(2,"EXT2> food :"+lab);
				}
				else
				{
					Def.baseCargo.append({ cargo=cargo, rate=9, type=3});
					trace(2,"BASE> food :"+lab);
				}
				continue;
			}
			if(selector<4)
			{
				if(lab=="VALU" || lab=="GOLD" || lab=="DIAM")
				{
					if(selector<=2)
					{
						Def.extCargo.append({ cargo=cargo, rate=14, type=3});
						trace(2,"EXT> bank* :"+lab);
					}
					else
					{
						Def.baseCargo.append({ cargo=cargo, rate=14, type=3});
						trace(2,"BASE> bank* :"+lab);
					}
					continue;
				}
				if(lab=="BDMT")
				{
					if(selector<=2)
					{
						Def.extCargo.append({ cargo=cargo, rate=5, type=3});
						trace(2,"EXT> buildmat :"+lab);
					}
					else
					{
						Def.baseCargo.append({ cargo=cargo, rate=11, type=3});
						trace(2,"BASE> buildmat :"+lab);
					}
					continue;
				}
				if(lab=="BEER")
				{
					if(selector<=2)
					{
						Def.extCargo.append({ cargo=cargo, rate=5, type=3});
						trace(2,"EXT> alcohol :"+lab);
					}
					else
					{
						Def.baseCargo.append({ cargo=cargo, rate=10, type=3});
						trace(2,"BASE> alcohol :"+lab);
					}
					continue;
				}
				if(lab=="FRVG" || lab=="FRUT" ) 
				{
					if(selector<=2)
					{
						Def.extCargo.append({ cargo=cargo, rate=5, type=3});
						trace(2,"EXT> fruit :"+lab);
					}
					else
					{
						Def.baseCargo.append({ cargo=cargo, rate=11, type=3});
						trace(2,"BASE> fruit :"+lab);
					}
					continue;
				}
				if(lab=="VEHI") //ECS
				{
					Def.extCargo.append({ cargo=cargo, rate=6, type=3});
					trace(2,"EXT> Vehicule :"+lab);
					continue;
				}
				if(lab=="FMSP")  // ECS arctic
				{
					Def.extCargo.append({ cargo=cargo, rate=8, type=3});
					trace(2,"EXT> Farm Supply :"+lab);
					continue;
				}

			}
		}
		trace(2,"-----------------------------------");
	}

	function getNextExtCargo()
	{
		trace(4,"request for next ext cargo...");
		var_dump("ext:",Def.extCargo);
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
			local mois =[0, 0, 0]; // dans l'ordre n-2, n-1 et n
			c[cargo.cargo] <- mois;
		}
		return c;
	}
	
function GetCargoRate()
	{
		if(!Def.isVectorFormed) Def.GetFeatCargo();
		return Def.cargoRate;
	}
function GetVectorType()
	{
		if(!Def.isVectorFormed) Def.GetFeatCargo();
		return Def.vectorType;
	}
/* ==== courbe atténuée classique (80%) ==== */	
function GetVectCst80()
	{
		return [0, 40,104,181,263,345,423,497];
	}
function GetVectAlpha80()
	{
		return [1.0, 0.8, 0.64, 0.512, 0.4096, 0.32768, 0.262144, 0.2097152];
	}

	/* ==== courbe atténuée classique (70%) ==== */	
function GetVectCst70()
	{
		return [0,60,144,232,315,387,447,496];
	}
function GetVectAlpha70()
	{
		return [1.0, 0.7,0.49,0.343,0.2401,0.16807,0.117649,0.0823543];
	}

	
	
/* ==== courbe linéaire puis, atténuée ==== */	
function GetLVectCst()
	{
		return [0, 0, -180, -60, 68, 196, 319, 434];
	}
function GetLVectAlpha()
	{
		return [0.55, 0.55, 1, 0.8, 0.64, 0.512, 0.4096, 0.32768];
	}

function GetDifficultyRate()
	{
	switch(GSController.GetSetting("Difficulty_level"))
		{
		case 1: return 1.4;
		case 2: return 1.25;
		case 3: return 1.1;
		case 4: return 1.0;
		case 5: return 0.9;
		case 6: return 0.75;
		case 7: return 0.6;
		default: return 1;
		}
	}
}