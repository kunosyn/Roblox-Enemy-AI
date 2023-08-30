return function(ai: Model, character: Model, part: Part)
	if not ai then return true end
	
	local origin = ai:WaitForChild('HumanoidRootPart')
	local direction = (part.Position - origin.Position)
	local params = RaycastParams.new()
	
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { ai }
	
	local raycast = workspace:Raycast(origin.Position, direction, params)
	
	if not raycast then return true end
	return not raycast.Instance:IsDescendantOf(character)
end
