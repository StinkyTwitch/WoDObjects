--[[------------------------------------------------------------------------------------------------
WoDObjects:
Automatic object interaction for Warlords of Draenor.

Credits:
G1zStar, based entirely on his code that he was awesome enough to share with me. I just reformatted
it and made it into a stand alone AddOn.
StinkyTwitch.

Usage:
At a command line type /wodobj or put "/wodobj" into a macro. This will toggle the AddOn to go from
FALSE state to TRUE state and run. Right now the timers are hard coded. It will only do the object
scan every 1/10th of a second. If an object is found the AddOn will only attempt to interact with it
once every second. This is to help prevent disconnects.

A future version will have the timers user configurable.
A future version MAY include previous expansions objects.
--------------------------------------------------------------------------------------------------]]

WoDObjects = {}
WoDObjects.toggle = false

--[[------------------------------------------------------------------------------------------------
WOD OBJECT TABLES
--------------------------------------------------------------------------------------------------]]
local WoDObjectsTanaan = {
	-- "Archmage Khadgar",
	"Mark of the Shadowmoon",
	"Mark of the Bleeding Hollow",
	"Mark of the Burning Blade",
	"Mark of the Shattered Hand",
	"Mark of the Blackrock",
	"Stasis Rune",
	"Bleeding Hollow Cage",
	"Blood Ritual Orb",
	"Iron Horde Weapon",
	"Iron Horde Weapon Rack",
	"Blackrock Powder Keg",
	"Makeshift Plunger",
	"Worldbreaker Side Turret",
	"Main Cannon Trigger",
}

local WoDObjectsAshran = {
	-- Quests
	"Slippery Slime",
	-- Treasures
}

local WoDObjectsFrostfireRidge = {
	"Architect Table",
	"Ball and Chain",
	"Barbed Thunderlord Spear",
	"Barrel of Frostwolf Oil",
	"Blackrock Blasting Powder",
	"Bounty of Bladespire",
	"Command Table",
	"Drudgeboat Salvage",
	"Dungar Frostmane",
	"Finalize Garrison Plot",
	"Frost Wolf",
	"Frost Wolf Howler##78894",
	"Frost Wolf Howler",
	"Frostwolf Axe",
	"Frostwolf Collar",
	"Frostwolf Crate",
	"Frostwolf Gladiator",
	"Frostwolf Grunt",
	"Frostwolf Rylak",
	"Frostwolf Shamanstone",
	"Frostwolf Slave",
	"Frostwolf Traveler's Pack",
	"Frostwolf Warrior",
	"Gana Surehide",
	"Garrison Blueprint: Barracks",
	"Garrison Cache",
	"Gol'kosh the Axe",
	"Heavy Plating",
	"Horde Banner",
	"Icevine",
	"Iron Horde Cannon",
	"Iron Horde Supplies",
	"Ladder",
	"Makar Stonebinder",
	"Master Surveyor",
	"Matron Suma",
	"Mulverick's Cage",
	--"Nerok",
	"North Incubator Cage",
	"Ogre Barricade",
	"Ogre Spike",
	"Olin Umberhide",
	"Roknor",
	"Rota Surehide",
	"Shivertail's Father",
	"Shivertail's Mother",
	"Siege Munitions",
	"South Incubator Cage",
	"Thunderlord Ballista",
	"Thunderlord Supplies",
	"Thunderlord War Rylak",
	"Tree Marking",
	"West Incubator Cage",
	"Wor'gol Villager",

	-- Treasures
	"Dusty Chest",
	"Lucky Coin",
	"Snow-Covered Strongbox",
	"Gnawed Bone",
	"Sealed Jug",
	"Supply Dump",
	"Pale Loot Sack",
	"Frozen Frostwolf Axe",
	"Slave's Stash",
	"Thunderlord Cache",
	"Burning Pearl",
	"Crag-Leaper's Cache",
	"Glowing Obsidian Shard",
	"Survivalist's Cache",
	"Goren Leftovers",
	"Grimfrost Treasure",
	"Raided Loot",
	"Forgotten Supplies",
	"Frozen Orc Skeleton",
	"Iron Horde Munitions",
	"Lady Sena's Other Materials Stash",
	"Iron Horde Supplies",
	"Wiggling Egg",
	"Spectator's Chest",
	"Arena Master's War Horn",
	"Envoy's Satchel",
	"Lagoon Pool",
	"Obsidian Petroglyph",
	"Young Orc Woman",
}

local WoDObjectsGarrison = {
	-- Quests
	"Fireweed",
	"Frostweed",
	"Gorgrond Flytrap",
	"Nagrand Arrowbloom",
	"Starflower",
	"Talador Orchid",
	-- Treasures
	"Lady Sena's Other Materials Stash",
}

local WoDObjectsGorgrond = {
	-- Quests
	"Ancient Seedbearer",
	"Bluff Rylak",
	"Chag the Noseless",
	"Dead Laughing Skull",
	"Dead Skulltaker",
	"Doomshot",
	"Drained Fungal Heart",
	"Glowing Mushroom",
	"Grom'kar Messenger",
	"Iron Horde Bonfire",
	"Longtooth Gorger",
	"Meka the Face Chewer",
	"Mulching Body",
	"Nazgrel's Cage",
	"Nisha",
	"Ogre Cage",
	"Penny's Plunger",
	"Pollen Pod",
	"Primal Seeds",
	"Rope Spike",
	"Saberon Stash",
	"Shackle",
	"Thukmar's Research",
	"Torg Earkeeper",
	"Weapon Loader",
	"Weaponization Orders",
	"Will of the Genesaur",
	-- Treasures
	"Brokor's Sack",
	"Discarded Pack",
	"Evermorn Supply Cache",
	"Explorer Canister",
	"Femur of Improbability",
	"Harvestable Precious Crystal",
	"Horned Skull",
	"Iron Supply Chest",
	"Laughing Skull Cache",
	"Ockbar's Pack",
	"Odd Skull",
	"Petrified Rylak Egg",
	"Pile of Rubble",
	"Remains of Balik Orecrusher",
	"Remains of Balldir Deeprock",
	"Sasha's Secret Stash",
	"Sniper's Crossbow",
	"Stashed Emergency Rucksack",
	"Strange Looking Dagger",
	"Sunken Treasure",
	"Suntouched Spear",
	"Vindicator's Hammer",
	"Warm Goren Egg",
	"Weapons Cache",

}

local WoDObjectsTalador = {
	"Altar of Ango'rosh",
	"Ancient Prism",
	"Annals of Aruuna",
	"Arcane Crystals",
	"Arcane Nexus",
	"Arcane Vortex",
	"Arkonite Crystal",
	"Arkonite Pylon",
	"Aruunem Berry Bush",
	"Astral Ward",
	"Auchenai Ballista",
	"Auchenai Prayerbook",
	"Auch'naaru",
	"Barum's Note",
	"Blackrock Bomb",
	"Body Pile",
	"Burning Resonator",
	"Crystal-Shaper's Tools",
	"Decommissioned Iron Shredder",
	"Defiling Crystal",
	"Demonic Gateway",
	"Drafting Table",
	"Forge",
	"Garrison Records",
	"Gazlowe's Eye 'n' Ear",
	"Gordunni Boulderthrower",
	"Harmonic Crystal",
	"Hastily Written Note",
	"Honed Crystal",
	"Iron Horde Explosives",
	"Iron Horde Siege Engine",
	"Iron Shredder Decommission Orders",
	"Iron Shredder Prototype",
	"Iron Star",
	"Karab'uun",
	"Khadgar's Portal",
	"Krelas' Portal",
	"Leafshadow",
	"Melani's Doll",
	"Panicked Young Prowler",
	"Polished Crystal",
	"Portal to Talador",
	"Roaring Fire",
	"Sack of Supplies",
	"Shadow Council Communicator",
	"Shadow Orb",
	"Sha'tari",
	"Slumbering Protector",
	"Telmor Registry",
	"The Art of Darkness",
	"Zorka's Void Gate",

	-- Treasures
	"Aarko's Family Treasure",
	"Amethyl Crystal",
	"Aruuna Mining Cart",
	"Barrel of Fish",
	"Bonechewer Remnants",
	"Bonechewer Spear",
	"Bright Coin",
	"Charred Sword",
	"Curious Deathweb Egg",
	"Draenei Weapons",
	"Farmer's Bounty",
	"Foreman's Lunchbox",
	"Iron Box",
	"Jug of Aged Ironwine",
	"Keluu's Belongings",
	"Ketya's Stash",
	"Light of the Sea",
	"Lightbearer",
	"Luminous Shell",
	"Pure Crystal Dust",
	"Relic of Aruuna",
	"Relic of Telmor",
	"Rook's Tacklebox",
	"Rusted Lockbox",
	"Soulbinder's Reliquary",
	"Teroclaw Nest",
	"Treasure of Ango'rosh",
	"Webbed Sac",
	"Yuuri's Gift",
}

local WoDObjectsSpiresOfArak = {
	"Armory Cannon",
	"Cannonball",
	"Cursed Arakkoa",
	"Effigy of Terokk",
	"Firebomb",
	"Firebomb Plunger",
	"Illusion Charm",
	"Injured Crewman",
	"Ishaal's Orb",
	"Poison Barrel",
	"Ragged Mask",
	"Ravager Egg",
	"Ravager Grub",
	"Serviceable Gear",
	"Skizzik",
	"Spore-be-Gone Turret",
	"Syth",
	"Syth's Bookcase",
	"Vigilant Outcast",
	"Weathered Wingblades",
	-- Treasures
	"Abandoned Mining Pick",
	"An Old Key",
	"Assassin's Spear",
	"Campaign Contributions",
	"Coinbender's Payment",
	"Elixir of Shadow Sight",
	"Fractured Sunstone",
	"Garrison Supplies",
	"Garrison Workman's Hammer",
	"Iron Horde Explosives",
	"Lost Herb Satchel",
	"Lost Ring",
	"Mysterious Mushrooms",
	"Offering to the Raven Mother",
	"Ogron Plunder",
	"Orcish Signaling Horn",
	"Outcast's Belongings",
	"Outcast's Pouch",
	"Rooby's Roo",
	"Sailor Zazzuk's 180-Proof Rum",
	"Sethekk Ritual Brew",
	"Shattered Hand Cache",
	"Shattered Hand Lockbox",
	"Shredder Parts",
	"Spray-O-Matic 5000 XT",
	"Sun-Touched Cache",
	"Toxicfang Venom",
	"Waterlogged Satchel",
}

local WoDObjectsNagrand = {
	-- Quests
	"Arkonite Crystal",
	"Iron Supply Crate",
	"Telaari Crystal",
	-- Treasures
	"A Pile of Dirt",
	"Abandoned Cargo",
	"Abandoned Fishing Rod",
	"Abu'Gar's Favorite Lure",
	"Abu'gar's Missing Reel",
	"Abu'gar's Vitality",
	"Adventurer's Mace",
	"Adventurer's Pack",
	"Adventurer's Pouch",
	"Adventurer's Sack",
	"Adventurer's Staff",
	"Ancient Snarlpaw Skull",
	"Appropriated Warsong Supplies",
	"Bag of Herbs",
	"Bone-Carved Dagger",
	"Bounty Board",
	"Bounty of the Elements",
	"Box of Ogre Research",
	"Brazwix's Treasure",
	"Brilliant Dreampetal",
	"Buried Timewarped Staff",
	"Burning Blade Locker",
	"Burning Blade Sword",
	"Ceremonial Pyre",
	"Challe",
	"Elemental Offering",
	"Elemental Shackles",
	"Ember Blossom",
	"Fallen Horde Soldier",
	"Fragment of Oshu'gun",
	"Frightened Spirit",
	"Freshwater Clam",
	"Fungus-Covered Chest",
	"Gambler's Purse",
	"Garrison Blueprints",
	"Gar'rok",
	"Genedar Debris",
	"Goblin Pack",
	"Golden Kaliri Egg",
	"Goldtoe's Plunder",
	"Grizzlemaw's Bonepile",
	"Hidden Stash",
	"Highmaul Sledge",
	"Important Exploration Supplies",
	"Iron Horde War Machine",
	"Lazy Peon",
	"Lost Pendant",
	"Mixed Unit Tactics",
	"Mountain Climber's Pack",
	"Nagrand Cherry",
	"Nagrand Scouting Report",
	"Nether Beacon",
	"Ogre Beads",
	"Ogre Scrolls",
	"Pale Elixir",
	"Pillar of Earth",
	"Pillar of Flame",
	"Pillar of Water",
	"Pillar of Wind",
	"Pokkar's Thirteenth Axe",
	"Polished Saberon Skull",
	"Pristine Lily",
	"Ritual Totem",
	"Rusty Keys",
	"Sabermaw Cage",
	"Saberon Stash",
	"Smuggler's Cache",
	"Spirit Coffer",
	"Steamwheedle Supplies",
	"Stolen Goods",
	"Summoning Brazier",
	"Telaar Defender Shield",
	"Treasure of Kull'krosh",
	"Void-Infused Crystal",
	"Void Crystal",
	"Void Portal",
	"Warsong Attack Plans",
	"Warsong Cache",
	"Warsong Command Brief",
	"Warsong Helm",
	"Warsong Lockbox",
	"Warsong Outrider Orders",
	"Warsong Spear",
	"Warsong Spoils",
	"Warsong Supplies",
	"Watertight Bag",
}

--[[------------------------------------------------------------------------------------------------
WOD OBJECT INTERACT
--------------------------------------------------------------------------------------------------]]
function WoDObjects.Interact()
	
	--[[
	Interact with Khadgar in Blasted Lands, Orgrimar and Shrine. This was for launch night and all
	the god damn people blocking him. After launch this really isn't necessary but its still in here.
	--]]
	if (GetCurrentMapContinent() == 2) or
	   (GetCurrentMapContinent() == 6 and GetCurrentMapZone == 12) or
	   (GetCurrentMapContinent() == 1 and GetCurrentMapZone() == 20) then
		for i = 1, ObjectCount() do
			local curObj = ObjectWithIndex(i)
			if ObjectName(curObj) == "Archmage Khadgar" and WoDObjects.Distance(curObj, nil) <= 8 then
				C_Timer.After(1, function() ObjectInteract(curObj) end)
				return
			end
		end
	end
		
	--[[
	Draenor (ID: 7)
	--]]
	if GetCurrentMapContinent() == 7 then
		--[[
		Tanaan (ID: 0)
		--]]
		if GetCurrentMapZone() == 0 then
			for i = 1, ObjectCount() do
				local curObj = ObjectWithIndex(i)
				if tContains(WoDObjectsTanaan, ObjectName(curObj)) and WoDObjects.Distance(curObj) <= 8 then
					--ObjectInteract(curObj)
					C_Timer.After(1, function() ObjectInteract(curObj) end)
					return
				end    					
			end
		end
		
		--[[
		Ashran (ID: 1)
		--]]
		if GetCurrentMapZone() == 1 then
			for i = 1, ObjectCount() do
				local curObj = ObjectWithIndex(i)
				if tContains(WoDObjectsAshran, ObjectName(curObj)) and WoDObjects.Distance(curObj) <= 8 then
					--ObjectInteract(curObj)
					C_Timer.After(1, function() ObjectInteract(curObj) end)
					return
				end    					
			end
		end
		
		--[[
		Frostfire Ridge (ID: 2)
		--]]
		if GetCurrentMapZone() == 2 then
			for i = 1, ObjectCount() do
				local curObj = ObjectWithIndex(i)
				if tContains(WoDObjectsFrostfireRidge, ObjectName(curObj)) and WoDObjects.Distance(curObj) <= 8 then
					C_Timer.After(1, function() ObjectInteract(curObj) end)
					return
				end
			end
		end
		
		--[[
		Garrison (ID: 3)
		--]]
		if GetCurrentMapZone() == 3 then
			for i = 1, ObjectCount() do
				local curObj = ObjectWithIndex(i)
				if tContains(WoDObjectsGarrison, ObjectName(curObj)) and WoDObjects.Distance(curObj) <= 3 then
						C_Timer.After(1, function() ObjectInteract(curObj) end)
						return
					end
				end
			end
		end
		
		--[[
		Gorgrond (ID: 4)
		--]]
		if GetCurrentMapZone() == 4 then
			for i = 1, ObjectCount() do
				local curObj = ObjectWithIndex(i)
				if tContains(WoDObjectsGorgrond, ObjectName(curObj)) and WoDObjects.Distance(curObj) <= 8 then
					C_Timer.After(1, function() ObjectInteract(curObj) end)
					return
				end
			end	
		end
		
		--[[
		Talador (ID: 7)
		--]]
		if GetCurrentMapZone() == 10 then
			for i = 1, ObjectCount() do
				local curObj = ObjectWithIndex(i)
				if tContains(WoDObjectsTalador, ObjectName(curObj)) and WoDObjects.Distance(curObj) <= 8 then
					C_Timer.After(1, function() ObjectInteract(curObj) end)
					return
				end
			end
		end
		
		--[[
		Spires of Arak (ID: 8)
		--]]
		if GetCurrentMapZone() == 8 then
			for i = 1, ObjectCount() do
				local curObj = ObjectWithIndex(i)
				if tContains(WoDObjectsSpiresOfArak, ObjectName(curObj)) and WoDObjects.Distance(curObj) <= 8 then
					C_Timer.After(1, function() ObjectInteract(curObj) end)
					return
				end
			end
		end
		
		--[[
		Nagrand (ID: 6)
		--]]
		if GetCurrentMapZone() == 6 then
			for i = 1, ObjectCount() do
				local curObj = ObjectWithIndex(i)
				if tContains(WoDObjectsNagrand, ObjectName(curObj)) and WoDObjects.Distance(curObj) <= 8 then
					C_Timer.After(1, function() ObjectInteract(curObj) end)
					return
				end
			end
		end
	end			
end


function WoDObjects.Distance(target, base) 
		-- if not base then base="player" end

		local X1, Y1, Z1 = ObjectPosition(target)
		local X2, Y2, Z2 = nil, nil, nil
		if not base then X2, Y2, Z2 = ObjectPosition("player") else X2, Y2, Z2 = ObjectPosition(base) end

		return math.sqrt(((X2 - X1) ^ 2) + ((Y2 - Y1) ^ 2) + ((Z2 - Z1) ^ 2))
  	end

--[[------------------------------------------------------------------------------------------------
SLASH COMMANDS
Either type this at the command line or run it in a macro to turn the AddOn on or off
--------------------------------------------------------------------------------------------------]]
SLASH_WODOBJECTSCMD1 = "/wodobj"

--[[------------------------------------------------------------------------------------------------
COMMAND LIST
--------------------------------------------------------------------------------------------------]]
function SlashCmdList.WODOBJECTSCMD(msg,editbox)
	local command, moretext = msg:match("^(%S*)%s*(.-)$");
	if moretext ~= "" then
		command = command .." "..moretext;
	end
	command = string.lower(command);
	if msg == "" then
		if not WoDObjects.toggle then
			print("Toggle WoDObjects On")
		else
			print("Toggle WoDObjects Off")
		end
		WoDObjects.toggle = not WoDObjects.toggle		-- Toggle between TRUE/FALSE when called		
	end
end

--[[------------------------------------------------------------------------------------------------
INITIALIZE THE FRAME FOR LISTENING
--------------------------------------------------------------------------------------------------]]
function WoDObjects_Initialize()
	if not WoDObjects_F then
		WoDObjects_F = CreateFrame("Frame");
		WoDObjects_F:RegisterEvent("PLAYER_ENTERING_WORLD")
		WoDObjects_F:RegisterEvent("ADDON_LOADED")
		WoDObjects_F:SetScript("OnEvent", WoDObjects_OnEvent)
	end
end

--[[------------------------------------------------------------------------------------------------
ONEVENT MAGIC
--------------------------------------------------------------------------------------------------]]
function WoDObjects_OnEvent(self, event, arg1)
	--[[
	Make sure we are loaded
	--]]
	if event == "ADDON_LOADED" then
		print("WoDObjects Loaded")
		WoDObjects_F:UnregisterEvent("ADDON_LOADED")
	end
	--[[
	Having the AddOn toggle false automatically if the player Logs/Portals/Reloads will
	prevent WoW from crashing on some occasions.
	--]]
	if event == "PLAYER_ENTERING_WORLD" then
		if WoDObjects.toggle then
			WoDObjects.toggle = not WoDObjects.toggle
		end
	end
end

--[[------------------------------------------------------------------------------------------------
RUN
Check the toggle "/wodobj", if TRUE then run through the Interact index, else end.
--------------------------------------------------------------------------------------------------]]
function WoDObjectsRun()
	if WoDObjects.toggle then
		if not UnitAffectingCombat( "player" ) and UnitCastingInfo( "player" ) == nil then
			C_Timer.After(0.2, function() WoDObjects.Interact() end)
		end
	end
end

--[[------------------------------------------------------------------------------------------------
TIMER
This runs the AddOns check once ever second till a Lua error happens or its turned off.
--------------------------------------------------------------------------------------------------]]
C_Timer.NewTicker( 1, function() WoDObjectsRun() end )

WoDObjects_Initialize()




















