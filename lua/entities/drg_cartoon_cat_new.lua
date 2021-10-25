if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Cartoon Cat(OLD)"
ENT.Category = "Trevor Henderson(OLD)"
ENT.Models = {"models/trevor_henderson/cartoon_cat/cartoon_cat_vb.mdl"}
ENT.BloodColor = BLOOD_COLOR_RED
ENT.CollisionBounds = Vector(17.5, 17.5, 90)
ENT.RagdollOnDeath = true

-- Sounds --
ENT.OnIdleSounds = {
	""
}

ENT.OnIdleSoundDelay = 80

-- Stats --
ENT.SpawnHealth = 500
ENT.DamageMultipliers = {}

-- AI --
ENT.RangeAttackRange = 1000
ENT.MeleeAttackRange = 100
ENT.ReachEnemyRange = 100
ENT.AvoidEnemyRange = 50

-- Relationships --
ENT.Factions = {"FACTION_CARTOONMONSTER"}
ENT.Frightening = true

-- Animations --
ENT.WalkAnimation = "walk_angry"
ENT.RunAnimation = "run_angry"
ENT.IdleAnimation = "idle_angry"
ENT.JumpAnimation = "fall"

-- Movements --
ENT.WalkSpeed = 100
ENT.RunSpeed = 300

-- Detection --
ENT.EyeBone = "head"
ENT.EyeOffset = Vector(10, 0, 1)
ENT.EyeAngle = Angle(0, 0, 0)

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
	{
		offset = Vector(0, 30, 20),
		distance = 100
	},
	{
		offset = Vector(7.5, 0, 0),
		distance = 0,
		eyepos = true
	}
}
ENT.PossessionBinds = {
	[IN_ATTACK] = {{
		coroutine = true,
		onkeydown = function(self)
			local direction = self:CalcPosDirection(self:GetPos() + self:PossessorNormal(),false)self:PlaySequenceAndMove("attack"..math.random(4),1,self.PossessionFaceForward) end
	}},
	[IN_ATTACK2] = {{
		coroutine = true,
		onkeydown = function(self)
			self:PossessorNormal()
			self:FaceTowards(self:GetPos() + self:PossessorNormal())
			local ent = self:GetClosestEnemy()
			self:Grab(ent)
		end
	}},
	[IN_RELOAD] = {{
		coroutine = true,
		onkeydown = function(self)
			self:PlaySequenceAndMove("taunt"..math.random(3))
		end
	}},
	[IN_JUMP] = {{
		coroutine = true,
		onkeydown = function(self)
			self:Jump(500)
		end
	}}
}

if SERVER then

  -- Helpers --

function ENT:snd(a)
	self:EmitSound(a)
	self:EmitSound("re2/em6200/foley_long"..math.random(2)..".mp3")
end
function ENT:AttackFunction()
	self:Attack({
		damage = self:IsPossessed() and 800 or 90,
		viewpunch = Angle(40, 0, 0),
		type = DMG_CRUSH,range=100,angle=135,
	}, function(self, hit)
		if #hit == 0 then self:snd("re2/em6200/attack_swing"..math.random(5)..".mp3")return end 
		self:snd("re2/em6200/attack_hit"..math.random(5)..".mp3")
	end)
end

-- Init/Think --

function ENT:CustomInitialize()
	self:snd("music/stingers/HL1_stinger_song28.mp3")
	self:SetDefaultRelationship(D_HT, 1)
	self.ShotOffHat = false
	self.CanAttack = true
	self:SetAttack("attack1", true)
	self:SetAttack("attack2", true)
	self:SetAttack("attack3", true)
	self.BadBoy = true

	--// sequence events for ez sound playback
	local function stepsnd() self:snd("re2/em6200/step"..math.random(6)..".mp3") end
	
	self:SequenceEvent("3000",15/87,self.AttackFunction)
	self:SequenceEvent("3001",11/85,self.AttackFunction)
	
	self:SequenceEvent("3011",10/106,function()self:snd("re2/em6200/attack_swing"..math.random(5)..".mp3")end)
	self:SequenceEvent("3011",27/106,self.AttackFunction)
	self:SequenceEvent("3001",10/109,function()self:snd("re2/em6200/attack_swing"..math.random(5)..".mp3")end)
	self:SequenceEvent("3001",27/109,self.AttackFunction)
	
	self:SequenceEvent("taunt2",12/54,function()self:snd("re2/em6200/foley_taunt"..math.random(2)..".mp3")end)

	--// sequence events for ez sound playback
	
	self:SetName("CartoonCat_" .. self:EntIndex())
end
function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "step" then
		self:snd("re2/em6200/step"..math.random(6)..".mp3")
	end
	if e == "land" then
		self:snd("re2/em6200/land.mp3")
	end
	if e == "ladderclimb" then
		self:snd("re2/em6200/climb"..math.random(2)..".mp3")
	end
end

function ENT:DoorCode(door)
	if self:GetCooldown("MRXDoor") == 0 then
		self:SetCooldown("MRXDoor", 6)
		local doorseq,doordur = self:LookupSequence("9200")
		local doorseq2,doordur2 = self:LookupSequence("9201")
		if IsValid(door) and door:GetClass() == "prop_door_rotating" then
			self.CanOpenDoor = false
			self.CanAttack = false
			self:SetNotSolid(true)
			door:SetNotSolid(true)
			-- find ourselves to know which side of the door we're on
			local fwd = door:GetPos()+door:GetForward()*5
			local bck = door:GetPos()-door:GetForward()*5
			local pos = self:GetPos()
			local fuck_double_doors1 = door:GetKeyValues()
			local fuck_double_doors2 = nil
			if isstring(fuck_double_doors1.slavename) and fuck_double_doors1.slavename != "" then
				fuck_double_doors2 = ents.FindByName(fuck_double_doors1.slavename)[1]
			end

			if fwd:DistToSqr(pos) < bck:DistToSqr(pos) then -- entered from forward
				self:SetNotSolid(true)
				door:SetNotSolid(true)
				if isentity(fuck_double_doors2) then
					self:SetPos(door:GetPos()+(door:GetForward()*50)+(door:GetRight()*-50)+(door:GetUp()*-52))
				else
					self:SetPos(door:GetPos()+(door:GetForward()*80)+(door:GetRight()*-32)+(door:GetUp()*-52))
				end
				local ang = door:GetAngles()
				ang:RotateAroundAxis(Vector(0,0,1),180)
				self:SetAngles(ang)
			elseif bck:DistToSqr(pos) < fwd:DistToSqr(pos) then -- entered from backward
				self:SetNotSolid(true)
				door:SetNotSolid(true)
				if isentity(fuck_double_doors2) then
					self:SetPos(door:GetPos()+(door:GetForward()*-50)+(door:GetRight()*-50)+(door:GetUp()*-52))
				else
					self:SetPos(door:GetPos()+(door:GetForward()*-80)+(door:GetRight()*-12)+(door:GetUp()*-52))
				end
				local a = (door:GetAngles())
				a:Normalize()
				self:SetAngles(a)
			end
			-- find ourselves to know which side of the door we're on
			if (fwd:DistToSqr(pos) < bck:DistToSqr(pos)) or (bck:DistToSqr(pos) < fwd:DistToSqr(pos)) then

				self:SetNotSolid(true)
				door:SetNotSolid(true)
				door:Fire("setspeed",500)

				if isentity(fuck_double_doors2) then
					fuck_double_doors2:SetNotSolid(true)
					fuck_double_doors2:Fire("setspeed",500)

					self:Timer(7/30,function()
						self:EmitSound("doors/vent_open3.wav",511,math.random(50,80))
						door:Fire("openawayfrom",self:GetName())
						fuck_double_doors2:Fire("openawayfrom",self:GetName())
					end)
					self:Timer(doordur2,function()
						door:Fire("setspeed",100)
						door:Fire("close")
						fuck_double_doors2:Fire("setspeed",100)
						fuck_double_doors2:Fire("close")
						self:Timer(1,function()
							door:SetNotSolid(false)
							fuck_double_doors2:SetNotSolid(false)
							self.CanOpenDoor = true
							self.CanAttack = true
							self.CanFlinch = false
							self:SetNotSolid(false)
						end)
					end)
					self:PlaySequence("9201",{rate=1, gravity=true, collisions=false})
				else
					self:Timer(0.5,function()
						if !IsValid(self) then return end
						self:EmitSound("doors/vent_open3.wav",511,math.random(50,80))
						door:Fire("openawayfrom",self:GetName())
					end)
					self:Timer(doordur,function()
						if !IsValid(self) then return end
						door:Fire("setspeed",100)
						door:Fire("close")
						self:Timer(0.2,function()
							door:SetNotSolid(false)
							if !IsValid(self) then return end
							self.CanOpenDoor = true
							self.CanAttack = true
							self.CanFlinch = false
							self:SetNotSolid(false)
						end)
					end)
					self:PlaySequence("9200",{rate=1, gravity=true, collisions=false})
				end
			else
				self:Timer(1,function()
					door:SetNotSolid(false)
					self:Timer(1,function()
						if !IsValid(self) then return end
						self.CanOpenDoor = true
					end)
					if !IsValid(self) then return end
					self.CanAttack = true
					self.CanFlinch = false
					self:SetNotSolid(false)
				end)
			end
		end
	end
end

function ENT:OnContact(ent)
	if self:GetRelationship(ent) == D_LI then return end

	if !self:IsPossessed() and (self.CanAttack and (ent != self:GetEnemy()) and (ent:IsPlayer() or ent:IsNPC())) then
		self.CanAttack = false
		local velocity = Vector(0, 150, 50)
		local right = self:GetPos()+self:GetRight()*1
		local left = self:GetPos()-self:GetRight()*1
		local pos = ent:GetPos()
		if left:DistToSqr(pos) < right:DistToSqr(pos) then
			self:PlaySequence("g_puntR")
			self:Timer(0.4,function()
				local dmg = DamageInfo()
				dmg:SetDamage(100000)
				dmg:SetDamageForce(self:GetForward()* -velocity)
				dmg:SetDamageType(DMG_CLUB)
				dmg:SetAttacker(self)
				dmg:SetReportedPosition(self:GetPos())

				ent:SetVelocity(self:GetForward()* -velocity)
				ent:TakeDamageInfo(dmg)

				self:EmitSound("re2/em6200/attack_hit"..math.random(5)..".mp3",511,100)
			end)
		else
			self:PlaySequence("g_puntL2")
			self:Timer(0.4,function()
				local dmg = DamageInfo()
				dmg:SetDamage(100000)
				dmg:SetDamageForce(self:GetForward()*velocity)
				dmg:SetDamageType(DMG_CLUB)
				dmg:SetAttacker(self)
				dmg:SetReportedPosition(self:GetPos())

				ent:SetVelocity(self:GetForward()* velocity)
				ent:TakeDamageInfo(dmg)

				self:EmitSound("re2/em6200/attack_hit"..math.random(5)..".mp3",511,100)
			end)
		end
		self:Timer(1.4,function()self.CanAttack = true end)
	elseif (ent:IsPlayer() or ent:IsNPC() or ent.Type == "nextbot") 
	and (self:IsPossessed() and (ent != self:GetPossessor())) 
	and (ent:GetClass() != self:GetClass()) then
		self:CallInCoroutine(function(self,delay)
			if delay > 0.1 then return end
			if IsValid(self.PropGun) then self.PropGun:SetNoDraw(true) end
			local dmg = DamageInfo() dmg:SetAttacker(self)
			local ragdoll = ent:DrG_RagdollDeath(dmg)
			local mr = math.random(2)
			
			local actualragdoll = self:GrabRagdoll(ragdoll, "head", "tag_ragdoll_attach")
				self:snd("re2/em6200/climb"..math.random(2)..".mp3")
				if ent:IsPlayer() then ent:SetPos(self:GetPos() + (self:GetForward()*120) + Vector(0,0,40)) end
			self:Timer(0.8,function()
				self:snd("re2/em6200/attack_swing"..math.random(5)..".mp3")
				self:DropRagdoll(actualragdoll)
				local phy = actualragdoll:GetPhysicsObject()
				if IsValid(phy) then
					if mr == 1 then
						phy:ApplyForceCenter((self:GetForward()*409600)+(self:GetRight()*512))
					else
						phy:ApplyForceCenter((self:GetForward()*409600)+(self:GetRight()*-512))
					end
				end
				actualragdoll:Fire("fadeandremove",1,10)
			end)
			self:PlaySequenceAndMove((mr==1 and "3011" or "3011"),0.75)
			if IsValid(self.PropGun) then self.PropGun:SetNoDraw(false) end
			self:PlaySequenceAndMove("taunt"..math.random(3))
		end)
	end	
end

function ENT:CustomThink()
	for k,ball in pairs(ents.FindInSphere(self:LocalToWorld(Vector(0,0,75)), 100)) do
		if IsValid(ball) then
			if ball:GetClass() == "prop_door_rotating" then self:DoorCode(ball) end
			if ball:GetClass() == "func_door_rotating" then ball:Fire("Open") end
			if ball:GetClass() == "func_door" then ball:Fire("Open") end
			if ball:GetClass() == "func_breakable" then self:PlaySequence("g_puntR") ball:Fire("Break") end

			if ball:GetClass() == "trigger_multiple" && ball:GetName("Cartoon_Cat_Trigger") then
				self.loco:JumpAcrossGap(ball:GetPos(), Vector(100, 100, 100))
			end
		end
	end
end

function ENT:Grab(ent)
	local grabbed = false
	local succeed = false
	self:EmitSound("trevor_henderson/cartoon_cat/roar2.wav")
	self:PlaySequenceAndMove("grab", 1, function(self, cycle)
		if grabbed or cycle < 0.28571428571429 then return end
		grabbed = true
		if not IsValid(ent) then return end
		if self:GetHullRangeSquaredTo(ent) > 50^2 then return end
		succeed = true
		
		local dmg = DamageInfo() dmg:SetAttacker(self)
		local ragdoll = ent:DrG_RagdollDeath(dmg)
		
		actualragdoll = self:GrabRagdoll(ragdoll, "head", "tag_ragdoll_attach")
		if ent:IsPlayer() then ent:SetPos(self:GetPos() + (self:GetForward()*60) + Vector(0,0,60)) end
		return true
	end)
	if succeed then
		if math.random(2) == 1 then
			self:PlaySequenceAndMove("execution1")
			self:EmitSound("trevor_henderson/cartoon_cat/roar3.wav")
			self:Timer(27/30,function()
				self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav",511,100)
				ParticleEffectAttach("blood_advisor_puncture",PATTACH_POINT_FOLLOW,self,3)
				for i=1,math.random(5,10) do ParticleEffectAttach("blood_impact_red_01",PATTACH_POINT_FOLLOW,self,3) end
				self:DropRagdoll(actualragdoll)
				actualragdoll:Fire("fadeandremove",1,10)
				actualragdoll:ManipulateBoneScale(actualragdoll:LookupBone("ValveBiped.Bip01_Head1"), Vector(0,0,0))
				
				if (ent:IsPlayer() and !ent:Alive()) then
					ent:ScreenFade(SCREENFADE.IN,Color(255,0,0,255),0.3,0.2)
					self:snd("player/pl_pain"..math.random(5,7)..".wav",511,100)
				end
			end)
			self:PlaySequenceAndMove("slap1")
			self:EmitSound("trevor_henderson/cartoon_cat/roar4.wav")
			self:PlaySequenceAndMove("taunt"..math.random(3))
		else
			if IsValid(self.PropGun) then self.PropGun:SetNoDraw(true) end
			self:Timer(35/30,function()
				self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav",511,100)
				ParticleEffectAttach("blood_advisor_puncture",PATTACH_POINT_FOLLOW,self,3)
				for i=1,math.random(5,10) do ParticleEffectAttach("blood_impact_red_01",PATTACH_POINT_FOLLOW,self,3) end
				self:DropRagdoll(actualragdoll)
				actualragdoll:Fire("fadeandremove",1,10)
				actualragdoll:ManipulateBoneScale(actualragdoll:LookupBone("ValveBiped.Bip01_Head1"), Vector(0,0,0))
				
				if (ent:IsPlayer() and !ent:Alive()) then
					ent:ScreenFade(SCREENFADE.IN,Color(255,0,0,255),0.3,0.2)
					self:snd("player/pl_pain"..math.random(5,7)..".wav",511,100)
				end
			end)
			self:PlaySequenceAndMove("ragdoll_grabB2")
			self:EmitSound("trevor_henderson/cartoon_cat/roar4.wav")
			if IsValid(self.PropGun) then self.PropGun:SetNoDraw(false) end
			self:PlaySequenceAndMove("taunt"..math.random(2))
		end
	end
end

function ENT:OnMeleeAttack(enemy)
	if !self.CanAttack then return end
	
	if enemy:Health() < (enemy:GetMaxHealth()*0.25) then
		if enemy.VJ_IsHugeMonster then
			self:PlaySequenceAndMove("slap"..math.random(2),1,self.FaceEnemy)
		else
			self:Grab(enemy)
		end
	else
		self:PlaySequenceAndMove("attack"..math.random(4),1,self.FaceEnemy)
	end
	if enemy.VJ_IsHugeMonster then
		local velocity = Vector(0, 150, 50)
		local right = self:GetPos()+self:GetRight()*1
		local left = self:GetPos()-self:GetRight()*1
		local pos = enemy:GetPos()
		local dmg = DamageInfo()
		dmg:SetDamage(100)
		dmg:SetDamageForce(self:GetForward()* -velocity)
		dmg:SetDamageType(DMG_CLUB)
		dmg:SetAttacker(self)
		dmg:SetReportedPosition(self:GetPos())

		enemy:SetVelocity(self:GetForward()* -velocity)
		enemy:TakeDamageInfo(dmg)
	end
end

function ENT:OnNewEnemy(enemy)
	self:EmitSound("trevor_henderson/cartoon_cat/ambience.wav")
	self:CallInCoroutine(function(self, delay)
		if delay > 0.1 then return end
		if not IsValid(enemy) then return end
		if not self:Visible(enemy) then return end
	end)
end

function ENT:OnReachedPatrol(pos)
	self:Wait(math.random(2, 4))
end

function ENT:OnIdle()
	self:AddPatrolPos(self:RandomPos(1500))
end

function ENT:OnLandOnGround()
	self:CallInCoroutine(function(self, delay)
	if delay > 0.1 then return end
		self:snd("re2/em6200/land.mp3")
		self:PlaySequenceAndMove("taunt1")
	end)
	end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
