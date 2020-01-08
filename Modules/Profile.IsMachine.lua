return function(player)
    return (GAMESTATE:IsHumanPlayer(player) and PROFILEMAN:IsPersistentProfile(player) and PROFILEMAN:GetProfile(player):GetDisplayName() ~= "")
end