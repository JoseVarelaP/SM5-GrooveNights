return function( player, tier )
    local TConv = string.format( "%04i", tier )
    local Names = {
        {{"Mario","Super Mario","Luigi","Super Luigi"}, "MarioTier"..TConv},
        {{"Yoshi","Yoshi the Dinosaur"}, "YoshiTier"..TConv},
        {{"Bowser","King Koopa"}, "BowserTier"},
        {{"Sonic","Sonic the Hedgehog","Tails","Tails Prower","Knuckles","Knucles the Echidna","Eggman","Dr Eggman","Robotnik","Dr Robotnik"}, "SonicTier"},
        {{"DK","Donkey Kong","Diddy","Diddy Kong","Dixie","Dixie Kong","Zinger","Wasp","Bee"}, "DKTier"},
        {{"Mario","Super Mario","Luigi","Super Luigi"}, "MarioTier"..TConv},
        {{'K Rool','King K Rool','Kaptain K Rool'}, "KRoolTier"},
        {{'Enguarde','Enguarde the Swordfish','Swordfish'}, "EnguardeTier"},
        {{'Rambi','Rambi the Rhino','Rhino'}, "RambiTier"},
        {{'Winky','Winky the Frog','Frog'}, "WinkyTier"},
        {{'Expresso','Expresso the Ostrich','Ostrich'}, "ExpressoTier"},
        {{'Bomberman','Bomb','Hudson'}, "BombermanTier"},
        {{'Megaman','X','Zero','0'}, "MegamanTier"},
        {{'TARO','TaroNuke'}, "TaroNukeTier"..TConv}
    }
    if PROFILEMAN:GetProfile(player) then
        for i,a in ipairs(Names) do
            for _,b in pairs(a[1]) do
                if PROFILEMAN:GetProfile(player):GetDisplayName() == b then
                    return a[2]
                end
            end
        end
    end
    return 'GradeTier'..TConv
end