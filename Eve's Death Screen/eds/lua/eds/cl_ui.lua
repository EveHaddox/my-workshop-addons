// Script made by Eve Haddox
// discord evehaddox

local check1, check2 = false, false

local avc = false

local autorespawntoggle = false
local autorespawncl = eds.color.disabled

surface.CreateFont( "EvesDethscreenFont", {
	font = "Inter",
	extended = false,
	size = 62,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "EvesDethscreenSecondFont", {
	font = "Inter",
	extended = false,
	size = 32,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "EvesDethscreenSmallFont", {
	font = "Inter",
	extended = false,
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local function notifclose()

    if IsValid(cooldowndotifp) then
        
        cooldowndotifp:Close()
        check2 = false

    end
    
end

local thecountdown = eds.delay

local function cooldownNotify()

    if check2 == true then return end

    check2 = true

    local w, h = 180, 60

    cooldowndotifp = vgui.Create("DFrame", nil)
    cooldowndotifp:SetPos((ScrW() - w) / 2, (ScrH() - h) / 2)
    cooldowndotifp:SetSize(w, h)
    cooldowndotifp:SetTitle("")
    cooldowndotifp:SetDraggable(false)
    cooldowndotifp:SetDraggable(false)
    cooldowndotifp:ShowCloseButton(false)

    function cooldowndotifp:Paint()

        draw.RoundedBox(5, 0, 0, w, h, eds.color.main)
        draw.SimpleText("Wait ".. thecountdown .." sec", "EvesDethscreenSecondFont", w / 2, h / 2, eds.color.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end
    
end

local function paintDethscreenHud(ply, attacker, weapon)

    if ply != LocalPlayer() then return end

    local plysave = ply

    thecountdown = eds.delay

    local w, h = 400, 80
    local cl1, cl2 = eds.color.main, eds.color.secondary
    local out = 5

    local frame = vgui.Create("DFrame", nil)
    frame:SetPos(0, 0)
    frame:SetSize(ScrW(), ScrH())
    frame:SetTitle("")
    frame:SetDraggable(false)
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:MakePopup()

    function frame:Paint()

    end

    timer.Simple(eds.delay, function() 
        
        check1 = false 
    
        if autorespawntoggle == true then

            frame:Close()
            
            net.Start("DethscreenRevive")
            net.WriteString(plysave:Nick())
            net.SendToServer()

        end
    
    end)

    timer.Create("respawnTimerCountdown", 1, eds.delay, function()

        if thecountdown <= 0 then
            thecountdown = eds.delay
        end

        thecountdown = thecountdown - 1
        
    end)

    local upw, uph = ScrW(), ScrH() / 9

    local dw, dh =  upw / 7, uph / 2.2

    local upanel = vgui.Create("DPanel", frame)
    upanel:SetPos(0, 0)
    upanel:SetSize(upw, uph)

    local weapontxt = weapon

    if weapon == nil then
        weapontxt = eds.noweapon
    end

    local infotxt = eds.title.default

    if ply == attacker then
        infotxt = eds.title.suicide
    end

    local attackertxt = attacker
    
    if eds.nokiller == "player" then
        attackertxt = ply:Nick()
    end

    if attacker != eds.nokiller then
        attackertxt = attacker:Nick()
    elseif attacker == eds.nokiller then
        infotxt = eds.title.suicide
        weapontxt = eds.falldamage
    end
    
    function upanel:Paint()
        
        draw.RoundedBox(0, 0, 0, upw, uph, cl1)
        draw.SimpleText(infotxt, "EvesDethscreenFont", 80, uph / 2, eds.color.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        draw.RoundedBox(0, ScrW() / 2 - (dw + 15), (uph - dh) / 2, dw, dh, eds.color.accent)
        draw.SimpleText(attackertxt, "EvesDethscreenSecondFont", ScrW() / 2 - 15 - dw + dh * 1.1, uph / 2, eds.color.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(eds.name.killer, "EvesDethscreenSmallFont", ScrW() / 2 - (dw + 13), (uph - dh * 1.4) / 2, eds.color.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        draw.RoundedBox(0, ScrW() / 2 + 15, (uph - dh) / 2, dw, dh, eds.color.accent)
        draw.SimpleText(weapontxt, "EvesDethscreenSecondFont", ScrW() / 2 + 15 + dw / 2, uph / 2, eds.color.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(eds.name.weapon, "EvesDethscreenSmallFont", ScrW() / 2 + 17, (uph - dh * 1.4) / 2, eds.color.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    end

    if avc == false then

        local antierror = attacker

        if attacker == eds.nokiller then
            antierror = ply
        end
            
        local killerAvatar = vgui.Create("AvatarImage", upanel)
        killerAvatar:SetPos( ScrW() / 2 - (dw + 15), (uph - dh) / 2)
        killerAvatar:SetSize(dh, dh)
        killerAvatar:SetPlayer(antierror, 86)
        
        avc = true 

    end

    local dpw, dph = ScrW(), ScrH() / 10

    local dpanel = vgui.Create("DPanel", frame)
    dpanel:SetPos(0, ScrH() - dph)
    dpanel:SetSize(dpw, dph)
    
    function dpanel:Paint()
        
        draw.RoundedBox(0, 0, 0, dpw, dph, cl1)

    end

    local rbw, rbh = 180, 60

    local respawnb = vgui.Create("DButton", dpanel)
    respawnb:SetPos(ScrW() - 10 -rbw, (dph - rbh) / 2)
    respawnb:SetSize(rbw, rbh)
    respawnb:SetText("")

    function respawnb:Paint()

        draw.RoundedBox(20, 0, 0, rbw, rbh, Color(44,140,76))
        draw.SimpleText("Respawn", "EvesDethscreenSecondFont", rbw / 2, rbh / 2, eds.color.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end

    function respawnb:DoClick()

        if check1 == false then
            
            frame:Close()

            thecountdown = eds.delay

            net.Start("DethscreenRevive")
            net.WriteString(plysave:Nick())
            net.SendToServer()

        else

            cooldownNotify()
            timer.Simple(eds.notiftime, function() notifclose() end)

        end

    end

    local arbw, arbh = 220, 60

    local autorespawnb = vgui.Create("DButton", dpanel)
    autorespawnb:SetPos(ScrW() - 20 - arbw - rbw, (dph - arbh) / 2)
    autorespawnb:SetSize(arbw, arbh)
    autorespawnb:SetText("")

    function autorespawnb:Paint()

        draw.RoundedBox(20, 0, 0, arbw, arbh, autorespawncl)
        draw.SimpleText("Auto Respawn", "EvesDethscreenSecondFont", arbw / 2, arbh / 2, eds.color.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end

    function autorespawnb:DoClick()

        if autorespawntoggle == false then
            autorespawntoggle = true
            autorespawncl = eds.color.enabled
        else
            autorespawntoggle = false
            autorespawncl = eds.color.disabled
        end

    end
    
end

net.Receive( "DethscreenHud", function(len, ply)

    local playerstring = net.ReadString()

    local pl = nil
    local killer = nil

    local decode = net.ReadTable(false)

    local attacker = decode[1]
    local weapon = decode[2]

    for k,v in ipairs(player.GetAll()) do
        if tostring(v:SteamID64()) == playerstring then
            pl = v
        end
        if v:SteamID64() == attacker then
            killer = v
        end
    end

    if killer == nil then
        killer = eds.nokiller
    end

    check1, avc = true, false

    if pl == LocalPlayer() then
        
        paintDethscreenHud(pl, killer, weapon)

    end

end)