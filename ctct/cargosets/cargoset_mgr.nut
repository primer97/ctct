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

        local id= CargoSet_Manager.check_identifiers();
        trace(4,"cargoSet identifier :"+ id);
        local set="";
        local sub="";

        switch(id)
        {
//            case "LVST/WOOD":
//                set = "Vanilla";
//                switch(GSGame.GetLandscape())
//                {
//                    case LT_TEMPERATE : sub ="Temp"; break;
//                    case LT_ARCTIC : sub ="Arctic"; break;
//                    case LT_TROPIC: sub ="Tropic"; break;
//                    case LT_TOYLAND : sub ="Toyland"; break;
//                }
//                break;

        // --- vanilla ---
            case "STEL/VALU":  set = "Vanilla"; sub ="Temp";    break;
            case "PAPR/GOLD":  set = "Vanilla"; sub ="Arctic";  break;
            case "WATR/DIAM":  set = "Vanilla"; sub ="Tropic";  break;
            case "BUBL/PLST":  set = "Vanilla"; sub ="Toyland"; break;

        // --- FIRS 4 ---
            case "FRUT/IORE":  set = "FIRS4"; sub ="Temp";   break;
            case "WOOD/WDPR":  set = "FIRS4"; sub ="Arctic"; break;
          //case "ENSP/FMSP":  set = "FIRS4"; sub ="Tropic"; break;
            case "CMNT/CHLO":  set = "FIRS4"; sub ="Steel";  break;
          //case "COPR/CORE":  set = "FIRS4"; sub ="IAHC";   break;

        // --- FIRS 3 & 2 ---
            case "FISH/FRUT":
                switch(CargoSet_Manager.getCargoAt(14)){
                    case "MNSP": set = "FIRS2"; sub = "Temp";  break;
                    case "MILK": set = "FIRS3"; sub = "Temp";  break;
                }
                break;
            case "OIL_/PAPR":  set = "FIRS2"; sub ="Arctic"; break;
            case "WDPR/PHOS":  set = "FIRS3"; sub ="Arctic"; break;
            case "ENSP/FMSP":
                switch(CargoSet_Manager.getCargoAt(19)){
                    case "STEL": set = "FIRS2"; sub = "Extrem";  break;
                    case "METL": set = "FIRS3"; sub = "Extrem";  break;
                }
                switch(CargoSet_Manager.getCargoAt(18)){
                    case "WOOL": set = "FIRS4"; sub = "Tropic";  break; // and FIRS3/Tropic as well
                    case "OIL_": set = "FIRS2"; sub = "Tropic";  break;
                }
                break;
            case "LIME/SAND":  set = "FIRS3"; sub ="Steel"; break;
            case "COPR/CORE":
                switch(CargoSet_Manager.getCargoAt(21)){
                    case "MNSP": set = "FIRS2"; sub = "IAHC";  break;
                    case "NUTS": set = "FIRS3"; sub = "IAHC";  break;
                    case "MNO2": set = "FIRS4"; sub = "IAHC";  break;
                }
                break;

        // --- FIRS 5 ---
            case "FOOD/KAOL":  set = "FIRS5"; sub ="Temp";   break;
            case "MAIL/PAPR":  set = "FIRS5"; sub ="Arctic"; break;
            case "FOOD/FRUT":  set = "FIRS5"; sub ="Tropic"; break;
            case "COAL/CTAR":  set = "FIRS5"; sub ="Steel";  break;
            case "DIAM/EOIL":  set = "FIRS5"; sub ="IAHC";   break;

        // --- AXIS 2 ---
            case "AORE/CBLK":  set = "AXIS2"; sub ="SteelCity";      break;
            case "SOAP/COAL":  set = "AXIS2"; sub ="TropicParadise"; break;

        // --- OTHERS ---
            case "RFPR/CHLO":  set = "XIS"; sub ="TheLot";   break;

            case "FMSP/FICR":  set = "NAIS"; sub ="";        break;

            case "STEL/GOLD":  set = "ECS"; sub ="";         break;

            case "YETI/OIL_":  set = "YETI"; sub ="any";     break;
        }

        if(set=="") set = "Auto";

        CargoSet_Manager.cargoset  <- set;
        CargoSet_Manager.subset  <- sub;
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
            if(cargo==16 && index9=="----") index9 = lab;
        }
        return index9 + "/" + index10;
    }

    function getCargoAt(pos)
    {
        if(GSCargo.GetCargoLabel(pos)==null) return "";
        return GSCargo.GetCargoLabel(pos)
    }

    // load specific cargoset
    function load()
    {
        require("base_cargo.nut");
        local file="cargoset_"+CargoSet_Manager.cargoset+".nut";
        require(file);
        CargoSet_Manager.cls <- currCargoset;
        CargoSet_Manager.cls.setupCargos(CargoSet_Manager.subset );

    }

}