local name = ""

local scrw = ScrW()
local scrh = ScrH()

surface.CreateFont("esuit.hud", {
    font = "Arial",
    size = 28,
    weight = 500
})

local function drawHud()
    if not est.hud then return end
    hook.Add("HUDPaint", "esuits.hud", function()
        surface.SetFont("esuit.hud")
        local w = surface.GetTextSize(name) + 30
        draw.RoundedBox(8, (scrw - w) / 2, scrh - 10 - 40 - 40, w, 40, est.theme.bg)
        draw.SimpleText(name, "esuit.hud", scrw / 2, scrh - 10 - 40 / 2 - 40, est.theme.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end)
end

net.Receive("esuits.hud", function(len)
    name = net.ReadString()
    bool = net.ReadBool()
    if bool then
        drawHud()
    else
        hook.Remove("HUDPaint", "esuits.hud")
    end
end)

hook.Add("OnPlayerChat", "esuits", function(ply, txt, team, dead)
    if ply != LocalPlayer() or txt != "!dropsuit" then return end
    LocalPlayer():ConCommand("esuits_dropsuit")
end)