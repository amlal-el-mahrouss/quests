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
	
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableGravity(false);
		phys:EnableDrag(false);
		phys:Wake();

		self.UseableUntil = 10;
		self.PickupSound = "COIN.PICKUP";
	end
end

function ENT:Use(target)
	self.DeactivationDelay = CurTime() + 10;
	self:EmitSound(self.PickupSound);

	if self.UseableUntil < 1 then self:Remove() end
	if CurTime() < self.DeactivationDelay then return end

	if target.Claims == nil then target.Claims = {} target.Claims[self:EntIndex()] = 1 return end
	target.Claims[self:EntIndex()] = target.Claims[self:EntIndex()] + 1;
	self.UseableUntil = self.UseableUntil - 1;
end
