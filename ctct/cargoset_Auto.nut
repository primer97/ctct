class currCargoset
{
    constructor()
    {

    }
    function setupCargos(subset)
    {
        trace(3,"Setup cargos for unkown cargoset => fallback to automatic cargos guess (like with city controller version 11" );
        currCargoset.legacy();
    }

    function legacy() // from CTCT v11
    {

        local selectorInit = GSController.GetSetting("Cargo_Selector");
        local selectorLocked = GSController.GetSetting("Cargo_ToUnlock");

        local lc=GSCargoList();
        foreach(cargo,_ in lc)
        {
            local lab = GSCargo.GetCargoLabel(cargo);

            local towneffect=GSCargo.GetTownEffect(cargo);
            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_PASSENGERS)
            {
                Def.baseCargo.append({ cargo=cargo, rate=2.8, div=6});
//                trace(3,"BASE cargo> Passengers town Effect: "+lab);
                continue;
            }

            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_MAIL)
            {
                if(selectorInit==1)
                {
                    Def.extCargo.append({ cargo = cargo, rate = 2.6, div = 3 });
//                    trace(3, "EXT cargo> Mail town effect: " + lab);
                }
                else
                {
                    Def.baseCargo.append({ cargo = cargo, rate = 2.6, div = 3 });
//                    trace(3, "BASE cargo> Mail town effect: " + lab);
                }
                continue;
            }

            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_GOODS || lab=="GOOD")
            {
                if(selectorInit>=4)
                {
                    Def.baseCargo.append({ cargo=cargo, rate=3, div=2});
//                    trace(3, "BASE cargo> Goods: "+lab);
                }
                else
                {
                    Def.extCargo.append({ cargo=cargo, rate=3, div=2});
//                    trace(3, "EXT cargo> Goods: "+lab);
                }
                continue;
            }

            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_WATER)
            {
                if(selectorInit>=4)
                {
                    Def.baseCargo.append({ cargo=cargo, rate=2.5, div=3});
//                    trace(3, "BASE cargo> Goods: "+lab + " = "+ GSCargo.GetName(cargo));
                }
                else
                {
                    if(selectorLocked==1)
                    {
                        Def.extCargo.append({ cargo=cargo, rate=2.5, div=3});
//                        trace(3, "EXT cargo> Water town effect: "+lab);
                    }

                }
                continue;
            }

            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_FOOD || lab=="FOOD")
            {
                if(selectorInit>=3)
                {
                    Def.baseCargo.append({ cargo=cargo, rate=3, div=8});
//                    trace(3, "BASE cargo> Goods: "+lab);
                }
                else
                {
                    Def.extCargo.append({ cargo=cargo, rate=3, div=8});
//                    trace(3, "EXT cargo> Food: "+lab);
                }
                continue;
            }

            if((lab=="VALU" || lab=="GOLD" || lab=="DIAM") && (selectorLocked==1 || selectorLocked==3))
            {
                Def.extCargo.insert(0,{ cargo=cargo, rate=4.5, div=2}); // positionne en haut des prios
//                trace(3,"EXT cargo> Bank item: "+lab);
                continue;
            }

            if(lab=="BDMT" && selectorLocked == 3)
            {
                Def.extCargo.append({ cargo=cargo, rate=3, div=7});
//                trace(3,"EXT cago> BuildMat: "+lab);
                continue;
            }

            if(lab=="BEER" && selectorLocked >=2)
            {
                Def.extCargo.append({ cargo=cargo, rate=3.5, div=7});
//                trace(3,"EXT cargo> Alcohol: "+lab + " = "+ GSCargo.GetName(cargo));
                continue;
            }

            if(lab=="FRVG" || lab=="FRUT")
            {
                Def.extCargo.append({ cargo=cargo, rate=3, div=7});
//                trace(3,"EXT cargo> Fruit: "+lab + " = "+ GSCargo.GetName(cargo));
                continue;
            }
            if(lab=="VEHI" && selectorLocked>=2) //ECS, FIRS, AXIS
                {
                Def.extCargo.insert(0, { cargo=cargo, rate=4, div=7});
                trace(3,"EXT cargo> Vehicule: "+lab);
                continue;
            }
            if(lab=="FMSP" && selectorLocked==3)  // ECS arctic, FIRS, AXIS
                {
                Def.extCargo.append({ cargo=cargo, rate=3, div=7});
//                trace(3,"EXT cargo> Farm Supply: "+lab);
                continue;
            }
//			if(GSCargo.IsValidTownEffect(cargo)) //--futur
//			{
//				Def.extCargo.append({ cargo=cargo, rate=3, div=7});
////				trace(3,"EXT cargo> other towneffect: "+lab);
//				continue;
//			}
            // + "Name:"+ GSCargo.GetName(cargo)
//            trace(4,"Unaffected "+lab+" cargo (T.E:"+towneffect+") '"+GSCargo.GetName(cargo)+"'");
        }



    }


}