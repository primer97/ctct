class currCargoset
{
    constructor()
    {
    }
    function setupCargos(subset)
    {
        trace(3,"Setup cargos for AXIS 2 ("+subset+")" );
        switch(subset)
        {
            case "SteelCity": currCargoset.steelCity(); break;
            case "TropicParadise": currCargoset.tropicParadise(); break;
        }
    }

    function steelCity()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8 }); // PASS
        Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo = 11, rate = 3.2, div = 6 }); // FOOD
        Def.extCargo.append( { cargo =  5, rate = 3.5, div = 5 }); // GOOD
        Def.extCargo.append( { cargo = 41, rate = 3.2, div = 5 }); // PETR
        Def.extCargo.append( { cargo = 62, rate = 4.2, div = 4 }); // VEHI

        towns_m._cargosetRate <- 1.1;

        Def.extCargo.reverse();
    }

    function tropicParadise()
    {
        Def.baseCargo.append({ cargo =  0, rate = 3.0, div = 8 }); // PASS
        Def.baseCargo.append({ cargo =  2, rate = 3.0, div = 4 }); // MAIL

        Def.extCargo.append( { cargo = 11, rate = 3.2, div = 6 }); // FOOD
        Def.extCargo.append( { cargo =  5, rate = 3.5, div = 5 }); // GOOD
        Def.extCargo.append( { cargo =  3, rate = 3.5, div = 5 }); // Alcohol BEER
        Def.extCargo.append( { cargo = 38, rate = 3.2, div = 5 }); // PETR
        Def.extCargo.append( { cargo = 63, rate = 4.2, div = 4 }); // VEHI

        towns_m._cargosetRate <- 1.15;

        Def.extCargo.reverse();
    }
}