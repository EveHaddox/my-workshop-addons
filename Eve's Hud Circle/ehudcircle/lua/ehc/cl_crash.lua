// Addon made by Eve Haddox
// my discord "evehaddox"

CRASH_AUTORECONNECT = 180

local CrashScreen = nil
local showingScreen = false
local fadeStart = 0
local isReconnecting = false
local timeSinceLastPacket = 0

local thinkDelay = 0
hook.Add("Think","check_connection", function()
    if thinkDelay > CurTime() then return end
    thinkDelay = CurTime()+1
    local isTimingOut, lastReceived = GetTimeoutInfo()
    timeSinceLastPacket = lastReceived
    if isTimingOut and not showingScreen then
        CrashShow()
    end
    if not isTimingOut and showingScreen then
        CrashHide()
    end
    if lastReceived > CRASH_AUTORECONNECT and not isReconnecting then
        isReconnecting = true
        RunConsoleCommand("retry")
    end
end)

local color_white = Color(255,255,255,255)
local color_black = Color(0,0,0,255)
local color_accent = Color(0, 195, 165)
local color_accent_dark = Color(0, 145, 115)
local color_button_dark = Color(20,20,20,200)
local color_button_light = Color(40,40,40,200)

function CrashShow()
    showingScreen = true
    fadeStart = CurTime()
    hook.Run("CrashShow")
    surface.PlaySound("vo/npc/male01/ohno.wav")
    if IsValid(CrashScreen) then
        CrashScreen:Remove()
    end
    CrashScreen = vgui.Create("DPanel")
    CrashScreen:SetSize(ScrW(),ScrH())
    CrashScreen:SetPos(0,0)
    CrashScreen:SetAlpha(0)
    CrashScreen:AlphaTo(255,2)
    function CrashScreen:Paint(w, h)

        surface.SetDrawColor(Color(0,0,0,200))
        surface.DrawRect(0,0,w,h)
        draw.SimpleTextOutlined("connection to the server has been lost","ehc.60",w/2,h/3.2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,color_black)
        if CRASH_AUTORECONNECT > 0 then
            draw.SimpleTextOutlined("You will automatically reconnect in "..math.floor(CRASH_AUTORECONNECT-timeSinceLastPacket).." seconds","ehc.60",w/2, h/2.8,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,color_black)
        end
    end

    local reconnectBtn = vgui.Create("DButton",CrashScreen)
    reconnectBtn:SetSize(140,55)
    reconnectBtn:SetPos(ScrW()/2-150,ScrH()/2 - 30)
    reconnectBtn:SetTextColor(color_white)
    reconnectBtn:SetFont("ehc.28")
    reconnectBtn:SetText("Reconnect")
    reconnectBtn.Paint = paintFunction
    reconnectBtn.DoClick = function()
        RunConsoleCommand("retry")
    end
    function reconnectBtn:Paint(w,h)
        draw.RoundedBox(20, 0, 0, w, h, ehc.colors.out)
        draw.RoundedBox(20, 1, 1, w - 2, h - 2, self:IsHovered() and ehc.colors.main or ehc.colors.sec)
    end

    local leaveBtn = vgui.Create("DButton",CrashScreen)
    leaveBtn:SetSize(140,55)
    leaveBtn:SetPos(ScrW()/2+50,ScrH()/2 - 30)
    leaveBtn:SetTextColor(color_white)
    leaveBtn:SetFont("ehc.28")
    leaveBtn:SetText("Disconnect")
    leaveBtn.Paint = paintFunction
    leaveBtn.DoClick = function(  )
        RunConsoleCommand("disconnect")
    end
    function leaveBtn:Paint(w,h)
        draw.RoundedBox(20, 0, 0, w, h, ehc.colors.out)
        draw.RoundedBox(20, 1, 1, w - 2, h - 2, self:IsHovered() and ehc.colors.main or ehc.colors.sec)
    end
    
    gui.EnableScreenClicker(true)
end

function CrashHide()
    showingScreen = false
    hook.Run("CrashHide")
    CrashScreen:AlphaTo(0,0.5)
    timer.Simple(0.5,function()
        --if IsValid(CrashScreen) then CrashScreen:Remove() end
    end)
    surface.PlaySound("vo/npc/male01/yeah02.wav")
    gui.EnableScreenClicker(false)
end