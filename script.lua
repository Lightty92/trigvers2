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
        print("No Fire Delay:", ToggleEnabled and "ON" or "OFF")
    end
end)

local Modules = { }; do
    local Required = { };
    local RequestedModules = {
        ["firstPerson"] = {["1"] = "signals"},
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

local Signals = Modules:Get("signals");

InvokeEvent = hookfunction(Signals.invoke, function(...)
    local Arguments = { ... };
    
    if not ToggleEnabled then
        return InvokeEvent(table.unpack(Arguments));
    end
    
    local eventName = Arguments[1]
    if eventName and tostring(eventName):find("shoot") or eventName == "fire" then
        return InvokeEvent(table.unpack(Arguments));
    end
    
    return InvokeEvent(table.unpack(Arguments));
end)

print("No Fire Delay Loaded! Press T to toggle.")
]=])
