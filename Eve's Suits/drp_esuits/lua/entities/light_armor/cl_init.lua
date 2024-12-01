include("shared.lua")

surface.CreateFont("esuit.item", {
    font = "Arial",
    size = 50,
    weight = 500
})

local dist = 350 ^ 2
function ENT:Draw()
    self:DrawModel()
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < dist then
        local ang = self:GetAngles()
        ang:RotateAroundAxis(self:GetAngles():Right(), 90)
        ang:RotateAroundAxis(self:GetAngles():Forward(), 90)
        local z = math.sin(CurTime() * 2) * 10
        cam.Start3D2D(self:GetPos() + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
        surface.SetFont("esuit.item")
        local text = self.PrintName
        local tw, th = surface.GetTextSize(text) + 20
        draw.RoundedBox(6, -tw / 2, -200 - z, tw, 60, einv.theme.primary)
        draw.SimpleText(text, "esuit.item", 0, -200 + 30 - z, einv.theme.text.h1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end