class stabilizer
{
	_houses = {}; // associtive array  townid=> house_count
	stab = 0; // mode stabilizer active 0/1
	constructor()
	{
	}

	/**
	 * Read settings.
	 * Called at game start, or at gamesave load.
	 */
	function Init()
	{
		stabilizer.stab <- GSController.GetSetting("Stabilizer");
	}

	/**
	 * Initialize stabilizer: makes all town stalled and save house count.
	 * Called only on new game.
	 */
	function NewGame()
	{
		if(!stabilizer.stab) return ;
		trace(2,"Stabilizer : active");
		local all_towns = GSTownList();
		
		foreach (town, _ in all_towns)
		{
			// save house count
			stabilizer._houses[town] <-	GSTown.GetHouseCount(town);
			// start "stalled"
			towns_m.townStalled(town);
		}
	}

	// check if town population is decreasing, we want to keep population same level
	function checkNoDecreasing(town,nbhouse)
	{
		if(!stabilizer.stab) return ;
		if(nbhouse<stabilizer._houses[town])
		{ // we have less hous than previous
			local newmaison=min(stabilizer._houses[town]-nbhouse,3); // max 3 new houses to create at once, no more
			trace(4,"Stabilizer : detected houses missing... ===> new houses to build :"+newmaison);
			GSTown.ExpandTown(town,newmaison);
		}
		else
		{
			stabilizer._houses[town]<-nbhouse; // we increaed amount of houses, save new number
		}
	}

	// a new town got founded
	function newTown(id)
	{
		if(!stabilizer.stab) return ;
		trace(4,"New Town to monitor on stabilizer"+id);
		stabilizer._houses[id] <- GSTown.GetHouseCount(id);
		towns_m.townStalled(id);
	}
};

