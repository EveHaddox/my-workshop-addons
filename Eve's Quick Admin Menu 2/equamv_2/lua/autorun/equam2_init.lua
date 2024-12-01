// Script made by Eve Haddox
// discord evehaddox

equam2 = equam2 or {}
equam2.dir = "equam2"

function equam2.IncludeClient(path)
    local str = equam2.dir .. "/" .. path .. ".lua"

    MsgC(Color(200, 180, 100), "[equam2] ", Color(220, 220, 220), "client loaded ".. str .."\n")

    if (CLIENT) then
        include(str)
    end

    if (SERVER) then
        AddCSLuaFile(str)
    end
end

function equam2.IncludeServer(path)
    local str = equam2.dir .. "/" .. path .. ".lua"

    MsgC(Color(100, 150, 200), "[equam2] ", Color(220, 220, 220), "server loaded ".. str .."\n")

    if (SERVER) then
        include(str)
    end
end

function equam2.IncludeShared(path)
    equam2.IncludeServer(path)
    equam2.IncludeClient(path)
end

// Main
equam2.IncludeShared("sh_config")
// Misc
equam2.IncludeClient("cl_font")
// Elements
equam2.IncludeClient("cl_main")