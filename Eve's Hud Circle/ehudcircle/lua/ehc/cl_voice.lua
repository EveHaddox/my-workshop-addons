// Addon made by Eve Haddox
// my discord "evehaddox"


local VoiceIsActived = false
local Icon = Material("materials/eve/speak.png")

function draw.RotatedBox( x, y, w, h )

	local Rotating = math.sin(CurTime() * 3)
	local flip = 0

    if Rotating < 0 then
        Rotating = 1 - (1 + Rotating)
		flip = 180
    end
		
	surface.SetMaterial(Icon)
	surface.SetDrawColor(Color(255,255,255))
	surface.DrawTexturedRectRotated( x, y, Rotating * 64, 64, flip )

end

////////////// drawing hud //////////////

hook.Add( "HUDPaint", "VoiceHUD", function()
	if VoiceIsActived then
		draw.RotatedBox( ScrW()-55, ScrH()/2-32, 64, 64)
    end
end )

////////////// hooks //////////////

hook.Add("PlayerStartVoice", "VoiceHUD_EnableVoice", function(ply)
	if ply == LocalPlayer() then
		VoiceIsActived = true
    end
end)

hook.Add("PlayerEndVoice", "VoiceHUD_DisableVoice", function(ply)
	if ply == LocalPlayer() then
		VoiceIsActived = false
    end
end)

////////////// showing talking //////////////

timer.Remove("Evehv2LoadVoice")

local function LoadVoice()
	g_VoicePanelList:SetPos( ScrW() - 250 - 12, 0 )
	g_VoicePanelList:SetSize( 250, ScrH() - 300 )

	VoiceNotify.Init = function( self )
		self.Avatar = vgui.Create( "AvatarImage", self )
		self.Avatar:Dock( LEFT )
		self.Avatar:SetSize( 34, 34 )

		self.LabelName = vgui.Create( "DLabel", self )
		self.LabelName:SetFont( "ehc.28" )
		self.LabelName:Dock( LEFT )
		self.LabelName:DockMargin( 10, -2, 0, 0 )
		self.LabelName:SetTextColor( ehc.colors.txt )
		self.LabelName:SetWide((250 - 54))

		self:SetSize( 250, 46 )
		self:DockPadding( 6, 6, 6, 6 )
		self:DockMargin( 0, 0, 0, 6 )
		self:Dock( BOTTOM )
	end

	VoiceNotify.Paint = function( self, w, h )
		if !IsValid(self.ply) then return end

		draw.RoundedBox( 5, 0, 0, w, h, ehc.colors.sec)
		draw.RoundedBox( 5, 0, 0, w, h, Color(140, 140, 140, 255 * self.ply:VoiceVolume()))
		draw.RoundedBox( 5, 4, 4, h - 8, h - 8, ehc.colors.out)
	end

	hook.Remove("StartChat", "DarkRP_StartFindChatReceivers")
	hook.Remove("PlayerStartVoice", "DarkRP_VoiceChatReceiverFinder")
end

if !IsValid(g_VoicePanelList) then
	timer.Create("Evehv2LoadVoice", 1, 60, function()
		if IsValid(g_VoicePanelList) then
			LoadVoice()
			timer.Remove("Evehv2LoadVoice")
		end
	end)
else
	LoadVoice()
end