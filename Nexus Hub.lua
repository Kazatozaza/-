game.Players.localPlayer.PlayerGui.Main.Stats.CanvasGroup.Melee.Value.Text = 500

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Nexus Hub",
   Icon = 0,
   LoadingTitle = "Nexus Hub",
   LoadingSubtitle = "Nexus Hub",
   Theme = "Bloom",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Nexus Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "Nexus Hub",
      Subtitle = "Key System",
      Note = "⁠Executor Cy xZ !⁠【💬】・𝗖𝗛𝗔𝗧",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})


local AutoFarm = Window:CreateTab("Main", nil)



-- ฟังก์ชันสำหรับสร้าง Toggle
local function createToggle(tab, name, callback)
    return tab:CreateToggle({
        Name = name,
        CurrentValue = false,
        Flag = name,
        Callback = function(Value)
            print(name .. " : " .. tostring(Value)) -- จะพิมพ์ในกรณีที่คลิกเปิดหรือปิด
            callback(Value)
        end,
    })
end


local isAutoClicking = false  -- ตัวแปรสำหรับตรวจสอบว่า AutoClick เปิดอยู่หรือไม่

createToggle(AutoFarm, "Combat", function(V)
    print("AutoClick Toggle: " .. tostring(V))
    if V then  -- ถ้า toggle เปิด
        isAutoClicking = true
        -- เริ่มการทำงานของ AutoClick
        local args = {
            [1] = CFrame.new(63.18721008300781, 16.720279693603516, 1023.1223754882812, 
                -0.8706213235855103, 0.4349839687347412, -0.22979913651943207, 
                0, 0.46711522340774536, 0.8841964602470398, 
                0.49195396900177, 0.7698003053665161, -0.4066804051399231)
        }

        local remoteEvent = game:GetService("Players").LocalPlayer.Character.Combat.A.RemoteEvent

        -- เริ่มลูปในการยิงเมื่อ toggle เปิด
        while isAutoClicking do
            remoteEvent:FireServer(unpack(args))  -- ส่งคำสั่งยิง
            wait(0.1)  -- รอ 0.1 วินาที ก่อนที่จะยิงครั้งต่อไป
        end
    else  -- ถ้า toggle ปิด
        isAutoClicking = false  -- หยุดลูป
    end
end)


-- ฟังก์ชั่นสำหรับเปิดและปิด AutoFarm หรือ Combat
function enableAutoFarm()
    print("AutoFarm Activated")
    startCombat()  -- เรียกใช้ฟังก์ชั่นที่เริ่มการโจมตี (หมัด)
end

function disableAutoFarm()
    print("AutoFarm Deactivated")
    stopCombat()  -- เรียกใช้ฟังก์ชั่นที่หยุดการโจมตี (หมัด)
end

-- ฟังก์ชั่นการโจมตี (หมัด) รัวๆ
function startCombat()
    print("Combat Started: Attacking with punches")
    
    -- ลูปการโจมตีรัวๆ
    while true do
        -- โค้ดการโจมตีหรือคลิก เช่นการยิงการโจมตี หรือการเปิดใช้งาน RemoteEvent
        local args = {
            [1] = CFrame.new(89.764892578125, 20.85077667236328, 1008.009765625, -0.40968194603919983, 0.1091807559132576, -0.9056711792945862, -0, 0.992811918258667, 0.11968575417995453, 0.912228524684906, 0.04903309419751167, -0.4067370295524597)
        }

        -- เรียกใช้ RemoteEvent เพื่อส่งคำสั่งไปยังเซิร์ฟเวอร์
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Wooden Sword").A.RemoteEvent:FireServer(unpack(args))
        
        wait(0.1)  -- รอ 0.1 วินาที ก่อนที่จะโจมตีใหม่ (คุณสามารถปรับเวลานี้ได้ตามต้องการ)
    end
end

function stopCombat()
    print("Combat Stopped: Stopping all punches")
    -- โค้ดหยุดการโจมตี เช่น หยุดการใช้เครื่องมือ หรือการยกเลิกการคลิก
end

-- สร้าง Toggle สำหรับ Combat
createToggle(AutoFarm, "Wooden Sword", function(V)
    print("AutoClick Toggle: " .. tostring(V))
    
    if V then
        -- เมื่อ Toggle ถูกเปิด (V = true)
        enableAutoFarm()  -- เปิด AutoFarm หรือ Combat
    else
        -- เมื่อ Toggle ถูกปิด (V = false)
        disableAutoFarm()  -- ปิด AutoFarm หรือ Combat
    end
end)






local AutoFarm = Window:CreateTab("Auto Farm", nil)

local function createToggle(tab, name, callback) 
    return tab:CreateToggle({
        Name = name,
        CurrentValue = false,
        Flag = name,
        Callback = function(Value)
            print(name .. " : " .. tostring(Value)) -- แสดงสถานะ Toggle
            callback(Value) -- เรียกใช้ callback เพื่อจัดการสถานะ
        end,
    })
end


createToggle(AutoFarm, "Bandit [Lv.1]", function(V)
    print("Melee Selective Toggle: " .. tostring(V))

    local selectedMonsters = {}
    local currentTargetMonster = nil
    local bodyPosition = nil
    local farmingActive = false  -- ควบคุมการเริ่มหรือหยุดฟาร์ม
    local farmingCoroutine = nil -- ใช้ตัวแปรนี้เพื่อติดตาม coroutine

    -- ฟังก์ชันเลือกมอนสเตอร์
    local function selectMonsters()
        selectedMonsters = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Name == "Bandit [Lv.1]" then
                    table.insert(selectedMonsters, obj)
                    print("เลือกมอนสเตอร์: " .. obj.Name)
                end
            end
        end
    end

    -- ฟังก์ชันเคลื่อนที่ไปหามอนสเตอร์
    local function moveToMonsterAndFloat(character, monster)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local monsterHRP = monster:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and monsterHRP then
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
                bodyPosition.D = 1000
                bodyPosition.P = 10000
                bodyPosition.Parent = humanoidRootPart
            end

            bodyPosition.Position = monsterHRP.Position + Vector3.new(0, 3, 2) -- ลอยขึ้น
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, monsterHRP.Position)
        end
    end

    -- การหยุดฟาร์ม
    local function stopFarming()
        -- ลบการเคลื่อนที่ไปหามอนสเตอร์
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        -- ลบมอนสเตอร์ที่เลือก
        selectedMonsters = {}
        currentTargetMonster = nil
        farmingActive = false
        print("หยุดการฟาร์ม Bandit [Lv.1]")

        -- หากมี coroutine กำลังทำงาน, หยุดการทำงาน
        if farmingCoroutine then
            farmingCoroutine = nil  -- ล้างการทำงานของ coroutine
        end
    end

    -- ฟังก์ชันที่ใช้ในการเริ่มและหยุดการฟาร์ม
    if V then
        -- หาก toggle เปิด, เริ่มฟาร์ม
        if not farmingActive then
            farmingActive = true

            -- สร้าง coroutine ใหม่
            farmingCoroutine = coroutine.wrap(function()
                while farmingActive do
                    -- หากมอนสเตอร์ไม่พร้อมหรือไม่ได้เลือก, ทำการเลือกใหม่
                    if not currentTargetMonster or not currentTargetMonster:FindFirstChild("Humanoid") or currentTargetMonster.Humanoid.Health <= 0 then
                        selectMonsters()
                        if #selectedMonsters > 0 then
                            currentTargetMonster = selectedMonsters[1]
                        end
                    end

                    if currentTargetMonster then
                        moveToMonsterAndFloat(game.Players.LocalPlayer.Character, currentTargetMonster)
                    end
                    wait(0.1)
                end
            end)

            farmingCoroutine() -- เริ่มกระบวนการฟาร์ม
            print("เริ่มฟาร์ม Bandit [Lv.1]")
        end
    else
        -- หาก toggle ปิด, หยุดการฟาร์ม
        if farmingActive then
            stopFarming()
        end
    end
end)



createToggle(AutoFarm, "Bandit Boss [Lv.25]", function(V)
    print("Melee Selective Toggle: " .. tostring(V))

    local selectedMonsters = {}
    local currentTargetMonster = nil
    local bodyPosition = nil
    local farmingActive = false  -- ควบคุมการเริ่มหรือหยุดฟาร์ม
    local farmingCoroutine = nil -- ใช้ตัวแปรนี้เพื่อติดตาม coroutine

    -- ฟังก์ชันเลือกมอนสเตอร์
    local function selectMonsters()
        selectedMonsters = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Name == "Bandit Boss [Lv.25]" then
                    table.insert(selectedMonsters, obj)
                    print("เลือกมอนสเตอร์: " .. obj.Name)
                end
            end
        end
    end

    -- ฟังก์ชันเคลื่อนที่ไปหามอนสเตอร์
    local function moveToMonsterAndFloat(character, monster)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local monsterHRP = monster:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and monsterHRP then
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
                bodyPosition.D = 1000
                bodyPosition.P = 10000
                bodyPosition.Parent = humanoidRootPart
            end

            bodyPosition.Position = monsterHRP.Position + Vector3.new(0, 3, 2) -- ลอยขึ้น
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, monsterHRP.Position)
        end
    end

    -- การหยุดฟาร์ม
    local function stopFarming()
        -- ลบการเคลื่อนที่ไปหามอนสเตอร์
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        -- ลบมอนสเตอร์ที่เลือก
        selectedMonsters = {}
        currentTargetMonster = nil
        farmingActive = false
        print("Bandit Boss [Lv.25]")

        -- หากมี coroutine กำลังทำงาน, หยุดการทำงาน
        if farmingCoroutine then
            farmingCoroutine = nil  -- ล้างการทำงานของ coroutine
        end
    end

    -- ฟังก์ชันที่ใช้ในการเริ่มและหยุดการฟาร์ม
    if V then
        -- หาก toggle เปิด, เริ่มฟาร์ม
        if not farmingActive then
            farmingActive = true

            -- สร้าง coroutine ใหม่
            farmingCoroutine = coroutine.wrap(function()
                while farmingActive do
                    -- หากมอนสเตอร์ไม่พร้อมหรือไม่ได้เลือก, ทำการเลือกใหม่
                    if not currentTargetMonster or not currentTargetMonster:FindFirstChild("Humanoid") or currentTargetMonster.Humanoid.Health <= 0 then
                        selectMonsters()
                        if #selectedMonsters > 0 then
                            currentTargetMonster = selectedMonsters[1]
                        end
                    end

                    if currentTargetMonster then
                        moveToMonsterAndFloat(game.Players.LocalPlayer.Character, currentTargetMonster)
                    end
                    wait(0.1)
                end
            end)

            farmingCoroutine() -- เริ่มกระบวนการฟาร์ม
            print("Bandit Boss [Lv.25]")
        end
    else
        -- หาก toggle ปิด, หยุดการฟาร์ม
        if farmingActive then
            stopFarming()
        end
    end
end)



createToggle(AutoFarm, "Kraken [Lv.100]", function(V)
    print("Melee Selective Toggle: " .. tostring(V))

    local selectedMonsters = {}
    local currentTargetMonster = nil
    local bodyPosition = nil
    local farmingActive = false  -- ควบคุมการเริ่มหรือหยุดฟาร์ม
    local farmingCoroutine = nil -- ใช้ตัวแปรนี้เพื่อติดตาม coroutine

    -- ฟังก์ชันเลือกมอนสเตอร์
    local function selectMonsters()
        selectedMonsters = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Name == "Kraken [Lv.100]" then
                    table.insert(selectedMonsters, obj)
                    print("เลือกมอนสเตอร์: " .. obj.Name)
                end
            end
        end
    end

    -- ฟังก์ชันเคลื่อนที่ไปหามอนสเตอร์
    local function moveToMonsterAndFloat(character, monster)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local monsterHRP = monster:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and monsterHRP then
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
                bodyPosition.D = 1000
                bodyPosition.P = 10000
                bodyPosition.Parent = humanoidRootPart
            end

            bodyPosition.Position = monsterHRP.Position + Vector3.new(0, 3, 2) -- ลอยขึ้น
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, monsterHRP.Position)
        end
    end

    -- การหยุดฟาร์ม
    local function stopFarming()
        -- ลบการเคลื่อนที่ไปหามอนสเตอร์
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        -- ลบมอนสเตอร์ที่เลือก
        selectedMonsters = {}
        currentTargetMonster = nil
        farmingActive = false
        print("Kraken [Lv.100]")

        -- หากมี coroutine กำลังทำงาน, หยุดการทำงาน
        if farmingCoroutine then
            farmingCoroutine = nil  -- ล้างการทำงานของ coroutine
        end
    end

    -- ฟังก์ชันที่ใช้ในการเริ่มและหยุดการฟาร์ม
    if V then
        -- หาก toggle เปิด, เริ่มฟาร์ม
        if not farmingActive then
            farmingActive = true

            -- สร้าง coroutine ใหม่
            farmingCoroutine = coroutine.wrap(function()
                while farmingActive do
                    -- หากมอนสเตอร์ไม่พร้อมหรือไม่ได้เลือก, ทำการเลือกใหม่
                    if not currentTargetMonster or not currentTargetMonster:FindFirstChild("Humanoid") or currentTargetMonster.Humanoid.Health <= 0 then
                        selectMonsters()
                        if #selectedMonsters > 0 then
                            currentTargetMonster = selectedMonsters[1]
                        end
                    end

                    if currentTargetMonster then
                        moveToMonsterAndFloat(game.Players.LocalPlayer.Character, currentTargetMonster)
                    end
                    wait(0.1)
                end
            end)

            farmingCoroutine() -- เริ่มกระบวนการฟาร์ม
            print("Kraken [Lv.100]")
        end
    else
        -- หาก toggle ปิด, หยุดการฟาร์ม
        if farmingActive then
            stopFarming()
        end
    end
end)




createToggle(AutoFarm, "Savage [Lv.150]", function(V)
    print("Melee Selective Toggle: " .. tostring(V))

    local selectedMonsters = {}
    local currentTargetMonster = nil
    local bodyPosition = nil
    local farmingActive = false  -- ควบคุมการเริ่มหรือหยุดฟาร์ม
    local farmingCoroutine = nil -- ใช้ตัวแปรนี้เพื่อติดตาม coroutine

    -- ฟังก์ชันเลือกมอนสเตอร์
    local function selectMonsters()
        selectedMonsters = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Name == "Savage [Lv.150]" then
                    table.insert(selectedMonsters, obj)
                    print("เลือกมอนสเตอร์: " .. obj.Name)
                end
            end
        end
    end

    -- ฟังก์ชันเคลื่อนที่ไปหามอนสเตอร์
    local function moveToMonsterAndFloat(character, monster)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local monsterHRP = monster:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and monsterHRP then
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
                bodyPosition.D = 1000
                bodyPosition.P = 10000
                bodyPosition.Parent = humanoidRootPart
            end

            bodyPosition.Position = monsterHRP.Position + Vector3.new(0, 3, 2) -- ลอยขึ้น
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, monsterHRP.Position)
        end
    end

    -- การหยุดฟาร์ม
    local function stopFarming()
        -- ลบการเคลื่อนที่ไปหามอนสเตอร์
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        -- ลบมอนสเตอร์ที่เลือก
        selectedMonsters = {}
        currentTargetMonster = nil
        farmingActive = false
        print("Savage [Lv.150]")

        -- หากมี coroutine กำลังทำงาน, หยุดการทำงาน
        if farmingCoroutine then
            farmingCoroutine = nil  -- ล้างการทำงานของ coroutine
        end
    end

    -- ฟังก์ชันที่ใช้ในการเริ่มและหยุดการฟาร์ม
    if V then
        -- หาก toggle เปิด, เริ่มฟาร์ม
        if not farmingActive then
            farmingActive = true

            -- สร้าง coroutine ใหม่
            farmingCoroutine = coroutine.wrap(function()
                while farmingActive do
                    -- หากมอนสเตอร์ไม่พร้อมหรือไม่ได้เลือก, ทำการเลือกใหม่
                    if not currentTargetMonster or not currentTargetMonster:FindFirstChild("Humanoid") or currentTargetMonster.Humanoid.Health <= 0 then
                        selectMonsters()
                        if #selectedMonsters > 0 then
                            currentTargetMonster = selectedMonsters[1]
                        end
                    end

                    if currentTargetMonster then
                        moveToMonsterAndFloat(game.Players.LocalPlayer.Character, currentTargetMonster)
                    end
                    wait(0.1)
                end
            end)

            farmingCoroutine() -- เริ่มกระบวนการฟาร์ม
            print("Savage [Lv.150]")
        end
    else
        -- หาก toggle ปิด, หยุดการฟาร์ม
        if farmingActive then
            stopFarming()
        end
    end
end)



createToggle(AutoFarm, "Villagers [Lv.300]", function(V)
    print("Melee Selective Toggle: " .. tostring(V))

    local selectedMonsters = {}
    local currentTargetMonster = nil
    local bodyPosition = nil
    local farmingActive = false  -- ควบคุมการเริ่มหรือหยุดฟาร์ม
    local farmingCoroutine = nil -- ใช้ตัวแปรนี้เพื่อติดตาม coroutine

    -- ฟังก์ชันเลือกมอนสเตอร์
    local function selectMonsters()
        selectedMonsters = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Name == "Villagers [Lv.300]" then
                    table.insert(selectedMonsters, obj)
                    print("เลือกมอนสเตอร์: " .. obj.Name)
                end
            end
        end
    end

    -- ฟังก์ชันเคลื่อนที่ไปหามอนสเตอร์
    local function moveToMonsterAndFloat(character, monster)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local monsterHRP = monster:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and monsterHRP then
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
                bodyPosition.D = 1000
                bodyPosition.P = 10000
                bodyPosition.Parent = humanoidRootPart
            end

            bodyPosition.Position = monsterHRP.Position + Vector3.new(0, 3, 2) -- ลอยขึ้น
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, monsterHRP.Position)
        end
    end

    -- การหยุดฟาร์ม
    local function stopFarming()
        -- ลบการเคลื่อนที่ไปหามอนสเตอร์
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        -- ลบมอนสเตอร์ที่เลือก
        selectedMonsters = {}
        currentTargetMonster = nil
        farmingActive = false
        print("Villagers [Lv.300]")

        -- หากมี coroutine กำลังทำงาน, หยุดการทำงาน
        if farmingCoroutine then
            farmingCoroutine = nil  -- ล้างการทำงานของ coroutine
        end
    end

    -- ฟังก์ชันที่ใช้ในการเริ่มและหยุดการฟาร์ม
    if V then
        -- หาก toggle เปิด, เริ่มฟาร์ม
        if not farmingActive then
            farmingActive = true

            -- สร้าง coroutine ใหม่
            farmingCoroutine = coroutine.wrap(function()
                while farmingActive do
                    -- หากมอนสเตอร์ไม่พร้อมหรือไม่ได้เลือก, ทำการเลือกใหม่
                    if not currentTargetMonster or not currentTargetMonster:FindFirstChild("Humanoid") or currentTargetMonster.Humanoid.Health <= 0 then
                        selectMonsters()
                        if #selectedMonsters > 0 then
                            currentTargetMonster = selectedMonsters[1]
                        end
                    end

                    if currentTargetMonster then
                        moveToMonsterAndFloat(game.Players.LocalPlayer.Character, currentTargetMonster)
                    end
                    wait(0.1)
                end
            end)

            farmingCoroutine() -- เริ่มกระบวนการฟาร์ม
            print("Villagers [Lv.300]")
        end
    else
        -- หาก toggle ปิด, หยุดการฟาร์ม
        if farmingActive then
            stopFarming()
        end
    end
end)


createToggle(AutoFarm, "wade [Lv.400]", function(V)
    print("Melee Selective Toggle: " .. tostring(V))

    local selectedMonsters = {}
    local currentTargetMonster = nil
    local bodyPosition = nil
    local farmingActive = false  -- ควบคุมการเริ่มหรือหยุดฟาร์ม
    local farmingCoroutine = nil -- ใช้ตัวแปรนี้เพื่อติดตาม coroutine

    -- ฟังก์ชันเลือกมอนสเตอร์
    local function selectMonsters()
        selectedMonsters = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Name == "wade [Lv.400]" then
                    table.insert(selectedMonsters, obj)
                    print("เลือกมอนสเตอร์: " .. obj.Name)
                end
            end
        end
    end

    -- ฟังก์ชันเคลื่อนที่ไปหามอนสเตอร์
    local function moveToMonsterAndFloat(character, monster)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local monsterHRP = monster:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and monsterHRP then
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
                bodyPosition.D = 1000
                bodyPosition.P = 10000
                bodyPosition.Parent = humanoidRootPart
            end

            bodyPosition.Position = monsterHRP.Position + Vector3.new(0, 3, 2) -- ลอยขึ้น
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, monsterHRP.Position)
        end
    end

    -- การหยุดฟาร์ม
    local function stopFarming()
        -- ลบการเคลื่อนที่ไปหามอนสเตอร์
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        -- ลบมอนสเตอร์ที่เลือก
        selectedMonsters = {}
        currentTargetMonster = nil
        farmingActive = false
        print("wade [Lv.400]")

        -- หากมี coroutine กำลังทำงาน, หยุดการทำงาน
        if farmingCoroutine then
            farmingCoroutine = nil  -- ล้างการทำงานของ coroutine
        end
    end

    -- ฟังก์ชันที่ใช้ในการเริ่มและหยุดการฟาร์ม
    if V then
        -- หาก toggle เปิด, เริ่มฟาร์ม
        if not farmingActive then
            farmingActive = true

            -- สร้าง coroutine ใหม่
            farmingCoroutine = coroutine.wrap(function()
                while farmingActive do
                    -- หากมอนสเตอร์ไม่พร้อมหรือไม่ได้เลือก, ทำการเลือกใหม่
                    if not currentTargetMonster or not currentTargetMonster:FindFirstChild("Humanoid") or currentTargetMonster.Humanoid.Health <= 0 then
                        selectMonsters()
                        if #selectedMonsters > 0 then
                            currentTargetMonster = selectedMonsters[1]
                        end
                    end

                    if currentTargetMonster then
                        moveToMonsterAndFloat(game.Players.LocalPlayer.Character, currentTargetMonster)
                    end
                    wait(0.1)
                end
            end)

            farmingCoroutine() -- เริ่มกระบวนการฟาร์ม
            print("wade [Lv.400]")
        end
    else
        -- หาก toggle ปิด, หยุดการฟาร์ม
        if farmingActive then
            stopFarming()
        end
    end
end)



createToggle(AutoFarm, "Asta [Lv.450]", function(V)
    print("Melee Selective Toggle: " .. tostring(V))

    local selectedMonsters = {}
    local currentTargetMonster = nil
    local bodyPosition = nil
    local farmingActive = false  -- ควบคุมการเริ่มหรือหยุดฟาร์ม
    local farmingCoroutine = nil -- ใช้ตัวแปรนี้เพื่อติดตาม coroutine

    -- ฟังก์ชันเลือกมอนสเตอร์
    local function selectMonsters()
        selectedMonsters = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Name == "Asta [Lv.450]" then
                    table.insert(selectedMonsters, obj)
                    print("เลือกมอนสเตอร์: " .. obj.Name)
                end
            end
        end
    end

    -- ฟังก์ชันเคลื่อนที่ไปหามอนสเตอร์
    local function moveToMonsterAndFloat(character, monster)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local monsterHRP = monster:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and monsterHRP then
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
                bodyPosition.D = 1000
                bodyPosition.P = 10000
                bodyPosition.Parent = humanoidRootPart
            end

            bodyPosition.Position = monsterHRP.Position + Vector3.new(0, 3, 2) -- ลอยขึ้น
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, monsterHRP.Position)
        end
    end

    -- การหยุดฟาร์ม
    local function stopFarming()
        -- ลบการเคลื่อนที่ไปหามอนสเตอร์
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        -- ลบมอนสเตอร์ที่เลือก
        selectedMonsters = {}
        currentTargetMonster = nil
        farmingActive = false
        print("Asta [Lv.450]")

        -- หากมี coroutine กำลังทำงาน, หยุดการทำงาน
        if farmingCoroutine then
            farmingCoroutine = nil  -- ล้างการทำงานของ coroutine
        end
    end

    -- ฟังก์ชันที่ใช้ในการเริ่มและหยุดการฟาร์ม
    if V then
        -- หาก toggle เปิด, เริ่มฟาร์ม
        if not farmingActive then
            farmingActive = true

            -- สร้าง coroutine ใหม่
            farmingCoroutine = coroutine.wrap(function()
                while farmingActive do
                    -- หากมอนสเตอร์ไม่พร้อมหรือไม่ได้เลือก, ทำการเลือกใหม่
                    if not currentTargetMonster or not currentTargetMonster:FindFirstChild("Humanoid") or currentTargetMonster.Humanoid.Health <= 0 then
                        selectMonsters()
                        if #selectedMonsters > 0 then
                            currentTargetMonster = selectedMonsters[1]
                        end
                    end

                    if currentTargetMonster then
                        moveToMonsterAndFloat(game.Players.LocalPlayer.Character, currentTargetMonster)
                    end
                    wait(0.1)
                end
            end)

            farmingCoroutine() -- เริ่มกระบวนการฟาร์ม
            print("Asta [Lv.450]")
        end
    else
        -- หาก toggle ปิด, หยุดการฟาร์ม
        if farmingActive then
            stopFarming()
        end
    end
end)


createToggle(AutoFarm, "Do [Lv.225]", function(V)
    print("Melee Selective Toggle: " .. tostring(V))

    local selectedMonsters = {}
    local currentTargetMonster = nil
    local bodyPosition = nil
    local farmingActive = false  -- ควบคุมการเริ่มหรือหยุดฟาร์ม
    local farmingCoroutine = nil -- ใช้ตัวแปรนี้เพื่อติดตาม coroutine

    -- ฟังก์ชันเลือกมอนสเตอร์
    local function selectMonsters()
        selectedMonsters = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Name == "Do [Lv.225]" then
                    table.insert(selectedMonsters, obj)
                    print("เลือกมอนสเตอร์: " .. obj.Name)
                end
            end
        end
    end

    -- ฟังก์ชันเคลื่อนที่ไปหามอนสเตอร์
    local function moveToMonsterAndFloat(character, monster)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local monsterHRP = monster:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and monsterHRP then
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
                bodyPosition.D = 1000
                bodyPosition.P = 10000
                bodyPosition.Parent = humanoidRootPart
            end

            bodyPosition.Position = monsterHRP.Position + Vector3.new(0, 3, 2) -- ลอยขึ้น
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, monsterHRP.Position)
        end
    end

    -- การหยุดฟาร์ม
    local function stopFarming()
        -- ลบการเคลื่อนที่ไปหามอนสเตอร์
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        -- ลบมอนสเตอร์ที่เลือก
        selectedMonsters = {}
        currentTargetMonster = nil
        farmingActive = false
        print("Do [Lv.225]")

        -- หากมี coroutine กำลังทำงาน, หยุดการทำงาน
        if farmingCoroutine then
            farmingCoroutine = nil  -- ล้างการทำงานของ coroutine
        end
    end

    -- ฟังก์ชันที่ใช้ในการเริ่มและหยุดการฟาร์ม
    if V then
        -- หาก toggle เปิด, เริ่มฟาร์ม
        if not farmingActive then
            farmingActive = true

            -- สร้าง coroutine ใหม่
            farmingCoroutine = coroutine.wrap(function()
                while farmingActive do
                    -- หากมอนสเตอร์ไม่พร้อมหรือไม่ได้เลือก, ทำการเลือกใหม่
                    if not currentTargetMonster or not currentTargetMonster:FindFirstChild("Humanoid") or currentTargetMonster.Humanoid.Health <= 0 then
                        selectMonsters()
                        if #selectedMonsters > 0 then
                            currentTargetMonster = selectedMonsters[1]
                        end
                    end

                    if currentTargetMonster then
                        moveToMonsterAndFloat(game.Players.LocalPlayer.Character, currentTargetMonster)
                    end
                    wait(0.1)
                end
            end)

            farmingCoroutine() -- เริ่มกระบวนการฟาร์ม
            print("Do [Lv.225]")
        end
    else
        -- หาก toggle ปิด, หยุดการฟาร์ม
        if farmingActive then
            stopFarming()
        end
    end
end)








local AutoFarm = Window:CreateTab("Event", nil)



createToggle(AutoFarm, "Six kagayno [Lv.1500] ", function(V)
    print("Melee Selective Toggle: " .. tostring(V))

    local selectedMonsters = {}
    local currentTargetMonster = nil
    local bodyPosition = nil
    local farmingActive = false  -- ควบคุมการเริ่มหรือหยุดฟาร์ม
    local farmingCoroutine = nil -- ใช้ตัวแปรนี้เพื่อติดตาม coroutine

    -- ฟังก์ชันเลือกมอนสเตอร์
    local function selectMonsters()
        selectedMonsters = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Name == "Six kagayno [Lv.1500] " then
                    table.insert(selectedMonsters, obj)
                    print("เลือกมอนสเตอร์: " .. obj.Name)
                end
            end
        end
    end

    -- ฟังก์ชันเคลื่อนที่ไปหามอนสเตอร์
    local function moveToMonsterAndFloat(character, monster)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local monsterHRP = monster:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and monsterHRP then
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
                bodyPosition.D = 1000
                bodyPosition.P = 10000
                bodyPosition.Parent = humanoidRootPart
            end

            bodyPosition.Position = monsterHRP.Position + Vector3.new(0, 3, 2) -- ลอยขึ้น
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, monsterHRP.Position)
        end
    end

    -- การหยุดฟาร์ม
    local function stopFarming()
        -- ลบการเคลื่อนที่ไปหามอนสเตอร์
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        -- ลบมอนสเตอร์ที่เลือก
        selectedMonsters = {}
        currentTargetMonster = nil
        farmingActive = false
        print("Six kagayno [Lv.1500]")

        -- หากมี coroutine กำลังทำงาน, หยุดการทำงาน
        if farmingCoroutine then
            farmingCoroutine = nil  -- ล้างเริ่มฟาร์มการทำงานของ coroutine
        end
    end

    -- ฟังก์ชันที่ใช้ในการเริ่มและหยุดการฟาร์ม
    if V then
        -- หาก toggle เปิด, เริ่มฟาร์ม
        if not farmingActive then
            farmingActive = true

            -- สร้าง coroutine ใหม่
            farmingCoroutine = coroutine.wrap(function()
                while farmingActive do
                    -- หากมอนสเตอร์ไม่พร้อมหรือไม่ได้เลือก, ทำการเลือกใหม่
                    if not currentTargetMonster or not currentTargetMonster:FindFirstChild("Humanoid") or currentTargetMonster.Humanoid.Health <= 0 then
                        selectMonsters()
                        if #selectedMonsters > 0 then
                            currentTargetMonster = selectedMonsters[1]
                        end
                    end

                    if currentTargetMonster then
                        moveToMonsterAndFloat(game.Players.LocalPlayer.Character, currentTargetMonster)
                    end
                    wait(0.1)
                end
            end)

            farmingCoroutine() -- เริ่มกระบวนการฟาร์ม
            print("Six kagayno [Lv.1500] ")
        end
    else
        -- หาก toggle ปิด, หยุดการฟาร์ม
        if farmingActive then
            stopFarming()
        end
    end
end)




createToggle(AutoFarm, "Shadow [Lv.450]", function(V)
    print("Melee Selective Toggle: " .. tostring(V))

    local selectedMonsters = {}
    local currentTargetMonster = nil
    local bodyPosition = nil
    local farmingActive = false  -- ควบคุมการเริ่มหรือหยุดฟาร์ม
    local farmingCoroutine = nil -- ใช้ตัวแปรนี้เพื่อติดตาม coroutine

    -- ฟังก์ชันเลือกมอนสเตอร์
    local function selectMonsters()
        selectedMonsters = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Name == "Shadow [Lv.450]" then
                    table.insert(selectedMonsters, obj)
                    print("เลือกมอนสเตอร์: " .. obj.Name)
                end
            end
        end
    end

    -- ฟังก์ชันเคลื่อนที่ไปหามอนสเตอร์
    local function moveToMonsterAndFloat(character, monster)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local monsterHRP = monster:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and monsterHRP then
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
                bodyPosition.D = 1000
                bodyPosition.P = 10000
                bodyPosition.Parent = humanoidRootPart
            end

            bodyPosition.Position = monsterHRP.Position + Vector3.new(0, 3, 2) -- ลอยขึ้น
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, monsterHRP.Position)
        end
    end

    -- การหยุดฟาร์ม
    local function stopFarming()
        -- ลบการเคลื่อนที่ไปหามอนสเตอร์
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        -- ลบมอนสเตอร์ที่เลือก
        selectedMonsters = {}
        currentTargetMonster = nil
        farmingActive = false
        print("Shadow [Lv.450]")

        -- หากมี coroutine กำลังทำงาน, หยุดการทำงาน
        if farmingCoroutine then
            farmingCoroutine = nil  -- ล้างการทำงานของ coroutine
        end
    end

    -- ฟังก์ชันที่ใช้ในการเริ่มและหยุดการฟาร์ม
    if V then
        -- หาก toggle เปิด, เริ่มฟาร์ม
        if not farmingActive then
            farmingActive = true

            -- สร้าง coroutine ใหม่
            farmingCoroutine = coroutine.wrap(function()
                while farmingActive do
                    -- หากมอนสเตอร์ไม่พร้อมหรือไม่ได้เลือก, ทำการเลือกใหม่
                    if not currentTargetMonster or not currentTargetMonster:FindFirstChild("Humanoid") or currentTargetMonster.Humanoid.Health <= 0 then
                        selectMonsters()
                        if #selectedMonsters > 0 then
                            currentTargetMonster = selectedMonsters[1]
                        end
                    end

                    if currentTargetMonster then
                        moveToMonsterAndFloat(game.Players.LocalPlayer.Character, currentTargetMonster)
                    end
                    wait(0.1)
                end
            end)

            farmingCoroutine() -- เริ่มกระบวนการฟาร์ม
            print("Shadow [Lv.450]")
        end
    else
        -- หาก toggle ปิด, หยุดการฟาร์ม
        if farmingActive then
            stopFarming()
        end
    end
end)




createToggle(AutoFarm, "Shadow God [Lv.500]", function(V)
    print("Melee Selective Toggle: " .. tostring(V))

    local selectedMonsters = {}
    local currentTargetMonster = nil
    local bodyPosition = nil
    local farmingActive = false  -- ควบคุมการเริ่มหรือหยุดฟาร์ม
    local farmingCoroutine = nil -- ใช้ตัวแปรนี้เพื่อติดตาม coroutine

    -- ฟังก์ชันเลือกมอนสเตอร์
    local function selectMonsters()
        selectedMonsters = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Name == "Shadow God [Lv.500]" then
                    table.insert(selectedMonsters, obj)
                    print("เลือกมอนสเตอร์: " .. obj.Name)
                end
            end
        end
    end

    -- ฟังก์ชันเคลื่อนที่ไปหามอนสเตอร์
    local function moveToMonsterAndFloat(character, monster)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local monsterHRP = monster:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and monsterHRP then
            if not bodyPosition then
                bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
                bodyPosition.D = 1000
                bodyPosition.P = 10000
                bodyPosition.Parent = humanoidRootPart
            end

            bodyPosition.Position = monsterHRP.Position + Vector3.new(0, 3, 2) -- ลอยขึ้น
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, monsterHRP.Position)
        end
    end

    -- การหยุดฟาร์ม
    local function stopFarming()
        -- ลบการเคลื่อนที่ไปหามอนสเตอร์
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        -- ลบมอนสเตอร์ที่เลือก
        selectedMonsters = {}
        currentTargetMonster = nil
        farmingActive = false
        print("Shadow God [Lv.500]")

        -- หากมี coroutine กำลังทำงาน, หยุดการทำงาน
        if farmingCoroutine then
            farmingCoroutine = nil  -- ล้างการทำงานของ coroutine
        end
    end

    -- ฟังก์ชันที่ใช้ในการเริ่มและหยุดการฟาร์ม
    if V then
        -- หาก toggle เปิด, เริ่มฟาร์ม
        if not farmingActive then
            farmingActive = true

            -- สร้าง coroutine ใหม่
            farmingCoroutine = coroutine.wrap(function()
                while farmingActive do
                    -- หากมอนสเตอร์ไม่พร้อมหรือไม่ได้เลือก, ทำการเลือกใหม่
                    if not currentTargetMonster or not currentTargetMonster:FindFirstChild("Humanoid") or currentTargetMonster.Humanoid.Health <= 0 then
                        selectMonsters()
                        if #selectedMonsters > 0 then
                            currentTargetMonster = selectedMonsters[1]
                        end
                    end

                    if currentTargetMonster then
                        moveToMonsterAndFloat(game.Players.LocalPlayer.Character, currentTargetMonster)
                    end
                    wait(0.1)
                end
            end)

            farmingCoroutine() -- เริ่มกระบวนการฟาร์ม
            print("Shadow God [Lv.500]")
        end
    else
        -- หาก toggle ปิด, หยุดการฟาร์ม
        if farmingActive then
            stopFarming()
        end
    end
end)





local AutoFarm = Window:CreateTab("Teleport", nil)


-- ตั้งค่าการเชื่อมโยงปุ่ม Teleport
createToggle(AutoFarm, "Kung Lv.700", function(V)
    if V then
        game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-999.582397, 36.8905754, -1551.56238)
    end
end)

createToggle(AutoFarm, "Event", function(V)
    if V then
        game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(52.9493446, 243.331482, 1059.41846)
    end
end)

createToggle(AutoFarm, "Villagers Lv300", function(V)
    if V then
        game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-930.338684, 28.3464279, 199.77359)
    end
end)

createToggle(AutoFarm, "Shopping Island", function(V)
    if V then
        game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(861.83551, 18.4624214, 392.129822)
    end
end)

createToggle(AutoFarm, "Startup Village", function(V)
    if V then
        game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(368.922516, 33.775032, -573.300781)
    end
end)

createToggle(AutoFarm, "Desert", function(V)
    if V then
        game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1385.73425, 20.4297142, -406.426605)
    end
end)


