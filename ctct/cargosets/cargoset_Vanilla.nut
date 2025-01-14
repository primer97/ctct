class currCargoset
{
    constructor()
    {
    }
    function setupCargos(subset)
    {
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
        Def.baseCargo.append({ cargo = 0, rate = 2.8, div = 6 }); // PASS
        Def.baseCargo.append({ cargo = 2, rate = 2.6, div = 3 }); // MAIL

        Def.extCargo.append( { cargo = 5, rate = 3.4, div = 5 }); // GOOD
        Def.extCargo.append( { cargo = 10, rate = 4, div = 5 });  // VALU

        Def.extCargo.reverse();
    }

    function arctic()
    {
        Def.baseCargo.append({ cargo = 0, rate = 2.8, div = 6 }); // PASS
        Def.baseCargo.append({ cargo = 2, rate = 2.6, div = 3 }); // MAIL

        Def.extCargo.append( { cargo = 5, rate = 3.4, div = 5 }); // GOOD
        Def.extCargo.append( { cargo =11, rate = 3.9, div = 5 }); // FOOD
        Def.extCargo.append( { cargo =10, rate = 4.0, div = 3 }); // GOLD

        Def.extCargo.reverse();
    }

    function tropic()
    {
        Def.baseCargo.append({ cargo = 0, rate = 2.8, div = 6 }); // PASS
        Def.baseCargo.append({ cargo = 2, rate = 2.6, div = 3 }); // MAIL

        Def.extCargo.append( { cargo = 5, rate = 3.4, div = 5 }); // GOOD
        Def.extCargo.append( { cargo =11, rate = 3.9, div = 5 }); // FOOD
        Def.extCargo.append( { cargo =9,  rate = 4.0, div = 5 }); // WATR
        Def.extCargo.append( { cargo =10, rate = 4.0, div = 5 }); // DIAM

        Def.extCargo.reverse();
    }
    function toyland()
    {
        Def.baseCargo.append({ cargo = 0, rate = 2.8, div = 6 }); // PASS
        Def.baseCargo.append({ cargo = 2, rate = 2.6, div = 3 }); // MAIL

        Def.extCargo.append( { cargo = 5, rate = 3.0, div = 5 }); // SWET
        Def.extCargo.append( { cargo =11, rate = 3.5, div = 5 }); // FZDR

        Def.extCargo.reverse();
    }

}
