// Script made by Eve Haddox
// discord evehaddox

escb = escb or {}
escb.dir = "escb"
escb.tests = {}

function escb.IncludeClient(path)
    local str = escb.dir .. "/" .. path .. ".lua"

    MsgC(Color(200, 180, 100), "[escb] ", Color(220, 220, 220), "client loaded ".. str .."\n")

    if (CLIENT) then
        include(str)
    end

    if (SERVER) then
        AddCSLuaFile(str)
    end
end

function escb.IncludeServer(path)
    local str = escb.dir .. "/" .. path .. ".lua"

    MsgC(Color(100, 150, 200), "[escb] ", Color(220, 220, 220), "server loaded ".. str .."\n")

    if (SERVER) then
        include(str)
    end
end

function escb.IncludeShared(path)
    escb.IncludeServer(path)
    escb.IncludeClient(path)
end

// Main
escb.IncludeShared("sh_config")
// Elements
escb.IncludeClient("cl_scoreboard")


hook.Run("escblibPostLoaded")