class currCargoset extends baseCargoset
{

    function setupCargos(subset)
    {
        currCargoset.constructor();
        trace(3,"Setup cargos for FIRS 4 ("+subset+")" );

        switch(subset)
        {
            case "Temp":   currCargoset.temp(); break;
            case "Arctic": currCargoset.arctic(); break;
            case "Tropic": currCargoset.tropic(); break;
            case "Steel":  currCargoset.steeltown(); break;
            case "IAHC":   currCargoset.inAHotCountry(); break;
        }
    }

    function temp()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8 }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo = 11, rate = 3.9, div = 6 }); // FOOD
        Def.extCargo.append( { cargo =  1, rate = 4.0, div = 5 }); // BEER
        Def.extCargo.append( { cargo =  5, rate = 4.2, div = 5 }); // GOOD

        Def.extCargo.reverse();
    }

    function arctic()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8 }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo = 11, rate = 3.6, div = 5 }); // FOOD

        Def.extCargo.reverse();
    }

    function tropic()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8 }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo = 11, rate = 3.9, div = 6 }); // FOOD
        Def.extCargo.append( { cargo =  1, rate = 4.0, div = 5 }); // BEER
        Def.extCargo.append( { cargo =  5, rate = 4.2, div = 5 }); // GOOD

        Def.extCargo.reverse();
    }

    function steeltown()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8 }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo = 11, rate = 3.9, div = 5 }); // FOOD
        Def.extCargo.append( { cargo =  5, rate = 4.3, div = 4 }); // VEHI

        Def.extCargo.reverse();
    }

    function inAHotCountry()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8 }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo = 24, rate = 4.0, div = 4 }); // PETR
        Def.extCargo.append( { cargo =  3, rate = 4.0, div = 5 }); // BDMT
        Def.extCargo.append( { cargo = 11, rate = 3.8, div = 5 }); // FOOD
        Def.extCargo.append( { cargo =  1, rate = 4.0, div = 4 }); // BEER
        Def.extCargo.append( { cargo =  5, rate = 4.0, div = 4 }); // GOOD

        towns_m._cargosetRate <- 1.2;

        Def.extCargo.reverse();
    }

}