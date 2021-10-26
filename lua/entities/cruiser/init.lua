-- Un Easter Egg
-- Apparait 5 rounds sur 20 avec un taux de chance de 20%

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetModel("models/props/re3_remake_patrol_car.mdl")
	self:SetPos(Vector(1466.309692, -138.753723, 94.031250))
	self:SetAngles(Angle(0.967987, 92.400124, 0.000000))
	self:SetBodygroup(1, 1);
	self:SetBodygroup(3, 1);

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
	end
end

