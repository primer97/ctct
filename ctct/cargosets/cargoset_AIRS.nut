class currCargoset extends baseCargoset
{

    function setupCargos(subset)
    {
        currCargoset.constructor();
        trace(3,"Setup cargos for AIRS ("+subset+")" );

        switch(subset)
        {
            case "Trains":    currCargoset.Trains(); break;
            case "BlackGold": currCargoset.BlackGold(); break;
            case "Trade":     currCargoset.Trade(); break;
        }
    }

    function Trains()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8   }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL

        Def.extCargo.append( { cargo =  6, rate = 3.2, div = 6   }); // BDMT
        Def.extCargo.append( { cargo = 11, rate = 3.5, div = 6   }); // FOOD
        Def.extCargo.append( { cargo =  5, rate = 3.6, div = 6   }); // GOOD
        Def.extCargo.append( { cargo = 20, rate = 3.7, div = 5   }); // PETR
        Def.extCargo.append( { cargo = 30, rate = 3.9, div = 5   }); // VEHI

        towns_m._cargosetRate <- 1.10;

        Def.extCargo.reverse();
    }

    function BlackGold()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8   }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL

        Def.extCargo.append( { cargo =  5, rate = 3.6, div = 6   }); // GOOD
        Def.extCargo.append( { cargo = 11, rate = 3.7, div = 6   }); // FOOD
        Def.extCargo.append( { cargo =  6, rate = 3.4, div = 6   }); // BDMT
        Def.extCargo.append( { cargo = 20, rate = 3.5, div = 5   }); // PETR
        Def.extCargo.append( { cargo = 30, rate = 3.9, div = 5   }); // VEHI

        towns_m._cargosetRate <- 1.10;

        Def.extCargo.reverse();
    }

    function Trade()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8   }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL

        Def.extCargo.append( { cargo = 11, rate = 3.7, div = 6   }); // FOOD
        Def.extCargo.append( { cargo =  5, rate = 4.0, div = 6   }); // GOOD
        Def.extCargo.append( { cargo = 15, rate = 3.5, div = 6   }); // PETR
        Def.extCargo.append( { cargo =  1, rate = 3.2, div = 6   }); // BDMT
        Def.extCargo.append( { cargo = 24, rate = 3.9, div = 5   }); // VEHI

        towns_m._cargosetRate <- 1.10;

        Def.extCargo.reverse();
    }
}