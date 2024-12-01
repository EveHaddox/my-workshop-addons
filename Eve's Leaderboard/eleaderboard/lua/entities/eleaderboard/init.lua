// Addon made by Eve Haddox
// my discord "evehaddox"

include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

util.AddNetworkString("SendELeaderboard")

timer.Create("SendELeaderboard", 5, 0, function()
    local Leaderboard = MySQLite.query ([[SELECT * FROM darkrp_player ORDER BY wallet DESC LIMIT 20]])
    local Index = 2
    for i = 2, 20, 2 do
        table.remove(Leaderboard, Index)
        Index = Index + 1
    end
    net.Start("SendELeaderboard")
    net.WriteTable(Leaderboard)
    net.Broadcast()
end)

function ENT:Initialize()
    
    if gmod.GetGamemode().Name != "DarkRP" then
        self.Owner = self:GetOwner()
        if self.Owner and self.Owner:IsValid() then
            self.Owner:ChatPrint("The money leaderboard entity requires the DarkRP Gamemode, entity removed!")
        end
        error("MoneyLeaderboard addon requires DarkRP!")
        self:Remove()
        return
    end
    
    self:SetModel("models/hunter/plates/plate2x2.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    self:SetMaterial("Models/effects/vol_light001")

    local phys = self:GetPhysicsObject()

    if phys and IsValid(phys) then
        phys:Wake()
    end
    
end

function ENT:OnRemove()

end
