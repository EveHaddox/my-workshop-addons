// Addon made by Eve Haddox
// my discord "evehaddox"

local color_white = Color(255,255,255)
local Colors = {}
Colors[NOTIFY_GENERIC] = Color(52, 73, 94)
Colors[NOTIFY_ERROR] = Color(192, 57, 43)
Colors[NOTIFY_UNDO] = Color(41, 128, 185)
Colors[NOTIFY_HINT] = Color(39, 174, 96)
Colors[NOTIFY_CLEANUP] = Color(243, 156, 18)
local LoadingColor = Color(22, 160, 133)

local Icons = {}
Icons[NOTIFY_GENERIC] = Material("materials/eve/generic.png")
Icons[NOTIFY_ERROR] = Material("materials/eve/error.png")
Icons[NOTIFY_UNDO] = Material("materials/eve/undo.png")
Icons[NOTIFY_HINT] = Material("materials/eve/hint.png")
Icons[NOTIFY_CLEANUP] = Material("materials/eve/cleanup.png")
local LoadingIcon = Material("materials/eve/cleanup.png")

local Notifications = {}

local function DrawNotification(x, y, w, h, text, icon, col, progress)

    draw.RoundedBox(20, x, y, w + 2, h + 2, col)
    draw.RoundedBox(20, x + 1, y + 1, w, h, ehc.colors.main)

    draw.SimpleText(text, "ehc.22", x + 12, y + h / 2 - 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    surface.SetDrawColor(color_white)
    surface.SetMaterial(icon)

    if progress then
        surface.DrawTexturedRectRotated(x + w - 18, y + h / 2, 16, 16, -CurTime() * 360 % 360)
    else
        surface.DrawTexturedRect(x + w - 24 - 4, y + 9, 16, 16)
    end
end

function notification.AddLegacy( text, type, time )
    surface.SetFont( "ehc.22" )
    table.insert( Notifications, 1, {
        x = ScrW(),
        y = ScrH()-200,
        w = surface.GetTextSize( text ) + 20 + 32,
        h = 32,
        text = text,
        col = Colors[ type ],
        icon = Icons[ type ],
        time = CurTime() + time,
        progress = nil,
    })
end

function notification.AddProgress(id, text, frac)
    for k,v in ipairs(Notifications) do
        if v.id == id then
            v.text = text
            v.progress = frac
            return
        end
    end
    surface.SetFont("ehc.22")
    table.insert(Notifications, 1, {
        x = ScrW(),
        y = ScrH()-200,
        w = surface.GetTextSize( text ) + 20 + 32,
        h = 32,
        id = id,
        text = text,
        col = LoadingColor,
        icon = LoadingIcon,
        time = math.huge,
        progress = math.Clamp( frac or 0, 0, 1 ),
    })    
end

function notification.Kill( id )
    for k,v in ipairs(Notifications) do
        if v.id == id then v.time = 0 end
    end
end

hook.Add("HUDPaint", "EhudCNotiffications", function()
    for k,v in ipairs(Notifications) do
        DrawNotification(math.floor(v.x), math.floor(v.y), v.w, v.h, v.text, v.icon, v.col, v.progress)

        v.x = Lerp(FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 10 or ScrW() + 1)
        v.y = Lerp(FrameTime() * 10, v.y, (ScrH()-200)-(k-1)*(v.h+5))
    end

    for k,v in ipairs(Notifications) do
        if v.x >= ScrW() and v.time < CurTime() then
            table.remove(Notifications, k)
        end
    end
end)

timer.Simple(3, function()
    function notification.AddLegacy( text, type, time )
        surface.SetFont( "ehc.22" )
        table.insert( Notifications, 1, {
            x = ScrW(),
            y = ScrH()-200,
            w = surface.GetTextSize( text ) + 20 + 32,
            h = 32,
            text = text,
            col = Colors[ type ],
            icon = Icons[ type ],
            time = CurTime() + time,
            progress = nil,
        })
    end
    
    function notification.AddProgress(id, text, frac)
        for k,v in ipairs(Notifications) do
            if v.id == id then
                v.text = text
                v.progress = frac
                return
            end
        end
        surface.SetFont("ehc.22")
        table.insert(Notifications, 1, {
            x = ScrW(),
            y = ScrH()-200,
            w = surface.GetTextSize( text ) + 20 + 32,
            h = 32,
            id = id,
            text = text,
            col = LoadingColor,
            icon = LoadingIcon,
            time = math.huge,
            progress = math.Clamp( frac or 0, 0, 1 ),
        })    
    end
    
    function notification.Kill( id )
        for k,v in ipairs(Notifications) do
            if v.id == id then v.time = 0 end
        end
    end
end)