class Interactions
{
    inst = null;
    //region declaration
    function check_sign();
    function check_town();
    function actions(actions);
    function check()
    {
        trace(1,"appel check");
        Interactions.check_sign();
//    Interactions.check_town();
    }
    //endregion declaration

     function proceed(instance)
     {
         Interactions.inst <- instance;
         trace(2,"EXCLUSIVE_TRANSPORT_RIGHTS triggered, checking for GS magic code");
         Interactions.check();
     }



    function action(action)
    {
        trace(1,">>>>>>>>> Interaction "+action);
        switch(action)
        {
            case "clear_goals":
                for(local i=0;i<40;i++)
                {
                    if(GSGoal.IsValidGoal(i))
                    {
                        trace(4,"del goal" +i);
                        GSGoal.Remove(i);
                    }
                }
                break;
                
            case "reset_goals":
                trace(2,"reset company goals");
                for(local i=0;i<15;i++)
                {
                    trace(4,"reset company "+i);
                    comp_m.DelCompany(i);
                    comp_m.NewCompany(i);
                }
                trace(2,"reset global goals");
                towns.createGoals();
                break;

            case "reset_cargos":
                trace(2,"reset cargos goals");
                towns.Start(true);
                break;

            case "game=free":
                Interactions.inst.gameType=1;
                trace(1,"change game type to 'free'");
                break;

            case "game=compet":
                trace(1,"change game type to 'competitive'");
                Interactions.inst.gameType=2;
                comp_m.checkHQ();
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
        GSLog.Info("company "+i +" is valid");
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


