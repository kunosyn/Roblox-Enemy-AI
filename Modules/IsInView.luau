AIConfig = require(script.Parent.Parent.AIConfiguration)
viewObstructed = require(script.Parent.ViewObstructed)

return function(ai: Model, character: Model, hrp: Part, noRaycast: boolean?)
	if not ai then return false end
	if noRaycast == nil then noRaycast = false end
	
	local head: Part = ai:WaitForChild('Head')
	local aiHRP = ai:WaitForChild('HumanoidRootPart')
	
	local lookVector = aiHRP.CFrame.LookVector
	local lookToPoint = (hrp.Position - aiHRP.Position).Unit
	
	local angle = math.acos(math.clamp(lookVector:Dot(lookToPoint), -1, 1))
	
	if not noRaycast then
		return ((math.abs(angle) <= (math.rad(AIConfig.fov) / 2)) and not viewObstructed(ai, character, hrp))
	else 
		return (math.abs(angle) <= (math.rad(AIConfig.fov) / 2))
	end
end
