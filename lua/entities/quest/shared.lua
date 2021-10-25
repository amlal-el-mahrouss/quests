

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Piêce."
ENT.Author			= "ALTernative"
ENT.Contact			= "N/A"
ENT.Purpose			= "Une pièce comme les autres.."
ENT.Instructions	= ""

ENT.Spawnable = false

local EatSound = Sound("sound/cauldron_magicspell.wav");

function ENT:OnRemove()
	local col = Color(136, 93, 24);
	sound.Play( EatSound, self:GetPos(), 75, 100,1)
	sound.Play( "garrysmod/balloon_pop_cute.wav", self:GetPos(), 75, 60, 0.3 )

	local part = EffectData();
	part:SetOrigin( self:GetPos())
	part:SetStart(Vector(col.r, col.g, col.b))
	part:SetScale( 1 )
	util.Effect("sweetspickup", part)
end
