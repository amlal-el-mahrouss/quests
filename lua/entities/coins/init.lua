// Basic Coin with quests
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local curtime;

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetModel("models/items/ammopack_large.mdl")

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake();
	end
end

function ENT:Use(target)
	self:SetOwner(target);
	self:EmitSound("COIN.PICKUP");
	target:PickupObject(self);

end
