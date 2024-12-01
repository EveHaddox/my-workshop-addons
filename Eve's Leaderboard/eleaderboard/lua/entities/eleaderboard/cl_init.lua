// Addon made by Eve Haddox
// my discord "evehaddox"

include("shared.lua")

surface.CreateFont("Billboard Font", {
	font = "Verdana",
	size = 35
})

surface.CreateFont("Billboard Title Font", {
	font = "Roboto",
	size = 65
})

local MoneyLeaderboard = {}

net.Receive("SendELeaderboard", function()
	MoneyLeaderboard = net.ReadTable()
end)

function ENT:Draw()
	self:DrawModel()

	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetAngles():Up(), 90)

	cam.Start3D2D(self:GetPos() + self:GetAngles():Right() * 47 + self:GetAngles():Up() * 5 - self:GetAngles():Forward() * 46, ang, 0.1)

		surface.SetDrawColor(Color(85,88,99,255))
		surface.DrawRect(90, 155, 770, 635)

        surface.SetDrawColor(48, 50, 59)
	    surface.DrawRect(95, 160, 760, 90)

        surface.SetDrawColor(42, 44, 51)
	    surface.DrawRect(95, 250, 760, 535)

	    draw.SimpleText(GetHostName(), "Billboard Title Font", 465, 210, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        

        for k, v in pairs(MoneyLeaderboard) do
        	draw.SimpleText(tostring(k) .. ".", "Billboard Font", 110, 240 + k * 50, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        	draw.SimpleText(v.rpname, "Billboard Font", 145, 240 + k * 50, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        	draw.SimpleText("$" .. string.Comma(v.wallet), "Billboard Font", 500, 240 + k * 50, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

	    
	cam.End3D2D()
end

