
include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	cam.Start3D2D(self:GetPos(), self:GetAngles(), 2)
		surface.DrawCircle(self:GetPos().x / 2, self:GetPos().z / self:GetPos().y, 32, 0, 255, 0, 155);
	cam.End3D2D();
end