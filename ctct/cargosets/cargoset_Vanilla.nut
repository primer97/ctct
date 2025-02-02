class currCargoset extends baseCargoset
{

    function setupCargos(subset)
    {
        currCargoset.constructor();
        trace(3,"Setup cargos for Vanilla game type ("+subset+")" );

        switch(subset)
        {
            case "Temp":   currCargoset.temp(); break;
            case "Arctic": currCargoset.arctic(); break;
            case "Tropic": currCargoset.tropic(); break;
            case "Toyland":  currCargoset.toyland(); break;
        }
    }

    function temp()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8 }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo =  5, rate = 3.5, div = 6 });  // GOOD
        Def.extCargo.append( { cargo = 10, rate = 4.0, div = 3.5 });// VALU

        Def.extCargo.reverse();
    }

    function arctic()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8 }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo =  5, rate = 3.5, div = 6   }); // GOOD
        Def.extCargo.append( { cargo = 11, rate = 3.2, div = 6   }); // FOOD
        Def.extCargo.append( { cargo = 10, rate = 4.0, div = 3.5 }); // GOLD

        Def.extCargo.reverse();
    }

    function tropic()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8 }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo =  5, rate = 3.5, div = 6   }); // GOOD
        Def.extCargo.append( { cargo = 11, rate = 3.8, div = 6   }); // FOOD
        Def.extCargo.append( { cargo =  9, rate = 3.8, div = 5   }); // WATR
        Def.extCargo.append( { cargo = 10, rate = 4.0, div = 3.5 }); // DIAM

        towns_m._cargosetRate <- 1.05; // +5% because many "4 city" goals

        Def.extCargo.reverse();
    }
    function toyland()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8 }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo = 5, rate = 3.7, div = 6 }); // SWET
        Def.extCargo.append( { cargo =11, rate = 3.9, div = 6 }); // FZDR

        Def.extCargo.reverse();
    }

}
