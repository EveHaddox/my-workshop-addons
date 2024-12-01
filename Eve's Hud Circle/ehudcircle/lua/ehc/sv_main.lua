// Addon made by Eve Haddox
// my discord "evehaddox"

if not SERVER then print("sv_main failed to load") return end

// prop counter

util.AddNetworkString("UpdateProp")

local PLAYER = FindMetaTable("Player")

PLAYER.AddCount_Old = PLAYER.AddCount_Old or PLAYER.AddCount

function PLAYER:AddCount( str, ent, ... )
	if IsValid(ent) and IsEntity(ent) and ent:GetClass() == "prop_physics" then
		self.Props = self.Props + 1
		ent.Owner = self

		net.Start("UpdateProp")
			net.WriteUInt(self.Props, 11)
		net.Send(self)
	end

	return self:AddCount_Old(str, ent, ...)
end

hook.Add("PlayerInitialSpawn", "EveHudSetProps",function( ply )
	ply.Props = 0
end)

hook.Add("EntityRemoved", "EveHudPropRemoved", function( ent )
	if ent.Owner and IsValid(ent.Owner) and ent.Owner.Props then

		ent.Owner.Props = math.max(ent.Owner.Props - 1, 0)

		net.Start("UpdateProp")
			net.WriteUInt(ent.Owner.Props, 11)
		net.Send(ent.Owner)
	end
end)

// voting

util.AddNetworkString("Evehv2Vote")

//Add a hook for when a vote occurs.
hook.Add("onVoteStarted", "EveHudVoteStarted",function( voteTbl )
	local rf = RecipientFilter()
	rf:AddAllPlayers()

	for k,v in ipairs(voteTbl.exclude) do
		rf:RemovePlayer(k)
	end

	net.Start("Evehv2Vote")
		net.WriteUInt(voteTbl.id,10)
		net.WriteString(voteTbl.question)
		net.WriteUInt(voteTbl.time,8)
	net.Send(rf)

end)