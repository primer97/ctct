/*
 * This file is part of MinimalGS, which is a GameScript for OpenTTD
 * Copyright (C) 2012-2013  Leif Linse
 *
 * MinimalGS is free software; you can redistribute it and/or modify it 
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License
 *
 * MinimalGS is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with MinimalGS; If not, see <http://www.gnu.org/licenses/> or
 * write to the Free Software Foundation, Inc., 51 Franklin Street, 
 * Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */


/** general **/
require("version.nut"); // get SELF_VERSION

/** Import modules **/
require("defines.nut");
require("utils.nut"); // dump function
require("towns.nut"); // les villes
require("industry.nut"); // les industries
require("companies.nut"); // les companies
require("stabilizer.nut"); // les companies

towns_m <- towns; // le gestionaire des villes...
def_m <- Def; // les definitions
indus_m <- industriesMgr; // le gestionaire d'industries
comp_m <- companies; // les companies
stab_m <- stabilizer; // le stabilisateur

class MainClass extends GSController 
{
	_loaded_data = null;
	_init_done = null;
	_init_newgame = null;
	gameType = null;
	constructor()
	{
		this._init_done = false;
		this._loaded_data = null;
		this._init_newgame = true;
	}
}

 /* Point d'entrée principal (boucle)
  * Appelé aprés un Load ou bien lors d'une nouvelle partie
  */
function MainClass::Start()
{
	// Initialisation durant le génération de la carte.
	this.Init();
	this.gameType = GSController.GetSetting("Game_Type");
	// attente du début du jeu. (une fois que la carte est complement généré)
	if(isVer14()==false) GSController.Sleep(1); // ancienne version : une tempo.
	// Deuxieme phase de l'initialisation, celle qui necessite que la carte soit terminée. (la companie 0 existe à ce point)
	this.InitStep2(this._init_newgame);
	
	// Boucle Principale
	local last_loop_date = GSDate.GetCurrentDate();
	while (true) {
		local loop_start_tick = GSController.GetTick();

		this.HandleEvents(); // Les evenements en provenance du jeu.
		
		trace(4,"game type="+this.gameType);
		if(this.gameType==2) comp_m.checkHQ(); // verifie les competiteurs
		
		
		local current_date = GSDate.GetCurrentDate();
		if (last_loop_date != null) {
			local year = GSDate.GetYear(current_date);
			local month = GSDate.GetMonth(current_date);
			if (year != GSDate.GetYear(last_loop_date)) {
				this.EndOfYear();
			}
			if (month != GSDate.GetMonth(last_loop_date)) {
				this.EndOfMonth();
				if(month==7 || month ==1) this.HalfAYear();
			}
		}
		last_loop_date = current_date;
	
		// se reveille tous les 5 jours (74 ticks par jour)
		local ticks_used = GSController.GetTick() - loop_start_tick;
		GSController.Sleep(max(1,5 * 74 - ticks_used));
	}
	
}

// deuxieme phase del'intialisation (tout est en place, la partie a deja commencé)
function MainClass::InitStep2(newgame)
{
	if(newgame) stab_m.NewGame(); // enregistrement des maisons
	
	towns_m.Start(newgame); // lecture des vecteurs et 1er tour de calcul town
	indus_m.Init();
	
//	GSGoal.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_COLORS), GSGoal.GT_NONE, 0);
	if(newgame) 
	{
		local towngoal = towns_m.createGoals(); // creation des goals
		comp_m.SetGoalVal(towngoal);
	}
}

// premiere phase de l'intialisation (pendant la generation du monde) le cout est moindre mais on ne peut pas tout faire.
function MainClass::Init()
{
	if (this._loaded_data != null)  // si on arrive depuis une sauvegarde.
	{
		indus_m.signs <- this._loaded_data["signes"];	// la liste des identifiants de signes.
		towns_m._etape <- this._loaded_data["etape"];	// l'avancement des cargo (passage des cargo etendu aux cargo a recevoir)
		towns_m._prevQty <- this._loaded_data["histo"]; // historique des receptions de cargo.
		towns_m._goals <- this._loaded_data["goals"];
		towns_m._limites <- this._loaded_data["limites"];
		towns_m._toreach <- this._loaded_data["toreach"];
		comp_m.comp <- this._loaded_data["companies"];
		comp_m.SetGoalVal(this._loaded_data["towngoal"]);
		comp_m.compete_goal <-this._loaded_data["competegoal"];
		stab_m._houses <- this._loaded_data["stab"];
	} else 
	{	// appelle de la partie init (qui fait l'objet de la sauvegarde par ailleurs)
		towns_m.NewGame();
	}
	this._init_done = true; 	// Indicate that all data structures has been initialized/restored.
	this._loaded_data = null; 	// the loaded data has no more use now after that _init_done is true.
	this.Settings(); // organise les settings specifiques pour ce script.
	stab_m.Init();
}

// Les evenements (ex: ET_INDUSTRY_OPEN, ET_INDUSTRY_CLOSE, ET_TOWN_FOUNDED, ET_EXCLUSIVE_TRANSPORT_RIGHTS, ET_COMPANY_MERGER, ET_COMPANY_BANKRUPT )
function MainClass::HandleEvents()
{
	if(GSEventController.IsEventWaiting()) {
		local ev = GSEventController.GetNextEvent();
		if (ev == null) return;

		local ev_type = ev.GetEventType();
		switch (ev_type) 
		{
			case GSEvent.ET_COMPANY_NEW: 
				local company_event = GSEventCompanyNew.Convert(ev);
				local company_id = company_event.GetCompanyID();
				trace(2,"New Company "+company_id);
				//Story.ShowMessage(company_id, GSText(GSText.STR_WELCOME, company_id));
				if(this.gameType==2) comp_m.NewCompany(company_id);
				break;
			case GSEvent.ET_COMPANY_BANKRUPT:
				local deadcompany = GSEventCompanyBankrupt.Convert(ev).GetCompanyID();
				if(this.gameType==2) comp_m.DelCompany(deadcompany);
				break;
			case GSEvent.ET_COMPANY_MERGER:
				local merged = GSEventCompanyMerger.Convert(ev).GetOldCompanyID();
				if(this.gameType==2) comp_m.DelCompany(merged);
				break;
			case GSEvent.ET_INDUSTRY_OPEN:
				this.ManageIndustry("open",ev);
				break;
			case GSEvent.ET_INDUSTRY_CLOSE:
				this.ManageIndustry("close",ev);
				break;
			case GSEvent.ET_TOWN_FOUNDED:
				towns_m.newTown(GSEventTownFounded.Convert(ev).GetTownID());
				break;
		}
	}
}
// gestion des evenements concernant les industries
function ManageIndustry(type,ev)
{
	local gs_event_industry_close = GSEventIndustryClose.Convert(ev); //TODO GSEventIndustryOpen
	local industry_id = gs_event_industry_close.GetIndustryID();
	switch(type)
	{
		case "close":
		indus_m.delIndustry(industry_id);
		break;
		case "open":
		indus_m.newIndustry(industry_id);
		break;
	}
}

/*
 * Traitements de fin de mois
 */
function MainClass::EndOfMonth()
{
	local start_tick = GSController.GetTick();
	trace(2,"* end of month *");
	indus_m.Update();
	towns_m.Update();
	if(this.gameType==2) comp_m.checkCompetition();
	
	trace(1,"duration:"+(GSController.GetTick() - start_tick));
}
/*
 * Traitements de fin d'année (appelé avant la fin de mois)
 */
function MainClass::EndOfYear()
{
	trace(2,"* end of year *");
	towns_m.updateDiffRate(); //met à jour le niveau de difficulté
	towns_m.ComputeAvgHab(); // met a jour la moyene d'hab par maison
}

/*
 * Traitements 2 fois par an (debut janvier et debut juin)
 * (appelé apres le fin de mois précedant)
 */
function MainClass::HalfAYear()
{
	trace(2,"* Half a year *");
	towns_m.checkNextCargo();
}

/*
 * Les objets a sauvegarder (par de float, ni d'instance de classe)
 * sont a regrouper dans une table retournée par cette methode. (a voir : uniquement des "arrays of integers" ?)
 */
function MainClass::Save()
{
	trace(1,"Saving data to savegame");

	if (!this._init_done) // si init non encore terminé, sauvegarde ce qu'on peut... (rien ou les données lues)
	{
		return this._loaded_data != null ? this._loaded_data : {};
	}

	return { 
		signes = indus_m.signs, /* liste des signes */
		etat = indus_m.etat, /* affichage des signes */
		histo = towns_m._prevQty, /* historique des cargo/villes */
		etape = towns_m._etape, /* avancé dans la la decouverte des cargos */
		goals = towns_m._goals, /* la liste des objectifs */
		limites = towns_m._limites, /* les limites pour les villes */
		toreach = towns_m._toreach,  /* le nombre de villes concernés */
		companies = comp_m.comp, /* les companies... */
		towngoal = comp_m.goalval, /* l'objectif company pour la ville owned */
		competegoal = comp_m.compete_goal, /* l'id du goal global */
		stab = stab_m._houses /* le nombre de maison pour le stabilisateur */
	};
}

/*
 * Appelé au chargement d'une sauvegarde. Ensuite, c'est Start() qui sera appelé, c'est dans Init que seront affecté les données aux objets locaux.
 */
function MainClass::Load(version, tbl)
{
	trace(1,"Loading data from savegame...");
	this._loaded_data = {}
	this._init_newgame=false;
   	foreach(key, val in tbl) 
	{
	//	trace(4,"load:"+key);
	//	trace(4,dump(val));
		this._loaded_data.rawset(key, val);
	}
	trace(2,"End of loading");
}

function MainClass::Settings()
{
	if(GSGameSettings.IsValid("economy.fund_buildings"))
		GSGameSettings.SetValue("economy.fund_buildings",0); // empeche le financement de nouvelles maison	
}