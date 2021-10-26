// Basic Coin with quests
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local curtime;


ENT.DeactivationDelay = CurTime();

function ENT:Initialize()
	self:PhysicsInit( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_BBOX )
	self:DrawShadow(true)
	self:SetModel("models/items/ammopack_medium.mdl")

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableGravity(false);
		phys:EnableDrag(false);
		phys:Wake();

		self.UseableUntil = 10;
		self.PickupSound = "COIN.PICKUP";

		self:ResetSequence(ACT_IDLE);
	end
end

function ENT:Use(target)
	target:SetNWBool("CompletedQuest", true);

	self:EmitSound(self.PickupSound);
	self:Remove();
end
