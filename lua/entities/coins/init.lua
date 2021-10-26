// Basic Coin with quests
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local curtime;


ENT.DeactivationDelay = CurTime();

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow(true)
	self:SetModel("models/items/ammopack_medium.mdl")

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake();
		phys:EnableGravity(false);
		phys:EnableDrag(false);
		
	end

	self.PickupSound = "COIN.PICKUP";
end

function ENT:Use(target)
	self:SetOwner(target);
	self:EmitSound(self.PickupSound);
	target:PickupObject(self);

end
