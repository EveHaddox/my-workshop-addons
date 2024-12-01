// Addon made by Eve Haddox
// my discord "evehaddox"

local function LoadFiles()

    if engine.ActiveGamemode() != "darkrp" then MsgC(Color(8,178,245), "[EHUD] ", Color(235,235,235), " Wrong gamemode, change to darkrp for eve hud to load\n") return end

    AddCSLuaFile("ehud_w_config.lua")
    include("ehud_w_config.lua")
    print("Eve's hud Loaded: ehv2_config.lua")

    for c,d in pairs( file.Find( "ehud_workshop/*.lua", "LUA" ) ) do
        local serverb, servere = string.find( d, "sv_" )
        local serverc, servere = string.find( d, "cl_" )
        if serverb and SERVER then 
            include( "ehud_workshop/"..d )
            print("Eve's hud Loaded: "..d)
        elseif serverc and SERVER then
            AddCSLuaFile( "ehud_workshop/"..d )
            print("Eve's hud Loaded: "..d)
        end
    end
    for c,d in pairs( file.Find( "ehud_workshop/*.lua", "LUA" ) ) do
        local serverb, servere = string.find( d, "cl_" )
        if serverb and CLIENT then 
            include( "ehud_workshop/"..d )
            print("Eve's hud Loaded: "..d)
        end
    end
    for c,d in pairs( file.Find( "ehud_workshop/*.lua", "LUA" ) ) do
        local serverb, servere = string.find( d, "sh_" )
        if serverb then 
            AddCSLuaFile( "ehud_workshop/"..d )
            include( "ehud_workshop/"..d )
            print("Eve's hud Loaded: "..d)
        end
    end
end

hook.Add("Initialize", "initevehudv2", LoadFiles)