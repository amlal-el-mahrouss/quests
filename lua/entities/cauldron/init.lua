AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()

		ParticleEffectAttach("soup_bubbles01", PATTACH_POINT_FOLLOW, self.Entity, 1)
		self.Sound = CreateSound( self, "cauldron_bubbling_loop.wav" )
		self.Sound:PlayEx( 0.5, 100 )
	end
end

local spell = Sound("sound/cauldron_magicspell.wav");

function ENT:Use(ply)
	for _, amount in ipairs(ply.Claims) do
		ply:PS2_AddStandardPoints(
			amount
			"Prime de quêtes.",
			true
		);
	end

	ply.Claims = {};
end