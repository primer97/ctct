class currCargoset extends baseCargoset
{

    function setupCargos(subset)
    {
        currCargoset.constructor();
        trace(3,"Setup cargos for CZIS game type." );

        currCargoset.realIndus();
    }

    function realIndus()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8   }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL

        Def.extCargo.append( { cargo = 12, rate = 3.2, div = 6   }); // BDMT
        Def.extCargo.append( { cargo =  5, rate = 3.6, div = 6   }); // GOOD
        Def.extCargo.append( { cargo = 40, rate = 3.7, div = 5   }); // PETR
        Def.extCargo.append( { cargo =  3, rate = 3.3, div = 6   }); // BEER
        Def.extCargo.append( { cargo = 11, rate = 3.5, div = 6   }); // FOOD
        Def.extCargo.append( { cargo = 25, rate = 3.2, div = 6   }); // FRUT
        Def.extCargo.append( { cargo = 10, rate = 3.4, div = 6   }); // BEAN
        Def.extCargo.append( { cargo = 58, rate = 3.9, div = 5   }); // VEHI

        towns_m._cargosetRate <- 1.10;

        Def.extCargo.reverse();
    }

}