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

        // Start only with Passenger cargo
        local OnlyPax = GSController.GetSetting("Cargo_Selector")==1;


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
                if(OnlyPax)
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
                if(selectorInit>=4)
                {
                    Def.baseCargo.append({ cargo=cargo, rate=3, div=2});
                }
                else
                {
                    Def.extCargo.append({ cargo=cargo, rate=3, div=2});
                }
                continue;
            }

            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_WATER)
            {
                if(selectorInit>=4)
                {
                    Def.baseCargo.append({ cargo=cargo, rate=2.5, div=3});
                }
                else
                {
                    if(selectorLocked==1)
                    {
                        Def.extCargo.append({ cargo=cargo, rate=2.5, div=3});
                    }

                }
                continue;
            }

            if (GSCargo.GetTownEffect(cargo)==GSCargo.TE_FOOD || lab=="FOOD")
            {
                if(selectorInit>=3)
                {
                    Def.baseCargo.append({ cargo=cargo, rate=3, div=8});
                }
                else
                {
                    Def.extCargo.append({ cargo=cargo, rate=3, div=8});
                }
                continue;
            }

            if((lab=="VALU" || lab=="GOLD" || lab=="DIAM") && (selectorLocked==1 || selectorLocked==3))
            {
                Def.extCargo.insert(0,{ cargo=cargo, rate=4.5, div=2}); // positionne en haut des prios
                continue;
            }

            if(lab=="BDMT" && selectorLocked == 3)
            {
                Def.extCargo.append({ cargo=cargo, rate=3, div=7});
                continue;
            }

            if(lab=="BEER" && selectorLocked >=2)
            {
                Def.extCargo.append({ cargo=cargo, rate=3.5, div=7});
                continue;
            }

            if(lab=="FRVG" || lab=="FRUT")
            {
                Def.extCargo.append({ cargo=cargo, rate=3, div=7});
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