// Script made by Eve Haddox
// discord evehaddox

local evsplytext = ""

-- declaring values
local scrw, scrh = ScrW(), ScrH()

local mw, mh = 1000, 920
local sw, sh = 980, 40

-- fonts

surface.CreateFont( "evescbmain", {
	font = "Comfortaa",
	size = 38,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
    
} )

surface.CreateFont( "evescbtitle", {
	font = "Comfortaa",
	size = 82,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
    
} )

surface.CreateFont( "evescbsfont", {
	font = "Comfortaa",
	size = 26,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
    
} )

local function getOnlinePlayers()

    if not game.SinglePlayer() then
        local plynum = 0
        for key, value in ipairs(player.GetAll()) do
            plynum = plynum + 1
        end

        evsplytext = plynum .." / ".. game.MaxPlayers()
    else
        evsplytext = "Singleplayer"
    end
    
end

-- Next, create a function to draw the scoreboard
local function DrawScoreboard()

    evescbbg = vgui.Create("DFrame")
    evescbbg:SetPos(0, 0)
    evescbbg:SetSize(scrw, scrh)
    evescbbg:SetTitle("")
    evescbbg:SetDraggable( false )
    evescbbg:SetVisible( true )
    evescbbg:ShowCloseButton( false )
    evescbbg:MakePopup()

    function evescbbg:Paint()
        draw.RoundedBox(0 , 0, 0, scrw, scrh, Color(255,255,255,10))
        Derma_DrawBackgroundBlur( evescbbg )

        draw.SimpleText(escb.name, "evescbtitle", scrw / 2, scrh * 0.05, escb.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.RoundedBox(20, scrw / 2 - 490, scrh * 0.13, 980, 2, escb.colors.txt)

        draw.SimpleText("Name", "evescbmain", scrw * 0.29, scrh * 0.112, escb.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Job", "evescbmain", scrw * 0.3752, scrh * 0.112, escb.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Rank", "evescbmain", scrw * 0.462, scrh * 0.112, escb.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText("K", "evescbmain", scrw * 0.61, scrh * 0.112, escb.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("D", "evescbmain", scrw * 0.65, scrh * 0.112, escb.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Ping", "evescbmain", scrw * 0.725, scrh * 0.112, escb.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        getOnlinePlayers()
        draw.SimpleText(evsplytext, "evescbmain", scrw - 10, 20, escb.colors.txt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

    end

    local mp = vgui.Create("DPanel", evescbbg)
    mp:SetPos((scrw - mw) / 2, scrh / 2 - (mh * 0.422))
    mp:SetSize(mw, mh)

    function mp:Paint()
    end

    local spanel = vgui.Create("DScrollPanel", mp)
    spanel:SetPos(0, 0)
    spanel:SetSize(mw, mh)

    for key, value in ipairs(player.GetAll()) do

        local ldbb = spanel:Add("DPanel", spanel)
        ldbb:SetSize(sw, sh)
        ldbb:SetPos(10, 45 * (key - 1))
        ldbb:SetBackgroundColor(escb.colors.main)

        function ldbb:Paint()

            draw.RoundedBox(3, 0, 0, sw, sh, escb.colors.main)

            draw.RoundedBox(0, 2, 2, 36, 36, escb.colors.secondary)

            draw.SimpleText(value:Nick(), "evescbsfont",  45, 19, escb.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(value:getDarkRPVar("job"), "evescbsfont",  250, 19, team.GetColor(value:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(value:GetUserGroup(), "evescbsfont",  420, 19, escb.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(value:Frags(), "evescbsfont",  700, 19, escb.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(value:Deaths(), "evescbsfont",  775, 19, escb.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(value:Ping(), "evescbsfont",  915, 19, escb.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        end

        local escbavatar = vgui.Create("AvatarImage", ldbb)
        escbavatar:SetPos(4, 4)
        escbavatar:SetSize(32, 32)
        escbavatar:SetPlayer(value, 64)

        local ki = vgui.Create("DImage", ldbb)
        ki:SetImage("materials/kills.png")
        ki:SetPos(665   , 2)
        ki:SetSize(36, 36)
        ki:GetBackgroundColor(escb.colors.transp)

        local di = vgui.Create("DImage", ldbb)
        di:SetImage("materials/deths.png")
        di:SetPos(742, 4)
        di:SetSize(30, 30)
        di:GetBackgroundColor(escb.colors.transp)

        local pi = vgui.Create("DImage", ldbb)
        pi:SetImage("materials/ping.png")
        pi:SetPos(875, 3)
        pi:SetSize(32, 32)
        pi:GetBackgroundColor(escb.colors.transp)

    end

end

hook.Add("ScoreboardShow", "create_scoreboard", function()
    DrawScoreboard()
    return true
end)

hook.Add("ScoreboardHide", "hide_scoreboard", function()
    if IsValid(evescbbg) then evescbbg:Remove() end
    return true
end)

-- Fix for removing default Scoreboard B-)
local function repairScoreboard()
    hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
    hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
    timer.Simple(3,function()
        hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
        hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
    end)
end

repairScoreboard()

hook.Add("OnGamemodeLoaded", "override_FAdmin_scoreboard", repairScoreboard)
hook.Add("DarkRPFinishedLoading", "override_FAdmin_scoreboard", repairScoreboard)