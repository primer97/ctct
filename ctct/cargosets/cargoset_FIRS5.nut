class currCargoset
{
    constructor()
    {
    }
    function setupCargos(subset)
    {
        trace(3,"Setup cargos for FIRS 5 ("+subset+")" );
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
        Def.baseCargo.append({ cargo = 14, rate = 3.0, div = 8 }); // PASS
        Def.baseCargo.append({ cargo = 12, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo =  9, rate = 3.9, div = 6 }); // FOOD
        Def.extCargo.append( { cargo =  0, rate = 4.0, div = 5 }); // BEER
        Def.extCargo.append( { cargo =  7, rate = 4.2, div = 5 }); // GOOD

        Def.extCargo.reverse();
    }

    function arctic()
    {
        Def.baseCargo.append({ cargo = 11, rate = 3.0, div = 8 }); // PASS
        Def.baseCargo.append({ cargo =  9, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo =  6, rate = 3.6, div = 5 }); // FOOD

        Def.extCargo.reverse();
    }

    function tropic()
    {
        Def.baseCargo.append({ cargo = 17, rate = 3.0, div = 8 }); // PASS
        Def.baseCargo.append({ cargo = 14, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo =  9, rate = 3.9, div = 6 }); // FOOD
        Def.extCargo.append( { cargo =  0, rate = 4.0, div = 5 }); // BEER
        Def.extCargo.append( { cargo = 11, rate = 4.2, div = 5 }); // GOOD

        Def.extCargo.reverse();
    }

    function steeltown()
    {
        Def.baseCargo.append({ cargo = 28, rate = 3.0, div = 8 }); // PASS
        Def.baseCargo.append({ cargo = 24, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo =  6, rate = 3.9, div = 5 }); // FOOD
        Def.extCargo.append( { cargo = 19, rate = 4.2, div = 5 }); // GOOD
        Def.extCargo.append( { cargo = 20, rate = 4.2, div = 5 }); // HWAR
        Def.extCargo.append( { cargo = 54, rate = 4.5, div = 4 }); // VEHI

        towns_m._cargosetRate <- 1.1;

        Def.extCargo.reverse();
    }

    function inAHotCountry()
    {
        Def.baseCargo.append({ cargo = 23, rate = 3.0, div = 8 }); // PASS
        Def.baseCargo.append({ cargo = 18, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo =  2, rate = 4.0, div = 5 }); // BDMT
        Def.extCargo.append( { cargo = 13, rate = 3.8, div = 5 }); // FOOD
        Def.extCargo.append( { cargo =  1, rate = 4.0, div = 5 }); // BEER
        Def.extCargo.append( { cargo = 24, rate = 4.0, div = 4 }); // PETR
        Def.extCargo.append( { cargo = 15, rate = 4.5, div = 4 }); // GOOD
        Def.extCargo.append( { cargo =  9, rate = 4.5, div = 3.5 }); // DIAM

        towns_m._cargosetRate <- 1.2;

        Def.extCargo.reverse();
    }

}