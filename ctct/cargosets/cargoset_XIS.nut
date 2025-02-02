class currCargoset extends baseCargoset
{

    function setupCargos(subset)
    {
        currCargoset.constructor();
        trace(3,"Setup cargos for XIS game type" );

        currCargoset.the_lot();
    }

    function the_lot()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8   }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo = 11, rate = 3.3, div = 6   }); // FOOD
        Def.extCargo.append( { cargo = 24, rate = 3.2, div = 6   }); // FRUT
        Def.extCargo.append( { cargo =  5, rate = 3.5, div = 6   }); // GOOD
        Def.extCargo.append( { cargo = 39, rate = 3.5, div = 5   }); // PETR
        Def.extCargo.append( { cargo = 58, rate = 4.0, div = 5   }); // VEHI

        towns_m._cargosetRate <- 1.15;

        Def.extCargo.reverse();
    }

}
