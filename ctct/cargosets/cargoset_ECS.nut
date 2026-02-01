class currCargoset extends baseCargoset
{

    function setupCargos(subset)
    {
        currCargoset.constructor();
        trace(3,"Setup cargos for ECS game type, designed for these vectors : town+Agri+Chem+Mach+Wood+House" );

        currCargoset.combinedVects();
    }

    function combinedVects()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8   }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL

        if(GSCargo.GetCargoLabel(31)) Def.extCargo.append( { cargo = 31, rate = 3.2, div = 6   }); // TOUR
        if(GSCargo.GetCargoLabel(5))  Def.extCargo.append( { cargo =  5, rate = 3.6, div = 6   }); // GOOD
        if(GSCargo.GetCargoLabel(11)) Def.extCargo.append( { cargo = 11, rate = 3.3, div = 6   }); // FOOD
        if(GSCargo.GetCargoLabel(27)) Def.extCargo.append( { cargo = 27, rate = 3.3, div = 6   }); // WATR
        if(GSCargo.GetCargoLabel(28)) Def.extCargo.append( { cargo = 28, rate = 3.3, div = 6   }); // BLDM
        if(GSCargo.GetCargoLabel(25)) Def.extCargo.append( { cargo = 25, rate = 3.5, div = 5   }); // GAS
        if(GSCargo.GetCargoLabel(24)) Def.extCargo.append( { cargo = 24, rate = 3.8, div = 5   }); // VEHI
        Def.extCargo.append( { cargo = 10, rate = 4.0, div = 5   }); // GOLD

        towns_m._cargosetRate <- 1.10;

        Def.extCargo.reverse();
    }

}
