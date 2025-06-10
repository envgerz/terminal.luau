--[[
	Author		@envgerr (691542738)
	Date		09/12/24 (DD, MM, YY)
	Version		3.0
	
	This script handles the whole functionality and visuals of the terminal.
]]


local ReplicatedStorage, SoundService, TweenService, RunService = game:GetService("ReplicatedStorage"), game:GetService("SoundService"), game:GetService("TweenService"), game:GetService("RunService")


local Fusion, Spring, Signal, Mouse = require(ReplicatedStorage.Modules.Fusion), require(ReplicatedStorage.Modules.Spring), require(ReplicatedStorage.Modules.Signal), require(ReplicatedStorage.Modules.Mouse)

local SystemData = require(ReplicatedStorage.Components.Data.SystemData)

local RefreshInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0)

local OpenSound = ReplicatedStorage.Components.Sounds.blip2
local Keys = ReplicatedStorage.Components.Sounds.Keys
local Hum = ReplicatedStorage.Components.Sounds.hum

local UI = shared.UI

local Children, Scoped = Fusion.Children, Fusion.scoped

local RND = Random.new()

local Terminal = {
	MessageAdded = Signal.new(),
	Visible = false,
	
	Container = shared.UI.Scope:New "Frame" {
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.new(),
		Visible = false,
		Parent = UI.HUD,
		ZIndex = 15,
		Size = UDim2.fromScale(1, 1),
		
		[Children] = {
			shared.UI.Scope:New "Frame" {
				BackgroundTransparency = 1,
				--ClipsDescendants = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.85, 0.85),

				[Children] = {
					shared.UI.Scope:New "Frame" {
						BackgroundTransparency = 0.25,
						BackgroundColor3 = Color3.new(),
						Size = UDim2.fromScale(1, 0.94),
						Name = "Messages",

						[Children] = {
							shared.UI.Scope:New "UIPadding" {},

							shared.UI.Scope:New "UIStroke" {
								Transparency = 0.4,
								Color = Color3.fromRGB(70, 70, 70),

								[Children] = script.UIGradient:Clone()
							},

							shared.UI.Scope:New "Frame" {
								BackgroundTransparency = 1,
								ClipsDescendants = true,
								Size = UDim2.fromScale(1, 1),

								[Children] = shared.UI.Scope:New "UIListLayout" {
									VerticalAlignment = Enum.VerticalAlignment.Bottom
								}
							}
						}
					},

					[Children] = shared.UI.Scope:New "Frame" {
						BackgroundTransparency = 0.25,
						BackgroundColor3 = Color3.new(),
						AnchorPoint = Vector2.new(0, 1),
						Position = UDim2.fromScale(0, 1),
						Size = UDim2.fromScale(1, 0.045),
						Name = "Input",

						[Children] = {
							shared.UI.Scope:New "TextBox" {
								BackgroundTransparency = 1,
								PlaceholderColor3 = Color3.fromRGB(130, 130, 130),
								TextTransparency = 0.35,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = Color3.fromRGB(160, 160, 160),
								FontFace = Font.fromName("Inconsolata"),
								Size = UDim2.fromScale(1, 1),

								[Children] = {
									shared.UI.Scope:New "UIPadding" {
										
									},
								}
							},

							shared.UI.Scope:New "UIStroke" {
								Transparency = 0.4,
								Color = Color3.fromRGB(70, 70, 70),
								
								[Children] = script.UIGradient:Clone()
							}
						}
					},

					shared.UI.Scope:New "ImageLabel" {
						BackgroundTransparency = 1,
						ImageTransparency = 0.675,
						ImageColor3 = Color3.new(0.6, 0.6, 0.6),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						ZIndex = 999,
						Image = "rbxassetid://10906540366",
						Size = UDim2.fromScale(1.4, 1.4),
					},
					
					shared.UI.Scope:New "Frame" {
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						Size = UDim2.fromScale(1, 0.94),
						
						[Children] = shared.UI.Scope:New "Frame" {
							BackgroundTransparency = 0.875,
							BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
							AnchorPoint = Vector2.new(0, 1),
							Size = UDim2.fromScale(1, 0.35),

							[Children] = script.UIGradient2:Clone()
						}
					}
				}
			},
			
			shared.UI.Scope:New "TextButton" {
				Size = UDim2.fromScale(0, 0),
				Name = "Modal",
				Modal = true
			},
			
			shared.UI.Scope:New "ImageLabel" {
				BackgroundTransparency = 1,
				ImageTransparency = 0.945,
				ImageColor3 = Color3.fromRGB(118, 118, 118),
				ScaleType = Enum.ScaleType.Tile,
				Position = UDim2.fromScale(0, -1),
				TileSize = UDim2.fromScale(1, 0.25),
				ZIndex = 9999,
				Image = "rbxassetid://373648642",
				Size = UDim2.fromScale(1, 2),
				Name = "Static"
			},
			
			shared.UI.Scope:New "ImageLabel" {
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.new(0, 0, 0),
				ImageTransparency = 0,
				ImageColor3 = Color3.new(0.6, 0.6, 0.6),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				ZIndex = 101,
				Image = "rbxassetid://10906540366",
				Name = "Glow",
				Size = UDim2.fromScale(1.3, 1.3),
			},
			
			shared.UI.Scope:New "ImageLabel" {
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.new(0, 0, 0),
				ImageTransparency = 0,
				ImageColor3 = Color3.new(0.6, 0.6, 0.6),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				ZIndex = 100,
				Image = "rbxassetid://16251201192",
				Size = UDim2.fromScale(1.3, 1.3),
			},
		}
	},
	
	AwaitList = {},
	Commands = {},
	Messages = {},
}


--[[
	@return		void
	
	Plays a random keystroke sound.
]]
local function PlayKey()
	local Sound = shared.Utilities.GetRandom(Keys:GetChildren())
	
	SoundService:PlayLocalSound(Sound)
end


--[[
	@param		TextFrame		Frame		|	The Text to scale.
	@return		void
	
	Scales a text by getting the absolutesize of the frame.
]]
local function ScaleText(TextFrame)
	TextFrame.TextLabel.TextSize = shared.Utilities.GetScale(Terminal.MessageContainer).Y * TextFrame.Size.Y.Scale
end


--[[
	@param		TextFrame		Frame		|	The Text to fade in.
	@return		void
	
	Slowly makes the text visible.
]]
local function FadeIn(TextFrame)
	Spring.target(TextFrame.TextLabel, 1, 4, {
		TextTransparency = 0.45
	})
end


--[[
	@param		Text			string		|	The text to be used.
	@return		void
	
	Creates a new text, scales it, makes it visible.
]]
local function NewText(Text)
	local TextFrame = UI.TextSample:Clone()
	
	ScaleText(TextFrame)
	FadeIn(TextFrame)
	
	TextFrame.TextLabel.Text = Text
	TextFrame.Parent = Terminal.MessageContainer
end


--[[
	@param Message {} | The message to retrieve it's components from.
	@return Command, Arguments string, {} | The retrieved components.
	
	Retrieves command, which is the first argument, and the argument(s) which is the rest of the arguments.
]]
local function GetComponents(Text)
	local Arguments = Text:split(" ")
	local Command = table.remove(Arguments, 1)

	while table.find(Arguments, "") do
		table.remove(Arguments, table.find(Arguments, ""))
	end

	return Command, Arguments
end


--[[
	@param		Message			string		|	The command to find.
	@param		Arguments		{string}	|	One or more arguments that come after the message.
	@return		void
	
	Tries to find a command with Message, and runs its function, if existent.
]]
local function RunCommand(Message, Arguments)
	local Command = Terminal.Commands[Message:lower()]
	
	if Command then
		Command.Callback(Arguments)
	else
		NewText(`\n{Message}\nInvalid command, type "help" for a list of commands.`)
	end
end


--[[
	@return		void
	
	Checks if the message on the textbox is on a waiting list, if so, then the wait list function is fired, and the function is aborted, otherwise the Message is processed with RunCommand.
]]
local function ProcessText()
	if Terminal.InputBox.Text ~= "" then
		for Index, Value in Terminal.AwaitList do
			if table.find(Value.Await, Terminal.InputBox.Text:lower()) then
				Value.Callback(Terminal.InputBox.Text:lower())
				
				Terminal.AwaitList[Index] = nil
				
				return
			end
		end
		
		local Command, Arguments = GetComponents(Terminal.InputBox.Text)

		RunCommand(Command, Arguments)
		
		Terminal.InputBox.Text = ""
	end
end


--[[
	@param Message string or {} | the string(s) to search for
	@return void
	
	Adds the string(s) to the awaiting list.
]]
local function AwaitMessage(Message, Callback)
	if type(Message) == "table" then
		for Index, Value in Message do
			Message[Index] = Value:lower()
		end
	else
		Message = {
			Message:lower()
		}
	end

	table.insert(Terminal.AwaitList, {
		Callback = Callback,
		Await = Message,
	})
end


local function FadeHum(In)
	Spring.target(Hum, 1, 2, {
		Volume = In and 0.025 or 0
	})
	
	Spring.completed(Hum, function()
		if not In then
			Hum:Stop()
		end
	end)
end


--[[
	@return		void
	
	Makes the terminal visible or not visible.
]]
local function Toggle()
	Terminal.Visible = not Terminal.Visible
	Terminal.Container.Modal.Modal = Terminal.Visible

	Terminal.Container.Visible = Terminal.Visible
	
	if Terminal.Visible then
		Terminal.Container.Visible = true
		
		SoundService:PlayLocalSound(OpenSound)
		FadeHum(true)
		Hum:Play()

		Spring.stop(Terminal.Container.ImageLabel)
		Spring.stop(Terminal.Container.Glow)

		Terminal.Container.ImageLabel.ImageTransparency = 1
		Terminal.Container.ImageLabel.BackgroundTransparency = 0
		Terminal.Container.Glow.ImageTransparency = 0

		Spring.target(Terminal.Container.ImageLabel, 1, 8, {
			ImageTransparency = 0,
		})

		Spring.completed(Terminal.Container.ImageLabel, function()
			Spring.target(Terminal.Container.ImageLabel, 1, 2, {
				BackgroundTransparency = 1,
				ImageTransparency = 1,
			})
			
			Spring.target(Terminal.Container.Glow, 1, 1, {
				BackgroundTransparency = 1,
				ImageTransparency = 1,
			})
		end)
	else
		FadeHum(false)
	end
end


--[[
	@param		Name			string		|		The name of the command
	@param		Description		string		|		The description of the command.
	@param		Callback		(any) -> ()	|		The function to call when the command is fired.

	Makes a command and stores it with given arguments.
]]
local function Command(Name, Description, Callback)
	Terminal.Commands[Name:lower()] = {
		Description = Description,
		Callback = Callback,
		Name = Name,
	}
end


do
	Terminal.MessageContainer = Terminal.Container.Frame.Messages.Frame
	Terminal.InputBox = Terminal.Container.Frame.Input.TextBox
	Terminal.InputBox.TextSize = shared.Utilities.GetScale(Terminal.MessageContainer).Y * 0.035
	
	local Offset = shared.Utilities.GetScale(Terminal.InputBox) * 0.01
	
	Terminal.InputBox.UIPadding.PaddingLeft = UDim.new(0, Offset.X)
	Terminal.MessageContainer.Parent.UIPadding.PaddingLeft = UDim.new(0, Offset.X)
	Terminal.MessageContainer.Parent.UIPadding.PaddingBottom = UDim.new(0, Offset.X)
	Terminal.MessageContainer.Parent.UIPadding.PaddingTop = UDim.new(0, Offset.X)

	Terminal.InputBox:GetPropertyChangedSignal("Text"):Connect(PlayKey)

	Terminal.InputBox.FocusLost:Connect(function(EnterPressed)
		if EnterPressed then
			ProcessText()
		end
	end)
	
	Terminal.MessageAdded:Connect(function(Message)
		for Index, Value in Terminal.AwaitList do
			if table.find(Value.Await, Message) then
				Value.Callback(Message)

				table.clear(Terminal.AwaitList[Index])
			end
		end
	end)
	
	RunService.RenderStepped:Connect(function()
		Terminal.Container.Frame.ImageLabel.ImageTransparency = 0.725 - (RND:NextNumber(-0.03, 0.03))
		Terminal.Container.Static.Position = UDim2.fromScale(0, RND:NextNumber(-1, 0))
	end)
	
	Mouse.Button1Up:Connect(function()
		Toggle()
	end)
	
	TweenService:Create(Terminal.Container.Frame.Frame.Frame, RefreshInfo, {
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromScale(0, 1)
	}):Play()
	
	do
		Command(
			"exit",
			"Close the terminal.",
			Toggle
		)
		
		Command(
			"help",
			"Shows information about commands",
			
			function(Arguments)
				if Arguments[1] then
					if Terminal.Commands[Arguments[1]] then
						NewText(`\n* {Arguments[1]:lower()} - {Terminal.Commands[Arguments[1]].Description}`)
					else
						NewText(`\nCommand "{Arguments[1]:lower()}" not found.`)
					end
				else
					NewText(`\nTo get more information about a command, use the \ndesired command as an argument with help\neg:"help info"\n`)
					
					for Index, Value in Terminal.Commands do
						NewText(`* {Index}`)
					end
				end
			end
		)
		
		Command(
			"info",
			"Shows information about an item or planet.",

			function(Arguments)
				if Arguments[1] then
					--local Item = ReplicatedStorage.CurrentShopItems:FindFirstChild(Arguments[1]:lower())
					local Index, Table, Planet = shared.Utilities.DeepSearch(SystemData, Arguments[1])
					
					warn(Index, Table, Planet)
					
					if Item then
						NewText(`\nItem "{Item.Name}" // Price : {Item:GetAttribute("Price")} // Description : {Item:GetAttribute("Description")}`)
					elseif Planet then
						NewText("")
						
						for Index, Value in Table.GeneralData do
							if type(Value) == "string" then
								NewText(`* {Index} - {Value}`)
							end
						end
					else
						NewText(`\nItem "{Arguments[1]}" not found.`)
					end
				else
					NewText("\nArgument expected with command \"info\".")
				end
			end
		)
		
		--[[Command(
			"planetary",
			"Shows the planet system map.",
			
			function()
				--Toggle()
				
				shared.UI.Planetary.Toggle()
			end
		)]]
	end
end


return Terminal
