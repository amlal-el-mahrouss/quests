AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/zerochain/props_halloween/witchcauldron.mdl")
    self:SetPos(Vector(190.129089, -342.967682, 64.031250)) 
    self:SetAngles(Angle(-0.980034, 89.959778, 0.000000))
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()

		ParticleEffectAttach("soup_bubbles01", PATTACH_POINT_FOLLOW, self, 1);
		self.Sound = CreateSound( self, "cauldron_bubbling_loop.wav" );
		self.Sound:PlayEx( 0.5, 100 );
		self.Spell = Sound("sound/cauldron_magicspell.wav");
	end
end

function ENT:Use(ply)
	ply:SetPos(Vector((self:GetPos().x / 2), (self:GetPos().z / self:GetPos().y), self:GetPos().z));
	ply:Freeze(true);
	ply:SetAngles(-self:GetForward())

	-- DO LOGIC

	ply:Freeze(false);
end