// Addon made by Eve Haddox
// my discord "evehaddox"

// initiating values

local scrw = ScrW()
local scrh = ScrH()

local circle = nil
local subsectionbg = nil
local scircle = nil

local mr = 45
local outw = 7
local outr = 35 - outw
local sr = 20

local Props = 0

local ammodisplay = 0

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

// making icons and playermodel refresh when script saves

if IsValid(ehc.ammoicon) then ehc.ammoicon:Remove() end
if IsValid(ehc.weaponicon) then ehc.weaponicon:Remove() end
if IsValid(ehc.propicon) then ehc.propicon:Remove() end

// prop counter

net.Receive("UpdateProp",function(  )
	Props = net.ReadUInt(11)
end)

local function propLimit(x, y, w, h)

    local proptxt = (Props .."/".. GetConVar( "sbox_maxprops" ):GetInt())

    draw.SimpleText(proptxt, "ehc.28", x, y, ehc.colors.txt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    
end

// painting hud

hook.Add("HUDPaint", "ehudCWep", function()
    
    local ply = LocalPlayer()

    if not ply then return end

    if ply:InVehicle() then return end

    local wep = ply:GetActiveWeapon()

    if wep:IsValid() then

        local amt = wep:GetPrimaryAmmoType()

        if amt > 0 then

            if IsValid(ehc.propicon) then ehc.propicon:Remove() end
        
            // background
            draw.NoTexture()
            surface.SetDrawColor(ehc.colors.sec)
            getCircle(scrw - ehc.spacing - mr, scrh - ehc.spacing - mr)
            surface.DrawPoly(circle)

            surface.SetDrawColor(ehc.colors.main)
            getSubsection(scrw - ehc.spacing - mr, scrh - ehc.spacing - mr)
            for k,v in pairs(subsectionbg) do 
                surface.DrawPoly(v)
            end

            // ammo
            local ammo = wep:Clip1()
            local mammo = wep:GetMaxClip1()
            local ammocalc = (ammo / mammo) * 360
            ammodisplay = Lerp(FrameTime() * 5, ammodisplay, ammocalc)

            surface.SetDrawColor(ehc.colors.txt)
            subsectionammo = draw.drawSubSection(scrw - ehc.spacing - mr, scrh - ehc.spacing - mr, outr, outw, 0, ammocalc, 1, true)
            for k,v in pairs(subsectionammo) do 
                surface.DrawPoly(v)
            end

            surface.SetDrawColor(ehc.colors.sec)
            getScircle(scrw - ehc.spacing * 2 - mr * 2 - sr, scrh - ehc.spacing - sr)
            surface.DrawPoly(scircle)

            getScircle(scrw - ehc.spacing * 2 - mr * 2 - sr, scrh - ehc.spacing * 1.5 - sr * 3)
            surface.DrawPoly(scircle)

            if not IsValid(ehc.weaponicon) then
                ehc.weaponicon = vgui.Create("DImage")
                ehc.weaponicon:SetImage("materials/eve/weapon.png")
                ehc.weaponicon:SetPos(scrw - ehc.spacing * 2 - mr * 2 - sr - ehc.iconsize / 2, scrh - ehc.spacing - sr - ehc.iconsize / 2)
                ehc.weaponicon:SetSize(ehc.iconsize, ehc.iconsize)
            end

            if not IsValid(ehc.ammoicon) then
                ehc.ammoicon = vgui.Create("DImage")
                ehc.ammoicon:SetImage("materials/eve/ammo.png")
                ehc.ammoicon:SetPos(scrw - ehc.spacing * 2 - mr * 2 - sr - ehc.iconsize / 2, scrh - ehc.spacing * 1.5 - sr * 3 - ehc.iconsize / 2)
                ehc.ammoicon:SetSize(ehc.iconsize, ehc.iconsize)
            end

            draw.SimpleText(wep:GetPrintName(), "ehc.28", scrw - ehc.spacing * 3 - mr * 2 - sr * 2, scrh - ehc.spacing - sr, ehc.colors.txt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            draw.SimpleText(wep:Clip1(), "ehc.28", scrw - ehc.spacing - mr, scrh - ehc.spacing - mr, ehc.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(ply:GetAmmoCount(amt), "ehc.28", scrw - ehc.spacing * 3 - mr * 2 - sr * 2, scrh - ehc.spacing * 1.5 - sr * 3, ehc.colors.txt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        end

        if amt < 0 then

            if IsValid(ehc.ammoicon) then ehc.ammoicon:Remove() end

            // background
            draw.NoTexture()
            surface.SetDrawColor(ehc.colors.sec)
            getCircle(scrw - ehc.spacing - mr, scrh - ehc.spacing - mr)
            surface.DrawPoly(circle)

            surface.SetDrawColor(ehc.colors.txt)
            getSubsection(scrw - ehc.spacing - mr, scrh - ehc.spacing - mr)
            for k,v in pairs(subsectionbg) do 
                surface.DrawPoly(v)
            end

            surface.SetDrawColor(ehc.colors.sec)
            getScircle(scrw - ehc.spacing * 2 - mr * 2 - sr, scrh - ehc.spacing - sr)
            surface.DrawPoly(scircle)

            getScircle(scrw - ehc.spacing * 2 - mr * 2 - sr, scrh - ehc.spacing * 1.5 - sr * 3)
            surface.DrawPoly(scircle)

            if not IsValid(ehc.weaponicon) then
                ehc.weaponicon = vgui.Create("DImage")
                ehc.weaponicon:SetImage("materials/eve/weapon.png")
                ehc.weaponicon:SetPos(scrw - ehc.spacing * 2 - mr * 2 - sr - ehc.iconsize / 2, scrh - ehc.spacing - sr - ehc.iconsize / 2)
                ehc.weaponicon:SetSize(ehc.iconsize, ehc.iconsize)
            end

            if not IsValid(ehc.propicon) then
                ehc.propicon = vgui.Create("DImage")
                ehc.propicon:SetImage("materials/eve/props.png")
                ehc.propicon:SetPos(scrw - ehc.spacing * 2 - mr * 2 - sr - ehc.iconsize / 2, scrh - ehc.spacing * 1.5 - sr * 3 - ehc.iconsize / 2)
                ehc.propicon:SetSize(ehc.iconsize, ehc.iconsize)
            end

            draw.SimpleText(wep:GetPrintName(), "ehc.28", scrw - ehc.spacing * 3 - mr * 2 - sr * 2, scrh - ehc.spacing - sr, ehc.colors.txt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            propLimit(scrw - ehc.spacing * 3 - mr * 2 - sr * 2, scrh - ehc.spacing * 1.5 - sr * 3)
        
        end

    else
        if IsValid(ehc.ammoicon) then ehc.ammoicon:Remove() end
        if IsValid(ehc.weaponicon) then ehc.weaponicon:Remove() end
        if IsValid(ehc.propicon) then ehc.propicon:Remove() end
    end

end)