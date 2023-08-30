Players = game:GetService('Players')

return function(hrp: Part)
	local playerMagnitudes = { }
	
	for i,v in Players:GetPlayers() do
		if not v.Character then continue end
		
		local rootpart: Part = v.Character:WaitForChild('HumanoidRootPart')
		local humanoid: Humanoid = v.Character:FindFirstChild('Humanoid')
		
		table.insert(playerMagnitudes, { player = v, magnitude = (hrp.Position - rootpart.Position).Magnitude })
	end
	
	table.sort(playerMagnitudes, function(p1, p2)
		return p1.magnitude < p2.magnitude
	end)
	
	return playerMagnitudes[1]
end
