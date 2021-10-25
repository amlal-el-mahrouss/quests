// Basic Coin with quests
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local curtime;

local function secTonMins(sec)
	return sec * 60;
end

local function metersToKilometers(meter)
	return meter * 1000;
end

local function hasMinPassed(min)
	return (CurTime() - min) == curtime;
end

ENT.DeactivationDelay = CurTime();
ENT.Conditions = {
	["KM"] = metersToKilometers(100),
	["MIN"] = secTonMins(120),
	["Frag"] = 10
}

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow(true)
	self:SetNoDraw(false)
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableGravity(false);
		phys:EnableDrag(false);
		phys:Wake();

		self.UseableUntil = math.Round((#team.GetPlayers(2) / 2), 0);

		if string.StartWith(util.DateStamp(), "2021-10-") then self:SetModel("models/halloween2015/pumbkin_n_f02.mdl") self:SetSkin(2) end
	end

	curtime = CurTime();
end

function ENT:Claim(target)
	if self.UseableUntil < 1 then self:Remove() end
	if !IsValid(target) || !self:ConditionAccomplished(target) then return end
	if !isnumber(target.Claims[self:GetName()]) || target.DeactivationDelay && CurTime() < target.DeactivationDelay then return end

	target.Claims[self:GetName()] = target.Claims[self:GetName()] + 1;
	target.DeactivationDelay = CurTime() + 10;

	self.UseableUntil = self.UseableUntil - 1;
	self:EmitSound("COIN.PICKUP");
end

function ENT:Use(target)
	if ( self:IsPlayerHolding() ) then return end
	target:PickupObject( self );

	target.Condition["MIN"] = CurTime() - curtime; 
	self:ConditionAccomplished(target)
	target.DeactivationDelay = CurTime() + 2;
end

function ENT:ConditionAccomplished(target)
	if !target.Condition then return false end

	for k, v in pairs(self.Conditions) do
		if target.Condition[k] >= v then target.Condition[k] = false return true end
	end

	return false;
end

hook.Add("PlayerDeath", "Condition::Frag", function(victim, _, attacker)
	if attacker:GetMurderer() then
		if !attacker.Condition["Frag"] then attacker.Condition["Frag"] = 1 else
			attacker.Condition["Frag"] = attacker.Condition + 1;
		end
	end
end)