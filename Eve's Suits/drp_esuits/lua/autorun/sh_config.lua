est = {}

est.suits = {
    light_armor = function(ply) ply:SetArmor(0) ply:SetMaxArmor(100) end,
    medium_armor = function(ply) ply:SetArmor(0) ply:SetMaxArmor(100) end,
    heavy_armor = function(ply) ply:SetArmor(0) ply:SetMaxArmor(100) end,
    speed_1 = function(ply) ply:SetWalkSpeed(160) ply:SetRunSpeed(240) ply:SetArmor(0) end,
    speed_2 = function(ply) ply:SetWalkSpeed(160) ply:SetRunSpeed(240) ply:SetArmor(0) ply:SetMaxArmor(100) end,
    super_armor = function(ply) ply:SetArmor(0) ply:SetMaxArmor(100) end,
    //(file name) = function(ply) (actions on dropping) end
}
// (file name) - the name of the folder of the suit in esuits\lua\entities
// to add new suits the shared.lua file must be edited

est.playermodels = {
    default = "models/player/Police.mdl",
    light_armor = "models/player/Police.mdl",
    medium_armor = "models/player/Combine_Soldier.mdl",
    heavy_armor = "models/player/Combine_Soldier_PrisonGuard.mdl",
    speed_1 = "models/player/Barney.mdl",
    speed_2 = "models/player/Barney.mdl",
    super_armor = "models/player/Combine_Super_Soldier.mdl",
}

est.theme = {
    bg = Color(42, 44, 51),
    txt = Color(233,233,233),
}

est.hud = true // should hud be enabled?

// don't touch
einv = einv or {}
einv.theme = {
    primary = Color(51, 53, 56),
    itemBg = Color(60, 63, 66),
    button = Color(0, 0, 0, 120),
    text = {
        h1 = Color(185, 185, 185),
        h2 = Color(165, 165, 165),
        h3 = Color(145, 145, 145),
        h4 = Color(125, 125, 125)
    },
}