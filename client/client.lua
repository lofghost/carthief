CreateThread(function()
    local ESX = nil

    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end) 
        Wait(0) 
    end

    while ESX.GetPlayerData().job == nil do
        Wait(0) 
    end

    local InMission, Stopped = false, false

    CreateThread(function()
        while true do
            local Sleep = 500

            local Self = PlayerPedId()

            if not InMission then
                if #(GetEntityCoords(Self) - Config['Cutscenes']['Start']['Ped'].xyz) <= 75.0 then
                    local ped = PedGenerator()

                    if DoesEntityExist(ped) then
                        while #(GetEntityCoords(Self) - GetEntityCoords(ped)) <= 5.0 and not IsEntityPlayingAnim(ped, Config['Settings']['Animation']['Dict'], Config['Settings']['Animation']['Anim'], 3) do
                            Wait(0)

                            if #(GetEntityCoords(Self) - GetEntityCoords(ped)) <= 3.0 then
                                DrawText3D(GetEntityCoords(ped), '~s~[~r~E~s~] ' .. Strings['Start'])
                            else
                                DrawText3D(GetEntityCoords(ped), Strings['Start'])
                            end

                            if IsControlJustReleased(0, 51) then
                                ESX.TriggerServerCallback('loffe_carthief:canStart', function(can)
                                    CreateThread(function()
                                        if can and not InMission then
                                            InMission = true
                                            DoScreenFadeOut(0)

                                            cinema = true

                                            while not NetworkHasControlOfEntity(ped) do 
                                                Wait(0) 
                                                NetworkRequestControlOfEntity(ped) 
                                            end

                                            while not HasAnimDictLoaded(Config['Settings']['Animation']['Dict']) do
                                                Wait(0)
                                                RequestAnimDict(Config['Settings']['Animation']['Dict'])
                                            end
                                            local burger = CreateObject(GetHashKey('prop_cs_burger_01'), 0.0, 0.0, 0.0, true, true, true)
                                            AttachEntityToEntity(burger, ped, GetPedBoneIndex(ped, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
                                            TaskPlayAnim(ped, Config['Settings']['Animation']['Dict'], Config['Settings']['Animation']['Anim'], 8.0, 8.0, -1, 1, 0, false, false, false)

                                            local cam = CreateCam('DEFAULT_SCRIPTED_Camera', 1)
                                            SetCamCoord(cam, Config['Cutscenes']['Start']['Camera'])
                                            PointCamAtCoord(cam, GetEntityCoords(ped))
                                            RenderScriptCams(1, 0, 0, 1, 1)
                                            SetCamActive(cam, true)

                                            Wait(1000)

                                            local Audio = CreateDui(Config['Settings']['Audio'], 1920, 1080)

                                            Wait(100)

                                            SetEntityCoords(Self, Config['Cutscenes']['Start']['Self'].xyz)
                                            SetEntityHeading(Self, Config['Cutscenes']['Start']['Self'].w)

                                            DoScreenFadeIn(1500)

                                            local timer = GetGameTimer() + Config['Cutscenes']['Start']['Length']
                                            BlockControls = true

                                            while timer >= GetGameTimer() do
                                                Wait(0)

                                                local curr = (GetGameTimer() - timer) + Config['Cutscenes']['Start']['Length']

                                                for k, v in pairs(Config['Subtitles']['Start']) do

                                                    if v[1] <= curr and v[2] >= curr then
                                                        DrawTxt({
                                                            ['x'] = 0.5, 
                                                            ['y'] = 0.935,
                                                            ['text'] = v[3],
                                                            ['centre'] = true,
                                                            ['scale'] = 0.45
                                                        })
                                                    end
                                                end
                                            end
                                            BlockControls = false
                                            DeleteObject(burger)

                                            DestroyCam(cam)
                                            ClearTimecycleModifier()
                                            RenderScriptCams(false, false, 0, 1, 0)

                                            cinema = false
                                            DestroyDui(Audio)
                                            ClearPedTasks(ped)  

                                            local position = Config['Vehicles']['Positions'][math.random(1, #Config['Vehicles']['Positions'])]
                                            local HasStolenCar = false
                                            local vehicle = 0
                                            local hotwire = 0
                                            local lockpick = 0
                                            local transmitter = 0
                                            local killedblip = false

                                            local blip = AddBlipForCoord(position.xyz)
                                            SetBlipSprite(blip, 523)
                                            SetBlipColour(blip, 6)
                                            SetBlipRoute(blip, true)
                                            SetBlipRouteColour(blip, 6)

                                            -- SetEntityCoords(Self, position)

                                            while InMission do
                                                Wait(0)

                                                if not HasStolenCar then
                                                    DrawTxt({
                                                        ['x'] = 0.5, 
                                                        ['y'] = 0.02,
                                                        ['text'] = '~s~[~r~F10~s~] ' .. Strings['Cancel'],
                                                        ['centre'] = true,
                                                        ['scale'] = 0.25
                                                    })

                                                    if IsControlJustReleased(0, 57) then
                                                        InMission = false
                                                        Stopped = true
                                                        DeleteEntity(vehicle)
                                                        RemoveBlip(blip)
                                                    end

                                                    if #(GetEntityCoords(Self) - position.xyz) >= 5.0 then
                                                        DrawTxt({
                                                            ['x'] = 0.5, 
                                                            ['y'] = 0.9,
                                                            ['text'] = Strings['GetToCar'],
                                                            ['centre'] = true,
                                                            ['scale'] = 0.45
                                                        })
                                                    end

                                                    if #(GetEntityCoords(Self) - position.xyz) <= 75.0 then
                                                        if not DoesEntityExist(vehicle) then
                                                            vehicle = CreateVehicle(LoadModel(Config['Vehicles']['Models'][math.random(1, #Config['Vehicles']['Models'])]), position.xyz, position.w, true)
                                                            SetNetworkIdExistsOnAllMachines(ObjToNet(vehicle))
                                                            SetVehicleDoorsLocked(vehicle, 2)
                                                            SetVehicleEngineOn(vehicle, false, true, true)
                                                            SetVehicleNumberPlateText(vehicle, 'AYRPCAR')
                                                        else
                                                            if GetVehicleDoorLockStatus(vehicle) == 2 then
                                                                local door = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'door_dside_f'))
                                                                if #(GetEntityCoords(Self) - door) <= 2.5 then
                                                                    DrawText3D(door, '~s~[~r~G~s~] ' .. (Strings['Lockpick']):format(lockpick / 10))
                                                                    if IsControlJustReleased(0, 47) then
                                                                        StartVehicleAlarm(vehicle)
                                                                        SetVehicleAlarmTimeLeft(vehicle, 2 * 60 * 1000 --[[2 minutes]])

                                                                        if not IsEntityPlayingAnim(Self, 'missheistfbisetup1', 'hassle_intro_loop_f', 3) then
                                                                            while not HasAnimDictLoaded('missheistfbisetup1') do
                                                                                Wait(0)
                                                                                RequestAnimDict('missheistfbisetup1')
                                                                            end
                                                                            TaskPlayAnim(Self, 'missheistfbisetup1', 'hassle_intro_loop_f', 8.0, 8.0, -1, 1, 0, false, false, false)
                                                                        end

                                                                        local random = math.random(15, 50)
                                                                        if lockpick + random <= 1000 then
                                                                            lockpick = lockpick + random
                                                                        else
                                                                            lockpick = lockpick + 1
                                                                        end
                                                                        if lockpick == 1000 then
                                                                            SetVehicleDoorsLocked(vehicle, 1)
                                                                            ClearPedTasks(Self)
                                                                        end
                                                                    end
                                                                end
                                                            elseif IsPedInVehicle(Self, vehicle, false) then
                                                                DrawTxt({
                                                                    ['x'] = 0.5, 
                                                                    ['y'] = 0.5,
                                                                    ['text'] = '~s~[~r~G~s~] ' .. (Strings['Hotwire']):format(hotwire / 10),
                                                                    ['centre'] = true,
                                                                    ['scale'] = 0.25
                                                                })
                                                                if IsControlJustReleased(0, 47) then
                                                                    StartVehicleAlarm(vehicle)
                                                                    SetVehicleAlarmTimeLeft(vehicle, 60 * 60 * 1000 --[[60 minutes]])

                                                                    if not IsEntityPlayingAnim(Self, 'veh@van@ds@base', 'hotwire', 3) then
                                                                        while not HasAnimDictLoaded('veh@van@ds@base') do
                                                                            Wait(0)
                                                                            RequestAnimDict('veh@van@ds@base')
                                                                        end
                                                                        TaskPlayAnim(Self, 'veh@van@ds@base', 'hotwire', 8.0, 8.0, -1, 1, 0, false, false, false)
                                                                    end

                                                                    local random = math.random(15, 50)
                                                                    if hotwire + random <= 1000 then
                                                                        hotwire = hotwire + random
                                                                    else
                                                                        hotwire = hotwire + 1
                                                                    end
                                                                    if hotwire == 1000 then
                                                                        HasStolenCar = true
                                                                        transmitter = GetGameTimer() + (Config['Settings']['TransmitterLength'] * 1000)
                                                                        SetVehicleEngineOn(vehicle, true, false, false)
                                                                        RemoveBlip(blip)
                                                                        ClearPedTasks(Self)
                                                                        TriggerServerEvent('loffe_carthief:setNetId', ObjToNet(vehicle))
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                else
                                                    if transmitter <= GetGameTimer() then
                                                        if not killedblip then
                                                            killedblip = true
                                                            TriggerServerEvent('loffe_carthief:deleteBlip')
                                                        end
                                                        if not DoesBlipExist(blip) then
                                                            blip = AddBlipForCoord(Config['Settings']['Deliver'])
                                                            SetBlipColour(blip, 2)
                                                            SetBlipRoute(blip, true)
                                                            SetBlipRouteColour(blip, 2)
                                                        end
                                                        if #(GetEntityCoords(vehicle) - Config['Settings']['Deliver']) >= 5.0 then
                                                            DrawTxt({
                                                                ['x'] = 0.5, 
                                                                ['y'] = 0.9,
                                                                ['text'] = Strings['Deliver'],
                                                                ['centre'] = true,
                                                                ['scale'] = 0.45
                                                            })
                                                        else
                                                            if IsPedInVehicle(Self, vehicle) then
                                                                DrawTxt({
                                                                    ['x'] = 0.5, 
                                                                    ['y'] = 0.9,
                                                                    ['text'] = Strings['GetOut'],
                                                                    ['centre'] = true,
                                                                    ['scale'] = 0.45
                                                                })
                                                            else
                                                                InMission = false
                                                                break
                                                            end
                                                        end
                                                        if #(GetEntityCoords(vehicle) - Config['Settings']['Deliver']) <= 50.0 then
                                                            DrawMarker(1, Config['Settings']['Deliver'] - vec3(0.0, 0.0, 0.2), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 1.5, 27, 175, 82, 175)
                                                        end
                                                    else
                                                        DrawTxt({
                                                            ['x'] = 0.5, 
                                                            ['y'] = 0.9,
                                                            ['text'] = (Strings['Transmitter']):format(math.floor((transmitter - GetGameTimer()) / 1000)),
                                                            ['centre'] = true,
                                                            ['scale'] = 0.45
                                                        })
                                                    end
                                                end
                                            end

                                            if not Stopped then
                                                RemoveBlip(blip)
                                                TriggerServerEvent('loffe_carthief:reward', GetVehicleBodyHealth(vehicle), GetVehicleEngineHealth(vehicle))
                                                DeleteEntity(vehicle)
                                            else
                                                RemoveBlip(blip)
                                                TriggerServerEvent('loffe_carthief:end')
                                            end

                                        end
                                    end)
                                end)
                                Wait(2500)
                            end
                        end
                    end
                end
            end

            Wait(Sleep)
        end
    end)
end)

local policeblip = 0

RegisterNetEvent('loffe_carthief:setBlip')
AddEventHandler('loffe_carthief:setBlip', function(netid)
    if DoesBlipExist(policeblip) then
        RemoveBlip(policeblip)
    end

    policeblip = AddBlipForEntity(NetToObj(netid))
    SetBlipSprite(policeblip, 523)
    SetBlipColour(policeblip, 1)
    SetBlipRoute(policeblip, true)
    SetBlipRouteColour(policeblip, 1)
end)

RegisterNetEvent('loffe_carthief:removeBlip')
AddEventHandler('loffe_carthief:removeBlip', function()
    if DoesBlipExist(policeblip) then
        RemoveBlip(policeblip)
    end
end)