class currCargoset extends baseCargoset
{

    function setupCargos(subset)
    {
        currCargoset.constructor();
        trace(3,"Setup cargos for unkown cargoset => fallback to automatic cargos guess (like with city controller version 11)" );

        currCargoset.legacy();
    }

    function legacy() // from CTCT v11
    {

        local lc=GSCargoList();
        foreach(cargo,_ in lc)
        {
            local lab = GSCargo.GetCargoLabel(cargo);

            local towneffect=GSCargo.GetTownEffect(cargo);

            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_PASSENGERS)
            {
                Def.baseCargo.append({ cargo=cargo, rate=2.8, div=6});
                continue;
            }

            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_MAIL)
            {
                if(currCargoset.OnlyPax)
                {
                    Def.extCargo.append({ cargo = cargo, rate = 2.6, div = 3 });
                }
                else
                {
                    Def.baseCargo.append({ cargo = cargo, rate = 2.6, div = 3 });
                }
                continue;
            }

            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_GOODS || lab=="GOOD")
            {
                Def.extCargo.append({ cargo=cargo, rate=3, div=2});
                continue;
            }

            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_WATER)
            {
                Def.extCargo.append({ cargo=cargo, rate=2.5, div=3});
                continue;
            }

            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_FOOD || lab=="FOOD")
            {
                Def.extCargo.append({ cargo=cargo, rate=3, div=8});
                continue;
            }

            if((lab=="VALU" || lab=="GOLD" || lab=="DIAM") && Def.extCargo.len()<=3)
            {
                Def.extCargo.insert(0,{ cargo=cargo, rate=4.5, div=2}); // positionne en haut des prios
                continue;
            }

            if(lab=="BDMT") // Building matl
            {
                Def.extCargo.append({ cargo=cargo, rate=3, div=7});
                continue;
            }

            if(lab=="BEER") // Alcohol
            {
                Def.extCargo.append({ cargo=cargo, rate=3.5, div=7});
                continue;
            }

            if(lab=="FRVG" || lab=="FRUT")
            {
                Def.extCargo.append({ cargo=cargo, rate=3, div=7});
                continue;
            }
            if(lab=="VEHI") //Vehicle
            {
                Def.extCargo.insert(0, { cargo=cargo, rate=4, div=7});
                continue;
            }
            if(lab=="FMSP") // Farm supply
                {
                Def.extCargo.append({ cargo=cargo, rate=3, div=7});
                continue;
            }
			if(GSCargo.IsValidTownEffect(cargo) && Def.extCargo.len()<=3) //--futur
			{
				Def.extCargo.append({ cargo=cargo, rate=3, div=7});
				continue;
			}
            // + "Name:"+ GSCargo.GetName(cargo)
//            trace(4,"Unaffected "+lab+" cargo (T.E:"+towneffect+") '"+GSCargo.GetName(cargo)+"'");
        }



    }


}