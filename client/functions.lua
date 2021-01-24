types = {
    ['Object'] = {
        FindFirstObject,
        FindNextObject,
        EndFindObject
    },
    ['Ped'] = {
        FindFirstPed,
        FindNextPed,
        EndFindPed
    },
    ['Vehicle'] = {
        FindFirstVehicle,
        FindNextVehicle,
        EndFindVehicle
    }
}

GetStuff = function(type)
    local data = {}
    local funcs = types[type]
    local handle, ent, success = funcs[1]()

    repeat
        success, entity = funcs[2](handle)
        if DoesEntityExist(entity) then
            for k, v in pairs(GetActivePlayers()) do
                if GetPlayerPed(v) ~= entity then
                    table.insert(data, entity)
                end
            end
        end
    until not success

    funcs[3](handle)
    return data
end

LoadModel = function(model)
    if type(model) == 'string' then
        model = GetHashKey(model)
    else
        if type(model) ~= 'number' then
            return false
        end
    end

    local timer = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        Wait(0)
        RequestModel(model)
        if GetGameTimer() >= timer then
            return false
        end
    end

    return model
end

PedGenerator = function()
    local ped

    local peds = GetStuff('Ped')
    for k, v in pairs(peds) do
        if GetEntityModel(v) == GetHashKey(Config['Settings']['Ped']) then
            if #(GetEntityCoords(v) - Config['Cutscenes']['Start']['Ped'].xyz) <= 2.5 then
                if not IsPedDeadOrDying(v) then
                    return v 
                end
            end
        end
    end

    local model = LoadModel(Config['Settings']['Ped'])

    ped = CreatePed(4, model, Config['Cutscenes']['Start']['Ped'], true)
    SetPedDefaultComponentVariation(ped)
    SetPedComponentVariation(ped, 3, 0, 2, 0)
    SetPedFriendly(ped)
    FreezeEntityPosition(ped, true)
    NetworkRegisterEntityAsNetworked(ped)
    SetNetworkIdCanMigrate(ObjToNet(ped))
    SetNetworkIdExistsOnAllMachines(ObjToNet(ped))

    return ped
end

SetPedFriendly = function(ped)
    SetEntityInvincible(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
end

DrawText3D = function(coords, text)
    SetDrawOrigin(coords)

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    DrawRect(0.0, 0.0125, 0.015 + text:gsub('~.-~', ''):len() / 370, 0.03, 45, 45, 45, 150)

    ClearDrawOrigin()
end

DrawTxt = function(options)
    local r, g, b = table.unpack(options['colour'] or {255, 255, 255})
    SetTextColour(r, g, b, 255)
        
    SetTextFont(options['font'] or 0)
    SetTextScale(options['scale'] or 0.3, options['scale'] or 0.3)
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextDropShadow()
    SetTextCentre(options['centre'] or false)
    SetTextEntry('STRING')
    AddTextComponentString(options['text'])
    DrawText(options['x'], options['y'])
end

cinema = false

CreateThread(function()
    while true do
        Wait(250)
        if cinema then
            for i = 1, 105 do
                Wait(0)

                DrawRect(0.5, -0.08 + (i / 1000), 1.0, 0.15, 0, 0, 0, 255)
                DrawRect(0.5, 1.08 - (i / 1000), 1.0, 0.15, 0, 0, 0, 255)
            end

            while cinema do
                Wait(0)
                
                DrawRect(0.5, 0.025, 1.0, 0.15, 0, 0, 0, 255)
                DrawRect(0.5, 0.975, 1.0, 0.15, 0, 0, 0, 255)

                DisplayRadar(false)
            end

            for i = 1, 105 do
                Wait(0)

                DrawRect(0.5, 0.025 - (i / 1000), 1.0, 0.15, 0, 0, 0, 255)
                DrawRect(0.5, 0.975 + (i / 1000), 1.0, 0.15, 0, 0, 0, 255)
            end
        end
    end
end)

BlockControls = false
CreateThread(function()
    while true do
        if BlockControls then
            for i = 0, 500 do
                DisableControlAction(0, i, true)
            end
            Wait(0)
        else
            Wait(250)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1500)
        collectgarbage() -- prevent ram shit, this will impact performance tho (0.04 ms every 1500 ms)
    end
end)