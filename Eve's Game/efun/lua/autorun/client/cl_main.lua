
MsgC(Color(204,124,33), "[efn]", Color(236,236,236), "loaded succesfully efun/lua/autorun/client/cl_main.lua\n")

eve.CreateFont("efn.info", 22)
eve.CreateFont("efn.card", 26)
eve.CreateFont("efn.cost", 28)
eve.CreateFont("efn.end", 34)

efn.random = false
efn.setEnymies = {}

local function menuOpen()

    efn.hp, efn.mp = 100, 100
    efn.shp, efn.smp = 100, 100

    efn.frameW, efn.frameH = 1800, 1000

    efn.turn = true
    efn.turnTime = 0

    efn.CurEnymies = {}

    efn.selected = 1

    efn.stunned = false

    local function TurnTimer()
        if not timer.Exists("efnTurnTimer") then
            timer.Create("efnTurnTimer", 1, 0, function()
                if efn.turnTime > 0 then
                    efn.turnTime = efn.turnTime - 1
                else
                    timer.Remove("efnTurnTimer")
                    efn.turn = true
                    enymiesRelaod()
                    if efn.stunned then
                        efn.stunned = false
                        efn.turn = false
                        TurnTimer()
                        efn.turnTime = efn.DfTurnTime
                        enymiesTurn()
                    end
                end
            end)
        end
    end

    local frame = vgui.Create("eve.frame")
    frame:SetSize(efn.frameW, efn.frameH)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Eve's Game")

    local function endScreenn()
        frame:Remove()
        local endframe = vgui.Create("eve.frame")
        endframe:SetSize(400, 200)
        endframe:Center()
        endframe:MakePopup()
        endframe:SetTitle("Eve's Game")

        local endPanel = endframe:Add("DPanel")
        endPanel:Dock(FILL)
        local msg, cl = "You Won!", eve.theme.green
        if efn.hp < 1 then
            msg, cl = "You Lost", eve.theme.red
        end
        endPanel.Paint = function(pnl, w, h)
            draw.SimpleText(msg, "eve.efn.end", w / 2, h / 2, cl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    // hotbar
    efn.hotBar = frame:Add("DPanel")
    efn.hotBar:Dock(BOTTOM)
    efn.hotBar:DockMargin(5, 5, 5, 5)

    efn.hotBar.Paint = function(pnl, w, h)
        draw.RoundedBox(10, 0, 0, w, h, eve.theme.primary)
    end

    // items
    local items = {}
    efn.inv = {}
    local invsave = {}

    for var = 1, efn.startHand do
        table.insert(items, table.Count(items) + 1, efn.cards[math.random(1, table.Count(efn.cards))])
    end

    local function drawCards()
        for k, v in pairs(items) do
            efn.inv[table.Count(efn.inv) + 1] = efn.hotBar:Add("DButton")
            local ipnl = efn.inv[table.Count(efn.inv)]
            if IsValid(ipnl) then
                ipnl:Dock(LEFT)
                ipnl:DockMargin(5, 5, 0, 5)
                ipnl:SetText("")
                ipnl.Paint = function(pnl, w, h)
                    draw.RoundedBox(10, 0, 0, w, h, eve.theme.secondary)
                    draw.SimpleText(v.name, "eve.efn.card", w / 2, 5, eve.theme.text.h2, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    draw.SimpleText(v.txt1, "eve.efn.cost", w / 2, h / 2, v.cl1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(v.txt2, "eve.efn.cost", w / 2, h - 5, v.cl2, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    if not efn.turn then
                        draw.RoundedBox(10, 0, 0, w, h, eve.theme.buyBtn)
                    end
                end
        
                ipnl.DoClick = function(pnl)
                    if not efn.turn then return end
                    if efn.mp < v.cost then
                        return 
                    end
                    v.func(LocalPlayer())
                    if efn.mp > 100 then
                        efn.mp = 100
                    elseif efn.mp < 1 then
                        efn.mp = 0
                    end
                    if efn.hp > 100 then
                        efn.hp = 100
                    elseif efn.hp < 1 then
                        efn.hp = 0
                    end
                    ipnl:Remove()
                    if efn.hp < 1 then
                        endScreenn()
                    end
                    local enymiesCount = 0
                    for k, v in ipairs(efn.CurEnymies) do
                        if IsValid(v) then
                            enymiesCount = enymiesCount + 1
                        end
                    end
                    if enymiesCount < 1 then
                        endScreenn()
                    end
                end
        
                ipnl.name = v.name
                ipnl.txt1 = v.txt1
                ipnl.txt2 = v.txt2

                items[k] = nil
                invsave[table.Count(invsave) + 1] = v
            end
        end
    end

    function efn.insertRandom(num)
        local delay = 0
        for var = 1, num do
            timer.Simple(delay, function()
                if table.Count(efn.hotBar:GetChildren()) < efn.maxHand then
                    table.insert(items, table.Count(items) + 1, efn.cards[math.random(1, table.Count(efn.cards))])
                    drawCards()
                end
            end)
            delay = delay + math.random(0.1, 0.2)
        end
    end

    drawCards()

    function efn.hotBar:PerformLayout(w, h)
        self:SetHeight(100)
        for k, v in pairs(efn.inv) do
            if IsValid(v) then
                surface.SetFont("eve.efn.card")
                local tw = surface.GetTextSize(v.name)
                local tw1 = surface.GetTextSize(v.txt1)
                local tw2 = surface.GetTextSize(v.txt2)
                if tw < tw1 then
                    tw = tw1
                end
                if tw < tw2 then
                    tw = tw2
                end
                if tw < 60 then
                    tw = 60
                end
                v:SetWide(tw + 20)
            end
        end
    end

    // info bar
    local ib = frame:Add("DPanel")
    ib:Dock(BOTTOM)
    ib:DockMargin(5, 5, 5, 0)

    function ib:PerformLayout(w, h)
        self:SetHeight(20)
    end

    ib.Paint = function(pnl, w, h)
        // hp
        draw.RoundedBox(10, 0, 0, 300, h, eve.theme.primary)
        
        efn.shp = Lerp(FrameTime() * 10, efn.shp, efn.hp)
        draw.RoundedBox(10, 0, 0, 300 * (efn.shp / 100), h, eve.theme.red)
        draw.SimpleText(efn.hp .."/100", "eve.efn.info", 150, h / 2, eve.theme.text.h2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        // mp
        draw.RoundedBox(10, 305, 0, 300, h, eve.theme.primary)

        efn.smp = Lerp(FrameTime() * 10, efn.smp, efn.mp)
        draw.RoundedBox(10, 305, 0, 300 * (efn.smp / 100), h, eve.theme.blue)
        draw.SimpleText(efn.mp .."/100", "eve.efn.info", 455, h / 2, eve.theme.text.h2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText(LocalPlayer():Nick(), "eve.efn.info", 610, h / 2, eve.theme.text.h2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetFont("eve.efn.info")
        local nmw = surface.GetTextSize(LocalPlayer():Nick()) + 5

        draw.SimpleText(table.Count(efn.hotBar:GetChildren()) .."/".. efn.maxHand, "eve.efn.info", 610 + nmw, h / 2, eve.theme.text.h2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        // turn timer
        /*
        if not efn.turn then
            draw.SimpleText(efn.turnTime, "eve.efn.info", w - 210, h / 2, eve.theme.text.h2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
        */

        // status
        if efn.stunned then
            draw.RoundedBox(10, 800, 0, 120, h, eve.theme.orange)
            draw.SimpleText("Stunned", "eve.efn.info", 860, h / 2, eve.theme.text.h2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    // next turn
    local nt = ib:Add("DButton")
    nt:Dock(RIGHT)
    nt:DockMargin(5, 0, 5, 0)
    nt:SetText("")

    function nt:PerformLayout(w, h)
        self:SetWide(200)
    end

    nt.Paint = function(pnl, w, h)
        local ntTxt = "Next Turn"
        if not efn.turn then
            ntTxt = "Opponent's turn"
        end
        draw.RoundedBox(10, 0, 0, w, h, eve.theme.primary)
        draw.SimpleText(ntTxt, "eve.efn.info", w / 2, h / 2, eve.theme.text.h2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    nt.DoClick = function(pnl)
        if not efn.turn then return end
        efn.turn = false
        //TurnTimer()
        efn.mp = efn.mp + efn.income
        if efn.mp > 100 then
            efn.mp = 100
        elseif efn.mp < 1 then
            efn.mp = 0
        end
        efn.insertRandom(efn.cardsDrawn)
        enymiesTurn()
    end
    
    // main panel
    local main = frame:Add("DPanel")
    main:Dock(FILL)
    main:DockMargin(5, 5, 5, 0)

    main.Paint = function(pnl, w, h)
        
    end

    // enymies panel
    local enemycount = efn.startEnymies
    local ew, eh = efn.frameW, 300

    local ep = main:Add("DPanel")
    ep:SetSize(ew, eh)
    ep:SetPos((efn.frameW - ew) / 2, (efn.frameH - eh) / 2.5)

    ep.Paint = function(pnl, w, h)
    end

    function enymiesTurn()
        local delay = math.random(0.5, 1.3)
        for k, v in ipairs(efn.CurEnymies) do
            if IsValid(v) then
                for var = 1, v.moves do
                    if efn.hp < 1 then
                        endScreenn()
                        return
                    end
                    timer.Simple(delay, function()
                        if not IsValid(frame) then return end
                        v.moves = v.moves - 1
                        v.action[math.random(1, table.Count(v.action))](v)
                        if efn.hp < 1 then
                            endScreenn()
                            return
                        end
                    end)
                    delay = delay + math.random(0.3, 0.8)
                end
            end
        end
        timer.Simple(delay, function()
            efn.turn = true
            enymiesRelaod()
            if efn.stunned then
                efn.stunned = false
                efn.turn = false
                //TurnTimer()
                enymiesTurn()
            end
        end)
    end

    function enymiesRelaod()
        for k, v in ipairs(efn.CurEnymies) do
            if IsValid(v) then
                v.moves = v.maxMoves 
            end
        end
    end

    efn.spawnEnymies = {}

    local function drawEnymies()
        for k, v in ipairs(efn.spawnEnymies) do
            efn.CurEnymies[table.Count(efn.CurEnymies) + 1] = ep:Add("DButton")
            local pnl = efn.CurEnymies[table.Count(efn.CurEnymies)]
    
            pnl:Dock(LEFT)
            pnl:DockMargin(5, 0, 5, 0)
            pnl:SetText("")
    
            pnl.hp = v.hp
            pnl.moves = v.moves
            pnl.maxMoves = v.moves
            pnl.action = v.action
            pnl.num = table.Count(efn.CurEnymies)
    
            pnl.Paint = function(pnl, w, h)
                draw.RoundedBox(10, 0, 0, w, h, eve.theme.primary)
                draw.SimpleText(v.name, "eve.efn.card", w / 2, 5, eve.theme.text.h2, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    
                // selected
                if efn.selected == pnl.num then
                    draw.RoundedBox(10, 0, 0, w, h, Color(185,185,185,12))
                end
    
                // hp
                draw.RoundedBox(10, 5, h - 20, w - 10, 15, eve.theme.secondary)
                draw.RoundedBox(10, 5, h - 20, (w - 10) * (pnl.hp / v.hp), 15, eve.theme.red)
                draw.SimpleText(pnl.hp .."/".. v.hp, "eve.efn.info", w / 2, h - 14, eve.theme.text.h2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                if pnl.hp < 1 then
                    pnl:Remove()
                    for k, v in ipairs(efn.CurEnymies) do
                        if IsValid(v) then
                            efn.selected = v.num
                            return
                        end
                    end
                    local enymiesCount = 0
                    for k, v in ipairs(efn.CurEnymies) do
                        if IsValid(v) then
                            enymiesCount = enymiesCount + 1
                        end
                    end
                    if enymiesCount < 1 then
                        endScreenn()
                    end
                end
    
                // moves
                draw.SimpleText("Moves ".. pnl.moves .."/".. v.moves, "eve.efn.info", w / 2, h - 25, eve.theme.text.h2, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            end
    
            pnl.DoClick = function(pnl)
                efn.selected = pnl.num
            end
            
            efn.spawnEnymies[k] = nil
        end 
    end

    function efn.addEnymy(num)
        enemycount = enemycount + 1
        efn.spawnEnymies[table.Count(efn.spawnEnymies) + 1] = efn.enymies[num]
        drawEnymies()
    end

    function ep:PerformLayout(w, h)
        for k, v in pairs(efn.CurEnymies) do
            if IsValid(v) then
                v:SetWide(200)
            end
        end
    end

    if efn.random then
        for var = 1, efn.startEnymies do
            efn.addEnymy(math.random(1, table.Count(efn.enymies)))
        end 
    else
        for k, v in pairs(efn.setEnymies) do
            efn.addEnymy(v)
        end
    end

end

efn.buttons = {
    [1] = {
        name = "Levels",
        func = function(v)
            for k, v in ipairs(efn.introPanel:GetChildren()) do
                v:Remove()
            end
            efn.random = false
            efn.drawIntroButtons(efn.buttons[1].btns)
        end,
        btns = {
            [1] = {
                name = "Level 1",
                func = function(v)
                    efn.introframe:Remove()

                    efn.income = 30

                    efn.startHand = 6
                    efn.maxHand = 15
                    efn.cardsDrawn = 3

                    efn.DfTurnTime = 3

                    efn.setEnymies = {
                        1
                    }
                    menuOpen()
                end
            },
            [2] = {
                name = "Level 2",
                func = function(v)
                    efn.introframe:Remove()
                    
                    efn.income = 30

                    efn.startHand = 5
                    efn.maxHand = 15
                    efn.cardsDrawn = 3

                    efn.DfTurnTime = 6

                    efn.setEnymies = {
                        2,
                        1
                    }
                    menuOpen()
                end
            },
            [3] = {
                name = "Level 3",
                func = function(v)
                    efn.introframe:Remove()
                    
                    efn.income = 30

                    efn.startHand = 5
                    efn.maxHand = 15
                    efn.cardsDrawn = 3

                    efn.DfTurnTime = 6

                    efn.setEnymies = {
                        3,
                        4
                    }
                    menuOpen()
                end
            },
            [4] = {
                name = "Level 4",
                func = function(v)
                    efn.introframe:Remove()
                    
                    efn.income = 30

                    efn.startHand = 5
                    efn.maxHand = 13
                    efn.cardsDrawn = 2

                    efn.DfTurnTime = 8

                    efn.setEnymies = {
                        2,
                        3,
                        1
                    }
                    menuOpen()
                end
            }
        }
    },
    [2] = {
        name = "Random",
        func = function(v)
            for k, v in ipairs(efn.introPanel:GetChildren()) do
                v:Remove()
                efn.drawIntroButtons(efn.buttons[2].btns)
            end
            efn.random = true
        end,
        btns = {
            [1] = {
                name = "Easy",
                func = function(v)
                    efn.introframe:Remove()
                    efn.income = 30

                    efn.startHand = 6
                    efn.maxHand = 15
                    efn.cardsDrawn = 3

                    efn.DfTurnTime = 8
                    efn.startEnymies = 1
                    menuOpen()
                end
            },
            [2] = {
                name = "Medium",
                func = function(v)
                    efn.introframe:Remove()
                    efn.income = 30

                    efn.startHand = 5
                    efn.maxHand = 15
                    efn.cardsDrawn = 3

                    efn.DfTurnTime = 8
                    efn.startEnymies = 2
                    menuOpen()
                end
            },
            [3] = {
                name = "Hard",
                func = function(v)
                    efn.introframe:Remove()
                    efn.income = 30

                    efn.startHand = 5
                    efn.maxHand = 15
                    efn.cardsDrawn = 3

                    efn.DfTurnTime = 10
                    efn.startEnymies = 3
                    menuOpen()
                end
            },
            [4] = {
                name = "Good Luck",
                func = function(v)
                    efn.introframe:Remove()
                    efn.income = 30

                    efn.startHand = 6
                    efn.maxHand = 12
                    efn.cardsDrawn = 2

                    efn.DfTurnTime = 12
                    efn.startEnymies = 4
                    menuOpen()
                end
            }
        }
    },
    [3] = {
        name = "Discord",
        func = function(v)
            gui.OpenURL("https://discord.gg/tAbYC4dT5q") 
            // I ask you leave this as my discord,
            // the addon is free so i want at least to be recognised for my work.
            // (The discord is not for a gmod server but a gmod community server)
        end
    }
}

local function introOpen()
    efn.introframe = vgui.Create("eve.frame")
    efn.introframe:SetSize(400, 200)
    efn.introframe:Center()
    efn.introframe:MakePopup()
    efn.introframe:SetTitle("Eve's Game")

    efn.introPanel = efn.introframe:Add("DPanel")
    efn.introPanel:Dock(FILL)
    efn.introPanel.Paint = function(pnl, w, h)
    end

    // buttons
    local pnls = {}
    function efn.drawIntroButtons(tbl)
        for k, v in ipairs(tbl) do
            pnls[v.name] = efn.introPanel:Add("eve.button")
            local pnl = pnls[v.name]
            pnl:Dock(TOP)
            pnl:DockMargin(5, 5, 5, 0)
            pnl:SetTxt(v.name)
    
            pnl.DoClick = function(pnl)
                v.func(v)
            end
        end
    end

    efn.drawIntroButtons(efn.buttons)
    
end

hook.Add("OnPlayerChat", "efn", function(ply, txt)
    if ply != LocalPlayer() return end
    if txt == "!efn" then
        introOpen()
    end
end)

concommand.Add("eve_game_open", function(ply, cmd, args)
    if ply != LocalPlayer() return end
    introOpen()
end)