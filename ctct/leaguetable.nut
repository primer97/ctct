class leaguetable
{
    /**@var tables = array<'key':string, 'id':?GSLeagueTable, 'el':array<GSCompany> > */
    tables = []; // leaguetable table [ key , id , el ]

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
     * Reset everything
     */
    function reset()
    {
        leaguetable.removeLeagueItems(true);
        leaguetable.tables <- [];
    }

    /**
     * Opposite of createTables()
     */
    function removeLeagueItems(dropleague=false)
    {
        foreach (league in leaguetable.tables)
        {
            if(GSLeagueTable.IsValidLeagueTable(league.id))
            {
                foreach (cid, company in companies.comp)
                {
                    if (league.el[cid] != null && GSLeagueTable.IsValidLeagueTableElement(league.el[cid])) // valid company && valid league
                        {
                        GSLeagueTable.RemoveElement(league.el[cid]);
                    }
                }
                league.el <- array(GSCompany.COMPANY_LAST); // fresh empty array of companies
            }
            if(dropleague) league.id <- null;
        }
    }
    /**
     * Build template for each Leagues
     */
    function structure()
    {
        //todo check Game mode and create the "town" league table only on competitive mode ?
        leaguetable.tables.append({ id = null, el = array(GSCompany.COMPANY_LAST), key="town" });
        leaguetable.tables.append({ id = null, el = array(GSCompany.COMPANY_LAST), key="CF"   });
    }

    /**
     * Instanciate League-table from each template and for each companies
     */
    function createTables()
    {
        foreach (league in leaguetable.tables)
        {
            if (league.id == null)
            {
                leaguetable.createLeague(league);
                for (local c_id = GSCompany.COMPANY_FIRST; c_id < GSCompany.COMPANY_LAST; c_id++)
                {
                    if (GSCompany.ResolveCompanyID(c_id) != GSCompany.COMPANY_INVALID)
                    {
                        leaguetable.buildCompanyFreshRank(league, c_id);
                    }
                }
            }
        }
    }

    function createLeague(league)
    {
        switch (league.key)
        {
            case "town":
                league.id = GSLeagueTable.New(GSText(GSText.STR_LEAGUE_NAME_TOWN) ,GSText(GSText.STR_LEAGUE_INFO),    GSText(GSText.STR_LEAGUE_BOTTOM));
                break;
            case "CF":
                league.id = GSLeagueTable.New(GSText(GSText.STR_LEAGUE_CASHFLOW)  ,GSText(GSText.STR_LEAGUE_CF_INFO), GSText(GSText.STR_LEAGUE_CF_BOTTOM));
                break;
        }
    }

    /**
     * Entry point for company creation
     */
    function NewCompany(c_id)
    {
        foreach (league in leaguetable.tables)
        {
            if (league.el[c_id] != null) continue;

            leaguetable.buildCompanyFreshRank(league, c_id);
        }
        leaguetable.updateTables();
    }

    /**
     * set initial Rank for a League & a company
     */
    function buildCompanyFreshRank(league, c_id)
    {
        if (league.id == null) return;

        switch (league.key)
        {
            case "town" :
                league.el[c_id] = GSLeagueTable.NewElement(league.id, 1, c_id, GSText(GSText.STR_LEAGUE_NOTOWN, c_id), "-", GSLeagueTable.LINK_NONE, 0); // later -> LINK_TOWN
                break;
            case "CF" :
                league.el[c_id] = GSLeagueTable.NewElement(league.id, 1, c_id, "", "-", GSLeagueTable.LINK_NONE, 0);
                break;
        }
    }

    /**
     * Entry point for company deletion
     */
    function DelCompany(c_id)
    {
        foreach (league in leaguetable.tables)
        {
            if(league.el[c_id] != null) GSLeagueTable.RemoveElement(league.el[c_id]);
            league.el[c_id] = null;
        }
        leaguetable.updateTables();
    }

    /**
     * Fully Update Tables and ranks
     */
    function updateTables()
    {
        trace(4,"leaguetable::updateTables");
        foreach (league in leaguetable.tables)
        {
            if(league.id == null) continue;
            switch (league.key)
            {
                case "town" :
                    leaguetable.updateTable_town(league);
                break;
                case "CF" :
                    leaguetable.updateTable_CashFlow12Months(league);
                break;
            }
        }
    }

    //---------------------------------------------------- League specifics

    // -- league 1 : town
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

    // -- league 2 : cash flow
    function updateTable_CashFlow12Months(league)
    {
        trace(4,"leaguetable::updateTable_cashflow");
        foreach(cid, company in companies.comp)
        {
            if(league.el[cid]!=null) // valid company
                {
                local income =   GSCompany.GetQuarterlyIncome(cid,1)   +GSCompany.GetQuarterlyIncome(cid,2)   +GSCompany.GetQuarterlyIncome(cid,3)  +GSCompany.GetQuarterlyIncome(cid,4);
                local expenses = GSCompany.GetQuarterlyExpenses(cid,1) +GSCompany.GetQuarterlyExpenses(cid,2) +GSCompany.GetQuarterlyExpenses(cid,3) +GSCompany.GetQuarterlyExpenses(cid,4);

                local cashflow = (income + expenses);

                GSLeagueTable.UpdateElementData(league.el[cid], cid, GSText(GSText.STR_LEAGUE_CF_ELEMENT, cid, income, expenses), GSLeagueTable.LINK_COMPANY , cid );

                GSLeagueTable.UpdateElementScore(league.el[cid], cashflow, GSText(GSText.STR_LEAGUE_CF_SCORE, cashflow));
            }
        }
    }

}
