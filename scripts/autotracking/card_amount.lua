-- how many cards each location can store
CARD_AMOUNT = {
    ["Duelist Bonus Level 1"] = {0, {}},
    ["Duelist Bonus Level 2"] = {0, {}},
    ["Duelist Bonus Level 3"] = {0, {}},
    ["Duelist Bonus Level 4"] = {0, {}},
    ["Duelist Bonus Level 5"] = {0, {}},
    ["Battle Damage"] = {0, {}},
    ["Battle Damage Only Bonus"] = {0, {}},
    ["Max ATK Bonus"] = {5, {}},
    ["Max Damage Bonus"] = {5, {}},
    ["Destroyed in Battle Bonus"] = {0, {}},
    ["Spell Card Bonus"] = {0, {}},
    ["Trap Card Bonus"] = {0, {}},
    ["Tribute Summon Bonus"] = {5, {}},
    ["Fusion Summon Bonus"] = {12, {}},
    ["Ritual Summon Bonus"] = {5, {}},
    ["No Special Summon Bonus"] = {0, {}},
    ["No Spell Cards Bonus"] = {5, {}},
    ["No Trap Cards Bonus"] = {5, {}},
    ["No Damage Bonus"] = {0, {}},
    ["Over 20000 LP Bonus"] = {9, {"Can Gain LP Every Turn", "Can Stall with ST"}},
    ["Low LP Bonus"] = {5, {}},
    ["Extremely Low LP Bonus"] = {5, {}},
    ["Low Deck Bonus"] = {5, {"Can Self Mill"}},
    ["Extremely Low Deck Bonus"] = {5, {"Can Self Mill"}},
    ["Effect Damage Only Bonus"] = {5, {}},
    ["No More Cards Bonus"] = {5, {}},
    ["Opponent's Turn Finish Bonus"] = {5, {}},
    ["Exactly 0 LP Bonus"] = {0, {}},
    ["Reversal Finish Bonus"] = {0, {}},
    ["Quick Finish Bonus"] = {0, {}},
    ["Exodia Finish Bonus"] = {6, {"Exodia", "Can Exodia Win"}},
    ["Last Turn Finish Bonus"] = {5, {"Can Last Turn Win"}},
    ["Final Countdown Finish Bonus"] = {5, {"Can Stall with ST"}},
    ["Destiny Board Finish Bonus"] = {10, {"Destiny Board and its letters", "Can Stall with Monsters"}},
    ["Yata-Garasu Finish Bonus"] = {5, {"Can Yata Lock"}},
    ["Skull Servant Finish Bonus"] = {5, {}},
    ["Konami Bonus"] = {5, {}},
    ["Beaters"] = {15, {}},
    ["Monster Removal"] = {10, {}},
    ["Backrow Removal"] = {10, {}},
    ["LD01 All except Level 4 forbidden"] = {12, {}},
    ["LD02 Medium/high Level forbidden"] = {12, {}},
    ["LD03 ATK 1500 or more forbidden"] = {12, {}},
    ["LD06 Traps forbidden"] = {5, {"No Trap Cards Bonus"}},
    ["LD10 All except LV monsters forbidden"] = {9, {}},
    ["LD11 All except Fairies forbidden"] = {10, {}},
    ["LD12 All except Wind forbidden"] = {8, {}},
    ["LD14 Level 3 or below forbidden"] = {12, {}},
    ["LD15 DEF 1500 or less forbidden"] = {12, {}},
    ["LD16 Effect Monsters forbidden"] = {10, {}},
    ["LD17 Spells forbidden"] = {5, {"No Spell Cards Bonus"}},
    ["LD18 Attacks forbidden"] = {6, {}},
    ["LD19 All except E-Hero's forbidden"] = {13, {}},
    ["LD20 All except Warriors forbidden"] = {10, {}},
    ["LD21 All except Dark forbidden"] = {11, {}},
    ["LD26 All except Toons forbidden"] = {6, {}},
    ["LD27 All except Spirits forbidden"] = {4, {}},
    ["LD28 All except Dragons forbidden"] = {10, {}},
    ["LD29 All except Spellcasters forbidden"] = {10, {}},
    ["LD30 All except Light forbidden"] = {8, {}},
    ["LD31 All except Fire forbidden"] = {8, {}},
    ["LD34 Normal Summons forbidden"] = {13, {}},
    ["LD35 All except Zombies forbidden"] = {13, {}},
    ["LD36 All except Earth forbidden"] = {8, {}},
    ["LD37 All except Water forbidden"] = {8, {}},
    ["LD39 Monsters forbidden"] = {2, {}},
    ["TD01 Battle Damage"] = {0, {}},
    ["TD02 Deflected Damage"] = {7, {}},
    ["TD03 Normal Summon"] = {0, {}},
    ["TD04 Ritual Summon"] = {10, {}},
    ["TD05 Special Summon A"] = {9, {}},
    ["TD06 20x Spell"] = {5, {}},
    ["TD07 10x Trap"] = {15, {}},
    ["TD08 Draw"] = {5, {}},
    ["TD09 Hand Destruction"] = {8, {}},
    ["TD10 During Opponent's Turn"] = {5, {}},
    ["TD11 Recover"] = {5, {"Can Gain LP Every Turn"}},
    ["TD12 Remove Monsters by Effect"] = {5, {}},
    ["TD13 Flip Summon"] = {8, {}},
    ["TD14 Special Summon B"] = {5, {}},
    ["TD15 Token"] = {5, {}},
    ["TD16 Union"] = {8, {}},
    ["TD17 10x Quick Spell"] = {12, {}},
    ["TD18 The Forbidden"] = {6, {"Exodia", "Can Exodia Win"}},
    ["TD19 20 Turns"] = {5, {"Can Stall with ST"}},
    ["TD20 Deck Destruction"] = {5, {}},
    ["TD21 Victory D."] = {11, {}},
    ["TD22 The Preventers Fight Back"] = {7, {"Ojama Delta Hurricane and required cards"}},
    ["TD23 Huge Revolution"] = {8, {"Huge Revolution and its required cards"}},
    ["TD24 Victory in 5 Turns"] = {5, {}},
    ["TD25 Moth Grows Up"] = {6, {"Perfectly Ultimate Great Moth and its required cards"}},
    ["TD26 Magnetic Power"] = {5, {"Valkyrion the Magna Warrior and its pieces"}},
    ["TD27 Dark Sage"] = {5, {"Dark Sage and its required cards"}},
    ["TD28 Direct Damage"] = {0, {}},
    ["TD29 Destroy Monsters in Battle"] = {0, {}},
    ["TD30 Tribute Summon"] = {5, {}},
    ["TD31 Special Summon C"] = {8, {}},
    ["TD32 Toon"] = {6, {}},
    ["TD33 10x Counter"] = {10, {}},
    ["TD34 Destiny Board"] = {10, {"Destiny Board and its letters", "Can Stall with Monsters"}},
    ["TD35 Huge Damage in a Turn"] = {3, {}},
    ["TD36 V-Z In the House"] = {10, {"VWXYZ-Dragon Catapult Cannon and the fusion materials"}},
    ["TD37 Uria, Lord of Searing Flames"] = {5, {}},
    ["TD38 Hamon, Lord of Striking Thunder"] = {10, {}},
    ["TD39 Raviel, Lord of Phantasms"] = {7, {}},
    ["TD40 Make a Chain"] = {5, {}},
    ["TD41 The Gatekeeper Stands Tall"] = {6, {"Gate Guardian and its pieces"}},
    ["TD42 Serious Damage"] = {0, {}},
    ["TD43 Return Monsters with Effects"] = {5, {}},
    ["TD44 Fusion Summon"] = {13, {}},
    ["TD45 Big Damage at once"] = {5, {}},
    ["TD46 XYZ In the House"] = {9, {"XYZ-Dragon Cannon fusions and their materials"}},
    ["TD47 Spell Counter"] = {5, {}},
    ["TD48 Destroy Monsters with Effects"] = {7, {"Can Stall with ST"}},
    ["TD49 Plunder"] = {8, {}},
    ["TD50 Dark Scorpion Combination"] = {8, {"Dark Scorpion Combination and its required cards"}},
}  