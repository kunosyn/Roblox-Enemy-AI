UserInputService = game:GetService('UserInputService')
TweenService = game:GetService('TweenService')
Players = game:GetService('Players')

local player: Player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local character = player.Character
if character == nil or character.Parent == nil then
	character = player.CharacterAdded:Wait()
end

local humanoid: Humanoid = character:WaitForChild('Humanoid')

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	if input.KeyCode == Enum.KeyCode.LeftShift then
		humanoid.WalkSpeed = 24
		
		TweenService:Create(camera, TweenInfo.new(0.05), { FieldOfView = 80 }):Play()
	end
end)

UserInputService.InputEnded:Connect(function(input, processed)
	if processed then return end

	if input.KeyCode == Enum.KeyCode.LeftShift then
		humanoid.WalkSpeed = 16
		TweenService:Create(camera, TweenInfo.new(0.05), { FieldOfView = 70 }):Play()
	end
end)
