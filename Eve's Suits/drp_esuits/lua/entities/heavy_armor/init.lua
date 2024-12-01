AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

AddCSLuaFile()

function ENT:Initialize()
    self:SetModel("models/props_junk/cardboard_box001a.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use(activator, caller)
    if activator:IsPlayer() then
        if EQUIPPED_ENTITIES[activator:SteamID()] then
            activator:PrintMessage(HUD_PRINTTALK, "A suit is already equipped")
            return
        end
        self.action(activator)
        activator:EmitSound("items/smallmedkit1.wav")

        SetPlayerEquipped(activator, self:GetClass(), true, self.PrintName)
        self:Remove()
    end
end