run_on_thread(getactorthreads()[1], [=[
local function GetService(Name)
    return cloneref(game.GetService(game, Name));
end

local PlayerService = GetService("Players");
local UserInputService = GetService("UserInputService");

local ToggleEnabled = false
local LocalPlayer = PlayerService.LocalPlayer;

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.T then
        ToggleEnabled = not ToggleEnabled
        print("Fast Scope:", ToggleEnabled and "ON" or "OFF")
    end
end)

local Modules = { }; do
    local Required = { };
    local RequestedModules = {
        ["firstPerson"] = {["1"] = "cam", ["2"] = "signals", ["3"] = "nodes", ["4"] = "chars", ["5"] = "collisionCheck", ["6"] = "firstPersonCam", ["7"] = "localChar", ["8"] = "breath", ["9"] = "charConfig", ["10"] = "equipment", ["11"] = "players", ["12"] = "mouse", ["13"] = "networkEvents", ["14"] = "gamepad", ["15"] = "mathLib"},
        ["bullet"] = {["2"] = "charData"},
    };

    function Modules:Require(Name)
        local NilInstances = getnilinstances();
        for Index = 1, #NilInstances do
            local Module = NilInstances[Index];
            if (Module.Name == Name) then
                return require(Module);
            end
        end
    end

    function Modules:Get(Module)
        local RequiredModule = Required[Module];
        if (not RequiredModule) then
            RequiredModule = self:Require(Module);
        end
        return RequiredModule;
    end

    function Modules:Initiate()
        for Module, Data in RequestedModules do
            local Initiator = self:Require(Module);
            if (not Initiator) then continue; end
            Initiator = Initiator.setup;
            for Index, Name in Data do
                Required[Name] = debug.getupvalue(Initiator, Index);
            end
        end
    end
    
    Modules:Initiate();
end

local firstPersonCam = Modules:Get("firstPersonCam");

-- Fast Scope
if firstPersonCam then
    local oldSetup = firstPersonCam.setup
    firstPersonCam.setup = function(...)
        local result = oldSetup(...)
        firstPersonCam.scopeSpeed = 0.001
        firstPersonCam.zoomSpeed = 0.001
        return result
    end
end

print("=================================")
print("Fast Scope Loaded!")
print("Press T to toggle")
print("=================================")
]=])
