AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/zerochain/props_halloween/witchcauldron.mdl");
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_FLYGRAVITY );
	self:SetSolid( SOLID_VPHYSICS );
	self.Items = {}

	for i, v in pairs( Pointshop2.GetRegisteredItems() ) do
		self.Items[i] = {
			chance = math.random(i, 100) / 100,
			classname = v.className,
			ranks = string.StartWith(v.className, "csgo_") && "vip" || "user"
		}
	end

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
	-- he can gets a random value of coins between 5 or 100.
	if ent:GetClass() == "coin" && owner:IsPlayer() then owner:PS2_AddStandardPoints(math.random(5, 100), "Recompense monétaire.", true) ent:Remove() end
end

-- or he can get random items from it.
function ENT:Use(ply)
	if !ply:IsPlayer() || !ply:GetNWBool("QuestCompleted", false) then return end

	ply:Freeze(true);
	ply:SetPos(Vector(self:GetPos().x, (self:GetPos().z / self:GetPos().y), self:GetPos().z));
	ply:SetVelocity(Vector(0, (self:GetPos().y / self:GetPos().z) * 1.5, 0));

	local roll = math.random(1, 100) / 100;
	local item = table.Random( self.Items );
	if ply:IsSuperAdmin() || ply:IsUserGroup(item.ranks) && roll >= item.chance then ply:PS2_EasyAddItem( item.classname ); end

	ply:Freeze(false);
	ply:SetNWBool("QuestCompleted", false);
end