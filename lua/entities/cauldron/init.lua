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

function ENT:DropCauldron(ply)
	local start = false;

	for _, v in pairs(ply.Claims) do
		start = true;
		ply:PS2_AddStandardPoints(
			math.Round((#ply.Claims / v), 0), 
			"Prime de quêtes.",
			true
		);
	end

	if start then ply.Claims[v:GetName()] = 0; end
end