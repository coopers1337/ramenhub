local Fluent = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau", true))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/refs/heads/main/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/refs/heads/main/Addons/InterfaceManager.luau"))()

local grabbables = Workspace:FindFirstChild("Grabbable")
local RS =  game:GetService("ReplicatedStorage")
local DropItem = RS.Remotes:FindFirstChild("DropItem")
local PickupItem = RS.Remotes:FindFirstChild("PickupItem")
local Interact = RS.Remotes:FindFirstChild("Interact")
local Aprons = RS.Apron
local CustomizationHandler = RS.Remotes.CustomizationHandler
local player = game:GetService("Players").LocalPlayer
local character = player.Character
local Buttons = Workspace.Important:FindFirstChild("Buttons")

local Window = Fluent:CreateWindow({
    Title = "Ramen Hub",
    SubTitle = "by FreeScripts",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Options = Fluent.Options

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "align-center" }),
    Troll = Window:AddTab({ Title = "Troll", Icon = "usb" }),
    StoreControl = Window:AddTab({ Title = "Store Control", Icon = "joystick" }),
    Vote = Window:AddTab({ Title = "Vote", Icon = "check" }),
    Buy = Window:AddTab({ Title = "Buy", Icon = "shopping-cart" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Tabs.Main:AddButton({
        Title = "Instant 75 level + money",
        Description = "Instant 75 level + money",
        Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/coopers1337/ramenhub/refs/heads/main/Instant75level.lua"))()
        end
})

Tabs.Main:AddButton({
        Title = "Action Mod",
        Description = "modify action speeds.",
        Callback = function()
            player.ActionStats.MoppingSpeed.Value = 0.01
            player.ActionStats.RollingSpeed.Value = 0.01
            player.ActionStats.CuttingSpeed.Value = 0.01
        end
})

Tabs.Main:AddButton({
        Title = "Unlock all aprons",
        Description = "Unlock all aprons for free.",
        Callback = function()
for i,v in pairs(Aprons:GetChildren()) do
local args = {
	"BuyApron",
	{
		Price = 0,
		ApronName = v.Name,
		Bowl = 0
	}
}
CustomizationHandler:FireServer(unpack(args))
end
        end
})

local storebtns = {"Open Store", "Close Store"}
local deliveryitems = {"Vegetable", "Protein", "Dough", "Broth Base"}

Tabs.StoreControl:AddButton({
        Title = "Open Store",
        Callback = function()
            if Buttons:FindFirstChild("Open Store") then
               Interact:FireServer(Buttons["Open Store"])
            end
        end
})

Tabs.StoreControl:AddButton({
        Title = "Close Store",
        Callback = function()
            if Buttons:FindFirstChild("Close Store") then
               Interact:FireServer(Buttons["Close Store"])
            end
        end
})

for i,v in pairs(Buttons:GetChildren()) do
if v:FindFirstChild("Interact") and not table.find(deliveryitems, v.Name) and not table.find(storebtns, v.Name) then
Tabs.Vote:AddButton({
        Title = v.Name,
        Callback = function()
             Interact:FireServer(v)
        end
})
end
end

for i,v in pairs(Buttons:GetChildren()) do
if v:FindFirstChild("Interact") and table.find(deliveryitems, v.Name) then
Tabs.Buy:AddButton({
        Title = v.Name,
        Callback = function()
             Interact:FireServer(v)
        end
})
end
end

Tabs.Troll:AddButton({
        Title = "Fling all items",
        Description = "Fling all grabbable items.",
        Callback = function()
            for i,v in pairs(grabbables:GetChildren()) do
            DropItem:FireServer(v, Vector3.new(0, -500, 0))
            end
        end
})

Tabs.Troll:AddButton({
        Title = "Void all items",
        Description = "Void all grabbable items.",
        Callback = function()
            for i,v in pairs(grabbables:GetChildren()) do
            DropItem:FireServer(v, Vector3.new(0, -100000000000000000000, 0))
            end
        end
})

Tabs.Troll:AddButton({
        Title = "ungrabbable all (permanent)",
        Description = "ungrabbable all grabbable items.",
        Callback = function()
            for i,v in pairs(grabbables:GetChildren()) do
            PickupItem:FireServer(v, Vector3.new(0, -100000000000000000000, 0))
            end
        end
})

Tabs.Troll:AddButton({
        Title = "Drop all items",
        Description = "Drop all grabbable items.",
        Callback = function()
            for i,v in pairs(grabbables:GetChildren()) do
            DropItem:FireServer(v, Vector3.zero)
            end
        end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("RamenHub")
SaveManager:SetFolder("RamenHub/typicalramen")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)

Fluent:Notify({
    Title = "Ramen Hub",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
