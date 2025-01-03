﻿class stabilizer
{
	_houses = {}; // la table (asociatif) town=> nb_house
	stab = 0; // mode stabilizer active
	constructor()
	{
	}

	function Init() // cette fonction est appelle au demarrage ou bien au chargement d'une partie
	{
		stabilizer.stab <- GSController.GetSetting("Stabilizer");
	}
	
	function NewGame()	// cette fonction est appelle dans le cas d'une nouvelle partie uniquement
	{
		if(!stabilizer.stab) return ;
		trace(2,"Stabilizer : active");
		local all_towns = GSTownList();
		
		foreach (town, _ in all_towns)
		{
			// enregistre le nombre de maison
			stabilizer._houses[town] <-	GSTown.GetHouseCount(town);
			// pas de croissance au depart
			towns_m.townStalled(town);
		}
	}

	function checkNoDecreasing(town,nbhouse)
	{ //verifie que la ville n'est pas en decroissance (garde le meme nombre de maison)
		if(!stabilizer.stab) return ;
		if(nbhouse<stabilizer._houses[town])
		{ // il y a moins de maisons !
			local newmaison=min(stabilizer._houses[town]-nbhouse,3); // pas plus de 3 maisons d'un coups hein...
			trace(4,"Stabilizer : detected houses missing... ===> new houses to build :"+newmaison);
			GSTown.ExpandTown(town,newmaison);
		}
		else
		{
			stabilizer._houses[town]<-nbhouse; // on enregistre le nombre de maison, car on est plus haut ;)
		}
	}



	// une nouvelle ville
	function newTown(id)
	{
		if(!stabilizer.stab) return ;
		trace(4,"New Town to monitor on stabilizer"+id);
		stabilizer._houses[id] <- GSTown.GetHouseCount(id);
		towns_m.townStalled(id);
	}
};

