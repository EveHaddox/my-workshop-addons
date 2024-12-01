// Script made by Eve Haddox
// discord evehaddox

util.AddNetworkString("DethscreenHud")
util.AddNetworkString( "DethscreenRevive" )

function respawnenable(ply, weapon, attacker)

    ply:UnLock()
    
end

hook.Add("PlayerDeath", "evesdethscreen", function(ply, bs, attacker )

    ply:Lock()

    local weapon = nil

    if attacker:IsPlayer() then
        weapon = attacker:GetActiveWeapon()
    end

    timer.Create("respawndelayevedethscreen", eds.delay, 1, function() respawnenable(ply, weapon, attacker) end )

    local encode = {
        [1] = nil
    }

    if IsValid(weapon) then
        encode = {
            [1] = attacker:SteamID64(),
            [2] = weapon:GetPrintName()
        }
    elseif attacker:IsPlayer() then
        encode = {
            [1] = attacker:SteamID64(),
            [2] = nil
        }
    else
        encode = {
            [1] = nil,
            [2] = nil
        }
    end

    net.Start("DethscreenHud")
    net.WriteString(tostring(ply:SteamID64()))
    net.WriteTable(encode, false)
    net.Broadcast()

end)

net.Receive("DethscreenRevive", function() 

    local ply = net.ReadString()

    for k,v in ipairs(player.GetAll()) do
        if tostring(v:Nick()) == ply then
            ply = v
        end
    end

    ply:Spawn()

end)