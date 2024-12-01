// Script made by Eve Haddox
// discord evehaddox

// making fonts

equam2.CreateFont("main", 26)

// functions

plyr = FindMetaTable("Player")

function plyr.drawOutlinedBox(out, x, y, w, h, cl, clout)

    draw.RoundedBox(15, x, y, w, h, clout)
    draw.RoundedBox(15, x + out, y + out, w - out * 2, h - out * 2, cl)
    
end

function plyr.drawTitleBox(out, lineh, x, y, w, h, cl, clout, clac, cltxt, txt)

    LocalPlayer().drawOutlinedBox(out, x, y, w, h, cl, clout)
    draw.RoundedBoxEx(15, x + out, y + out, w - out * 2, 36 - out * 2, eve.colors.bg1, true, true, false, false)

    draw.RoundedBox(0, x + out, y + 32, w - out * 2, lineh, eve.colors.ac)

    draw.SimpleText(txt, "equam2.main", x + 10, y + 16, cltxt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

end

function plyr.drawButton(out, x, y, w, h, txt, cl, clout, cltxt)
    
    LocalPlayer().drawOutlinedBox(out, x, y, w, h, cl, clout)
    draw.SimpleText(txt, "equam2.main", x + w / 2, y + h / 2 - 2, cltxt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function draw.drawCircle(x, y, r, step, cache)
    local positions = {}


    for i = 0, 360, step do
        table.insert(positions, {
            x = x + math.cos(math.rad(i)) * r,
            y = y + math.sin(math.rad(i)) * r
        })
    end


    return (cache and positions) or surface.DrawPoly(positions)
end

function draw.drawArc(x, y, r, startAng, endAng, step ,cache)
    local positions = {}


    positions[1] = {
        x = x,
        y = y
    }


    for i = startAng - 90, endAng - 90, step do
        table.insert(positions, {
            x = x + math.cos(math.rad(i)) * r,
            y = y + math.sin(math.rad(i)) * r
        })
    end


    return (cache and positions) or surface.DrawPoly(positions)
end

function draw.drawSubSection(x, y, r, r2, startAng, endAng, step, cache)
    local positions = {}
    local inner = {}
    local outer = {}


    r2 = r+r2
    startAng = startAng or 0
    endAng = endAng or 0


    for i = startAng - 90, endAng - 90, step do
        table.insert(inner, {
            x = math.ceil(x + math.cos(math.rad(i)) * r2),
            y = math.ceil(y + math.sin(math.rad(i)) * r2)
        })
    end


    for i = startAng - 90, endAng - 90, step do
        table.insert(outer, {
            x = math.ceil(x + math.cos(math.rad(i)) * r),
            y = math.ceil(y + math.sin(math.rad(i)) * r)
        })
    end


    for i = 1, #inner * 2 do
        local outPoints = outer[math.floor(i / 2) + 1]
        local inPoints = inner[math.floor((i + 1) / 2) + 1]
        local otherPoints


        if i % 2 == 0 then
            otherPoints = outer[math.floor((i + 1) / 2)]
        else
            otherPoints = inner[math.floor((i + 1) / 2)]
        end


        table.insert(positions, {outPoints, otherPoints, inPoints})
    end


    if cache then
        return positions
    else
        for k,v in pairs(positions) do 
            surface.DrawPoly(v)
        end
    end
end

// initiating values

local menu = nil
local echat_open = false
local visible = false

local mw, mh = ScrW(), ScrH()
local mainCircle = draw.drawCircle(mw / 2, mh / 2, 80, 3, true)

local btw, bth = 180, 120
local btcl1, btcl2, btcl3, btcl4 = equam2.colors.bg1, equam2.colors.bg1, equam2.colors.bg1, equam2.colors.bg1
local anim1, anim2, anim3, anim4 = 0, 0, 0, 0

local txt1, txt2, txt3, txt4 = equam2.equamv2.pagem.up.name, equam2.equamv2.pagem.right.name, equam2.equamv2.pagem.down.name, equam2.equamv2.pagem.left.name
local page = 0
local tab = nil
local cmd = ""
local targ = ""

local function checkAdmin(ply)
    local rank = ply:GetUserGroup()
    for key, value in ipairs(equam2.staff) do
        if value == rank then
            return true
        end
    end
end

local function resetPage()
    cmd = ""
    page = 0
    anim1 = 0
    anim2 = 0
    anim3 = 0
    anim4 = 0
    txt1, txt2, txt3, txt4 = equam2.equamv2.pagem.up.name, equam2.equamv2.pagem.right.name, equam2.equamv2.pagem.down.name, equam2.equamv2.pagem.left.name
end

local function openMenu()
    visible = true
    menu = vgui.Create("DFrame")
    menu:SetSize(mw, mh)
    menu:Center()
    menu:MakePopup()
    menu:SetTitle("")
    menu:SetVisible(true)
    menu:ShowCloseButton(false)
    menu:SetPaintShadow( false )
    menu:SetDraggable(false)

    menu.Paint = function()

        draw.NoTexture()
        surface.SetDrawColor(equam2.colors.bg2)
        surface.DrawPoly(mainCircle)

        draw.SimpleText("EQUAM v2", "equam2.main", mw / 2, mh / 2, equam2.colors.txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        // menage tab
        local menSubsection = draw.drawSubSection(ScrW() / 2, ScrH() / 2, 90 + anim1, 80, 315, 360, 3, true)
        local menSubsection2 = draw.drawSubSection(ScrW() / 2, ScrH() / 2, 90 + anim1, 80, 0, 45, 3, true)

        for k,v in pairs(menSubsection) do 
            surface.SetDrawColor(btcl1)
            surface.DrawPoly(v)
        end
        for k,v in pairs(menSubsection2) do 
            surface.DrawPoly(v)
        end

        // teleport tab
        local telSubsection = draw.drawSubSection(ScrW() / 2, ScrH() / 2, 90 + anim2, 80, 45, 135, 3, true)

        for k,v in pairs(telSubsection) do 
            surface.SetDrawColor(btcl2)
            surface.DrawPoly(v)
        end

        // punish tab
        local punSubsection = draw.drawSubSection(ScrW() / 2, ScrH() / 2, 90 + anim3, 80, 135, 225, 3, true)

        for k,v in pairs(punSubsection) do 
            surface.SetDrawColor(btcl3)
            surface.DrawPoly(v)
        end

        // warn tab
        local punSubsection = draw.drawSubSection(ScrW() / 2, ScrH() / 2, 90 + anim4, 80, 225, 315, 3, true)

        for k,v in pairs(punSubsection) do 
            surface.SetDrawColor(btcl4)
            surface.DrawPoly(v)
        end
        
    end

    local menageB = vgui.Create("DButton", menu)
    menageB:SetPos((ScrW() - btw) / 2, (ScrH() - bth) / 2 - 130)
    menageB:SetSize(btw, bth)
    menageB:SetText("")

    function menageB:DoClick()
        if page == 0 then
            page = 1
            tab = equam2.equamv2.pageu
            txt1, txt2, txt3, txt4 = equam2.equamv2.pageu.up.name, equam2.equamv2.pageu.right.name, equam2.equamv2.pageu.down.name, equam2.equamv2.pageu.left.name
        elseif page == 1 then
            page = 2
            cmd = tab.up.cmd
            txt1, txt2, txt3, txt4 = equam2.equamv2.person.up.name, equam2.equamv2.person.right.name, equam2.equamv2.person.down.name, equam2.equamv2.person.left.name
        end
    end

    menageB.Paint = function(self,w,h)

        if self:IsHovered() then
            anim1 = Lerp(FrameTime() * 5, anim1, 10)
            btcl1 = equam2.colors.ac2
            btxtcl = equam2.colors.ac
        else
            anim1 = Lerp(FrameTime() * 5, anim1, 0)
            btcl1 = equam2.colors.bg1
            btxtcl = equam2.colors.txt
        end
        
        //surface.SetDrawColor(equam2.colors.ac)
        //surface.DrawRect(0, 0, w, h) // this is the hitbox
        draw.SimpleText(txt1, "equam2.main", btw / 2, bth / 2 - anim1, btxtcl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end

    local teleportB = vgui.Create("DButton", menu)
    teleportB:SetPos((ScrW() - btw) / 2 + 160, (ScrH() - btw) / 2)
    teleportB:SetSize(bth, btw)
    teleportB:SetText("")

    function teleportB:DoClick()
        if page == 0 then
            page = 1
            tab = equam2.equamv2.pager
            txt1, txt2, txt3, txt4 = equam2.equamv2.pager.up.name, equam2.equamv2.pager.right.name, equam2.equamv2.pager.down.name, equam2.equamv2.pager.left.name
        elseif page == 1 then
            page = 2
            cmd = tab.right.cmd
            txt1, txt2, txt3, txt4 = equam2.equamv2.person.up.name, equam2.equamv2.person.right.name, equam2.equamv2.person.down.name, equam2.equamv2.person.left.name
        elseif page == 2 then
            page = 3
            targ = LocalPlayer():Nick()
            RunConsoleCommand(equam2.equamv2.prefix, cmd, targ)
            visible = false
            resetPage()
            menu:Remove()
        end
    end

    teleportB.Paint = function(self,w,h)

        if self:IsHovered() then
            anim2 = Lerp(FrameTime() * 5, anim2, 10)
            btcl2 = equam2.colors.ac2
            btxtcl = equam2.colors.ac
        else
            anim2 = Lerp(FrameTime() * 5, anim2, 0)
            btcl2 = equam2.colors.bg1
            btxtcl = equam2.colors.txt
        end
        
        //surface.SetDrawColor(equam2.colors.ac)
        //surface.DrawRect(0, 0, w, h) // this is the hitbox
        draw.SimpleText(txt2, "equam2.main", bth / 2 + anim2, btw / 2, btxtcl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end

    local punishB = vgui.Create("DButton", menu)
    punishB:SetPos((ScrW() - btw) / 2, (ScrH() - bth) / 2 + 130)
    punishB:SetSize(btw, bth)
    punishB:SetText("")

    function punishB:DoClick()
        if page == 0 then
            page = 1
            tab = equam2.equamv2.paged
            txt1, txt2, txt3, txt4 = equam2.equamv2.paged.up.name, equam2.equamv2.paged.right.name, equam2.equamv2.paged.down.name, equam2.equamv2.paged.left.name
        elseif page == 1 then
            page = 2
            cmd = tab.down.cmd
            txt1, txt2, txt3, txt4 = equam2.equamv2.person.up.name, equam2.equamv2.person.right.name, equam2.equamv2.person.down.name, equam2.equamv2.person.left.name
        end
    end

    punishB.Paint = function(self,w,h)

        if self:IsHovered() then
            anim3 = Lerp(FrameTime() * 5, anim3, 10)
            btcl3 = equam2.colors.ac2
            btxtcl = equam2.colors.ac
        else
            anim3 = Lerp(FrameTime() * 5, anim3, 0)
            btcl3 = equam2.colors.bg1
            btxtcl = equam2.colors.txt
        end
        
        //surface.SetDrawColor(equam2.colors.ac)
        //surface.DrawRect(0, 0, w, h) // this is the hitbox
        draw.SimpleText(txt3, "equam2.main", btw / 2, bth / 2 + anim3, btxtcl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end

    local WarnB = vgui.Create("DButton", menu)
    WarnB:SetPos((ScrW() - btw) / 2 - 100, (ScrH() - btw) / 2)
    WarnB:SetSize(bth, btw)
    WarnB:SetText("")

    function WarnB:DoClick()
        if page == 0 then
            page = 1
            txt1, txt2, txt3, txt4 = equam2.equamv2.pagel.up.name, equam2.equamv2.pagel.right.name, equam2.equamv2.pagel.down.name, equam2.equamv2.pagel.left.name
            RunConsoleCommand("awarn", "menu")
            visible = false
            resetPage()
            menu:Remove()
        elseif page == 1 then
            page = 2
            cmd = tab.left.cmd
            txt1, txt2, txt3, txt4 = equam2.equamv2.person.up.name, equam2.equamv2.person.right.name, equam2.equamv2.person.down.name, equam2.equamv2.person.left.name
        elseif page == 2 then
            page = 3
            local combox = vgui.Create("DComboBox", menu)
            combox:SetPaintBackground(false)
            combox:SetSize(120 ,25)
            combox:SetPos((ScrW() - 120) / 2, ScrH() / 2 - 40)
            combox:SetFont("font")
            combox:SetColor(equam2frtxt2)

            combox.Paint = function(self,w,h)
                LocalPlayer().drawOutlinedBox(2, 0, 0, w, h, equam2.colors.bg1, equam2.colors.out)
            end
            
            for k,v in ipairs(player.GetAll()) do
                combox:AddChoice( tostring(v:Nick()) )
            end
            combox.OnSelect = function( self, index, value )
                targ = value
            end

            local WarnB = vgui.Create("DButton", menu)
            WarnB:SetPos((ScrW() - 80) / 2, (ScrH() - 25) / 2 + 35)
            WarnB:SetSize(90, 30)
            WarnB:SetText("")

            function WarnB:DoClick()
                RunConsoleCommand(equam2.equamv2.prefix, cmd, targ)
            end

            WarnB.Paint = function(self,w,h)

                if self:IsHovered() then
                    btcl = equam2.colors.ac2
                    btxtcl = equam2.colors.ac
                else
                    btcl = equam2.colors.bg1
                    btxtcl = equam2.colors.txt
                end
                
                LocalPlayer().drawButton(2, 0, 0, w, h, "Submit", btcl, equam2.colors.out, btxtcl)

            end
        end
    end

    WarnB.Paint = function(self,w,h)

        if self:IsHovered() then
            anim4 = Lerp(FrameTime() * 5, anim4, 10)
            btcl4 = equam2.colors.ac2
            btxtcl = equam2.colors.ac
        else
            anim4 = Lerp(FrameTime() * 5, anim4, 0)
            btcl4 = equam2.colors.bg1
            btxtcl = equam2.colors.txt
        end
        
        //surface.SetDrawColor(equam2.colors.ac)
        //surface.DrawRect(0, 0, w, h) // this is the hitbox
        draw.SimpleText(txt4, "equam2.main", bth / 2 - anim4, btw / 2, btxtcl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end

end

local function closeMenu()
    resetPage()
    visible = false
    if IsValid(menu) then
        menu:Remove()
    end
end

// making chat check work

hook.Add("echat_ChatOpened", "equamv2ChatCheck", function(ply, model)
	echat_open = true
end)
hook.Add("echat_ChatClosed", "equamv2ChatCheck", function(ply, model)
	echat_open = false
end)

// checking if the menu should be opened and checking if not typing

hook.Add("Think", "equamv2Check", function()
    if not checkAdmin(LocalPlayer()) then return end
    if gui.IsConsoleVisible() or gui.IsGameUIVisible() or echat_open then
        return
    end
    if input.IsKeyDown(equam2.equamv2.key) then
        if visible == true then return end
        openMenu()
    else
        if visible == false then return end
        closeMenu()
    end
end)