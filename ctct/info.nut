/*
 * This file is part of CTCT, which is a GameScript for OpenTTD
 * Copyright (C) 2012-2013  Leif Linse
 *
 * CTCT is free software; you can redistribute it and/or modify it 
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License
 *
 * CTCT is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with CTCT; If not, see <http://www.gnu.org/licenses/> or
 * write to the Free Software Foundation, Inc., 51 Franklin Street, 
 * Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

require("version.nut");

class FMainClass extends GSInfo {
	function GetAuthor()		{ return "hpfx"; }
	function GetName()			{ return "City Controller"; }
	function GetDescription() 	{ return "City growing controller"; }
	function GetVersion()		{ return SELF_VERSION; }
	function GetDate()			{ return "2024-12-25"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "CTCT"; }
	function GetAPIVersion()	{ return "12"; }
	function GetURL()			{ return ""; }
	//function MinVersionToLoad() { return "5"; }
	
	function GetSettings() 
	{
		AddSetting(
		{name = "log_level", 
		 description = "Debug: Log level (higher = print more)", 
		 easy_value = 1, medium_value = 1, hard_value = 1, custom_value = 1, 
		 flags = CONFIG_INGAME, 
		 min_value = 1, max_value = 4}
		 );
		AddLabels("log_level", {_1 = "1: Info", _2 = "2: Details", _3 = "3: Cargo", _4 = "4: Debug" } );
		
		AddSetting(
		{name = "Difficulty_level", 
		 description = "Difficulty Level  (Growing factor)",
		 easy_value = 2, medium_value = 4, hard_value = 6, custom_value = 4, 
		 flags = CONFIG_INGAME, 
		 min_value = 1, max_value = 7}
		 );
		AddLabels("Difficulty_level", { _1 = "Very Easy", _2 = "Easy", _3 = "Slightly Easy", _4 = "Normal", _5 ="Slightly Hard",_6 = "Hard", _7 = "Very Hard" } );
		
		AddSetting(
		{name = "Unlocking_speed",
			description = "Difficulty Level (Step to unlock next cargo)",
			easy_value = 1, medium_value = 2, hard_value = 3,
			flags = CONFIG_NONE,
			min_value = 1, max_value = 3}
		);
		AddLabels("Unlocking_speed", { _1 = "Small steps (3k)", _2 = "Normal Steps (5k)", _3 = "Higher steps (7k)" } );


// deprecated
		AddSetting({
			name = "Quicker_Achievement", 
			description = "Quicker Achievement: Lower inhab requirement in competitive mode (lower difficulty)", 
			easy_value = 1, medium_value = 0, hard_value = 0, custom_value = 1, 
			flags = CONFIG_NONE | CONFIG_BOOLEAN});
			
		
		AddSetting({name = "Game_Type",
				description = "Game Mode",
				easy_value = 1,
				medium_value = 1,
				hard_value = 2,
				custom_value = 1,
				flags = CONFIG_NONE, min_value = 1, max_value = 2});
		AddLabels("Game_Type", {_1 = "Every towns are free, Collaborative Town growing",
								_2 = "Competition, Claimed Cities (set your HQ to claim)"} );
		//to do : _3 = "Competition + game stops on goal achievement"
		
		AddSetting({name = "Cargo_Selector",
				description = "Already unlocked cargos (Town acceptance)",
				easy_value = 4,
				medium_value = 2,
				hard_value = 1,
				custom_value = 2,
				flags = CONFIG_NONE, min_value = 1, max_value = 4});
		AddLabels("Cargo_Selector", {_1 = "Few: Start with Passengers only !", _2 ="Normal: Passengers and Mails", _3 = "More: Passengers, Mails and Foods", _4 ="Too much: Passenger, Mails, Foods and Goods" } );
//		AddLabels("Cargo_Selector", {_1 = "Normal: Basic cargo progressivity, unlock nexts on goals", _2 ="Few : Start with Passengers only, unlock others on goals", _3 = "Extented: Start with all cargos" } );

		AddSetting({name = "Cargo_ToUnlock",
			description = "Cargo to unlock",
			easy_value = 4,
			medium_value = 2,
			hard_value = 1,
			custom_value = 2,
				flags = CONFIG_NONE, min_value = 1, max_value = 3});
		AddLabels("Cargo_ToUnlock", {_1 = "Basics (Foods, Goods, Fruits, Water, Valuables)", _2 ="AXIS/FIRS (Foods, Goods, Fruits, Alcohol, Vehicles)", _3 = "AXIS/FIRS more (+ Farm Supply, Build Mat...)", _4 ="?" } );

		
		AddSetting({
			name = "industry_signs", 
			description = "Option: Display industry signs", 
			easy_value = 0, medium_value = 0, hard_value = 0, custom_value = 0, 
			flags = CONFIG_INGAME | CONFIG_BOOLEAN});
		
		AddSetting({
			name = "stabilizer", 
			description = "Option: town stabilizer (avoid decreasing even if bulldoze)",
			easy_value = 1, medium_value = 1, hard_value = 1, custom_value = 1, 
			flags = CONFIG_NONE | CONFIG_BOOLEAN});
		
		AddSetting({name = "owned_city_display",
				description = "Option: Owned cities indicator",
				easy_value = 1,
				medium_value = 1,
				hard_value = 1,
				custom_value = 1,
				flags = CONFIG_NONE, min_value = 1, max_value = 4});
		AddLabels("owned_city_display", {_1 = "Set the president name in the city name",
										 _2 = "Set the company name in the city name",
										 _3 = "Add a sign with the president name below the city",
										 _4 = "Add a sign with the company name below the city"
										 } );
		
		
	}
}

RegisterGS(FMainClass());
