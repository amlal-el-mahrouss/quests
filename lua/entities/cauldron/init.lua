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

function ENT:Touch(ent)
	local owner = ent:GetOwner();
	if ent:GetClass() == "coins" && owner:IsPlayer() then owner:PS2_AddStandardPoints(100, "Récompense de quête.", true) self:Remove(); end
end

function ENT:Use(ply)
	ply:Freeze(true);
	ply:SetPos(Vector(self:GetPos().x, (self:GetPos().z / self:GetPos().y), self:GetPos().z));
	ply:SetVelocity(Vector(0, (self:GetPos().y / self:GetPos().z) * 2, 0));

	ply:Freeze(false);
end