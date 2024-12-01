// Script made by Eve Haddox
// discord evehaddox

local scrw, scrh = ScrW(), ScrH()

//local mw, mh = 1775, 1000
//local sw, sh = 1755, 890
//local tw, th = 1755, 80

local mw, mh = scrw * 0.9, scrh * 0.9
local sw, sh = scrw * 0.89, scrh * 0.8
local tw, th = scrw * 0.89, scrh * 0.072

local bw, bh = scrw * 0.069, scrh * 0.055

local posf = scrh * 0.055

local spacing = scrw * 0.0052
local bspacing = spacing * 6

local iconw = scrw * 0.02

local evemotdurl = emotd.default

surface.CreateFont( "evemotd", {
	font = "Comfortaa",
	size = 42,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
    
} )

function evemotd()

    local bg = vgui.Create("DFrame")
    bg:SetPos(0, 0)
    bg:SetSize(scrw, scrh)
    bg:SetTitle("")
    bg:SetDraggable(false)
    bg:SetDraggable(false)
    bg:ShowCloseButton(false)

    function bg:Paint(w, h)

        Derma_DrawBackgroundBlur(bg)
        
    end

    -- the main frame

    local mf = vgui.Create("DFrame", mf)
    mf:SetPos((scrw - mw) / 2, (scrh - mh) / 2)
    mf:SetSize(mw, mh)
    mf:MakePopup()
    mf:SetTitle("")
    mf:SetDraggable(false)
    mf:SetDraggable(false)
    mf:ShowCloseButton(false)

    function mf:Paint(w, h)

        draw.RoundedBox(20, 0, 0, mw, mh, emotd.colors.outline)
        draw.RoundedBox(20, 2, 2, mw - 4, mh - 4, emotd.colors.main)
        
    end

    -- upper panel

    local up = vgui.Create("DPanel", mf)
    up:SetSize(tw, th)
    up:SetPos(spacing, spacing)

    function up:Paint(w, h)

        draw.RoundedBox(20, 0, 0, tw, th, emotd.colors.outline)
        draw.RoundedBox(20, 2, 2, tw - 5, th - 5, emotd.colors.secondary)

    end

    -- lower panel

    local mp = vgui.Create("DPanel", mf)
    mp:SetSize(sw, sh)
    mp:SetPos(spacing, spacing * 2 + th)

    function mp:Paint(w, h)

        draw.RoundedBox(20, 0, 0, sw, sh, emotd.colors.outline)
        draw.RoundedBox(20, 2, 2, sw - 4, sh - 4, emotd.colors.secondary)

    end

    -- the website capture

    local wb = vgui.Create("DHTML", mp)
    wb:Dock(FILL)
    wb:OpenURL(evemotdurl)

    -- tab buttons

    -- dashboard

    local db = vgui.Create("DButton", up)
    db:SetPos(spacing, spacing)
    db:SetSize(220, bh)
    db:SetText("")

    function db:Paint(w, h)

        if self:IsHovered() then
            draw.RoundedBox(20, 0, 0, w, h, emotd.colors.main)
        end
        draw.SimpleText("Dashboard", "evemotd", spacing  * 2 + iconw, bh / 2 - 5 , emotd.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    end

    function db:DoClick()

        wb:OpenURL(emotd.pages["Dashboard"])
        
    end

    local di = vgui.Create("DImage", db)
    di:SetImage("materials/dashboard.png")
    di:SetPos(spacing, spacing)
    di:SetSize(36, 36)
    di:GetBackgroundColor(emotd.colors.transp)

    -- rules

    local rb = vgui.Create("DButton", up)
    rb:SetPos(spacing + bw + bspacing - 20 + posf, spacing)
    rb:SetSize(bw + 8, bh)
    rb:SetText("")

    function rb:Paint(w, h)

        if self:IsHovered() then
            draw.RoundedBox(20, 0, 0, w, h, emotd.colors.main)
        end
        draw.SimpleText("Rules", "evemotd", spacing  * 2 + iconw - 5, bh / 2 - 5, emotd.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    end

    function rb:DoClick()

        wb:OpenURL(emotd.pages["Rules"])
        
    end

    local ri = vgui.Create("DImage", rb)
    ri:SetImage("materials/rules.png")
    ri:SetPos(spacing, spacing)
    ri:SetSize(36, 36)
    ri:GetBackgroundColor(emotd.colors.transp)

    -- forum

    local fb = vgui.Create("DButton", up)
    fb:SetPos(spacing + (bw + bspacing) * 2 + posf - 45, spacing)
    fb:SetSize(bw + 23, bh)
    fb:SetText("")

    function fb:Paint(w, h)

        if self:IsHovered() then
            draw.RoundedBox(20, 0, 0, w, h, emotd.colors.main)
        end
        draw.SimpleText("Forum", "evemotd", spacing  * 2 + iconw, bh / 2 - 5, emotd.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    end

    function fb:DoClick()

        wb:OpenURL(emotd.pages["Forum"])
        
    end

    local fi = vgui.Create("DImage", fb)
    fi:SetImage("materials/forum.png")
    fi:SetPos(spacing, spacing)
    fi:SetSize(36, 36)
    fi:GetBackgroundColor(emotd.colors.transp)

    -- donate

    local dnb = vgui.Create("DButton", up)
    dnb:SetPos(spacing + (bw + bspacing) * 3 + posf - 50, spacing)
    dnb:SetSize(bw + 33, bh)
    dnb:SetText("")

    function dnb:Paint(w, h)

        if self:IsHovered() then
            draw.RoundedBox(20, 0, 0, w, h, emotd.colors.main)
        end
        draw.SimpleText("Donate", "evemotd", spacing  * 2 + iconw, bh / 2 - 5, emotd.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    end

    function dnb:DoClick()

        wb:OpenURL(emotd.pages["Donate"])
        
    end

    local dni = vgui.Create("DImage", dnb)
    dni:SetImage("materials/donate.png")
    dni:SetPos(spacing, spacing)
    dni:SetSize(36, 36)
    dni:GetBackgroundColor(emotd.colors.transp)

    -- discord
    
    local dcb = vgui.Create("DButton", up)
    dcb:SetPos(spacing + (bw + bspacing) * 4 + posf - 45, spacing)
    dcb:SetSize(bw + 40, bh)
    dcb:SetText("")

    function dcb:Paint(w, h)

        if self:IsHovered() then
            draw.RoundedBox(20, 0, 0, w, h, emotd.colors.main)
        end
        draw.SimpleText("Discord", "evemotd", spacing  * 2 + iconw, bh / 2 - 5, emotd.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    end

    function dcb:DoClick()

        gui.OpenURL(emotd.pages["Discord"])
        
    end

    local dci = vgui.Create("DImage", dcb)
    dci:SetImage("materials/discord.png")
    dci:SetPos(spacing, spacing)
    dci:SetSize(36, 36)
    dci:GetBackgroundColor(emotd.colors.transp)

    -- steam

    local sb = vgui.Create("DButton", up)
    sb:SetPos(spacing + (bw + bspacing) * 5 + posf - 35, spacing)
    sb:SetSize(bw + 23, bh)
    sb:SetText("")

    function sb:Paint(w, h)

        if self:IsHovered() then
            draw.RoundedBox(20, 0, 0, w, h, emotd.colors.main)
        end
        draw.SimpleText("Steam", "evemotd", spacing  * 2 + iconw, bh / 2 - 5, emotd.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    end

    function sb:DoClick()

        wb:OpenURL(emotd.pages["Steam"])
        
    end

    local si = vgui.Create("DImage", sb)
    si:SetImage("materials/steam.png")
    si:SetPos(spacing, spacing)
    si:SetSize(36, 36)
    si:GetBackgroundColor(emotd.colors.transp)

    -- close button

    local cb = vgui.Create("DButton", up)
    cb:SetPos(tw - spacing - bw - 5, spacing)
    cb:SetSize(bw + 5, bh)
    cb:SetText("")

    function cb:Paint(w, h)

        if self:IsHovered() then
            draw.RoundedBox(20, 0, 0, w, h, emotd.colors.main)
        end
        draw.SimpleText("Close", "evemotd", spacing  * 2 + iconw - 5, bh / 2 - 5, emotd.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    end

    function cb:DoClick()

        mf:Close()
        bg:Close()
        
    end

    local ci = vgui.Create("DImage", cb)
    ci:SetImage("materials/close.png")
    ci:SetPos(spacing, spacing)
    ci:SetSize(36, 36)
    ci:GetBackgroundColor(emotd.colors.transp)

    concommand.Add("eve_motd_close", function(ply, cmd, args)
        mf:Close()
        bg:Close()
    end)
    
end

hook.Add("OnPlayerChat", "evemotd", function(player, text)

    if player != LocalPlayer() then return end

    if text == "!motd" then
        evemotd()
    end

end)

hook.Add("InitPostEntity", "evemotd", function()
    evemotd()
end)