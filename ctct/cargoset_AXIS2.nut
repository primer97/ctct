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

    }

    function tropicParadise()
    {
        Def.baseCargo.append({ cargo=1, rate=2.8, div=6});
        Def.baseCargo.append({ cargo=2, rate=2.8, div=6});
        Def.baseCargo.append({ cargo=3, rate=2.8, div=6});
        Def.baseCargo.append({ cargo=4, rate=2.8, div=6});
        Def.baseCargo.append({ cargo=5, rate=2.8, div=6});
        Def.extCargo.append({ cargo=6, rate = 2.6, div = 3 });
        Def.extCargo.append({ cargo=7, rate = 2.6, div = 3 });
        Def.extCargo.append({ cargo=8, rate = 2.6, div = 3 });
        Def.extCargo.append({ cargo=9, rate = 2.6, div = 3 });
        Def.extCargo.append({ cargo=10, rate = 2.6, div = 3 });
        Def.extCargo.append({ cargo=11, rate = 2.6, div = 3 });
        Def.extCargo.append({ cargo=12, rate = 2.6, div = 3 });
        Def.extCargo.append({ cargo=13, rate = 2.6, div = 3 });
        Def.extCargo.append({ cargo=14, rate = 2.6, div = 3 });

    }
}