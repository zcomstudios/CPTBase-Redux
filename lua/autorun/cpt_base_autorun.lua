/*--------------------------------------------------
	Copyright (c) 2018 by Cpt. Hazama, All rights reserved.
	Nothing in these files or/and code may be reproduced, adapted, merged or
	modified without prior written consent of the original author, Cpt. Hazama
--------------------------------------------------*/
AddCSLuaFile('server/cpt_utilities.lua')
include('server/cpt_utilities.lua')

// Bots
CPTBase.AddNPC("Player Bot","npc_cpt_bot","CPTBase Redux")

// Combine
CPTBase.AddNPC("Combine Assasssin","npc_cpt_cassassin","CPTBase Redux")
CPTBase.AddNPC("Cremator","npc_cpt_cremator","CPTBase Redux")
CPTBase.AddNPC("Mortar Synth","npc_cpt_mortarsynth","CPTBase Redux")
CPTBase.AddNPC("Combine Soldier","npc_cpt_csoldier","CPTBase Redux")

// Zombies + Enemy Aliens
CPTBase.AddNPC("Parasite","npc_cpt_parasite","CPTBase Redux")
CPTBase.AddNPC("Puker Zombie","npc_cpt_pukerzombie","CPTBase Redux")
CPTBase.AddNPC("Zombie (NB)","nextbot_cpt_testnpc","CPTBase Redux")
CPTBase.AddNPC("Ichthyosaur","npc_cpt_icky","CPTBase Redux")

CPTBase.AddConVar("cpt_allowspecialdmg",1)
CPTBase.AddConVar("cpt_corpselifetime",100)
CPTBase.AddConVar("cpt_debug_nodegraph",0)
CPTBase.AddConVar("cpt_debug_showcptnodegraph",0)
CPTBase.AddConVar("cpt_debug_cancreategraph",0)
CPTBase.AddConVar("cpt_aiusecustomnodes",0)
CPTBase.AddConVar("cpt_aidifficulty",2) -- 1 = Easy, 2 = Normal, 3 = Hard, 4 = Hell

game.AddAmmoType({name="9×19mm",dmgtype=DMG_BULLET})
game.AddAmmoType({name="5.7×28mm",dmgtype=DMG_BULLET})
game.AddAmmoType({name="5.56×45mm",dmgtype=DMG_BULLET})
game.AddAmmoType({name="darkpulseenergy",dmgtype=DMG_DISSOLVE})
game.AddAmmoType({name="defaultammo",dmgtype=DMG_BULLET})

function CPTBase_Chat(ply,spoke)
	local lowered = string.lower(spoke)
	if (ply:IsAdmin() or ply:IsSuperAdmin()) && (string.sub(lowered,1,11) == "!setfaction") then
		local in_faction = string.sub(string.upper(spoke),13)
		ply.Faction = in_faction
		ply:ChatPrint("Set faction to " .. in_faction)
	end
end
hook.Add("PlayerSay","CPTBase_Chat",CPTBase_Chat)

hook.Add("PlayerSpawn","CPTBase_StopIgnition",function(ply)
	timer.Simple(0.02,function()
		if IsValid(ply) then
			if ply:IsOnFire() then
				ply:Extinguish()
			end
		end
	end)
end)

hook.Add("PlayerSpawn","CPTBase_AddDefaultPlayerValues",function(ply)
	ply.IsPossessing = false
	ply.CPTBase_EF_RAD = 0
	ply:SetNWBool("CPTBase_IsPossessing",false)
	ply:SetNWEntity("CPTBase_PossessedNPCClass",nil)
end)

if CLIENT then
	hook.Add("PlayerStartVoice","CPTBase_SetVoiceData",function(ply)
		for _,v in ipairs(ents.GetAll()) do
			if v:IsValid() && v:IsNPC() && v:GetNWBool("IsCPTBase_NPC") then
				net.Start("cpt_SpeakingPlayer")
				net.WriteEntity(v)
				net.WriteEntity(ply)
				net.SendToServer()
			end
		end
	end)
end