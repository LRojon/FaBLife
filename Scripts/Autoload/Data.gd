extends Node

##### CONSTANTES #####

enum Format {
	CC,
	SAGE,
	LL,
	UPF
}

const DB_SRC: Dictionary[String, String] = {
	"fabrary" : "https://fabrary.net/",
	"cardvault" : "https://cardvault.fabtcg.com/"
}

var MENU_OPTION: Array[MenuOptionData] = [
	load("res://Assets/Resources/MenuOptions/Database.tres"),
	load("res://Assets/Resources/MenuOptions/GEM.tres"),
	load("res://Assets/Resources/MenuOptions/Historic.tres"),
	load("res://Assets/Resources/MenuOptions/ModeV.tres"),
	load("res://Assets/Resources/MenuOptions/New.tres"),
	load("res://Assets/Resources/MenuOptions/Reset.tres"),
	load("res://Assets/Resources/MenuOptions/Settings.tres"),
	load("res://Assets/Resources/MenuOptions/Timer.tres"),
]

# En sec
var TIMER : Dictionary[Data.Format, int] = {
	Data.Format.CC   : 55 * 60,
	Data.Format.SAGE : 35 * 60,
	Data.Format.LL   : 55 * 60,
	Data.Format.UPF  : -1
}

var classes : Dictionary[String, Class] = {
	"Adjudicator"	: Class.new(0,  "Assassin"),
	"Assassin"		: Class.new(1,  "Assassin"),
	"Bard"			: Class.new(2,  "Assassin"),
	"Brute"			: Class.new(3,  "Assassin"),
	"Generic"		: Class.new(4,  "Assassin"),
	"Guardian"		: Class.new(5,  "Assassin"),
	"Illusionist"	: Class.new(6,  "Assassin"),
	"Mechanologist"	: Class.new(7,  "Assassin"),
	"Merchant"		: Class.new(8,  "Assassin"),
	"Necromancer"	: Class.new(9,  "Assassin"),
	"Ninja"			: Class.new(10, "Assassin"),
	"Pirate"		: Class.new(11, "Assassin"),
	"Ranger"		: Class.new(12, "Assassin"),
	"Runeblade"		: Class.new(13, "Assassin"),
	"Shapeshifter"	: Class.new(14, "Assassin"),
	"Thief"			: Class.new(15, "Assassin"),
	"Warrior"		: Class.new(16, "Assassin"),
	"Wizard"		: Class.new(17, "Assassin"),
}

var talents : Dictionary[String, Talent] = {
	"Chaos"		: Talent.new(0,  "Chaos"),
	"Draconic"	: Talent.new(1,  "Draconic"),
	"Earth"		: Talent.new(2,  "Earth"),
	"Elemental"	: Talent.new(3,  "Elemental"),
	"Ice"		: Talent.new(4,  "Ice"),
	"Light"		: Talent.new(5,  "Light"),
	"Lightning"	: Talent.new(6,  "Lightning"),
	"Mystic"	: Talent.new(7,  "Mystic"),
	"Revered"	: Talent.new(8,  "Revered"),
	"Reviled"	: Talent.new(9,  "Reviled"),
	"Royal"		: Talent.new(10, "Royal"),
	"Shadow"	: Talent.new(11, "Shadow"),
}

var _Hero : Dictionary[String, Hero] = {
	"ArakniS"		: Hero.new("ArakniS",		"Arakni, 5L!p3d 7hRu 7h3 cR4X"		,  193, 38, ["Assassin"], ["Chaos"], [Format.CC, Format.LL]),
	"Arakni"		: Hero.new("Arakni",		"Arakni, Huntsman"					,  274, 40, ["Assassin"], [], [Format.CC, Format.LL]),
	"ArakniM"		: Hero.new("ArakniM",		"Arakni, Marionette"				,  899, 40, ["Assassin"], ["Chaos"], [Format.CC, Format.LL]),
	"AuroraL"		: Hero.new("AuroraL",		"Aurora, Legacy of Tempest"			,    0, 40, ["Runeblade"], ["Lightning"], [Format.LL]),
	"Aurora"		: Hero.new("Aurora",		"Aurora, Shooting Star"				, 1051, 40, ["Runeblade"], ["Elemental"], [Format.CC, Format.LL]),
	"Azalea"		: Hero.new("Azalea",		"Azalea, Ace in the Hole"			, 1036, 40, ["Ranger"], [], [Format.LL]),
	"Betsy"			: Hero.new("Betsy",			"Betsy, Skin in the Game"			,    7, 40, ["Guardian"], [], [Format.CC, Format.LL]),
	"Bravo"			: Hero.new("Bravo",			"Bravo, Showstopper"				,  776, 40, ["Guardian"], [], [Format.CC, Format.LL]),
	"Starvo"		: Hero.new("Starvo",		"Bravo, Star of the Show"			, 1582, 40, ["Guardian"], ["Elemental"], [Format.LL]),
	"Briar"			: Hero.new("Briar",			"Briar, Warden of Thorns"			, 1158, 40, ["Runebalde"], ["Elemental"], [Format.LL]),
	"Chane"			: Hero.new("Chane",			"Chane, Bound by Shadow"			, 1102, 40, ["Runeblade"], ["Shadow"], [Format.LL]),
	"Cindra"		: Hero.new("Cindra",		"Cindra, Dracai of Retribution"		,  880, 40, ["Ninja"], ["Draconic", "Royal"], [Format.CC, Format.LL]),
	"Dio"			: Hero.new("Dio",			"Dash I/O"							,  950, 36, ["Mechanologist"], [], [Format.CC, Format.LL]),
	"Dash"			: Hero.new("Dash",			"Dash, Inventor Extraordinaire"		, 1013, 40, ["Mechanologist"], [], [Format.LL]),
	"Dorinthea"		: Hero.new("Dorinthea",		"Dorinthea Ironsong"				,  758, 40, ["Warrior"], [], [Format.CC, Format.LL]),
	"Mortimer"		: Hero.new("Mortimer",		"Dr. Mortimer, Blight of the Pits"	,    0, 40, ["Assassin"], [], []),
	"Dromai"		: Hero.new("Dromai",		"Dromai, Ash Artist"				, 1096, 40, ["Illusionist"], ["Draconic"], [Format.LL]),
	"Enigma"		: Hero.new("Enigma",		"Enigma, Ledger of Ancestry"		, 1046, 40, ["Illusionist"], ["Mystic"], [Format.LL]),
	"Fai"			: Hero.new("Fai",			"Fai, Rising Rebellion"				,  893, 40, ["Ninja"], ["Draconic"], [Format.CC, Format.LL]),
	"Fang"			: Hero.new("Fang",			"Fang, Dracai of Blades"			,  153, 40, ["Warrior"], ["Draconic", "Royal"], [Format.CC, Format.LL]),
	"Florian"		: Hero.new("Florian",		"Florian, Rotwood Harbinger"		, 1029, 40, ["Runeblade"], ["Elemental"], [Format.LL]),
	"Gravy"			: Hero.new("Gravy",			"Gravy Bones, Shipwrecked Looter"	,  584, 40, ["Necromancer", "Pirate"], [], [Format.CC, Format.LL]),
	"Hala"			: Hero.new("Hala",			"Hala, Bladesaint of the Vow"		,    5, 40, ["Warrior"], [], [Format.CC, Format.LL]),
	"Ira"			: Hero.new("Ira",			"Ira, Scarlet Revenger"				,  131, 40, ["Ninja"], [], [Format.CC, Format.LL]),
	"Iyslander"		: Hero.new("Iyslander",		"Iyslander, Stormbind"				, 1012, 36, ["Wizard"], ["Elemental"], [Format.LL]),
	"Jarl"			: Hero.new("Jarl",			"Jarl Vetreiði"						,  268, 40, ["Guardian"], ["Elemental"], [Format.CC, Format.LL]),
	"Kano"			: Hero.new("Kano",			"Kano, Dracai of Aether"			, 1028, 30, ["Wizard"], [], [Format.LL]),
	"Kassai"		: Hero.new("Kassai",		"Kassai of the Golden Sand"			,  967, 40, ["Warrior"], [], [Format.CC, Format.LL]),
	"Katsu"			: Hero.new("Katsu",			"Katsu, the Wanderer"				,  783, 40, ["Ninja"], [], [Format.CC, Format.LL]),
	"Kayo"			: Hero.new("Kayo",			"Kayo, Armed and Dangerous"			, 1014, 40, ["Brute"], [], [Format.LL]),
	"KayoR"			: Hero.new("KayoR",			"Kayo, Underhanded Cheat"			,   29, 40, ["Brute"], ["Reviled"], [Format.CC, Format.LL]),
	"Levia"			: Hero.new("Levia",			"Levia, Shadowborn Abomination"		,  200, 40, ["Brute"], ["Shadow"], [Format.CC, Format.LL]),
	"Lexi"			: Hero.new("Lexi",			"Lexi, Livewire"					, 1276, 40, ["Ranger"], ["Elemental"], [Format.LL]),
	"Lyath"			: Hero.new("Lyath",			"Lyath Goldmane, Vile Savant"		,    3, 40, ["Guardian"], ["Reviled"], [Format.CC, Format.LL]),
	"Malice"		: Hero.new("Malice",		"Malice, Domina of the Dead"		,    0, 40, ["Necromancer"], ["Shadow"], [Format.CC, Format.LL]),
	"Marlynn"		: Hero.new("Marlynn",		"Marlynn, Treasure Hunter"			,   21, 40, ["Ranger", "Pirate"], [], [Format.CC, Format.LL]),
	"Maxx"			: Hero.new("Maxx",			"Maxx 'The Hype' Nitro"				,   85, 40, ["Mechanologist"], [], [Format.CC, Format.LL]),
	"Nuu"			: Hero.new("Nuu",			"Nuu, Alluring Desire"				, 1004, 40, ["Assassin"], ["Mystic"], [Format.LL]),
	"Oldhim"		: Hero.new("Oldhim",		"Oldhim, Grandfather of Eternity"	, 1186, 40, ["Guardian"], ["Elemental"], [Format.LL]),
	"Olympia"		: Hero.new("Olympia",		"Olympia, Prized Fighter"			,    7, 40, ["Warrior"], [], [Format.CC, Format.LL]),
	"Oscilio"		: Hero.new("Oscilio",		"Oscilio, Constella Intelligence"	,  781, 36, ["Wizard"], ["Elemental"], [Format.CC, Format.LL]),
	"OscilioF"		: Hero.new("OscilioF",		"Oscilio, Forked Continuum"			,    0, 38, ["Wizard"], ["Lightning"], [Format.CC, Format.LL]),
	"Pleiades"		: Hero.new("Pleiades",		"Pleiades, Superstar"				,   50, 40, ["Guardian"], ["Revered"], [Format.CC, Format.LL]),
	"PrismA"		: Hero.new("PrismA",		"Prism, Awakener of Sol"			, 1010, 32, ["Illusionist"], ["Light"], [Format.LL]),
	"Prism"			: Hero.new("Prism",			"Prism, Sculptor of Arc Light"		, 1098, 40, ["Illusionist"], ["Light"], [Format.LL]),
	"Puffin"		: Hero.new("Puffin",		"Puffin, Hightail"					,   43, 40, ["Mechanologist", "Pirate"], [], [Format.CC, Format.LL]),
	"Rhinar"		: Hero.new("Rhinar",		"Rhinar, Reckless Rampage"			,  362, 40, ["Brute"], [], [Format.CC, Format.LL]),
	"Riptide"		: Hero.new("Riptide",		"Riptide, Lurker of the Deep"		,   98, 38, ["Ranger"], [], [Format.CC, Format.LL]),
	"Ser Boltyn"	: Hero.new("Ser Boltyn",	"Ser Boltyn, Breaker of Dawn"		,  417, 40, ["Warrior"], ["Light"], [Format.CC, Format.LL]),
	"Teklovossen"	: Hero.new("Teklovossen",	"Teklovossen, Esteemed Magnate"		,  124, 40, ["Mechanologist"], [], [Format.CC, Format.LL]),
	"Tuffnut"		: Hero.new("Tuffnut",		"Tuffnut, Bumbling Hulkster"		,    5, 40, ["Brute"], ["Revered"], [Format.CC, Format.LL]),
	"Uzuri"			: Hero.new("Uzuri",			"Uzuri, Switchblade"				,  405, 40, ["Assassin"], [], [Format.CC, Format.LL]),
	"Valda"			: Hero.new("Valda",			"Valda, Seismic Impact"				,   28, 40, ["Guardian"], [], [Format.CC, Format.LL]),
	"Verdance"		: Hero.new("Verdance",		"Verdance, Thorn of the Rose"		, 1019, 40, ["Wizard"], ["Elemental"], [Format.LL]),
	"Victor"		: Hero.new("Victor",		"Victor Goldmane, High and Mighty"	, 1033, 40, ["Guardian"], [], [Format.LL]),
	"Viserai"		: Hero.new("Viserai",		"Viserai, Rune Blood"				, 1016, 40, ["Runeblade"], [], [Format.LL]),
	"ViseraiF"		: Hero.new("ViseraiF",		"Viserai, the Forsaken"				,    0, 40, ["Runeblade"], ["Shadow"], [Format.CC, Format.LL]),
	"Vynnset"		: Hero.new("Vynnset",		"Vynnset, Iron Maiden"				,  296, 40, ["Runeblade"], ["Shadow"], [Format.CC, Format.LL]),
	"Zen"			: Hero.new("Zen",			"Zen, Tamer of Purpose"				, 1000, 40, ["Ninja"], ["Mystic"], [Format.LL]),
	"Zyggy"			: Hero.new("Zyggy",			"Zyggy Starlight"					,   13, 40, ["Illusionist"], ["Lightning"], [Format.CC, Format.LL]),
##### Young #####
	"YArakni"		: Hero.new("YArakni",		"Arakni"							,    0, 20, ["Assassin"], [], [Format.UPF, Format.SAGE]),
	"YArakniS"		: Hero.new("YArakniS",		"Arakni, Solitary Confinement"		,    0, 19, ["Assassin"], [], [Format.UPF, Format.SAGE]),
	"YArakniW"		: Hero.new("YArakniW",		"Arakni, Web of Deceit"				,    0, 20, ["Assassin"], ["Chaos"], [Format.UPF, Format.SAGE]),
	"YAurora"		: Hero.new("YAurora",		"Aurora"							,    0, 20, ["Runeblade"], ["Elemental"], [Format.UPF, Format.SAGE]),
	"YAuroraE"		: Hero.new("YAuroraE",		"Aurora, Emissary of Lightning"		,    0, 20, ["Runeblade"], ["Lightning"], [Format.UPF, Format.SAGE]),
	"YAzalea"		: Hero.new("YAzalea",		"Azalea"							,    0, 20, ["Ranger"], [], [Format.UPF, Format.SAGE]),
	"YBaalghor"		: Hero.new("YBaalghor",		"Baalghor, Omen of the End"			,    0, 33, [], ["Shadow"], [Format.UPF, Format.SAGE]),
	"YBenji"		: Hero.new("YBenji",		"Benji, the Piercing Wind"			,    0, 17, ["Ninja"], [], [Format.UPF, Format.SAGE]),
	"YBetsy"		: Hero.new("YBetsy",		"Betsy"								,    0, 20, ["Guardian"], [], [Format.UPF, Format.SAGE]),
	"YBlaze"		: Hero.new("YBlaze",		"Blaze, Firemind"					,    0, 17, ["Wizard"], [], [Format.UPF, Format.SAGE]),
	"YBoltyn"       : Hero.new("YBoltyn",       "Boltyn"							,    0, 20, ["Warrior"], ["Light"], [Format.UPF, Format.SAGE]),
	"YBravo"		: Hero.new("YBravo",		"Bravo"								,    0, 20, ["Guardian"], [], [Format.UPF, Format.SAGE]),
	"YFlavo"		: Hero.new("YFlavo",		"Bravo, Flattering Showman"			,    0, 20, ["Guardian"], [], [Format.UPF, Format.SAGE]),
	"YBrevant"		: Hero.new("YBrevant",		"Brevant, Civic Protector"			,    0, 20, ["Guardian"], [], [Format.UPF]),
	"YBriar"		: Hero.new("YBriar",		"Briar"								,    0, 20, ["Runeblade"], ["Elemental"], [Format.UPF]),
	"YChane"		: Hero.new("YChane",		"Chane"								,    0, 20, ["Runeblade"], ["Shadow"], [Format.UPF]),
	"YCindra"		: Hero.new("YCindra",		"Cindra"							,    0, 20, ["Ninja"], ["Draconic", "Royal"], [Format.UPF, Format.SAGE]),
	"YDash"			: Hero.new("YDash",			"Dash"								,    0, 20, ["Mechanologist"], [], [Format.UPF, Format.SAGE]),
	"YDashD"		: Hero.new("YDashD",		"Dash, Database"					,    0, 18, ["Mechanologist"], [], [Format.UPF, Format.SAGE]),
	"YDataDoll"		: Hero.new("YDataDoll",		"Data Doll MKII"					,    0, 20, ["Mechanologist"], [], [Format.UPF, Format.SAGE]),
	"YDorinthea"	: Hero.new("YDorinthea",	"Dorinthea"							,    0, 20, ["Warrior"], [], [Format.UPF, Format.SAGE]),
	"YDorintheaQ"	: Hero.new("YDorintheaQ",	"Dorinthea, Quicksilver Prodigy"	,    0, 20, ["Warrior"], [], [Format.UPF, Format.SAGE]),
	"YMortimer"		: Hero.new("YMortimer",		"Dr. Mortimer"						,    0, 20, ["Assassin"], [], [Format.UPF, Format.SAGE]),
	"YDromai"		: Hero.new("YDromai",		"Dromai"							,    0, 20, ["Illusionist"], ["Draconic"], [Format.UPF, Format.SAGE]),
	"YEmperor"		: Hero.new("YEmperor",		"Emperor, Dracai of Aesir"			,    0, 15, ["Wizard", "Warrior"], ["Draconic", "Royal"], [Format.UPF]),
	"YEnigma"		: Hero.new("YEnigma",		"Enigma"							,    0, 20, ["Illusionist"], ["Mystic"], [Format.UPF, Format.SAGE]),
	"YEnigmaN"		: Hero.new("YEnigmaN",		"Enigma, New Moon"					,    0, 20, ["Illusionist"], ["Mystic"], [Format.UPF]),
	"YFai"			: Hero.new("YFai",			"Fai"								,    0, 20, ["Ninja"], ["Draconic"], [Format.UPF, Format.SAGE]),
	"YFang"			: Hero.new("YFang",			"Fang"								,    0, 20, ["Warrior"], ["Draconic"], [Format.UPF, Format.SAGE]),
	"YFlorian"		: Hero.new("YFlorian",		"Florian"							,    0, 20, ["Runeblade"], ["Elemental"], [Format.UPF, Format.SAGE]),
	"YFrankie"		: Hero.new("YFrankie",		"Frankie, Make Ends Meat"			,    0, 20, ["Necromancer"], [], [Format.UPF]),
	"YGenis"		: Hero.new("YGenis",		"Genis Wotchuneed"					,    0, 20, ["Merchant"], [], [Format.UPF]),
	"YGravy"		: Hero.new("YGravy",		"Gravy Bones"						,    0, 20, ["Necromancer", "Pirate"], [], [Format.UPF, Format.SAGE]),
	"YHala"			: Hero.new("YHala",			"Hala"								,    0, 20, ["Warrior"], [], [Format.UPF, Format.SAGE]),
	"YIra"			: Hero.new("YIra",			"Ira, Crimson Haze"					,    0, 20, ["Ninja"], [], [Format.UPF, Format.SAGE]),
	"YIyslander"	: Hero.new("YIyslander",	"Iyslander"							,    0, 18, ["Wizard"], ["Elemental"], [Format.UPF, Format.SAGE]),
	"YKano"			: Hero.new("YKano",			"Kano"								,    0, 15, ["Wizard"], [], [Format.UPF, Format.SAGE]),
	"vKassai"		: Hero.new("YKassai",		"Kassai"							,    0, 20, ["Warrior"], [], [Format.UPF, Format.SAGE]),
	"YKassaiCS"		: Hero.new("YKassaiCS",		"Kassai, Cintari Sellsword"			,    0, 20, ["Warrior"], [], [Format.UPF, Format.SAGE]),
	"YKatsu"		: Hero.new("YKatsu",		"Katsu"								,    0, 20, ["Ninja"], [], [Format.UPF, Format.SAGE]),
	"YKavdaen"		: Hero.new("YKavdaen",		"Kavdaen, Trader of Skins"			,    0, 20, ["Merchant"], [], [Format.UPF, Format.SAGE]),
	"YKayo"			: Hero.new("YKayo",			"Kayo"								,    0, 20, ["Brute"], [], [Format.UPF, Format.SAGE]),
	"YKayoBR"		: Hero.new("YKayoBR",		"Kayo, Berserker Runt"				,    0, 19, ["Brute"], [], [Format.UPF, Format.SAGE]),
	"YKayoR"		: Hero.new("YKayoR",		"Kayo, Strong-arm"					,    0, 20, ["Brute"], ["Reviled"], [Format.UPF, Format.SAGE]),
	"YKilljoy"		: Hero.new("YKilljoy",		"Killjoy, the Crooked Blade"		,    0, 20, ["Warrior"], ["Reviled"], [Format.UPF, Format.SAGE]),
	"YLevia"		: Hero.new("YLevia",		"Levia"								,    0, 20, ["Brute"], ["Shadow"], [Format.UPF, Format.SAGE]),
	"YLexi"			: Hero.new("YLexi",			"Lexi"								,    0, 20, ["Ranger"], ["Elemental"], [Format.UPF, Format.SAGE]),
	"YLyath"		: Hero.new("YLyath",		"Lyath Goldmane"					,    0, 20, ["Guardian"], ["Reviled"], [Format.UPF, Format.SAGE]),
	"YMalice"		: Hero.new("YMalice",		"Malice"							,    0, 20, ["Necromancer"], ["Shadow"], [Format.UPF, Format.SAGE]),
	"YMarlynn"		: Hero.new("YMarlynn",		"Marlynn"							,    0, 20, ["Ranger", "Pirate"], [], [Format.UPF, Format.SAGE]),
	"YMaxx"			: Hero.new("YMaxx",			"Maxx Nitro"						,    0, 20, ["Mechanologist"], [], [Format.UPF, Format.SAGE]),
	"YMelody"		: Hero.new("YMelody",		"Melody, Sing-along"				,    0, 20, ["Bard"], [], [Format.UPF]),
	"YNuu"			: Hero.new("YNuu",			"Nuu"								,    0, 20, ["Assassin"], ["Mystic"], [Format.UPF, Format.SAGE]),
	"YOldhim"		: Hero.new("YOldhim",		"Oldhim"							,    0, 20, ["Guardian"], ["Elemental"], [Format.UPF]),
	"YOlympia"		: Hero.new("YOlympia",		"Olympia"							,    0, 18, ["Warrior"], [], [Format.UPF, Format.SAGE]),
	"YOscilio"		: Hero.new("YOscilio",		"Oscilio"							,    0, 18, ["Wizard"], ["Elemental"], [Format.UPF]),
	"YOscilioSA"	: Hero.new("YOscilioSA",	"Oscilio, Scion of the Third Age"	,    0, 19, ["Wizard"], ["Lightning"], [Format.UPF, Format.SAGE]),
	"YPleiades"		: Hero.new("YPleiades",		"Pleiades"							,    0, 20, ["Guardian"], ["Revered"], [Format.UPF, Format.SAGE]),
	"YPrism"		: Hero.new("YPrism",		"Prism"								,    0, 20, ["Illusionist"], ["Light"], [Format.UPF, Format.SAGE]),
	"YPrismA"		: Hero.new("YPrismA",		"Prism, Advent of Thrones"			,    0, 16, ["Illusionist"], ["Light"], [Format.UPF, Format.SAGE]),
	"YTeklovossenP"	: Hero.new("YTeklovossenP",	"Professor Teklovossen"				,    0, 20, ["Mechanologist"], [], [Format.UPF]),
	"YPuffin"		: Hero.new("YPuffin",		"Puffin"							,    0, 20, ["Mechanologist", "Pirate"], [], [Format.UPF, Format.SAGE]),
	"YRhinar"		: Hero.new("YRhinar",		"Rhinar"							,    0, 20, ["Brute"], [], [Format.UPF, Format.SAGE]),
	"YRiptide"		: Hero.new("YRiptide",		"Riptide"							,    0, 19, ["Ranger"], [], [Format.UPF, Format.SAGE]),
	"YScurv"		: Hero.new("YScurv",		"Scurv, Stowaway"					,    0, 20, ["Pirate", "Thief"], [], [Format.UPF, Format.SAGE]),
	"YShiyana"		: Hero.new("YShiyana",		"Shiyana, Diamond Gemini"			,    0, 20, ["Shapeshifter"], [], [Format.UPF]),
	"YSquizzy"		: Hero.new("YSquizzy",		"Squizzy & Floof"					,    0, 20, ["Merchant"], [], [Format.UPF]),
	"YTaylor"		: Hero.new("YTaylor",		"Taylor"							,    0, 18, ["Shapeshifter"], [], [Format.UPF]),
	"YTeklovossen"	: Hero.new("YTeklovossen",	"Teklovossen"						,    0, 20, ["Mechanologist"], [], [Format.UPF, Format.SAGE]),
	"YTerra"		: Hero.new("YTerra",		"Terra"								,    0, 20, ["Guardian"], ["Elemental"], [Format.UPF, Format.SAGE]),
	"YTuffnut"		: Hero.new("YTuffnut",		"Tuffnut"							,    0, 20, ["Brute"], ["Revered"], [Format.UPF, Format.SAGE]),
	"YUzuri"		: Hero.new("YUzuri",		"Uzuri"								,    0, 20, ["Assassin"], [], [Format.UPF, Format.SAGE]),
	"YValda"		: Hero.new("YValda",		"Valda Brightaxe"					,    0, 21, ["Guardian"], [], [Format.UPF, Format.SAGE]),
	"YVerdance"		: Hero.new("YVerdance",		"Verdance"							,0, 20, ["Wizard"], ["Elemental"], [Format.UPF, Format.SAGE]),
	"YVictor"		: Hero.new("YVictor",		"Victor Goldmane"					,    0, 20, ["Guardian"], [], [Format.UPF, Format.SAGE]),
	"YViserai"		: Hero.new("YViserai",		"Viserai"							,    0, 20, ["Runeblade"], [], [Format.UPF, Format.SAGE]),
	"YViseraiB"		: Hero.new("YViseraiB",		"Viserai, Between Worlds"			,    0, 20, ["Runeblade"], ["Shadow"], [Format.UPF, Format.SAGE]),
	"YVynnset"		: Hero.new("YVynnset",		"Vynnset"							,    0, 20, ["Runeblade"], ["Shadow"], [Format.UPF, Format.SAGE]),
	"YYoji"			: Hero.new("YYoji",			"Yoji, Royal Protector"				,    0, 22, ["Guardian"], [], [Format.UPF, Format.SAGE]),
	"YYorick"		: Hero.new("YYorick",		"Yorick, Weaver of Tales"			,    0, 20, ["Bard"], [], [Format.UPF]),
	"YZane"			: Hero.new("YZane",			"Zane, Broadly Beloved"				,    0, 20, ["Warrior"], ["Revered"], [Format.UPF, Format.SAGE]),
	"YZen"			: Hero.new("YZen",			"Zen"								,    0, 20, ["Ninja"], ["Mystic"], [Format.UPF, Format.SAGE]),
	"YZyggy"		: Hero.new("YZyggy",		"Zyggy"								,    0, 20, ["Illusionist"], ["Lightning"], [Format.UPF, Format.SAGE]),
}

##### DECLARATIONS ####

var menuOption : Dictionary[int, MenuOptionData] = {}

##### BUILT-IN #####

func _ready() -> void:
	for mo: MenuOptionData in MENU_OPTION:
		menuOption.set(mo.id, mo)

##### GETTER #####

func _get_db_src(_id: String):
	if Data.DB_SRC.keys().has(_id):
		return DB_SRC[_id]
	push_error("DB source not found")
	return ""

func _get_class(_name: String) -> Class:
	if Data.classes.find_key(_name):
		return Data.classes[_name]
	push_error("Class not found")
	return Class.new(-1, "")

func _get_talent(_name: String) -> Talent:
	if Data.talents.find_key(_name):
		return Data.talents[_name]
	push_error("Talent not found")
	return Talent.new(-1, "")

func _get_hero(_name: String) -> Hero:
	for k in Data._Hero.keys():
		if k == _name:
			return Data._Hero[_name]
			break
	push_error("Hero not found")
	return Hero.new(-1, "", -1, -1, [], [], [])

func _get_heroes_by_format(format: Data.Format) -> Array[Hero]:
	var ret_heroes : Array[Hero] = []
	for val: Hero in _Hero.values():
		if val.formats.has(format):
			ret_heroes.push_back(val)
	return ret_heroes

func _get_str_format(format : Data.Format) -> String:
	return Data.Format.keys()[format]
