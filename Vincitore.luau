local DiscordInvite = "https://discord.gg/8UNY58pxk"

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

pcall(function()
    local old = CoreGui:FindFirstChild("OutdatedScriptUI")
    if old then
        old:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OutdatedScriptUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 420, 0, 250)
Main.Position = UDim2.new(0.5, -210, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(70, 70, 80)
Stroke.Thickness = 1
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 15)
Title.BackgroundTransparency = 1
Title.Text = "This Script Is Outdated"
Title.TextColor3 = Color3.fromRGB(255, 90, 90)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local Description = Instance.new("TextLabel")
Description.Size = UDim2.new(1, -40, 0, 55)
Description.Position = UDim2.new(0, 20, 0, 60)
Description.BackgroundTransparency = 1
Description.Text = "Join our Discord server to get the new script."
Description.TextColor3 = Color3.fromRGB(220, 220, 225)
Description.TextSize = 16
Description.Font = Enum.Font.Gotham
Description.TextWrapped = true
Description.Parent = Main

local LinkBox = Instance.new("TextBox")
LinkBox.Size = UDim2.new(1, -40, 0, 38)
LinkBox.Position = UDim2.new(0, 20, 0, 120)
LinkBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
LinkBox.BorderSizePixel = 0
LinkBox.Text = DiscordInvite
LinkBox.TextColor3 = Color3.fromRGB(120, 180, 255)
LinkBox.TextSize = 14
LinkBox.Font = Enum.Font.Gotham
LinkBox.ClearTextOnFocus = false
LinkBox.TextEditable = false
LinkBox.Parent = Main

local LinkCorner = Instance.new("UICorner")
LinkCorner.CornerRadius = UDim.new(0, 8)
LinkCorner.Parent = LinkBox

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 160, 0, 38)
CopyButton.Position = UDim2.new(0.5, -80, 0, 170)
CopyButton.BackgroundColor3 = Color3.fromRGB(80, 130, 255)
CopyButton.BorderSizePixel = 0
CopyButton.Text = "Copy Discord Link"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.TextSize = 14
CopyButton.Font = Enum.Font.GothamBold
CopyButton.Parent = Main

local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 8)
CopyCorner.Parent = CopyButton

local Fallback = Instance.new("TextLabel")
Fallback.Size = UDim2.new(1, -40, 0, 25)
Fallback.Position = UDim2.new(0, 20, 0, 215)
Fallback.BackgroundTransparency = 1
Fallback.Text = "Fallback manual copy"
Fallback.TextColor3 = Color3.fromRGB(150, 150, 160)
Fallback.TextSize = 12
Fallback.Font = Enum.Font.Gotham
Fallback.Parent = Main

local function CopyDiscord()
    local copied = false

    if typeof(setclipboard) == "function" then
        local success = pcall(function()
            setclipboard(DiscordInvite)
        end)

        if success then
            copied = true
        end
    end

    if copied then
        CopyButton.Text = "Copied!"
        CopyButton.BackgroundColor3 = Color3.fromRGB(70, 180, 110)

        task.delay(1.5, function()
            if CopyButton and CopyButton.Parent then
                CopyButton.Text = "Copy Discord Link"
                CopyButton.BackgroundColor3 = Color3.fromRGB(80, 130, 255)
            end
        end)
    else
        LinkBox.TextEditable = true
        LinkBox:CaptureFocus()
        LinkBox.CursorPosition = #DiscordInvite + 1
        LinkBox.SelectionStart = 1
        LinkBox.CursorPosition = #DiscordInvite + 1

        CopyButton.Text = "Copy Manually"

        task.delay(1.5, function()
            if CopyButton and CopyButton.Parent then
                CopyButton.Text = "Copy Discord Link"
            end
        end)
    end
end

CopyButton.MouseButton1Click:Connect(CopyDiscord)

local dragging = false
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart

    Main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        updateDrag(input)
    end
end)
