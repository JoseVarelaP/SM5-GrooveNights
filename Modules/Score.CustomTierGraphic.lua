return function( player, tier )
    local TConv = string.format( "%04i", tier )
    local Names = {
        ["MarioTier"..TConv] = {"Mario","Super Mario","Luigi","Super Luigi"},
        ["YoshiTier"..TConv] = {"Yoshi","Yoshi the Dinosaur"},
        ["BowserTier"] = {"Bowser","King Koopa"},
        ["SonicTier"] = {"Sonic","Sonic the Hedgehog","Tails","Tails Prower","Knuckles","Knucles the Echidna","Eggman","Dr Eggman","Robotnik","Dr Robotnik"},
        ["DKTier"] = {"DK","Donkey Kong","Diddy","Diddy Kong","Dixie","Dixie Kong","Zinger","Wasp","Bee"},
        ["KRoolTier"] = {'K Rool','King K Rool','Kaptain K Rool'},
        ["EnguardeTier"] = {'Enguarde','Enguarde the Swordfish','Swordfish'},
        ["RambiTier"] = {'Rambi','Rambi the Rhino','Rhino'},
        ["WinkyTier"] = {'Winky','Winky the Frog','Frog'},
        ["ExpressoTier"] = {'Expresso','Expresso the Ostrich','Ostrich'},
        ["BombermanTier"] = {'Bomberman','Bomb','Hudson'},
        ["MegamanTier"] = {'Megaman','X','Zero','0'},
        ["TaroNukeTier"..TConv] = {'TARO','TaroNuke'}
    }
    if PROFILEMAN:GetProfile(player) then
        for _,a in pairs(Names) do
            for i,v in pairs(a) do
                if PROFILEMAN:GetProfile(player):GetDisplayName() == v then return _ end
            end
        end
    end
    return 'GradeTier'..TConv
end