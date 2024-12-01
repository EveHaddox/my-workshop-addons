EQUIPPED_ENTITIES = EQUIPPED_ENTITIES or {}

util.AddNetworkString("esuits.hud")

local function SetEquipped(ply, entityType, isEquipped, name)
    if not IsValid(ply) then return end
    if isEquipped then
        EQUIPPED_ENTITIES[ply:SteamID()] = entityType
        net.Start("esuits.hud")
        net.WriteString(name)
        net.WriteBool(true)
        net.Send(ply)
        net.Abort()

        
    else
        EQUIPPED_ENTITIES[ply:SteamID()] = nil

        local jobTable = ply:getJobTable()
        local playermodel = jobTable.model
        if istable(playermodel) then
            playermodel = playermodel[1]
        end

        ply:SetModel(playermodel)
    end
end

function SetPlayerEquipped(ply, entityType, state, name)
    SetEquipped(ply, entityType, state, name)
end

hook.Add("PlayerDisconnected", "CleanUpEquippedData", function(ply)
    EQUIPPED_ENTITIES[ply:SteamID()] = nil
end)

hook.Add("PlayerDeath", "esuits", function(ply)
    SetPlayerEquipped(ply, nil, false)
    net.Start("esuits.hud")
    net.WriteString("")
    net.WriteBool(false)
    net.Send(ply)
    net.Abort()
end)

local dropping = {}

concommand.Add("esuits_dropsuit", function(ply, cmd, args)
    if dropping[ply] then ply:PrintMessage(HUD_PRINTTALK, "Already dropping") return end
    dropping[ply] = true
    local entityType = EQUIPPED_ENTITIES[ply:SteamID()]
    if entityType then
        local ent = ents.Create(entityType)
        if not IsValid(ent) then return end
        local time = CurTime() + 5
        ply:PrintMessage(HUD_PRINTTALK, "Your suit will drop in 5sec")

        local function timePrint()
            timer.Simple(1, function()
                if CurTime() < time then
                    ply:PrintMessage(HUD_PRINTTALK, math.Round(time - CurTime()))
                    timePrint()
                else
                    ply:PrintMessage(HUD_PRINTTALK, "Dropped")

                    

                    local trace = {}
                    trace.start = ply:EyePos()
                    trace.endpos = trace.start + ply:GetAimVector() * 85
                    trace.filter = ply

                    local tr = util.TraceLine(trace)
                    ent:SetPos(tr.HitPos) //ply:GetPos() + Vector(50, 0, 50)

                    ent:Spawn()
                    ent:Activate()

                    SetPlayerEquipped(ply, nil, false)
                    ply:EmitSound("phx/eggcrack.wav")
                    est.suits[entityType](ply)
                    net.Start("esuits.hud")
                    net.WriteString("")
                    net.WriteBool(false)
                    net.Send(ply)
                    net.Abort()
                    dropping[ply] = false
                end
            end)
        end

        timePrint()

    else
        ply:PrintMessage(HUD_PRINTTALK, "You do not have an entity equipped.")
        dropping[ply] = false
    end
end)
