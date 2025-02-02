class currCargoset extends baseCargoset
{

    function setupCargos(subset)
    {
        currCargoset.constructor();
        trace(3,"Setup cargos for YETI" );

        currCargoset.yeti();
    }

    function yeti()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8   }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL

        Def.extCargo.append( { cargo =  8, rate = 3.3, div = 6   }); // FOOD
        Def.extCargo.append( { cargo =  4, rate = 3.3, div = 6   }); //
        Def.extCargo.append( { cargo = 13, rate = 3.5, div = 5   }); //

        Def.extCargo.reverse();
    }

}
