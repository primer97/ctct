class leaguetable
{
    tables = []; // la table des leaguetable [ name , id , el , town , val ]

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

    function structure()
    {
        leaguetable.tables.append({name = GSText.STR_LEAGUE_NAME_TOWN, id = null, el = array(GSCompany.COMPANY_LAST), town= null, val = 0 })
//        for (local c_id = GSCompany.COMPANY_FIRST; c_id < GSCompany.COMPANY_LAST; c_id++)
//        {
//            leaguetable.tables[0].val.rawset(c_id,0);
//            leaguetable.tables[0].town.rawset(c_id,0);
//        }
    }

    function createTables()
    {
        foreach (league in leaguetable.tables)
        {
            if (league.id == null)
            {
                league.id = GSLeagueTable.New(GSText(league.name),GSText(GSText.STR_LEAGUE_INFO), GSText(GSText.STR_LEAGUE_BOTTOM));
                var_dump("league.id",league.id);
                for (local c_id = GSCompany.COMPANY_FIRST; c_id < GSCompany.COMPANY_LAST; c_id++)
                {
                    if (GSCompany.ResolveCompanyID(c_id) != GSCompany.COMPANY_INVALID)
                    {
//                        league.el[c_id] = GSLeagueTable.NewElement(league.id, 1, c_id, GSText(GSText.STR_LEAGUE_NOTOWN, c_id), "-", GSLeagueTable.LINK_NONE, 0); //LINK_TOWN
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
            league.el[c_id] = leaguetable.buildFreshRank(league.id, c_id);

        }
        leaguetable.updateTables();
    }

    function buildFreshRank(id, c_id)
    {
        return GSLeagueTable.NewElement(id, 1, c_id, GSText(GSText.STR_LEAGUE_NOTOWN, c_id), "-", GSLeagueTable.LINK_NONE, 0); //LINK_TOWN
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
}
