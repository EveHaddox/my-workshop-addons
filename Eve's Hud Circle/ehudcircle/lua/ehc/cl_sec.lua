// Addon made by Eve Haddox
// my discord "evehaddox"

///////////////////// laws /////////////////////

function DrawLaws()

    local count = 1

    local laws = ""
    local space = "\n"

    local split = string.Explode("\n", #DarkRP.getLaws())
    for k, v in pairs(split) do
        count = k
	end

    for i = 1, #DarkRP.getLaws() do
        count = i
    end

    local lw, lh = 430, 46
    local hs = lh + 18 * count
	local x, y = ehc.spacing, ehc.spacing

    draw.RoundedBox(20, x, y, lw, hs, ehc.colors.out)
    draw.RoundedBox(20, x + 2, y + 2, lw - 4, hs - 4, ehc.colors.sec)
    draw.RoundedBoxEx(20, x + 2, y + 2, lw - 4, 33, ehc.colors.main, true, true, false, false)

    draw.RoundedBox(0, x + 2, y + 33, lw - 4, 2, ehc.colors.ac)

    draw.SimpleText("Laws", "ehc.28", ehc.spacing + 12, ehc.spacing + 30, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

    for i = 1, #DarkRP.getLaws() do
        laws = i .. ". " .. DarkRP.getLaws()[i]
        draw.SimpleText(laws, "ehc.22", ehc.spacing + 8, ehc.spacing + 34 + 18 * (i - 1), ehc.colors.txt)
    end

    if ehc.lawbord then
        lawh = hs + ehc.spacing
    end
    
end

///////////////////// agenda /////////////////////

function DrawAgenda()
	local tbl = LocalPlayer():getAgendaTable()
	if(!tbl) then return end

	local agenda = LocalPlayer():getDarkRPVar("agenda")
	if(!agenda || agenda == "") then return end

    local count = 1

    local split = string.Explode("\n", agenda)
    for k, v in pairs(split) do
        count = k
	end

	local agw, agh = 430, 46
    local hs = agh + 18 * (count - 1)
	local x, y = ehc.spacing, ehc.spacing + lawh

    draw.RoundedBox(20, x, y, agw, hs, ehc.colors.out)
    draw.RoundedBox(20, x + 2, y + 2, agw - 4, hs - 4, ehc.colors.sec)
    draw.RoundedBoxEx(20, x + 2, y + 2, agw - 4, 33, ehc.colors.main, true, true, false, false)

    draw.RoundedBox(0, x + 2, y + 33, agw - 4, 2, ehc.colors.ac)

	draw.SimpleText(tbl.Title, "ehc.28", x + 8, y + 33, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	local split = string.Explode("\n", agenda)
	for k, v in pairs(split) do
		draw.SimpleText(v, "ehc.22", x + 8, y + 14 + 18 * (k - 1), ehc.colors.txt)
	end

end

///////////////////// vote menu /////////////////////

usermessage.Hook("DoVote", function(  )	end)

local voteQueue = {}
local curVote
local ply = LocalPlayer()

local function startVote( id, question, time, isVote )
	local queue

	local QueuePanel = vgui.Create("DPanel")
	QueuePanel:SetSize(290, 180)
	QueuePanel:SetPos(ehc.spacing, ScrH() / 2 - (180) / 2 - 180)
	QueuePanel.Paint = function (self, w, h)

		draw.RoundedBox(20, 0, 0, w, h, ehc.colors.out)
        draw.RoundedBox(20, 2, 2, w - 4, h - 4, ehc.colors.sec)
        draw.RoundedBoxEx(20, 2, 2, w - 4, 33, ehc.colors.main, true, true, false, false)

        draw.RoundedBox(0, 2, 33, w - 4, 2, ehc.colors.ac)

        draw.SimpleText("Vote", "ehc.28", 8, 32, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

		local QueueText = "There are " .. #voteQueue .. " votes in queue"
		surface.SetFont("ehc.22")
		local textw, texth = select(1, surface.GetTextSize( QueueText ))

        if queue == true  then
            draw.SimpleText(QueueText, "ehc.22",  w / 2 - textw / 2, h - (80 / 2 - texth / 2), color_white)
        end
	end
	QueuePanel.Think = function (self, w, h)
		if #voteQueue > 0 and !queue then
			self:SetSize(290, 220)
			queue = true
		end
	end

	local Window = vgui.Create("DPanel", QueuePanel)
	Window:SetSize(290, 180)
	Window:SetPos(0, 0)
	Window.Paint = function (self, w, h)
	end

	local VoteText = vgui.Create("DLabel", Window)
	VoteText:SetFont("ehc.22") // small font
	VoteText:SetText(string.Replace( DarkRP.deLocalise(question), "\n", " " ))
	VoteText:SetPos(10, 47)
	VoteText:SetWide(280)
	VoteText:SetAutoStretchVertical( true )
	VoteText:SetWrap(true)

    local cl_hover, textcl = ehc.colors.out, ehc.colors.txt
    local txtclv = textcl

	for i = 1, 2 do
		local Button = vgui.Create("DButton", Window)
		Button:SetSize(120, 30)
		Button:SetPos(i == 1 and 12 or (290 - 120 - 12), Window:GetTall() - 12 - 30)
		Button:SetFont("ehc.22")
		Button.DoClick = function()
			QueuePanel:Remove()

			if i == 1 then
				ply:ConCommand("vote " .. id .. " yea\n")
			else
				ply:ConCommand("vote " .. id .. " nay\n")
			end

		//	Main:Remove()
		end

        local btxt = "Yes"

        if i == 1 then
            btxt = "Yes"
        elseif i == 2 then
            btxt = "No"
        end

        Button.Paint = function( s, w, h )

            if Button:IsHovered() then
                if btxt == "Yes" then
                    cl_hover = ehc.colors.pos
                elseif btxt == "No" then
                    cl_hover = ehc.colors.neg
                end
                draw.RoundedBox(20, 0, 0, w, h, ehc.colors.out)
                draw.RoundedBox(20, 2, 2, w - 4, h - 4, ehc.colors.sec)
                txtclv = cl_hover
            else
                draw.RoundedBox(20, 0, 0, w, h, ehc.colors.out)
                draw.RoundedBox(20, 2, 2, w - 4, h - 4, ehc.colors.main)
                txtclv = textcl
            end

            draw.SimpleText(btxt, Button:GetFont(), w / 2, h / 2 - 2, txtclv, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            Button:SetTextColor(ehc.colors.tr)

        end

	end

	local voteStarted = CurTime()

	local TimerText = vgui.Create("DLabel", Window)
	TimerText:SetFont("ehc.22")
	TimerText:SizeToContents()
	TimerText:SetPos(Window:GetWide() / 2 - TimerText:GetWide() / 2, Window:GetTall() - 66 - 5)
	TimerText.Think = function()
		if !time then return end

		local calcTime = math.max(math.floor(time - (CurTime() - voteStarted)), 0)

		if TimerText:GetValue() != tostring(calcTime) then
			TimerText:SetText("Vote expires in " .. calcTime .. " seconds")
			TimerText:SizeToContents()
			TimerText:SetPos(Window:GetWide() / 2 - TimerText:GetWide() / 2, Window:GetTall() - 66 - 5)
		end
	end

	curVote = QueuePanel

	if time < 0 then QueuePanel:Remove() return end

	timer.Simple(time, function()
		if IsValid(QueuePanel) then
			QueuePanel:Remove()
		end
	end)

	QueuePanel.OnRemove = function()
		curVote = nil

		if #voteQueue == 0 then return end

		local newVote = voteQueue[1]
		startVote(newVote.id, newVote.question, newVote.ending - CurTime(),newVote.isVote)

		voteQueue[1] = nil
		voteQueue = table.ClearKeys(voteQueue)

		queue = nil
	end
end

net.Receive("Evehv2Vote",function()

	local id = net.ReadUInt(10)
	local question = net.ReadString()
	local time = net.ReadUInt(8)

	surface.PlaySound("plats/elevbell1.wav")

	if IsValid(curVote) then
		table.insert(voteQueue, {id = id, question = question, ending = CurTime() + time, isVote = true})
	else
		startVote(id, question, time, true)
	end
end)

///////////////////// gestures /////////////////////

concommand.Add("_darkrp_animationmenu", function(  )
	if open then return end

	gesturePanels = {}

    local animations = {
		[ACT_GMOD_GESTURE_BOW] = "Bow",
		[ACT_GMOD_TAUNT_MUSCLE] = "Sexy Dance",
		[ACT_GMOD_GESTURE_BECON] = "Follow Me",
		[ACT_GMOD_TAUNT_LAUGH] = "Laugth",
		[ACT_GMOD_TAUNT_PERSISTENCE] = "Lion Pose",
		[ACT_GMOD_GESTURE_DISAGREE] = "No",
		[ACT_GMOD_GESTURE_AGREE] = "Thumbs Up",
		[ACT_GMOD_GESTURE_WAVE] = "Wave",
		[ACT_GMOD_TAUNT_DANCE] = "Dance",
	}

	local gestureFrame = vgui.Create("DPanel")

	for k, v in pairs(animations) do
		local gestureButton = vgui.Create("DButton", gestureFrame)
		gestureButton:SetText(v)

		gestureButton.DoClick = function(  )
			RunConsoleCommand("_DarkRP_DoAnimation", k)
			gestureFrame:Remove()
		end

		table.insert(gesturePanels, gestureButton)
	end

	gestureFrame:SetSize(450, 49 + 44 * math.ceil(#gesturePanels / 2))
	gestureFrame:Center()
	gestureFrame:MakePopup()
	gestureFrame.Paint = function(self, w, h)
		draw.RoundedBox(20, 0, 0, w, h, ehc.colors.out)
        draw.RoundedBox(20, 2, 2, w - 4, h - 4, ehc.colors.sec)
        draw.RoundedBoxEx(20, 2, 2, w - 4, 33, ehc.colors.main, true, true, false, false)

        draw.RoundedBox(0, 2, 33, w - 4, 2, ehc.colors.ac)

        draw.SimpleText("Gestures", "ehc.28", 12, 30, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	end

	local PosData = {}
	local x = 10

	for i = 1, #gesturePanels do
		if (i % 2 == 0) then x = 230 else x = 10 end
		table.insert( PosData, { x = x, y = 44 * math.ceil(i / 2) + 6} )
	end

    local cl_hover, textcl = ehc.colors.out, ehc.colors.txt
    local txtclv = textcl

	for k,v in ipairs(gesturePanels) do
		if PosData[k] then
			v:SetSize(210, 34)
			v:SetPos(PosData[k].x, PosData[k].y - 5)
			v:SetFont("ehc.22")

			v.Paint = function( s, w, h )

				if v:IsHovered() then
                    draw.RoundedBox(20, 0, 0, w, h, ehc.colors.out)
                    draw.RoundedBox(20, 1, 1, w - 2, h - 2, ehc.colors.sec)
					surface.SetDrawColor(cl_hover)
					txtclv = cl_hover
				else
                    draw.RoundedBox(20, 0, 0, w, h, ehc.colors.out)
                    draw.RoundedBox(20, 1, 1, w - 2, h - 2, ehc.colors.main)
					surface.SetDrawColor(textcl)
					txtclv = textcl
				end

                draw.SimpleText(v:GetText(), v:GetFont(), w / 2, h / 2 - 2, txtclv, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                v:SetTextColor(ehc.colors.tr)

			end
		end
	end

	local CloseBut = vgui.Create("DButton", gestureFrame)
	CloseBut:SetText( "" )
	CloseBut:SetSize(41, 41)
	CloseBut:SetPos(gestureFrame:GetWide() - 32, 2)
	CloseBut.DoClick = function()
		gestureFrame:Remove()
	end
	CloseBut.Paint = function( s, w, h )
		surface.SetMaterial(Material("materials/eve/close.png"))
		surface.SetDrawColor(ehc.colors.txt)
		surface.DrawTexturedRect(0, 4, 24, 24)
	end

	gestureFrame.OnRemove = function()
		open = false
	end

	open = true
end)

// drawing elements

hook.Add( "HUDPaint", "ehudCsec", function()

    ///////////// Agenda /////////////
            
    if agenda then
        DrawAgenda()
    end

    ///////////// Laws /////////////

    if (DarkRP.getLaws() and DarkRP.getLaws() != "") and ehc.lawbord then
        DrawLaws()
    end

end)

hook.Add("OnPlayerChat", "lawboardToggleEhudC", function(ply, txt)
	if txt == "!law" then
		if ehc.lawbord == false then
			ehc.lawbord = true
		else
			ehc.lawbord = false
		end
	end
end)