class leaguetable
{
    /**@var tables = array<'name':GSText, 'id':?GSLeagueTable, 'el':array<GSCompany>, 'town':? , val:0> */
    tables = []; // la table des leaguetable [ name , id , el , town , val ]

    previousQuarterCashFlow = {};
    lastKnownQuarter = -1;

constructor()
    {
        trace(4,"leaguetable:constructor");
    }

    function init()
    {
        trace(4,"leaguetable::init");
        leaguetable.structure();
        leaguetable.createTables();
    }

    /**
     * Build template for each Leages
     */
    function structure()
    {
        leaguetable.tables.append({name = GSText.STR_LEAGUE_NAME_TOWN, id = null, el = array(GSCompany.COMPANY_LAST), town= null, val = 0 })
        leaguetable.tables.append({name = GSText.STR_LEAGUE_CASHFLOW, id = null, el = array(GSCompany.COMPANY_LAST), town= null, val = 0 })
//        for (local c_id = GSCompany.COMPANY_FIRST; c_id < GSCompany.COMPANY_LAST; c_id++)
//        {
//            leaguetable.tables[0].val.rawset(c_id,0);
//            leaguetable.tables[0].town.rawset(c_id,0);
//        }
    }

    /**
     * Instanciate League-table from templace for each compnies
     */
    function createTables()
    {
        foreach (league in leaguetable.tables)
        {
            if (league.id == null)
            {
                switch (league.name)
                {
                    case GSText.STR_LEAGUE_NAME_TOWN :
                        league.id = GSLeagueTable.New(GSText(league.name),GSText(GSText.STR_LEAGUE_INFO), GSText(GSText.STR_LEAGUE_BOTTOM));
                        break;
                    case GSText.STR_LEAGUE_CASHFLOW :
                        league.id = GSLeagueTable.New(GSText(league.name),GSText(GSText.STR_LEAGUE_CF_INFO), GSText(GSText.STR_LEAGUE_CF_BOTTOM));
                        break;
                }
//                league.id = GSLeagueTable.New(GSText(league.name),GSText(GSText.STR_LEAGUE_INFO), GSText(GSText.STR_LEAGUE_BOTTOM));
                var_dump("league.id",league.id);
                for (local c_id = GSCompany.COMPANY_FIRST; c_id < GSCompany.COMPANY_LAST; c_id++)
                {
                    if (GSCompany.ResolveCompanyID(c_id) != GSCompany.COMPANY_INVALID)
                    {
                        league.el[c_id] = leaguetable.buildFreshRank(league.id, c_id);
                    }
                }
            }
        }
    }

    function NewCompany(c_id)
    {
        foreach (league in leaguetable.tables)
        {
            if (league.el[c_id] != null) continue;

            //todo verifier si c_id existe dans league[]
//            league.el[c_id] = GSLeagueTable.NewElement(league.id, 1, c_id, "Texte", "1", GSLeagueTable.LINK_NONE, 0);
            switch (league.name) //todo move logic to buildFreshRank
                {
                case GSText.STR_LEAGUE_NAME_TOWN :
                    league.el[c_id] = leaguetable.buildFreshRank(league.id, c_id);
                    break;
                case GSText.STR_LEAGUE_CASHFLOW :
                    league.el[c_id] = leaguetable.buildFreshRankCF(league.id, c_id);
                    break;
            }
//            league.el[c_id] = leaguetable.buildFreshRank(league.id, c_id);

        }
        leaguetable.updateTables();
    }

    /**
     * set initial Rank for Town League only
     */
    function buildFreshRank(id, c_id)
    {
        return GSLeagueTable.NewElement(id, 1, c_id, GSText(GSText.STR_LEAGUE_NOTOWN, c_id), "-", GSLeagueTable.LINK_NONE, 0); //LINK_TOWN
    }

    /**
     * set initial Rank for Town CashFlow only -- to do merge with buildFreshRank
     */
    function buildFreshRankCF(id, c_id)
    {
        return GSLeagueTable.NewElement(id, 1, c_id, "", "-", GSLeagueTable.LINK_NONE, 0);
    }



    function DelCompany(c_id)
    {
        foreach (league in leaguetable.tables)
        {
            if(league.el[c_id] != null) GSLeagueTable.RemoveElement(league.el[c_id]);
            league.el[c_id] = null;
        }
        leaguetable.updateTables();
    }

    function updateTables()
    {
        trace(4,"leaguetable::updateTables");
        foreach (league in leaguetable.tables)
        {
            switch (league.name)
            {
                case GSText.STR_LEAGUE_NAME_TOWN :
                    leaguetable.updateTable_town(league);
                break;
                case GSText.STR_LEAGUE_CASHFLOW :
                    leaguetable.updateTable_CashFlow12Months(league);
                break;
            }
        }
    }

    function updateTable_town(league)
    {
        trace(4,"leaguetable::updateTable_town");
        foreach(cid, company in companies.comp)
        {
        // 'HQTile' - > location of HQ (tileID)
        // 'town'   - > claimed townID
        // 'sign'   - > signID of sign used to name
        // 'goal'   - > company goalID
        // 'etat'   - > status code : 0=no HQ    1=HQ set    20 to 10=HQ in conflict

            if(league.el[cid]!=null)
            {
                local score=0;
                if(company.etat==1) //HQ Set
                {
                    score = GSTown.GetPopulation(company.town);
                    trace(4,"leaguetable:: HQSet for cid "+cid+" score="+score);
                    GSLeagueTable.UpdateElementData(league.el[cid], cid, GSText(GSText.STR_LEAGUE_NORMAL, company.town,cid), GSLeagueTable.LINK_TOWN , company.town );
                }
                else
                {
                    GSLeagueTable.UpdateElementData(league.el[cid], cid, GSText(GSText.STR_LEAGUE_NOTOWN, cid) , GSLeagueTable.LINK_NONE, 0);
                }

                GSLeagueTable.UpdateElementScore(league.el[cid], score, GSText(GSText.STR_LEAGUE_SCORE, score));
            }
        }
    }

    function GetDayInQuarter()
    {
        local currentDate = GSDate.GetCurrentDate();
        local month = GSDate.GetMonth(currentDate);
        local dayOfMonth = GSDate.GetDayOfMonth(currentDate);
        local dayInQuarter = dayOfMonth + (month - 1) * 30;
        return dayInQuarter % 91;
    }

    function updateTable_CashFlow(league)
    {
        local dayInQuarter = leaguetable.GetDayInQuarter()
        local month=GSDate.GetMonth(GSDate.GetCurrentDate());
        local divisor = month %3;
        if(divisor ==0) divisor = 3;

        trace(4,"leaguetable::updateTable_cashflow, Month:"+month+" ("+divisor+") Qday:"+dayInQuarter);

        foreach(cid, company in companies.comp)
        {
            if(league.el[cid]!=null) // valid company
            {

                // current Month
                local income = GSCompany.GetQuarterlyIncome(cid,GSCompany.CURRENT_QUARTER );
                local incomeMonth = income / divisor;
                local expenses = GSCompany.GetQuarterlyExpenses(cid,GSCompany.CURRENT_QUARTER ); // is already negative !
                local expensesMonth = expenses / divisor;
                trace(4,"CF "+cid+" CurrentQ("+income+" "+expenses+") -> CurrentM("+incomeMonth+" "+expensesMonth+") scrore="+(incomeMonth + expensesMonth));

                if(dayInQuarter<15) // too few days, not relevant, take last quarter
                {
                    incomeMonth = GSCompany.GetQuarterlyIncome(cid, 1 ) / 3;
                    expensesMonth = GSCompany.GetQuarterlyExpenses(cid, 1 ) / 3;
                    trace(4,"CF "+cid+" update with Last Quarter CurrentM("+incomeMonth+" "+expensesMonth+") scrore="+(incomeMonth + expensesMonth));
                }
                local cashflow = (incomeMonth + expensesMonth);


                GSLeagueTable.UpdateElementData(league.el[cid], cid, GSText(GSText.STR_LEAGUE_CF_ELEMENT, cid, incomeMonth/2, expensesMonth/2), GSLeagueTable.LINK_COMPANY , cid );

                GSLeagueTable.UpdateElementScore(league.el[cid], cashflow/2, GSText(GSText.STR_LEAGUE_CF_SCORE, cashflow/2)); // scrores are multiplied by 2 when displayed I dont know why !
            }
        }
    }

    function updateTable_CashFlow1Quarter(league)
    {

        trace(4,"leaguetable::updateTable_cashflow");

        foreach(cid, company in companies.comp)
        {
            if(league.el[cid]!=null) // valid company
                {

                local income = GSCompany.GetQuarterlyIncome(cid,1);
                local expenses = GSCompany.GetQuarterlyExpenses(cid,1);
                trace(4,"CF "+cid+" Q1-Q4("+income+" "+expenses+") ");

                local cashflow = (income + expenses);

                GSLeagueTable.UpdateElementData(league.el[cid], cid, GSText(GSText.STR_LEAGUE_CF_ELEMENT, cid, income/2, expenses/2), GSLeagueTable.LINK_COMPANY , cid );

                GSLeagueTable.UpdateElementScore(league.el[cid], cashflow/2, GSText(GSText.STR_LEAGUE_CF_SCORE, cashflow/2)); // scrores are multiplied by 2 when displayed I dont know why !
            }
        }
    }

    function updateTable_CashFlow12Months(league)
    {

        trace(4,"leaguetable::updateTable_cashflow");

        foreach(cid, company in companies.comp)
        {
            if(league.el[cid]!=null) // valid company
                {

                local income = GSCompany.GetQuarterlyIncome(cid,1) + GSCompany.GetQuarterlyIncome(cid,2) + GSCompany.GetQuarterlyIncome(cid,3) + GSCompany.GetQuarterlyIncome(cid,4);
                local expenses = GSCompany.GetQuarterlyExpenses(cid,1)+GSCompany.GetQuarterlyExpenses(cid,2)+GSCompany.GetQuarterlyExpenses(cid,3)+GSCompany.GetQuarterlyExpenses(cid,4);
                trace(4,"CF "+cid+" Q1-Q4("+income+" "+expenses+") "); //these number are half real number ?

                local cashflow = (income + expenses);

                GSLeagueTable.UpdateElementData(league.el[cid], cid, GSText(GSText.STR_LEAGUE_CF_ELEMENT, cid, income, expenses), GSLeagueTable.LINK_COMPANY , cid );

                GSLeagueTable.UpdateElementScore(league.el[cid], cashflow, GSText(GSText.STR_LEAGUE_CF_SCORE, cashflow));
            }
        }
    }

}
