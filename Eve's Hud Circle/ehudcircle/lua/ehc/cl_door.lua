// Addon made by Eve Haddox
// my discord "evehaddox"

local Door = {
    ["prop_door_rotating"] = true,
    ["func_door"] = true,
    ["func_door_rotating"] = true,
}

local function GetDrawPosAng(door)
    local dimens = door:OBBMaxs() - door:OBBMins()
    local center = door:OBBCenter()
    local min, j 
    local lpos, lang

    for i=1, 3 do
        if !min or dimens[i] <= min then
            j = i
            min = dimens[i]
        end
    end

    local norm = Vector()
    norm[j] = 1

    local lang = Angle( 0, norm:Angle().y + 90, 90 )

    if door:GetClass() == "prop_door_rotating" then
        lpos = Vector( center.x, center.y, center.z + 25 ) + lang:Up() * (min / 8)
    else
        lpos = center + Vector( 0, 0, 20 ) + lang:Up() * ((min / 2) - 0.1)
    end

    local ang = door:LocalToWorldAngles( lang )
    local dot = ang:Up():Dot( LocalPlayer():GetShootPos() - door:WorldSpaceCenter() )

    if dot < 0 then
        lang:RotateAroundAxis( lang:Right(), 180 )

        if door:GetClass() == "prop_door_rotating" then
            lpos = Vector( center.x - min/6 - 0.1, center.y, center.z + 25 ) + lang:Up() * (min / 10^9)
        else
            lpos = center + Vector( 0, 0, 20 ) + lang:Up() * ((min / 2) - 0.1)
        end
        ang = door:LocalToWorldAngles( lang )

    end

    local pos = door:LocalToWorld( lpos )
    local scale = 0.05

    return pos, ang, scale
end

hook.Add("PostDrawTranslucentRenderables", "DoorHUD", function()
    local ShouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DoorHUD")

    if ShouldDraw == false or !DarkRP then return end

    for k, v in pairs( ents.GetAll() ) do
        if Door[v:GetClass()] and LocalPlayer():GetPos():DistToSqr(v:GetPos()) < 500000 then

            cam.Start3D2D(GetDrawPosAng(v))
                v:drawDoorInfo()
            cam.End3D2D()

        end
    end
end)

local Entity = FindMetaTable("Entity")

function Entity:drawDoorInfo()
    
    local ply = LocalPlayer()
    local blocked = self:getKeysNonOwnable()
    local superadmin = ply:IsSuperAdmin()
    local doorTeams = self:getKeysDoorTeams()
    local doorGroup = self:getKeysDoorGroup()
    local playerOwned = self:isKeysOwned() or table.GetFirstValue(self:getKeysCoOwners() or {}) ~= nil
    local owned = playerOwned or doorGroup or doorTeams

    local doorInfo = {}

    local title = self:getKeysTitle()
    if title then 
        surface.SetFont("ehc.100")
        local w = surface.GetTextSize(title) + 10
        surface.DrawRect(-w/2,50,w,150)
        draw.SimpleText(title, "ehc.100", 0, 50+150/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if owned then
        table.insert(doorInfo, "Owned By")
    end

    if playerOwned then
        if self:isKeysOwned() then table.insert(doorInfo, self:getDoorOwner():Nick()) end
        for k in pairs(self:getKeysCoOwners() or {}) do
            local ent = Player(k)
            if not IsValid(ent) or not ent:IsPlayer() then continue end
            table.insert(doorInfo, ent:Nick())
        end

        local allowedCoOwn = self:getKeysAllowedToOwn()
        if allowedCoOwn and not fn.Null(allowedCoOwn) then

            for k in pairs(allowedCoOwn) do
                local ent = Player(k)
                if not IsValid(ent) or not ent:IsPlayer() then continue end
                table.insert(doorInfo, ent:Nick())
            end
        end
    elseif doorGroup then
        table.insert(doorInfo, doorGroup)
    elseif doorTeams then
        for k, v in pairs(doorTeams) do
            if not v or not RPExtraTeams[k] then continue end

            table.insert(doorInfo, RPExtraTeams[k].name)
        end
    elseif not blocked then
        table.insert(doorInfo, "Unowned")
    end

    local text = table.concat(doorInfo, "\n")
    surface.SetFont("ehc.80")

    local w = surface.GetTextSize(text) + 10
    local h = table.Count(doorInfo) * 80

    if #doorInfo > 0 then
        draw.DrawNonParsedText(text, "ehc.80", 0 , 200 + 10 , Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end

end

hook.Add("HUDDrawDoorData", "RemoveDoorHUD", function(ent)

    local ShouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DoorStateHUD")

    if ShouldDraw == false then return true end

    if ent:getKeysNonOwnable() and LocalPlayer():IsSuperAdmin() then
        draw.DrawNonParsedText(DarkRP.getPhrase("keys_allow_ownership"), "TargetID", ScrW()/2, ScrH()/1.1, Color(255,255,255,255), 1)
    end
    
    return true
end)

hook.Add("onKeysMenuOpened", "Evehv2DoorMenu", function( ent, frame )
    hook.Add("HUDShouldDraw", "Evehv2RemoveCrosshair_DoorMenu",function( name )
        if name == "CHudCrosshair" then return false end
    end)

    local oldFunc = frame.OnRemove or function(  ) end

    local panels = frame:GetChildren()

    for i = 1,4 do
        panels[i]:Remove()
        panels[i] = nil
    end

    panels = table.ClearKeys(panels)
    local PanelsCount = #panels


    frame.PerformLayout = function() end
    frame:SetSize(450, 49 + 44 * math.ceil(PanelsCount / 2))

    frame.Paint = function (self, w, h)
        draw.RoundedBox(20, 0, 0, w, h, ehc.colors.out)
        draw.RoundedBox(20, 2, 2, w - 4, h - 4, ehc.colors.sec)
        draw.RoundedBoxEx(20, 2, 2, w - 4, 33, ehc.colors.main, true, true, false, false)

        draw.RoundedBox(0, 2, 33, w - 4, 2, ehc.colors.ac)

        draw.SimpleText("Door Options", "ehc.28", 12, 32 - 2, ehc.colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end

    local PosData = {}
    local x = 10

    for i = 1, PanelsCount do
        if (i % 2 == 0) then x = 230 else x = 10 end
        table.insert( PosData, { x = x, y = 44 * math.ceil(i / 2) + 6} )
    end

    for k, v in ipairs(panels) do
        v:SetFont("ehc.22")
        v:SetSize(210, 34)
        v:SetPos(PosData[k].x, PosData[k].y - 5)

        local cl_hover, textcl = ehc.colors.out, ehc.colors.txt
        local txtclv = textcl

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

    local closeCooldown = CurTime() + 0.2
    local allowClose = false

    frame.Think = function()
        if input.IsKeyDown(KEY_F2) then
            if closeCooldown > CurTime() or !allowClose then return end
            frame:Close()
        else
            allowClose = true
        end
    end

    local CloseBut = vgui.Create("DButton", frame)
    CloseBut:SetText( "" )
    CloseBut:SetSize(38, 38)
    CloseBut:SetPos(frame:GetWide() - 34, -2)
    CloseBut.DoClick = function()
        frame:Close()
    end
    CloseBut.Paint = function( s, w, h )
        surface.SetMaterial(Material("materials/eve/close.png"))
        surface.SetDrawColor(ehc.colors.txt)
        surface.DrawTexturedRect(0, 8, 24, 24)
    end
end)

hook.Add("Evehv2Reload", "Evehv2UnloadDoorMenu", function()
    hook.Remove("onKeysMenuOpened", "Evehv2DoorMenu")
end)