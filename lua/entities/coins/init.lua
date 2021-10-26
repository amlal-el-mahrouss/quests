// Basic Coin with quests
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local curtime;


ENT.DeactivationDelay = CurTime();

function ENT:Initialize()
	self:PhysicsInit( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_BBOX )
	self:DrawShadow(true)
	
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableGravity(false);
		phys:EnableDrag(false);
		phys:Wake();

		self.UseableUntil = math.Round((#team.GetPlayers(2) / 2), 0);
		self.PickupSound = "COIN.PICKUP";

		if string.StartWith(util.DateStamp(), "2021-10-") then 
			self.PickupSound = "COIN.PICKUP.HALLOWEEN" 
			self:SetModel("models/halloween2015/pumbkin_n_f02.mdl") 
			self:SetSkin(2) 
		end
	end
end

function ENT:Use(target)
	if self.UseableUntil < 1 then self:Remove() end
	if CurTime() < self.DeactivationDelay then return end

	target.Claims[self:GetName()] = target.Claims[self:GetName()] + 1;
	self.DeactivationDelay = CurTime() + 10;

	self.UseableUntil = self.UseableUntil - 1;
	self:EmitSound(self.PickupSound);
end
