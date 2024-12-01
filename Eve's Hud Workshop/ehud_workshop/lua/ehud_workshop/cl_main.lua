// Addon made by Eve Haddox
// my discord "evehaddox"

// initiating values

local scrw = ScrW()
local scrh = ScrH()

local is = 22

local hw, hh = is + eve.ehudw.spacing * 2.5, scrh * 0.1
local ahw, ahh = scrh * 0.1, scrh * 0.1
local uhw, uhh = is + eve.ehudw.spacing * 2.3, scrh * 0.035
local barw, barh = scrw * 0.005, scrh * 0.1

local wantedpos = 0
local lockdownpos = 0

local ghw, ghh = scrw * 0.04, scrh * 0.04

// disabling default hud

local disabledHUDs = {
    ["DarkRP_HUD"] = true,
    ["CHudBattery"] = true,
    ["CHudHealth"] = true,
    ["DarkRP_Hungermod"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudAmmo"] = true,
}

hook.Add("HUDShouldDraw", "shud_disabledefaulthud", function(vs)
    if disabledHUDs[vs] then return false end
end)

// making icons and playermodel refresh when script saves

if IsValid(eve.ehudw.Panel) then eve.ehudw.Panel:Remove() end
if IsValid(eve.ehudw.jobicon) then eve.ehudw.jobicon.Panel:Remove() end
if IsValid(eve.ehudw.nickicon) then eve.ehudw.nickicon.Panel:Remove() end
if IsValid(eve.ehudw.moneyicon) then eve.ehudw.moneyicon.Panel:Remove() end
if IsValid(eve.ehudw.salaryicon) then eve.ehudw.salaryicon.Panel:Remove() end
if IsValid(eve.ehudw.licenceicon) then eve.ehudw.licenceicon.Panel:Remove() end
if IsValid(eve.ehudw.wantedicon) then eve.ehudw.wantedicon.Panel:Remove() end
if IsValid(eve.ehudw.lockdownicon) then eve.ehudw.lockdownicon.Panel:Remove() end

// painting hud

hook.Add( "HUDPaint", "eHudW", function()

    // playermodel box
    draw.RoundedBox(20, eve.ehudw.spacing, scrh - ahh - eve.ehudw.spacing, ahw, ahh, eve.ehudw.colors.ac)
    draw.RoundedBox(20, eve.ehudw.spacing + 2, scrh - ahh - eve.ehudw.spacing + 2, ahw - 4, ahh - 4, eve.ehudw.colors.main)

    // playermodel
    if not IsValid(eve.ehudw.Panel) then
        eve.ehudw.Panel = vgui.Create( "DPanel" )
        eve.ehudw.Panel:SetPos(eve.ehudw.spacing * 2 - ahh * 0.1, scrh - ahh - eve.ehudw.spacing / 2)
        eve.ehudw.Panel:SetSize(ahh - eve.ehudw.spacing, ahh - eve.ehudw.spacing)
        eve.ehudw.Panel:ParentToHUD()

        eve.ehudw.Panel.Paint = function()            
        end

        eve.ehudw.icon = vgui.Create( "DModelPanel", eve.ehudw.Panel )
        eve.ehudw.icon:SetSize(hh, hh * 2)
        eve.ehudw.icon:SetModel( LocalPlayer():GetModel() ) -- you can only change colors on playermodels
        eve.ehudw.icon:SetLookAt(eve.ehudw.icon.Entity:GetPos() + Vector(0, 0, 35)) -- Center on the model's middle
        eve.ehudw.icon:SetCamPos( Vector(40,0,50) )
        function eve.ehudw.icon:LayoutEntity( Entity ) return end
        function eve.ehudw.icon.Entity:GetPlayerColor() return Vector (1, 0, 0) end
    end

    eve.ehudw.icon:SetModel( LocalPlayer():GetModel() )

    // main box

    // nick
    surface.SetFont("EHW28")
    ns = surface.GetTextSize(LocalPlayer():Nick())
    // money
    surface.SetFont("EHW28")
    ms = surface.GetTextSize(DarkRP.formatMoney(ply:getDarkRPVar("money")))
    // salary
    surface.SetFont("EHW28")
    ss = surface.GetTextSize("+".. DarkRP.formatMoney(ply:getDarkRPVar("salary")))

    hw = is + eve.ehudw.spacing * 2.5
    bs = math.max(ns, ms, ss)
    hw = hw + bs

    draw.RoundedBox(20, eve.ehudw.spacing * 2 + ahw, scrh - hh - eve.ehudw.spacing, hw, hh, eve.ehudw.colors.ac)
    draw.RoundedBox(20, eve.ehudw.spacing * 2 + ahw + 2, scrh - hh - eve.ehudw.spacing + 2, hw - 4, hh - 4, eve.ehudw.colors.main)

    if not IsValid(eve.ehudw.nickicon) then
        eve.ehudw.nickicon = vgui.Create("DImage")
        eve.ehudw.nickicon:SetImage("materials/eve/id.png")
        eve.ehudw.nickicon:SetPos(eve.ehudw.spacing * 2 + ahw + hw * 0.05, scrh - hh - is / 2 - eve.ehudw.spacing + hh * 0.2, eve.ehudw.colors.txt)
        eve.ehudw.nickicon:SetSize(is, is)
    end
    if not IsValid(eve.ehudw.moneyicon) then
        eve.ehudw.moneyicon = vgui.Create("DImage")
        eve.ehudw.moneyicon:SetImage("materials/eve/money.png")
        eve.ehudw.moneyicon:SetPos(eve.ehudw.spacing * 2 + ahw + hw * 0.05, scrh - hh - (is + 2) / 2 - eve.ehudw.spacing + hh * 0.5, eve.ehudw.colors.txt)
        eve.ehudw.moneyicon:SetSize(is + 2, is + 2)
    end
    if not IsValid(eve.ehudw.salaryicon) then
        eve.ehudw.salaryicon = vgui.Create("DImage")
        eve.ehudw.salaryicon:SetImage("materials/eve/salary.png")
        eve.ehudw.salaryicon:SetPos(eve.ehudw.spacing * 2 + ahw + hw * 0.05, scrh - hh - is / 2 - eve.ehudw.spacing + hh * 0.8, eve.ehudw.colors.txt)
        eve.ehudw.salaryicon:SetSize(is, is)
    end

    draw.SimpleText(LocalPlayer():Nick(), "EHW28", eve.ehudw.spacing * 2.5 + ahw + is + hw * 0.05, scrh - hh - eve.ehudw.spacing + hh * 0.18, eve.ehudw.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(DarkRP.formatMoney(ply:getDarkRPVar("money")), "EHW28", eve.ehudw.spacing * 2.5 + ahw + is + hw * 0.05, scrh - hh - eve.ehudw.spacing + hh * 0.48, eve.ehudw.colors.money, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("+".. DarkRP.formatMoney(ply:getDarkRPVar("salary")), "EHW28", eve.ehudw.spacing * 2.5 + ahw + is + hw * 0.05, scrh - hh - eve.ehudw.spacing + hh * 0.76, eve.ehudw.colors.salary, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    // upper box
    uhw = is + eve.ehudw.spacing * 2.3
    surface.SetFont("EHW28")
    js = surface.GetTextSize(ply:getDarkRPVar("job"))
    uhw = uhw + js + eve.ehudw.spacing

    draw.RoundedBox(20, eve.ehudw.spacing, scrh - uhh - hh - eve.ehudw.spacing * 1.5, uhw, uhh, eve.ehudw.colors.ac)
    draw.RoundedBox(20, eve.ehudw.spacing + 2, scrh - uhh - hh - eve.ehudw.spacing * 1.5 + 2, uhw - 4, uhh - 4, eve.ehudw.colors.main)

    if not IsValid(eve.ehudw.jobicon) then
        eve.ehudw.jobicon = vgui.Create("DImage")
        eve.ehudw.jobicon:SetImage("materials/eve/job.png")
        eve.ehudw.jobicon:SetPos(eve.ehudw.spacing * 2.2, scrh - (uhh + is) / 2 - hh - eve.ehudw.spacing * 1.5)
        eve.ehudw.jobicon:SetSize(is, is)
    end

    draw.SimpleText(ply:getDarkRPVar("job"), "EHW28", eve.ehudw.spacing * 3 + is, scrh - uhh / 2 - hh - 3 - eve.ehudw.spacing * 1.5, team.GetColor(ply:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    // hp
    draw.RoundedBox(20, eve.ehudw.spacing * 3 + hw + ahw, scrh - barh - eve.ehudw.spacing, barw, barh, eve.ehudw.colors.sec)
    draw.RoundedBox(20, eve.ehudw.spacing * 3 + hw + ahw + 2, scrh - barh * (LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) - eve.ehudw.spacing + 2, barw - 4, barh * (LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) - 4, eve.ehudw.colors.hp)

    // ar
    draw.RoundedBox(20, eve.ehudw.spacing * 3.5 + hw + ahw + barw, scrh - barh - eve.ehudw.spacing, barw, barh, eve.ehudw.colors.sec)
    draw.RoundedBox(20, eve.ehudw.spacing * 3.5 + hw + ahw + barw + 2, scrh - barh * (LocalPlayer():Armor() / LocalPlayer():GetMaxArmor()) - eve.ehudw.spacing + 2, barw - 4, barh * (LocalPlayer():Armor() / LocalPlayer():GetMaxArmor()) - 4, eve.ehudw.colors.ar)

    // gun licence
    if LocalPlayer():getDarkRPVar("HasGunlicense") then
        if not IsValid(eve.ehudw.licenceicon) then
            eve.ehudw.licenceicon = vgui.Create("DImage")
            eve.ehudw.licenceicon:SetImage("materials/eve/licence.png")
            eve.ehudw.licenceicon:SetPos(eve.ehudw.spacing * 2 + uhw, scrh - (uhh + (is + 3)) / 2 - hh - eve.ehudw.spacing * 1.5)
            eve.ehudw.licenceicon:SetSize(is + 3, is + 3)
        end
    else
        if IsValid(eve.ehudw.licenceicon) then eve.ehudw.licenceicon.Panel:Remove() end
    end
    if IsValid(eve.ehudw.licenceicon) then
        eve.ehudw.licenceicon:SetPos(eve.ehudw.spacing * 2 + uhw, scrh - (uhh + (is + 3)) / 2 - hh - eve.ehudw.spacing * 1.5)
    end

    // wanted
    wantedpos = 0
    if IsValid(eve.ehudw.licenceicon) then
        wantedpos = wantedpos + is + eve.ehudw.spacing
    end
    if LocalPlayer():getDarkRPVar("wanted") then
        if not IsValid(eve.ehudw.wantedicon) then
            eve.ehudw.wantedicon = vgui.Create("DImage")
            eve.ehudw.wantedicon:SetImage("materials/eve/wanted.png")
            eve.ehudw.wantedicon:SetPos(eve.ehudw.spacing * 2 + uhw + wantedpos, scrh - (uhh + (is + 3)) / 2 - hh - eve.ehudw.spacing * 1.5)
            eve.ehudw.wantedicon:SetSize(is + 3, is + 3)
        end
    else
        if IsValid(eve.ehudw.wantedicon) then eve.ehudw.wantedicon.Panel:Remove() end
    end
    if IsValid(eve.ehudw.wantedicon) then
        eve.ehudw.wantedicon:SetPos(eve.ehudw.spacing * 2 + uhw + wantedpos, scrh - (uhh + (is + 3)) / 2 - hh - eve.ehudw.spacing * 1.5)
    end

    // lockdown
    lockdownpos = 0
    if IsValid(eve.ehudw.wantedicon) then
        lockdownpos = lockdownpos + is + eve.ehudw.spacing
    end
    if GetGlobalBool("DarkRP_LockDown") then
        if not IsValid(eve.ehudw.lockdownicon) then
            eve.ehudw.lockdownicon = vgui.Create("DImage")
            eve.ehudw.lockdownicon:SetImage("materials/eve/lockdown.png")
            eve.ehudw.lockdownicon:SetPos(eve.ehudw.spacing * 2 + uhw + wantedpos + lockdownpos, scrh - (uhh + (is + 3)) / 2 - hh - eve.ehudw.spacing * 1.5)
            eve.ehudw.lockdownicon:SetSize(is + 3, is + 3)
        end
    else
        if IsValid(eve.ehudw.lockdownicon) then eve.ehudw.lockdownicon.Panel:Remove() end
    end
    if IsValid(eve.ehudw.lockdownicon) then
        eve.ehudw.lockdownicon:SetPos(eve.ehudw.spacing * 2 + uhw + wantedpos + lockdownpos, scrh - (uhh + (is + 3)) / 2 - hh - eve.ehudw.spacing * 1.5)
    end

end)

hook.Add("HUDPaint", "eHudWWep", function()
    
    local ply = LocalPlayer()

    if not ply then return end

    if ply:InVehicle() then return end

    local wep = ply:GetActiveWeapon()

    if wep:IsValid() then

        local amt = wep:GetPrimaryAmmoType()

        if amt > 0 then
        
            surface.SetFont("EHW22")
            amw = surface.GetTextSize("/ "..ply:GetAmmoCount(amt))

            surface.SetFont("EHW28")
            clw = surface.GetTextSize(wep:Clip1())
            wnw = surface.GetTextSize(wep:GetPrintName())

            local amhw, amhh = eve.ehudw.spacing * 2 + amw + clw

            draw.RoundedBox(20, scrw - eve.ehudw.spacing - ghw, scrh - eve.ehudw.spacing - ghh, ghw, ghh, eve.ehudw.colors.ac)
            draw.RoundedBox(20, scrw - eve.ehudw.spacing - ghw + 2, scrh - eve.ehudw.spacing - ghh + 2, ghw - 4, ghh - 4, eve.ehudw.colors.main)

            ghw = eve.ehudw.spacing * 2 + wnw

            draw.SimpleText(wep:GetPrintName(), "EHW28", scrw - eve.ehudw.spacing - ghw / 2, scrh - eve.ehudw.spacing - ghh / 2 - 2, eve.ehudw.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            draw.RoundedBox(20, scrw - eve.ehudw.spacing - amhw, scrh - eve.ehudw.spacing * 1.5 - ghh * 2, amhw, ghh, eve.ehudw.colors.ac)
            draw.RoundedBox(20, scrw - eve.ehudw.spacing - amhw + 2, scrh - eve.ehudw.spacing * 1.5 - ghh * 2 + 2, amhw - 4, ghh - 4, eve.ehudw.colors.main)

            draw.SimpleText(wep:Clip1(), "EHW28", scrw - amhw, scrh - eve.ehudw.spacing * 1.5 - ghh * 1.5 - 3, eve.ehudw.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText("/ "..ply:GetAmmoCount(amt), "EHW22", scrw - amhw + clw * 1.1, scrh - eve.ehudw.spacing * 1.5 - ghh * 1.5 - 1, eve.ehudw.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        end

        if amt < 0 then

            surface.SetFont("EHW28")
            wnw = surface.GetTextSize(wep:GetPrintName())

            ghw = eve.ehudw.spacing * 2 + wnw

            draw.RoundedBox(20, scrw - eve.ehudw.spacing - ghw, scrh - eve.ehudw.spacing - ghh, ghw, ghh, eve.ehudw.colors.ac)
            draw.RoundedBox(20, scrw - eve.ehudw.spacing - ghw + 2, scrh - eve.ehudw.spacing - ghh + 2, ghw - 4, ghh - 4, eve.ehudw.colors.main)

            draw.SimpleText(wep:GetPrintName(), "EHW28", scrw - eve.ehudw.spacing - ghw / 2, scrh - eve.ehudw.spacing - ghh / 2 - 2, eve.ehudw.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        end

    end

end)

// debug

concommand.Add("eve_disable_hud", function(ply, cmd, args)
    if ply:GetUserGroup() != "superadmin" then return end
    hook.Remove("HUDPaint", "eHudW")
    eve.ehudw.Panel:Remove()
    eve.ehudw.jobicon.Panel:Remove()
end)

concommand.Add("eve_disable_weapon_hud", function(ply, cmd, args)
    if ply:GetUserGroup() != "superadmin" then return end
    hook.Remove("HUDPaint", "eHudWWep")
end)