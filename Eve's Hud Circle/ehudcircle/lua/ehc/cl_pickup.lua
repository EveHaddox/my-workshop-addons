// Addon made by Eve Haddox
// my discord "evehaddox"

local Pickups = {}

hook.Add("HUDShouldDraw", "EhudPickupDisable", function(name)
    if name == "CHudItemPickup" then
        return false
    end
end)


local function DrawNotification(x, y, w, h, text, icon, col, progress)
    draw.RoundedBox(20, x, y, w, h, ehc.colors.out)
    draw.RoundedBox(20, x + 2, y + 2, w - 4, h - 4, ehc.colors.main)

    draw.SimpleText(text, "ehc.22", x + 10, y + h / 2 - 2, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

local function AddPickupLine(text)
    text = "+ "..text
    surface.SetFont( "ehc.22" )
    table.insert( Pickups, 1, {
        x = ScrW(),
        y = ehc.pickupStart,
        w = surface.GetTextSize( text ) + 20,
        h = 32,
        text = text,
        time = CurTime()+5,
        progress = nil,
    })
end

hook.Add("HUDPaint", "Ehudc_pickup", function()
    for k,v in ipairs(Pickups) do
        DrawNotification(math.floor(v.x), math.floor(v.y), v.w, v.h, v.text, v.icon, v.col, v.progress)

        v.x = Lerp(FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 10 or ScrW() + 1)
        v.y = Lerp(FrameTime() * 10, v.y, (ehc.pickupStart)+(k-1)*(v.h+5))
    end

    for k,v in ipairs(Pickups) do
        if v.x >= ScrW() and v.time+1 < CurTime() then
            table.remove(Pickups, k)
        end
    end
end)


hook.Add("HUDItemPickedUp","Ehud_pickup", function(itemName)
    if not LocalPlayer() or not IsValid(LocalPlayer()) then return end
    AddPickupLine(language.GetPhrase("#" .. itemName))
end)

hook.Add("HUDWeaponPickedUp","Ehud_pickup", function(wep)
    if not LocalPlayer() or not IsValid(LocalPlayer()) then return end
    if not IsValid(wep) then return end
    if not isfunction(wep.GetPrintName) then return end
    AddPickupLine(wep:GetPrintName())
end)

hook.Add("HUDAmmoPickedUp","Ehud_pickup", function(itemname, amount)
    if not LocalPlayer() or not IsValid(LocalPlayer()) then return end
    AddPickupLine(amount.." "..language.GetPhrase("#" .. itemname .. "_Ammo"))
end)

hook.Add("InitPostEntity","Ehud_pickup",function()
    GAMEMODE.HUDDrawPickupHistory = function()end
end)