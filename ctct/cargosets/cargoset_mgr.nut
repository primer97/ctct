class CargoSet_Manager
{
    constructor() {
    }

//region cargoset
/*
	Vanilla              				Firs 4						                Firs 3							                    Firs 5						                Axis
idx	Temp.	Arctic	trop	toyland		Temp.	Arctic	Tropic	Steel.	IAHC		Temp.	Arctic	Tropic	Steel.	IAHC	Extrem		Temp.	Arctic	Tropic	Steel.	IAHC		Steel.	TropicPar.
0	PASS	PASS	PASS	PASS		PASS	PASS	PASS	PASS	PASS		PASS	PASS	PASS	PASS	PASS	PASS		BEER	NH3_	BEER	ACID	GRVL		PASS	PASS
1	COAL	COAL	RURB	SUGR		BEER	NH3_	BEER	ACID	BEER		BEER	KAOL	BEER	CMNT	BEER	BEER		RFPR	ENSP	BEAN	GRVL	BEER		ACID	ACET
2	MAIL	MAIL	MAIL	MAIL		MAIL	MAIL	MAIL	MAIL	MAIL		MAIL	MAIL	MAIL	MAIL	MAIL	MAIL		COAL	BOOM	RFPR	ALUM	BDMT		MAIL	MAIL
3	OIL_	OIL_	OIL_	TOYS		RFPR	ENSP	BEAN	STAL	BDMT		RFPR	ENSP	BEAN	QLME	BDMT	AORE		ENSP	FMSP	JAVA	CBLK	CASS		STAL	BEER
4	LVST	LVST	FRUT	BATT		COAL	BOOM	RFPR	ALUM	CASS		CLAY	FMSP	RFPR	ENSP	CASS	BDMT		FMSP	FERT	COPR	CSTI	RFPR		ALO_	BIOM
5	GOOD	GOOD	GOOD	SWET		GOOD	FMSP	GOOD	VEHI	GOOD		GOOD	GOOD	GOOD	VEHI	GOOD	GOOD		FISH	FISH	CORE	CMNT	CLAY		GOOD	GOOD
6	GRAI	WHEA	MAIZ	TOFF		ENSP	FERT	JAVA	CBLK	RFPR		COAL	PAPR	JAVA	FMSP	RFPR	RFPR		FRUT	FOOD	ENSP	FOOD	JAVA		ALUM	BDMT
7	WOOD	WOOD	WOOD	COLA		FMSP	FISH	COPR	STCB	CLAY		ENSP	PORE	COPR	STEL	CLAY	CLAY		GOOD	KAOL	FMSP	CHLO	COPR		NH3_	RFPR
8	IORE	    	CORE	CTCD		FISH	KAOL	CORE	CSTI	JAVA		FMSP	BEER	CORE	SLAG	JAVA	COAL		IORE	WOOD	FISH	SOAP	CORE		NHNO	CLAY
9	STEL	PAPR	WATR	BUBL		FRUT	WOOD	ENSP	CMNT	COPR		FISH	WDPR	ENSP	LIME	COPR	ENSP		FOOD	MAIL	FOOD	COAL	DIAM		AORE	SOAP
10	VALU	GOLD	DIAM	PLST		IORE	WDPR	FMSP	CHLO	CORE		FRUT	PHOS	FMSP	SAND	CORE	FMSP		KAOL	PAPR	FRUT	CTAR	EOIL		CBLK	COAL
11	    	FOOD	FOOD	FZDR		FOOD	FOOD	FOOD	FOOD	FOOD		FOOD	FOOD	FOOD	FOOD	FOOD	FOOD		LVST	PASS	GOOD	COKE	ENSP		FOOD	FOOD
12		                				KAOL	PAPR	FISH	SOAP	DIAM		IORE	BOOM	FISH	MNO2	DIAM	FISH		MAIL	PEAT	GRAI	CCPR	FMSP		STCB	COKE
13		            	    			LVST	PEAT	FRUT	COAL	EOIL		LVST	ZINC	FRUT	COAL	EOIL	FRUT		MILK	PHOS	LVST	POWR	FOOD		CMNT	COPR
14	            			    		MILK	PHOS	GRAI	CTAR	ENSP		MILK	FISH	GRAI	IORE	ENSP	GRAI		PASS	POTA	MAIL	ENSP	FRUT		RFPR	COCO
15          					    	SAND	POTA	LVST	COKE	FMSP		SAND	SULP	LVST	IRON	FMSP	IORE		SAND	PORE	NITR	FMSP	GOOD		CHLO	CORE
16          			    			SCMT	PORE	NITR	POWR	FRUT		SCMT	FERT	NITR	COKE	FRUT	LVST		SCMT	SULP	OIL_	FEAL	LVST		SOAP	EOIL
17			            	    		STEL	SULP	OIL_	ENSP	LVST		STEL	WOOD	OIL_	PETR	LVST	WDPR		STEL	WDPR	PASS	FOCA	WOOD		COAL	ENSP
18					                    		ZINC	WOOL	FMSP	WOOD	    		PEAT	WOOL	SULP	WDPR	MNSP		    	ZINC	WOOL	GLAS	MAIL		CTAR	BOOM
 */
//endregion cargoset

    static cargoset ="";
    static subset ="";

    static cls=null;

    // Guess the cargoSet and prepare cargos data
    function guess()
    {
        CargoSet_Manager.cargoset <-"";
        CargoSet_Manager.subset <-"";

        local id= CargoSet_Manager.check_identifiers();
        trace(4,"cargoSet identifier :"+ id);
        switch(id)
        {
//            case "LVST/WOOD":
//                CargoSet_Manager.cargoset <- "Vanilla";
//                switch(GSGame.GetLandscape())
//                {
//                    case LT_TEMPERATE : CargoSet_Manager.subset <-"Temp"; break;
//                    case LT_ARCTIC : CargoSet_Manager.subset <-"Arctic"; break;
//                    case LT_TROPIC: CargoSet_Manager.subset <-"Tropic"; break;
//                    case LT_TOYLAND : CargoSet_Manager.subset <-"Toyland"; break;
//                }
//                break;
            case "STEL/VALU":  CargoSet_Manager.cargoset <- "Vanilla"; CargoSet_Manager.subset <-"Temp"; break;
            case "PAPR/GOLD":  CargoSet_Manager.cargoset <- "Vanilla"; CargoSet_Manager.subset <-"Arctic"; break;
            case "WATR/DIAM":  CargoSet_Manager.cargoset <- "Vanilla"; CargoSet_Manager.subset <-"Tropic"; break;
            case "BUBL/PLST":  CargoSet_Manager.cargoset <- "Vanilla"; CargoSet_Manager.subset <-"Toyland"; break;

            case "FRUT/IORE":  CargoSet_Manager.cargoset <- "FIRS4"; CargoSet_Manager.subset <-"Temp"; break;
            case "WOOD/WDPR":  CargoSet_Manager.cargoset <- "FIRS4"; CargoSet_Manager.subset <-"Arctic"; break;
//            case "ENSP/FMSP":  CargoSet_Manager.cargoset <- "FIRS4"; CargoSet_Manager.subset <-"Tropic"; break;
            case "CMNT/CHLO":  CargoSet_Manager.cargoset <- "FIRS4"; CargoSet_Manager.subset <-"Steel"; break;
            case "COPR/CORE":  CargoSet_Manager.cargoset <- "FIRS4"; CargoSet_Manager.subset <-"IAHC"; break;

            case "FISH/FRUT":  CargoSet_Manager.cargoset <- "FIRS3"; CargoSet_Manager.subset <-"Temp"; break;
            case "WDPR/PHOS":  CargoSet_Manager.cargoset <- "FIRS3"; CargoSet_Manager.subset <-"Arctic"; break;
            case "ENSP/FMSP":
                switch(CargoSet_Manager.getCargoAt(18))
                {
                    case "WOOL": CargoSet_Manager.cargoset <- "FIRS4";  CargoSet_Manager.subset <- "Tropic";     break; // FIRS3 as well
                    case "MNSP": CargoSet_Manager.cargoset <- "FIRS3"; CargoSet_Manager.subset <- "Extrem";     break;
                }
                break;
            //case "ENSP/FMSP":  CargoSet_Manager.cargoset <- "FIRS3"; CargoSet_Manager.subset <-"Extrem"; break;
            case "LIME/SAND":  CargoSet_Manager.cargoset <- "FIRS3"; CargoSet_Manager.subset <-"Steel"; break;
            case "COPR/CORE":  CargoSet_Manager.cargoset <- "FIRS3"; CargoSet_Manager.subset <-"IAHC"; break;

            case "FOOD/KAOL":  CargoSet_Manager.cargoset <- "FIRS5"; CargoSet_Manager.subset <-"Temp"; break;
            case "MAIL/PAPR":  CargoSet_Manager.cargoset <- "FIRS5"; CargoSet_Manager.subset <-"Arctic"; break;
            case "FOOD/FRUT":  CargoSet_Manager.cargoset <- "FIRS5"; CargoSet_Manager.subset <-"Tropic"; break;
            case "COAL/CTAR":  CargoSet_Manager.cargoset <- "FIRS5"; CargoSet_Manager.subset <-"Steel"; break;
            case "DIAM/EOIL":  CargoSet_Manager.cargoset <- "FIRS5"; CargoSet_Manager.subset <-"IAHC"; break;

            case "AORE/CBLK":  CargoSet_Manager.cargoset <- "AXIS2"; CargoSet_Manager.subset <-"SteelCity"; break;
            case "SOAP/COAL":  CargoSet_Manager.cargoset <- "AXIS2"; CargoSet_Manager.subset <-"TropicParadise"; break;

            case "RFPR/CHLO":  CargoSet_Manager.cargoset <- "XIS"; CargoSet_Manager.subset <-"TheLot"; break;

            case "FMSP/FICR":  CargoSet_Manager.cargoset <- "NAIS"; CargoSet_Manager.subset <-""; break;

            case "STEL/GOLD":  CargoSet_Manager.cargoset <- "ECS"; CargoSet_Manager.subset <-""; break;
        }

        if(CargoSet_Manager.cargoset =="") CargoSet_Manager.cargoset <- "Auto";
        trace(1,"current cargoSet :"+ CargoSet_Manager.cargoset +" "+ CargoSet_Manager.subset );
        CargoSet_Manager.load();
    }

    // Guess the cargoSet by checking few cargo types
    function check_identifiers()
    {
        local index9 = "----"; // undefined
        local index10 = "----"; // undefined

        local lc=GSCargoList();
        foreach(cargo,_ in lc)
        {
            local lab = GSCargo.GetCargoLabel(cargo);
            if(cargo==9) index9 = lab;
            if(cargo==10) index10 = lab;
        }
        return index9 + "/" + index10;
    }

    function getCargoAt(pos)
    {
        return GSCargo.GetCargoLabel(pos)
        local lc=GSCargoList();
        local nb=0;

//        foreach(cargo,_ in lc)
//        {
//            local lab = GSCargo.GetCargoLabel(cargo);
//            local te=GSCargo.GetTownEffect(cargo);
//            trace(4," - "+ (cargo<10 ? " ":"") + cargo + ": "+lab+" " + (te ? "[TE]":"....") + " '"+ GSCargo.GetName(cargo)+"'");
//        }

        foreach(cargo,_ in lc)
        {
            trace(1,"cargo at "+pos+" = "+cargo);
            if(nb==pos)
            {
                local lab = GSCargo.GetCargoLabel(cargo);
                trace(1,"cargo at "+pos+" = "+cargo);
                return lab;
            }
            nb=nb+1;
        }
    }

    // load specific cargoset
    function load()
    {
        local file="cargoset_"+CargoSet_Manager.cargoset+".nut";
        require(file);
        CargoSet_Manager.cls <- currCargoset;
        CargoSet_Manager.cls.setupCargos(CargoSet_Manager.subset );

    }


}