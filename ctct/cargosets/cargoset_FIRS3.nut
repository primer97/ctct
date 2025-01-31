class currCargoset
{
    OnlyPax = false;
    constructor()
    {
    }
    function setupCargos(subset)
    {
        trace(3,"Setup cargos for FIRS 3 ("+subset+")" );

        // Start only with Passenger cargo
        currCargoset.OnlyPax <- GSController.GetSetting("Cargo_Selector")==1;

        switch(subset)
        {
            case "Temp":   currCargoset.temp(); break;
            case "Arctic": currCargoset.arctic(); break;
            case "Tropic": currCargoset.tropic(); break;
            case "Steel":  currCargoset.steeltown(); break;
            case "IAHC":   currCargoset.inAHotCountry(); break;
            case "Extrem": currCargoset.extrem(); break;
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
        Def.extCargo.append( { cargo =  1, rate = 4.0, div = 5 }); // BEER // suppl
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
        Def.extCargo.append( { cargo = 5, rate =  4.2, div = 6 }); // GOOD

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
        Def.extCargo.append( { cargo = 17, rate = 3.7, div = 5 }); // PETR
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

        Def.extCargo.append( { cargo = 23, rate = 4.0, div = 4 }); // PETR
        Def.extCargo.append( { cargo = 11, rate = 3.8, div = 5 }); // FOOD
        Def.extCargo.append( { cargo =  5, rate = 4.0, div = 4 }); // GOOD
        Def.extCargo.append( { cargo = 12, rate = 4.2, div = 4 }); // DIAM // suppl

        towns_m._cargosetRate <- 1.1;

        Def.extCargo.reverse();
    }

    function extrem()
    {
        Def.baseCargo.append({ cargo = 0, rate = 3.0, div = 8 }); // PASS

        if(currCargoset.OnlyPax)
            Def.extCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL
        else
            Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo = 11, rate = 3.8, div = 5 });   // FOOD
        Def.extCargo.append( { cargo = 22, rate = 4.0, div = 4.5 }); // PETR
        Def.extCargo.append( { cargo =  5, rate = 4.2, div = 4 });   // GOOD

        Def.extCargo.reverse();
    }


}