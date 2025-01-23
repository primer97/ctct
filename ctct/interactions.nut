class Interactions
{
    inst = null;
    //region declaration
    function check_sign();
    function check_town();
    function actions(actions);
    function check()
    {
        Interactions.check_sign();
//    Interactions.check_town();
    }
    //endregion declaration

     function proceed(instance)
     {
         Interactions.inst <- instance;
         trace(2,"EXCLUSIVE_TRANSPORT_RIGHTS triggered, checking for 'GS:' magic code");
         Interactions.check();
     }

/**
 * GS Interactions -- For debugging / Sandbox "cheating" / retro-compatibility Purpose -- USE AT YOUR OWN RISK
 *
 * cg  | clear_goals   | remove existing ottd global goals
 * rg  | reset_goals   | drop and rebuild company goals
 * rh  | reset_history | empty town history delivered cargos
 * rt  | reset_towns   | refresh town
 * ?g  | check_goals   | check goals completation without waiting for half a year
 * g+  | next_goal     | manually unlock next goal
 * gf  | game=free     | set game type as free
 * gc  | game=compt    | set game type as competitive
 * s0  | sign=off      | remove industry signs
 * s1  | sign=on       | add industry signs
 */

    function action(action)
    {
        trace(1,">>>>>>>>> Interaction "+action);
        switch(action)
        {
            case "clear_goals":
            case "cg":
                trace(2,"CLEAR GOALS");
                for(local i=0;i<100;i++)
                {
                    if(GSGoal.IsValidGoal(i))
                    {
                        trace(4,"del goal " +i);
                        GSGoal.Remove(i);
                    }
                }
                break;
                
            case "reset_goals":
            case "rg":
                trace(2,"RESET COMPANY GOALS");
                for(local i=0;i<15;i++)
                {
                    comp_m.DelCompany(i);
                    comp_m.NewCompany(i);
                }
                trace(2,"rebuild global goals");
                towns.createGoals();
                break;

            case "reset_hist":
            case "rh":
                trace(2,"RESET TOWNS HISTORY");
                foreach (townid, _ in GSTownList())
                {
                    towns.InitiateCargoHist_FoundedTown(townid)
                }
                break;

            case "reset_towns":
            case "rt":
                trace(2,"RESET TOWNS DATA");
                towns.Start(true);
                break;

            case "check_goals":
            case "?g":
                trace(2,"CHECK GOALS");
                while(towns.checkNextCargo())
                {
                    //dummy
                }
                break;

            case "next_goal":
            case "g+":
                trace(2,"NEXT GOAL"); // cheater :)
                if(Def.extCargo.len()==0) return;
                local added=Def.getNextExtCargo();
                if(added.cargo!=-1)
                {
                    GSGoal.SetProgress(towns._goals[towns._etape+1],GSText(GSText.STR_GOAL_REACHED,0));
                    GSGoal.SetCompleted(towns._goals[towns._etape+1],true);

                    towns.extendWithCargo(added.cargo,towns._limites[towns._etape+1],1,added.rate,added.div,true);
                    towns._etape <- towns._etape + 1;
                }
                break;

            case "game=free":
            case "gf":
                trace(2,"CHANGE GAME TYPE TO 'FREE'");
                Interactions.inst.gameType=1;
                break;

            case "game=compet":
            case "gc":
                trace(2,"CHANGE GAME TYPE TO 'COMPETITIVE'");
                Interactions.inst.gameType=2;
                comp_m.checkHQ();
                break;
            case "signs=off":
            case "s0":
                trace(2,"REMOVE INDUSTRY SIGNS");
                industriesMgr.RAZ();
                foreach( signid, x in GSSignList())
                {
                    if(GSSign.IsValidSign(signid))
                    {
                        GSSign.RemoveSign(signid);
                    }
                }
                break;

            case "signs=on":
            case "s1":
                trace(2,"SETUP INDUSTRY SIGNS");
                industriesMgr.etat <- true;
                industriesMgr.CollectIndustryForSign();
                break;

            case "list_signs":
                trace(2,"LIST ALL SIGNS");
                trace(2,"- Game signs:");
                local signs = GSSignList();
                foreach(signid, x in signs)
                {
                    local info="found a sign, " + signid;
                    if(GSSign.IsValidSign(signid))
                    {
                        local txt = GSSign.GetName(signid);
                        info = info + " : "+txt;
                    }
                    trace(2," - "+ info);
                }
                trace(2,"- Companies signs:");
                for(local ci=0;ci<15;ci++)
                {
                    if(GSCompany.ResolveCompanyID(ci)!=GSCompany.COMPANY_INVALID)
                    local cm = GSCompanyMode(ci)
                    local signs = GSSignList();
                    foreach( signid, x  in signs)
                    {
                        local info="company "+ci+ " have a sign, " + signid;
                        if(GSSign.IsValidSign(signid))
                        {
                            info = info + " : " + GSSign.GetName(signid);
                        }
                        trace(2," - "+ info);
                    }
                }
                break;
        }
    }

}




//region check by sign

function Interactions::check_sign()
{
    trace(4,"Interactions::check_sign() call");
    local action ="";
    for(local i=0;i<15;i++)
    {
        if(GSCompany.ResolveCompanyID(i)!=GSCompany.COMPANY_INVALID)
        trace(4,"company "+i +" is valid");
        local c = GSCompanyMode(i)
        local signs = GSSignList();
//        if(!GSCompanyMode.IsDeity())
//        {
//            GSLog.Info("OK - company mode");
//        }
        foreach( signid, index in signs)
        {
            if(GSSign.IsValidSign(signid))
            {
                local txt = GSSign.GetName(signid);
                trace(4, "sign for cie "+i+" : "+txt );
                if(txt.find("GS:") == 0)
                {
                    local a=txt.slice(3);
                    trace(2, "Valid sign action : '"+a+"'" );
                    action = a;
                    GSSign.RemoveSign(signid);
                }

            }
        }
    }
//    if(GSCompanyMode.IsDeity())
//    {
//        GSLog.Info("OK - now god");
//    }

    if(action!="")
    {
        Interactions.actions(action);
    }

}

//endregion check by sign

//region check by townname
function Interactions::check_town()
{
    local towns = GSTownList();

    foreach( townid , _ in towns)
    {
        if(GSTown.IsValidTown(townid))
        {
            local txt = GSTown.GetName(townid);
            local pos=txt.find(" GS:");

            if(pos >0)
            {
                local long=txt.len()-pos-4;
                local action=txt.slice(pos+4);
//                Interactions.actions(action);
                Interactions.action(action);
                local oldname=txt.slice(0,pos);
                trace(4,"revert the town name back to :"+oldname);
                GSTown.SetName(townid,oldname);
            }
        }
    }
}
//endregion check by townname

function Interactions::actions(actions)
{
    trace(4,"Interactions :"+actions);
    local list=str_split(actions,",");
    foreach(action in list)
    {
        Interactions.action(action)
    }

}



function str_split(txt,separator)
{
    local tab=[];
    local pos=txt.find(separator);
    if(pos==null) // no separator
    {
        tab.push(txt);
        return tab;
    }
    while(pos!=null)
    {
        //trace(4,"current str'"+txt+"' ("+ txt.len()+ ")");
        local item=txt.slice(0,pos);
        //trace(4,"item '"+item+"'");
        tab.push(item);
        txt=txt.slice(pos+1);
        pos=txt.find(separator);
    }
    if(txt!="")
        tab.push(txt);
    return tab;
}


