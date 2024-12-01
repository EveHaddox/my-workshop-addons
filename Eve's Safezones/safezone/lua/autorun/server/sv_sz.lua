
util.AddNetworkString("safezone")
util.AddNetworkString("safezone_delete")

SAFEZONE_CACHE = SAFEZONE_CACHE or {}

hook.Add("EntityTakeDamage", "safezones_god", function(ply, dmginfo)
    if ply:IsPlayer() and ply.luctusInSafezone then
        dmginfo:SetDamage(0)
    end
end)

hook.Add("PlayerSpawnObject", "safezones_nospawning", function(ply, model, skinNumber )
  if ply.luctusInSafezone then
    return false
  end
end)

function LuctusSafezoneHandleSpawns()
    local res = sql.Query("CREATE TABLE IF NOT EXISTS safezones(pos_one VARCHAR(200), pos_two VARCHAR(200))")
    if res == false then 
        error(sql.LastError())
    end

    res = sql.Query("SELECT *,rowid FROM safezones")
    if res == false then
        error(sql.LastError())
    end

    if res and #res > 0 then
        for k,v in pairs(res) do
            p1 = Vector(v["pos_one"])
            p2 = Vector(v["pos_two"])
            local ent = ents.Create("safezone")
            ent:SetPos( (p1 + p2) / 2 )
            ent.min = p1
            ent.max = p2
            ent:Spawn()
            ent:SetID(v["rowid"])
            ent:SetEID(ent:EntIndex())
            SAFEZONE_CACHE[v["rowid"]] = ent:EntIndex()
        end
    end
    print("[safezones] Safezones spawned!")
    hook.Remove("PlayerInitialSpawn", "safezone_init")
end

hook.Add("PlayerInitialSpawn", "safezone_init", LuctusSafezoneHandleSpawns)
hook.Add("PostCleanupMap", "safezone_init", LuctusSafezoneHandleSpawns)

function luctusLeftSafezone(ply)
    ply.luctusInSafezone = false
    net.Start("safezone")
        net.WriteBool(false)
    net.Send(ply)
end

function luctusEnteredSafezone(ply)
    ply.luctusInSafezone = true
    net.Start("safezone")
        net.WriteBool(true)
    net.Send(ply)
end

function luctusSaveSafezone(posone, postwo)
    local res = sql.Query("INSERT INTO safezones VALUES("..sql.SQLStr(posone)..", "..sql.SQLStr(postwo)..")")
    if res == false then 
        error(sql.LastError())
    end
    if res == nil then print("[safezones] Safezone saved successfully!") end
  
    local ent = ents.Create("safezone")
    ent:SetPos( (posone + postwo) / 2 )
    ent.min = posone
    ent.max = postwo
    ent:Spawn()

    res = sql.QueryRow("SELECT rowid FROM safezones ORDER BY rowid DESC limit 1")
    if res == false then 
        error(sql.LastError())
    end
    ent:SetID(tonumber(res["rowid"]))
    ent:SetEID(ent:EntIndex())
    SAFEZONE_CACHE[res["rowid"]] = ent:EntIndex()
end

net.Receive("safezone_delete", function(len, ply)
    if not ply:IsAdmin() and not ply:IsSuperAdmin() then return end
    local rowid = net.ReadString()
    if not tonumber(rowid) then return end
    res = sql.QueryRow("DELETE FROM safezones WHERE rowid = "..rowid)
    if res == false then 
        error(sql.LastError())
    end
    print("[safezones] Deleted safezone from DB")
    if SAFEZONE_CACHE[rowid] then
        local ent = ents.GetByIndex(SAFEZONE_CACHE[rowid])
        if ent and IsValid(ent) then ent:Remove() end
    end
    print("[safezones] Deleted safezone from map")
end)

print("[safezones] sv loaded")
