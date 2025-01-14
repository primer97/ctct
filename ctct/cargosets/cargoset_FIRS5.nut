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
        Def.baseCargo.append({ cargo = 14, rate = 2.8, div = 6 }); // PASS
        Def.baseCargo.append({ cargo = 12, rate = 2.6, div = 3 }); // MAIL

        Def.extCargo.append( { cargo = 9, rate = 3.8, div = 5 }); // FOOD
        Def.extCargo.append( { cargo = 0, rate = 4.0, div = 5 }); // BEER
        Def.extCargo.append( { cargo = 7, rate = 4.2, div = 5 }); // GOOD

        Def.extCargo.reverse();
    }

    function arctic()
    {
        Def.baseCargo.append({ cargo = 11, rate = 2.8, div = 6 }); // PASS
        Def.baseCargo.append({ cargo = 9, rate = 2.6, div = 3 }); // MAIL

        Def.extCargo.append( { cargo = 6, rate = 3.8, div = 5 }); // FOOD

        Def.extCargo.reverse();
    }

    function tropic()
    {
        Def.baseCargo.append({ cargo = 17, rate = 2.8, div = 6 }); // PASS
        Def.baseCargo.append({ cargo = 14, rate = 2.6, div = 3 }); // MAIL

        Def.extCargo.append( { cargo = 9, rate = 3.8, div = 5 }); // FOOD
        Def.extCargo.append( { cargo = 0, rate = 4.0, div = 5 }); // BEER
        Def.extCargo.append( { cargo = 11, rate = 4.2, div = 5 }); // GOOD

        Def.extCargo.reverse();
    }

    function steeltown()
    {
        Def.baseCargo.append({ cargo = 28, rate = 2.8, div = 6 }); // PASS
        Def.baseCargo.append({ cargo = 24, rate = 2.6, div = 3 }); // MAIL

        Def.extCargo.append( { cargo = 6, rate = 3.8, div = 5 }); // FOOD
        Def.extCargo.append( { cargo = 19, rate = 4.2, div = 4 }); // GOOD
        Def.extCargo.append( { cargo = 20, rate = 4.2, div = 4 }); // HWAR
        Def.extCargo.append( { cargo = 54, rate = 4.2, div = 4 }); // VEHI

        Def.extCargo.reverse();
    }

    function inAHotCountry()
    {
        Def.baseCargo.append({ cargo = 23, rate = 2.8, div = 6 }); // PASS
        Def.baseCargo.append({ cargo = 18, rate = 2.6, div = 3 }); // MAIL

        Def.extCargo.append( { cargo =  2, rate = 4.0, div = 4 }); // BDMT
        Def.extCargo.append( { cargo = 13, rate = 3.8, div = 4 }); // FOOD
        Def.extCargo.append( { cargo =  1, rate = 4.0, div = 4 }); // BEER
        Def.extCargo.append( { cargo = 24, rate = 4.0, div = 4 }); // PETR
        Def.extCargo.append( { cargo = 15, rate = 4.0, div = 4 }); // GOOD
        Def.extCargo.append( { cargo =  9, rate = 4.0, div = 4 }); // DIAM

        Def.extCargo.reverse();
    }

}