class currCargoset extends baseCargoset
{

    function setupCargos(subset)
    {
        currCargoset.constructor();
        trace(3,"Setup cargos for NAIS game type" );

        currCargoset.na();
    }

    function na()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8   }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo = 11, rate = 3.1, div = 6   }); // FOOD
        Def.extCargo.append( { cargo =  5, rate = 3.5, div = 6   }); // GOOD
        Def.extCargo.append( { cargo = 13, rate = 3.5, div = 5   }); // FUEL


        Def.extCargo.append( { cargo =  3, rate = 3.3, div = 5.0 });  // BDMT
        Def.extCargo.append( { cargo = 19, rate = 3.3, div = 5.0 });  // ENSP : machinery
        Def.extCargo.append( { cargo =  4, rate = 3.3, div = 5.0 });  // RFPR : chemical
        Def.extCargo.append( { cargo = 14, rate = 3.3, div = 5.0 });  // GLAS
        Def.extCargo.append( { cargo = 18, rate = 3.3, div = 5.0 });  // WDPR : Lumber
        Def.extCargo.append( { cargo = 24, rate = 3.3, div = 5.0 });  // PAPR
        Def.extCargo.append( { cargo = 22, rate = 3.3, div = 5.0 });  // PORE : Minerals
        Def.extCargo.append( { cargo = 30, rate = 4, div = 3.5 });  // VALU

        towns_m._cargosetRate <- 1.2; // +20% to compensate NAIS difficulty

        Def.extCargo.reverse();
    }

}
