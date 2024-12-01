
local evefrtxt = Color(235, 235, 235)
local evefrbg2 = Color(42, 44, 51)
local evefrout = Color(85,88,99)

surface.CreateFont( "evsafezoneF", {
	font = "Comfortaa",
	size = 36,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
    
} )

local tr = 0

net.Receive("safezone",function()
    local toggle = net.ReadBool()
    if toggle then
        local w = ScrW()
        local h = ScrH()
        hook.Add("HUDPaintBackground", "safezone_display", function()
            local bw, bh = 140, 40
            draw.RoundedBox(20, (w - bw) / 2, h - bh - 10, bw, bh, evefrout)
            draw.RoundedBox(20, (w - bw) / 2 + 2, h - bh + 2 - 10, bw - 4, bh - 4, evefrbg2)
            draw.SimpleText(SAFEZONE_TEXT, "evsafezoneF", w / 2, h - bh / 2 - 13, evefrtxt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end)
    else
        hook.Remove("HUDPaintBackground", "safezone_display")
    end
end)

print("[safezones] cl loaded")
