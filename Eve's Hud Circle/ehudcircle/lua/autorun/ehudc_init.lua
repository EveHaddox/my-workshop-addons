// Script made by Eve Haddox
// discord evehaddox

ehc = ehc or {}
ehc.dir = "ehc"

function ehc.IncludeClient(path)
    local str = ehc.dir .. "/" .. path .. ".lua"

    MsgC(Color(200, 180, 100), "[ehc] ", Color(220, 220, 220), "client loaded ".. str .."\n")

    if (CLIENT) then
        include(str)
    end

    if (SERVER) then
        AddCSLuaFile(str)
    end
end

function ehc.IncludeServer(path)
    local str = ehc.dir .. "/" .. path .. ".lua"

    MsgC(Color(100, 150, 200), "[ehc] ", Color(220, 220, 220), "server loaded ".. str .."\n")

    if (SERVER) then
        include(str)
    end
end

function ehc.IncludeShared(path)
    ehc.IncludeServer(path)
    ehc.IncludeClient(path)
end

hook.Add("DarkRPFinishedLoading", "EhudCircle", function()
    // Main
    ehc.IncludeShared("sh_config")
    // Misc
    ehc.IncludeClient("cl_fonts")
    // Elements
    ehc.IncludeClient("cl_main")
    ehc.IncludeClient("cl_sec")
    ehc.IncludeClient("cl_wep")
    ehc.IncludeClient("cl_door")
    ehc.IncludeClient("cl_notif")
    ehc.IncludeClient("cl_pickup")
    ehc.IncludeClient("cl_overhead")
    ehc.IncludeClient("cl_voice")
    ehc.IncludeClient("cl_crash")
    // Server
    ehc.IncludeServer("sv_main")
end)