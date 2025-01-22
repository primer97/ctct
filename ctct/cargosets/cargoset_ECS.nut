class currCargoset
{
    constructor()
    {
    }
    function setupCargos(subset)
    {
        trace(3,"Setup cargos for ECS game type, designed for these vectors : town+Agri+Chem+Mach+Wood+House" );
        currCargoset.combinedVects();
    }

    function combinedVects()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8   }); // PASS
        Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL

        Def.extCargo.append( { cargo = 31, rate = 3.2, div = 6   }); // TOUR
        Def.extCargo.append( { cargo =  5, rate = 3.6, div = 6   }); // GOOD
        Def.extCargo.append( { cargo = 11, rate = 3.3, div = 6   }); // FOOD
        Def.extCargo.append( { cargo = 27, rate = 3.3, div = 6   }); // WATR
        Def.extCargo.append( { cargo = 28, rate = 3.3, div = 6   }); // BLDM
        Def.extCargo.append( { cargo = 25, rate = 3.5, div = 5   }); // GAS
        Def.extCargo.append( { cargo = 24, rate = 4.0, div = 5   }); // VEHI
        Def.extCargo.append( { cargo = 10, rate = 4.0, div = 5   }); // GOLD

        towns_m._cargosetRate <- 1.20;

        Def.extCargo.reverse();
    }

}
