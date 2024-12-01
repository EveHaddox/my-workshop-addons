// Addon made by Eve Haddox
// my discord "evehaddox"

local Plyrm = FindMetaTable("Player")

Plyrm.drawPlayerInfo = function(targ)
    if not IsValid(targ) then return end
    local Cteam = team.GetColor(targ:Team())
    local pos = targ:EyePos()
    local distance = LocalPlayer():GetPos():Distance( targ:GetPos() )
    if distance < ehc.drawdist then
        pos.z = pos.z + 1
        pos = pos:ToScreen()

        local ypos = distance / 4

        local name, plyTeam = targ:Nick(), targ:Team()
        draw.SimpleText(string.upper(name),"ehc.28",pos.x, pos.y - 133 + ypos, Color(255, 255, 255, 250),TEXT_ALIGN_CENTER ,TEXT_ALIGN_CENTER)	
        local Job = targ:getDarkRPVar("job") or team.GetName(targ:Team())
        local Jobdq = team.GetColor(targ:Team())
        draw.SimpleText(Job,"ehc.28",pos.x, pos.y - 110 + ypos, Jobdq,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

Plyrm.drawWantedInfo = function(targ)
    if not targ:Alive() then return end
    local distance = LocalPlayer():GetPos():Distance( targ:GetPos() )
    if distance <= ehc.drawdist then
        local ypos = distance / 4
        local pos = targ:EyePos()
        pos.z = pos.z + 1
        pos = pos:ToScreen()	
        local nick, plyTeam = targ:Nick(), targ:Team()
        draw.SimpleText("Wanted","ehc.28",pos.x, pos.y - 170 + ypos, Color(255, 0, 0, 250),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
    end  
end