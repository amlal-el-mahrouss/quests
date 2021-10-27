// Basic Coin with quests
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local curtime;

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetModel("models/items/ammopack_medium.mdl")
	self:SetBodygroup(2, 1);
	self:SetBodygroup(3, 1);
	self:SetBodygroup(2, 2);
	self:AddEffects(EF_ITEM_BLINK)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake();

		phys:EnableMotion(true);
		phys:EnableCollisions(true);
		phys:EnableDrag(true);
		phys:EnableGravity(true);
	end

	self:ResetSequence("idle");
end

function ENT:Use(ply, caller, use, value)
	local owner = self:GetOwner();
	if not IsValid(owner) || not owner:IsPlayer() then return end
	owner:SetNWBool("QuestCompleted", true);
	
	self:SetModelScale(0, 0.15);
	timer.Simple(0.15, function()
		if IsValid(self) then self:EmitSound("COIN.DEPOSIT"); self:Remove() end
	end)
end

function ENT:Think()

	self:NextThink( CurTime() )
	return true
end