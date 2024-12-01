// Addon made by Eve Haddox
// my discord "evehaddox"

// functions

plyr = FindMetaTable("Player")

function plyr.drawOutlinedBox(out, x, y, w, h, cl, clout)

    draw.RoundedBox(15, x, y, w, h, clout)
    draw.RoundedBox(15, x + out, y + out, w - out * 2, h - out * 2, cl)
    
end

function plyr.drawTitleBox(out, lineh, x, y, w, h, cl, clout, clac, cltxt, txt)

    LocalPlayer().drawOutlinedBox(out, x, y, w, h, cl, clout)
    draw.RoundedBoxEx(15, x + out, y + out, w - out * 2, 36 - out * 2, ehc.colors.main, true, true, false, false)

    draw.RoundedBox(0, x + out, y + 32, w - out * 2, lineh, ehc.colors.ac)

    draw.SimpleText(txt, "equam2.main", x + 10, y + 16, cltxt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

end

function plyr.drawButton(out, x, y, w, h, txt, cl, clout, cltxt)
    
    LocalPlayer().drawOutlinedBox(out, x, y, w, h, cl, clout)
    draw.SimpleText(txt, "equam2.main", x + w / 2, y + h / 2 - 2, cltxt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function draw.drawCircle(x, y, r, step, cache)
    local positions = {}


    for i = 0, 360, step do
        table.insert(positions, {
            x = x + math.cos(math.rad(i)) * r,
            y = y + math.sin(math.rad(i)) * r
        })
    end


    return (cache and positions) or surface.DrawPoly(positions)
end

function draw.drawArc(x, y, r, startAng, endAng, step ,cache)
    local positions = {}


    positions[1] = {
        x = x,
        y = y
    }


    for i = startAng - 90, endAng - 90, step do
        table.insert(positions, {
            x = x + math.cos(math.rad(i)) * r,
            y = y + math.sin(math.rad(i)) * r
        })
    end


    return (cache and positions) or surface.DrawPoly(positions)
end

function draw.drawSubSection(x, y, r, r2, startAng, endAng, step, cache)
    local positions = {}
    local inner = {}
    local outer = {}


    r2 = r+r2
    startAng = startAng or 0
    endAng = endAng or 0


    for i = startAng - 90, endAng - 90, step do
        table.insert(inner, {
            x = math.ceil(x + math.cos(math.rad(i)) * r2),
            y = math.ceil(y + math.sin(math.rad(i)) * r2)
        })
    end


    for i = startAng - 90, endAng - 90, step do
        table.insert(outer, {
            x = math.ceil(x + math.cos(math.rad(i)) * r),
            y = math.ceil(y + math.sin(math.rad(i)) * r)
        })
    end


    for i = 1, #inner * 2 do
        local outPoints = outer[math.floor(i / 2) + 1]
        local inPoints = inner[math.floor((i + 1) / 2) + 1]
        local otherPoints


        if i % 2 == 0 then
            otherPoints = outer[math.floor((i + 1) / 2)]
        else
            otherPoints = inner[math.floor((i + 1) / 2)]
        end


        table.insert(positions, {outPoints, otherPoints, inPoints})
    end


    if cache then
        return positions
    else
        for k,v in pairs(positions) do 
            surface.DrawPoly(v)
        end
    end
end


// initiating values

local scrw = ScrW()
local scrh = ScrH()

local circle = nil
local subsectionbg = nil
local scircle = nil
local mcircle = nil

local mr = 45
local outw = 7
local outr = 35 - outw
local sr = 20
local mdr = 25

local hpdisplay = 0
local ardisplay = 0

local is = ehc.iconsize

// disabling default hud

local disabledHUDs = {
    ["DarkRP_HUD"] = true,
    ["CHudBattery"] = true,
    ["CHudHealth"] = true,
    ["DarkRP_Hungermod"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudAmmo"] = true,
}

hook.Add("HUDShouldDraw", "EveHud", function(vs)
    if disabledHUDs[vs] then return false end
end)

// declaring functions

local function getCircle(x, y)
    circle = draw.drawCircle(x, y, mr, 1, true)
end

local function getSubsection(x, y)
    subsectionbg = draw.drawSubSection(x, y, outr, outw, 0, 360, 1, true)
end

local function getScircle(x, y)
    scircle = draw.drawCircle(x, y, sr, 1, true)
end

local function getMcircle(x, y)
    mcircle = draw.drawCircle(x, y, mdr, 1, true)
end

// making icons and playermodel refresh when script saves

if IsValid(ehc.jobicon) then ehc.jobicon:Remove() end
if IsValid(ehc.moneyicon) then ehc.moneyicon:Remove() end
if IsValid(ehc.licenceicon) then ehc.licenceicon.Panel:Remove() end
if IsValid(ehc.wantedicon) then ehc.wantedicon.Panel:Remove() end
if IsValid(ehc.lockdownicon) then ehc.lockdownicon.Panel:Remove() end
if IsValid(ehc.arrestedicon) then ehc.arrestedicon.Panel:Remove() end

// painting hud

hook.Add( "HUDPaint", "ehudCmain", function()

    local ply = LocalPlayer()

    // background
    draw.NoTexture()
    surface.SetDrawColor(ehc.colors.sec)
    getCircle(ehc.spacing + mr, scrh - ehc.spacing - mr)
    surface.DrawPoly(circle)

    getCircle(ehc.spacing * 2 + mr * 3, scrh - ehc.spacing - mr)
    surface.DrawPoly(circle)

    // display outline
    surface.SetDrawColor(ehc.colors.main)
    getSubsection(ehc.spacing + mr, scrh - ehc.spacing - mr)
    for k,v in pairs(subsectionbg) do 
        surface.DrawPoly(v)
    end

    getSubsection(ehc.spacing * 2 + mr * 3, scrh - ehc.spacing - mr)
    for k,v in pairs(subsectionbg) do 
        surface.DrawPoly(v)
    end

    // hp
    local hp = LocalPlayer():Health()
    local mhp = LocalPlayer():GetMaxHealth()
    local hpcalc = (hp / mhp) * 360
    hpdisplay = Lerp(FrameTime() * 5, hpdisplay, hpcalc)
    hptxt = math.Round(hpdisplay / 3.6, 0)

    draw.SimpleText(hptxt, "ehc.28", ehc.spacing + mr, scrh - ehc.spacing - mr, ehc.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local subsectionhp = draw.drawSubSection(ehc.spacing + mr, scrh - ehc.spacing - mr, outr, outw, 0, math.Round(hpdisplay), 1, true)

    surface.SetDrawColor(ehc.colors.hp)
    for k,v in pairs(subsectionhp) do 
        surface.DrawPoly(v)
    end

    // ar
    local ar = LocalPlayer():Armor()
    local mar = LocalPlayer():GetMaxArmor()
    local arcalc = (ar / mar) * 360
    ardisplay = Lerp(FrameTime() * 5, ardisplay, arcalc)
    artxt = math.Round(ardisplay / 3.6, 0)

    draw.SimpleText(artxt, "ehc.28", ehc.spacing * 2 + mr * 3, scrh - ehc.spacing - mr, ehc.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local subsectionar = draw.drawSubSection(ehc.spacing * 2 + mr * 3, scrh - ehc.spacing - mr, outr, outw, 0, math.Round(ardisplay), 1, true)

    surface.SetDrawColor(ehc.colors.ar)
    for k,v in pairs(subsectionar) do 
        surface.DrawPoly(v)
    end

    // small displays
    surface.SetDrawColor(ehc.colors.sec)
    getScircle(ehc.spacing * 3 + mr * 4 + sr, scrh - ehc.spacing - sr)
    surface.DrawPoly(scircle)

    getScircle(ehc.spacing * 3 + mr * 4 + sr, scrh - ehc.spacing * 1.5 - sr * 3)
    surface.DrawPoly(scircle)

    // icons
    if not IsValid(ehc.jobicon) then
        ehc.jobicon = vgui.Create("DImage")
        ehc.jobicon:SetImage("materials/eve/job.png")
        ehc.jobicon:SetPos(ehc.spacing * 3 + mr * 4 + sr - (is - 3) / 2, scrh - ehc.spacing * 1.5 - sr * 3 - (is - 3) / 2)
        ehc.jobicon:SetSize(is - 3, is - 3)
    end

    if not IsValid(ehc.moneyicon) then
        ehc.moneyicon = vgui.Create("DImage")
        ehc.moneyicon:SetImage("materials/eve/money.png")
        ehc.moneyicon:SetPos(ehc.spacing * 3 + mr * 4 + sr - is / 2, scrh - ehc.spacing - sr - is / 2)
        ehc.moneyicon:SetSize(is, is)
    end

    // text
    draw.SimpleText(ply:getDarkRPVar("job"), "ehc.28", ehc.spacing * 4 + mr * 4 + sr * 2, scrh - ehc.spacing * 1.5 - sr * 3, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(DarkRP.formatMoney(ply:getDarkRPVar("money")), "ehc.28", ehc.spacing * 4 + mr * 4 + sr * 2, scrh - ehc.spacing - sr, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    // status displays

    // gun licence
    if ply:getDarkRPVar("HasGunlicense") then
        if ehc.statustext then
            draw.SimpleText("Licence", "ehc.28", ehc.spacing * 2 + mdr * 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart - 2, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        surface.SetDrawColor(ehc.colors.sec)
        getMcircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart)
        surface.DrawPoly(mcircle)
        surface.DrawCircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart, mdr * 0.75, ehc.colors.ar)
        surface.DrawCircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart, mdr * 0.75 + 1, ehc.colors.ar)
        if not IsValid(ehc.licenceicon) then
            ehc.licenceicon = vgui.Create("DImage")
            ehc.licenceicon:SetImage("materials/eve/weapon.png")
            ehc.licenceicon:SetPos(ehc.spacing + mdr - is / 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - is / 2 - ehc.statusdstart)
            ehc.licenceicon:SetSize(is, is)
        end
    else
        if IsValid(ehc.licenceicon) then ehc.licenceicon.Panel:Remove() end
    end
    if IsValid(ehc.licenceicon) then
        ehc.licenceicon:SetPos(ehc.spacing + mdr - is / 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - is / 2 - ehc.statusdstart)
    end

    // wanted
    wantedpos = 0
    if IsValid(ehc.licenceicon) then
        wantedpos = wantedpos + mdr * 1.8 + ehc.spacing
    end
    if LocalPlayer():getDarkRPVar("wanted") then
        if ehc.statustext then
            draw.SimpleText("Wanted", "ehc.28", ehc.spacing * 2 + mdr * 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos - 2, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        surface.SetDrawColor(ehc.colors.sec)
        getMcircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos)
        surface.DrawPoly(mcircle)
        surface.DrawCircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos, mdr * 0.75, ehc.colors.hp)
        surface.DrawCircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos, mdr * 0.75 + 1, ehc.colors.hp)
        if not IsValid(ehc.wantedicon) then
            ehc.wantedicon = vgui.Create("DImage")
            ehc.wantedicon:SetImage("materials/eve/wanted.png")
            ehc.wantedicon:SetPos(ehc.spacing + mdr - is / 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - is / 2 - ehc.statusdstart + wantedpos)
            ehc.wantedicon:SetSize(is, is)
        end
    else
        if IsValid(ehc.wantedicon) then ehc.wantedicon.Panel:Remove() end
    end
    if IsValid(ehc.wantedicon) then
        ehc.wantedicon:SetPos(ehc.spacing + mdr - is / 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - is / 2 - ehc.statusdstart + wantedpos)
    end

    // lockdown
    lockdownpos = 0
    if IsValid(ehc.wantedicon) then
        lockdownpos = lockdownpos + mdr * 1.8 + ehc.spacing
    end
    if GetGlobalBool("DarkRP_LockDown") then
        if ehc.statustext then
            draw.SimpleText("Lockdown", "ehc.28", ehc.spacing * 2 + mdr * 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos + lockdownpos - 2, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        surface.SetDrawColor(ehc.colors.sec)
        getMcircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos + lockdownpos)
        surface.DrawPoly(mcircle)
        surface.DrawCircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos + lockdownpos, mdr * 0.75, ehc.colors.hp)
        surface.DrawCircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos + lockdownpos, mdr * 0.75 + 1, ehc.colors.hp)
        if not IsValid(ehc.lockdownicon) then
            ehc.lockdownicon = vgui.Create("DImage")
            ehc.lockdownicon:SetImage("materials/eve/lockdown.png")
            ehc.lockdownicon:SetPos(ehc.spacing + mdr - is / 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - is / 2 - ehc.statusdstart + wantedpos + lockdownpos)
            ehc.lockdownicon:SetSize(is, is)
        end
    else
        if IsValid(ehc.lockdownicon) then ehc.lockdownicon.Panel:Remove() end
    end
    if IsValid(ehc.lockdownicon) then
        ehc.lockdownicon:SetPos(ehc.spacing + mdr - is / 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - is / 2 - ehc.statusdstart + wantedpos + lockdownpos)
    end

    // arrested
    arrestedpos = 0
    if IsValid(ehc.lockdownicon) then
        arrestedpos = arrestedpos + mdr * 1.8 + ehc.spacing
    end
    if ply:getDarkRPVar("Arrested") then
        if ehc.statustext then
            draw.SimpleText("Arrested", "ehc.28", ehc.spacing * 2 + mdr * 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos + lockdownpos + arrestedpos - 2, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        surface.SetDrawColor(ehc.colors.sec)
        getMcircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos + lockdownpos + arrestedpos)
        surface.DrawPoly(mcircle)
        surface.DrawCircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos + lockdownpos + arrestedpos, mdr * 0.75, ehc.colors.hp)
        surface.DrawCircle(ehc.spacing + mdr, scrh - ehc.spacing * 2 - mdr - mr * 2 - ehc.statusdstart + wantedpos + lockdownpos + arrestedpos, mdr * 0.75 + 1, ehc.colors.hp)
        if not IsValid(ehc.arrestedicon) then
            ehc.arrestedicon = vgui.Create("DImage")
            ehc.arrestedicon:SetImage("materials/eve/arrested.png")
            ehc.arrestedicon:SetPos(ehc.spacing + mdr - is / 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - is / 2 - ehc.statusdstart + wantedpos + lockdownpos + arrestedpos)
            ehc.arrestedicon:SetSize(is, is)
        end
    else
        if IsValid(ehc.arrestedicon) then ehc.arrestedicon.Panel:Remove() end
    end
    if IsValid(ehc.arrestedicon) then
        ehc.arrestedicon:SetPos(ehc.spacing + mdr - is / 2, scrh - ehc.spacing * 2 - mdr - mr * 2 - is / 2 - ehc.statusdstart + wantedpos + lockdownpos + arrestedpos)
    end

end)

// debug

//hook.Remove("HUDPaint", "ehudCmain")