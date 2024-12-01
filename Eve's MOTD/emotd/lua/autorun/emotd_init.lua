// Script made by Eve Haddox
// discord evehaddox

emotd = emotd or {}
emotd.dir = "emotd"

function emotd.IncludeClient(path)
    local str = emotd.dir .. "/" .. path .. ".lua"

    MsgC(Color(200, 180, 100), "[emotd] ", Color(220, 220, 220), "client loaded ".. str .."\n")

    if (CLIENT) then
        include(str)
    end

    if (SERVER) then
        AddCSLuaFile(str)
    end
end

function emotd.IncludeServer(path)
    local str = emotd.dir .. "/" .. path .. ".lua"

    MsgC(Color(100, 150, 200), "[emotd] ", Color(220, 220, 220), "server loaded ".. str .."\n")

    if (SERVER) then
        include(str)
    end
end

function emotd.IncludeShared(path)
    emotd.IncludeServer(path)
    emotd.IncludeClient(path)
end

// Main
emotd.IncludeShared("sh_config")
// Elements
emotd.IncludeClient("cl_motd")


hook.Run("emotdlibPostLoaded")