// Script made by Eve Haddox
// discord evehaddox

eds = eds or {}
eds.dir = "eds"

function eds.IncludeClient(path)
    local str = eds.dir .. "/" .. path .. ".lua"

    MsgC(Color(200, 180, 100), "[eds] ", Color(220, 220, 220), "client loaded ".. str .."\n")

    if (CLIENT) then
        include(str)
    end

    if (SERVER) then
        AddCSLuaFile(str)
    end
end

function eds.IncludeServer(path)
    local str = eds.dir .. "/" .. path .. ".lua"

    MsgC(Color(100, 150, 200), "[eds] ", Color(220, 220, 220), "server loaded ".. str .."\n")

    if (SERVER) then
        include(str)
    end
end

function eds.IncludeShared(path)
    eds.IncludeServer(path)
    eds.IncludeClient(path)
end

// Main
eds.IncludeShared("sh_config")
// Elements
eds.IncludeClient("cl_ui")
// Server
eds.IncludeServer("sv_main")