ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Speed Suit" // name used by the suit
ENT.Author = "Eve Haddox"
ENT.Category = "Eve"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.action = function(ply) 
    ply:SetWalkSpeed(250) 
    ply:SetRunSpeed(350) 
    ply:SetArmor(50)

    local model = est.playermodels["speed_1"]
    if not model then
        model = est.playermodels["default"]
    end

    ply:SetModel(model)
end // effects on equiping