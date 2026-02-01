class currCargoset extends baseCargoset
{

    function setupCargos(subset)
    {
        currCargoset.constructor();

        switch(subset)
        {
            case "b2":   currCargoset.realIndusB2(); break;
            case "b4":   currCargoset.realIndusB4(); break;
        }
    }

    function realIndusB2() // beta 2
    {
        trace(3,"Setup cargos for Real Industry game type beta2." );

        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8   }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  5, rate = 3.0, div = 4   }); // MAIL
        else
            Def.baseCargo.append({ cargo =  5, rate = 3.0, div = 4   }); // MAIL

        Def.extCargo.append( { cargo = 14, rate = 3.2, div = 6   }); // STUD
        Def.extCargo.append( { cargo = 19, rate = 3.6, div = 6   }); // FOOD
        Def.extCargo.append( { cargo =  2, rate = 3.3, div = 6   }); // GOOD
        Def.extCargo.append( { cargo = 17, rate = 3.3, div = 6   }); // VEHI
        Def.extCargo.append( { cargo =  9, rate = 4.0, div = 5   }); // VALUE

        towns_m._cargosetRate <- 1.10;

        Def.extCargo.reverse();
    }

    function realIndusB4() // beta 4
    {
        trace(3,"Setup cargos for Real Industry game type beta4." );

        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8   }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4   }); // MAIL

        Def.extCargo.append( { cargo = 11, rate = 3.0, div = 6   }); // FOOD
        Def.extCargo.append( { cargo = 14, rate = 3.3, div = 6   }); // STUD
        Def.extCargo.append( { cargo =  5, rate = 3.0, div = 6   }); // GOOD
        Def.extCargo.append( { cargo = 17, rate = 3.2, div = 6   }); // VEHI
        Def.extCargo.append( { cargo = 20, rate = 3.3, div = 6   }); // PLAYR
        Def.extCargo.append( { cargo = 10, rate = 4.0, div = 5   }); // VALUE

        towns_m._cargosetRate <- 1.15;

        Def.extCargo.reverse();
    }
}