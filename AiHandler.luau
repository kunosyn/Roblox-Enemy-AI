RunService = game:GetService('RunService')
Players = game:GetService('Players')
PathFindingService = game:GetService('PathfindingService')

modules = script:WaitForChild('Modules')
getNearestPlayer = require(modules.GetNearestPlayer)
isInView = require(modules.IsInView)
aiConfiguration = require(script.AIConfiguration)


local rig = script.Parent
local head = rig:WaitForChild('Head')
local aiHrp = rig:WaitForChild('HumanoidRootPart')
local aiHumanoid: Humanoid = rig:WaitForChild('Humanoid')

aiHumanoid.WalkSpeed = aiConfiguration.walkspeed
aiHrp:SetNetworkOwner(nil)

local target: Part | nil = nil
local targetHumanoid: Humanoid | nil = false
local pathfinding: boolean = false
local damageTarget: boolen = false
local chaseElapsed: number = 0


-- Targetting Coroutine
coroutine.wrap(function()
	while wait(0.1) do
		local nearest = getNearestPlayer(aiHrp)
		
		if nearest ~= nil then
			local character = nearest.player.Character
			local hrp: Part = character:WaitForChild('HumanoidRootPart')
			local huamnoid: Humanoid = character:WaitForChild('Humanoid')
			
			local distance = (aiHrp.Position - hrp.Position).Magnitude
	
			
			if chaseElapsed < 10 then
				if isInView(rig, target, hrp) and distance <= aiConfiguration.snapOnDistance then
					target = hrp
					aiHumanoid.WalkSpeed = aiConfiguration.chaseSpeed
				elseif not isInView(rig, target, hrp, true) and distance <= aiConfiguration.behindTargetDistance then
					target = hrp
					aiHumanoid.WalkSpeed = aiConfiguration.chaseSpeed
				end
			end
				
			if target then
				if distance >= aiConfiguration.targetInterestDistance then 
					target = nil
					targetHumanoid = nil
					damageTarget = false
					chaseElapsed = 0
					
					aiHumanoid.WalkSpeed = aiConfiguration.walkspeed
				end
			end
		end
	end
end)()

-- Movement Coroutine
coroutine.wrap(function()
	while wait(0.1) do
		if target ~= nil then
			local character = target.Parent
			targetHumanoid = character:WaitForChild('Humanoid')
			
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = { rig }
			
			local raycast = workspace:Raycast(head.Position, (target.Position - aiHrp.Position), params)
			
			if raycast and raycast.Instance:IsDescendantOf(target.Parent) then
				if (target.Position - aiHrp.Position).Magnitude < 4 then
					aiHumanoid:MoveTo(aiHrp.Position)
					damageTarget = true
				else
					aiHumanoid:MoveTo(target.Position)
					damageTarget = false
				end
			else
				pathfinding = true
				
				local path: Path = PathFindingService:CreatePath({
					AgentCanJump = true,
					AgentHeight = 4,
					AgentRadius = 2.5
				})
				
				path:ComputeAsync(aiHrp.Position, target.Position)
			
				local waypoints = path:GetWaypoints()
			
				for i,v in waypoints do
					if not target then break end
					if isInView(rig, target.Parent, target) then break end
					
					if v.Action == Enum.PathWaypointAction.Jump then
						aiHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
					
					aiHumanoid:MoveTo(v.Position)
					aiHumanoid.MoveToFinished:Wait()
				end
				
				pathfinding = false
			end
		else
			while not target do
				wait(2)
				
				local x = math.random(-15, 15)
				local z = math.random(-15, 15)
				local destination = aiHrp.Position + Vector3.new(x, 0, z)
				
				aiHumanoid:MoveTo(destination)
				aiHumanoid.MoveToFinished:Wait()
			end
		end
	end
end)()

coroutine.wrap(function()
	while wait(1) do
		if target ~= nil then
			chaseElapsed += 1
		else
			chaseElapsed = 0
		end
	end
end)

coroutine.wrap(function()
	while wait(0.2) do
		if damageTarget and targetHumanoid ~= nil then
			targetHumanoid:TakeDamage(10)
		end
	end
end)()
