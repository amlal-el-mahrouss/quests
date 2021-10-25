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

function ENT:DropCauldron(target)
	local start = false;

	for _, v in pairs(target.Claims) do
		target:PS2_AddStandardPoints(
			math.Round((#target.Claims / v), 0), 
			"Argent.",
			true
		);

		LibC:Log(target:SteamID() .. " Got: " .. tostring(points));
		start = true;
	end

	if start then target.Claims[v:GetName()] = 0; end
end
