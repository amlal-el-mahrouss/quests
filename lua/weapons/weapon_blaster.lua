-- Halloween Revolver
-- model: models/halloween2015/pumbkin_n_f00.mdl
-- skin: 13
AddCSLuaFile()

if CLIENT then
	local mat = Material("vgui/entities/bonbon01");

	function SWEP:DrawWeaponSelection( x, y, w, h, alpha )
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(x, y, w, h)
	end
end

SWEP.PrintName = "Blasteur"
SWEP.Author = "ALTernative"
SWEP.Purpose = "C'est un faux pistolet qui te permet de capturer des quêtes"

SWEP.Slot = 5
SWEP.SlotPos = 2

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/mercy/c_mercy_nope.mdl" )
SWEP.WorldModel = Model( "models/weapons/mercy/w_mercy_blaster.mdl" )
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

if (SERVER) then
	SWEP.LockDelay = CurTime()
end

SWEP.DrawAmmo = false 

local AttackSound = Sound( "fireworks/mortar_fire.wav" )

function SWEP:Initialize()

	self:SetHoldType( "revolver" )

end

function SWEP:PrimaryAttack()
	if CurTime() > self.Weapon:GetNextPrimaryFire() then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		local anim = "shoot"
		local vm = self.Owner:GetViewModel()
		vm:ResetSequence( vm:LookupSequence( anim ) )
	
		self:EmitSound( AttackSound )
		self:DealDamage()
	
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "reload" ) )
		vm:SetPlaybackRate( 1 )
		self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:DealDamage()
	self.Owner:LagCompensation( true )

	local tr = util.TraceHull( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 700 ),
		filter = self.Owner,
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		mask = MASK_SHOT_HULL
	} )

	
	self.Owner:LagCompensation( false )

	local col = Color(255, 255, 255); 
    local part = EffectData();

	if IsValid(tr.Entity) then
		col = Color(223, 119, 50);
		
		part:SetOrigin( tr.Entity:GetPos() )
		part:SetStart(Vector(col.r, col.g, col.b))
		part:SetScale( 1 )
		util.Effect("sweetspickup", part)

		if SERVER && IsValid(tr.Entity) then
			if tr.Entity:GetClass() == "quest" then
				tr.Entity:Claim(self.Owner) -- this owner claims the quest
				self.LockDelay = CurTime() + 5 
			elseif tr.Entity:GetClass() == "cauldron" then
				tr.Entity:DropCauldron(self.Owner)
				self.LockDelay = CurTime() + 10
			end
		end
	else
	    part:SetOrigin( tr.HitPos )
		part:SetStart(Vector(col.r, col.g, col.b))
		part:SetScale( 1 )
		util.Effect( "sweetspickup", part)
	end

end

function SWEP:OnDrop()
	self:Remove() -- You can't drop fists
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "draw" ) )
	vm:SetPlaybackRate( 1 )

	self.Weapon:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() / 1 ) 

	if SERVER && !istable(self.Owner.Claims) then self.Owner.Claims = {}; end
	return true
end