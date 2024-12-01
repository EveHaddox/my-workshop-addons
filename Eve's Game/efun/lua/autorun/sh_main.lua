MsgC(Color(33,204,90), "[efn]", Color(236,236,236), "loaded succesfully efun/lua/autorun/sh_main.lua\n")

efn = efn or {}

eve = eve or {}

eve.theme = {
    primary = Color(51, 53, 56),
    secondary = Color(45, 46, 49),
    light = Color(55, 56, 59),
    accent = Color(192, 57, 43),

    background = Color(39, 41, 44),
    backgroundSec = Color(60, 63, 66),

    closeBtn = Color(185, 185, 185),
    buyBtn = Color(0, 0, 0, 100),
    button = {
        hover = Color(69, 70, 73),
        txtHover = Color(228, 228, 228)
    },

    text = {
        h1 = Color(185, 185, 185),
        h2 = Color(165, 165, 165),
        h3 = Color(145, 145, 145),
        h4 = Color(125, 125, 125)
    },
    red = Color(145, 48, 48),
    orange = Color(145, 95, 48),
    green = Color(50, 145, 50),
    blue = Color(50, 95, 145)
}

efn.income = 30

efn.startHand = 5
efn.maxHand = 15
efn.cardsDrawn = 3

efn.DfTurnTime = 5

efn.startEnymies = 3

efn.efc = {
    [1] = function()
        efn.hp = efn.hp - 20      
    end,
    [2] = function()
        efn.hp = efn.hp + 20      
    end,
    [3] = function()
        efn.mp = efn.mp - 20    
    end,
    [4] = function()
        efn.mp = efn.mp + 20   
    end,
    [5] = function()
        if table.Count(efn.inv) > 0 then
            for var = 1, math.random(1, table.Count(efn.inv)) do
                efn.inv[math.random(1, table.Count(efn.inv))]:Remove()
            end
        end 
    end,
    [6] = function()
        efn.insertRandom(math.random(1, 7))
    end,
    [7] = function()
        efn.hp = efn.hp - 90   
    end,
    [8] = function()
        efn.mp = efn.mp - 100
    end,
    [9] = function()
        efn.CurEnymies[efn.selected].hp = efn.CurEnymies[efn.selected].hp - math.random(1, 200)
    end
}

efn.cards = {
    [1] = {
        name = "Sacrafice",
        txt1 = "MP +20",
        txt2 = "HP -10",
        cl1 = eve.theme.blue,
        cl2 = eve.theme.red,
        cost = 0,
        func = function()
            efn.hp = efn.hp - 10
            efn.mp = efn.mp + 20
        end
    },
    [2] = {
        name = "Heal",
        txt1 = "MP -10",
        txt2 = "HP +20",
        cost = 10,
        cl1 = eve.theme.blue,
        cl2 = eve.theme.red,
        func = function()
            efn.hp = efn.hp + 20
            efn.mp = efn.mp - 10
        end
    },
    [3] = {
        name = "Draw",
        txt1 = "MP -10",
        txt2 = "Draw 2",
        cost = 10,
        cl1 = eve.theme.blue,
        cl2 = eve.theme.text.h3,
        func = function()
            efn.mp = efn.mp - 10
            efn.insertRandom(2)
        end
    },
    [4] = {
        name = "Magic Missle",
        txt1 = "MP -20",
        txt2 = "Damage 20",
        cost = 20,
        cl1 = eve.theme.blue,
        cl2 = eve.theme.red,
        func = function()
            efn.mp = efn.mp - 20
            efn.CurEnymies[efn.selected].hp = efn.CurEnymies[efn.selected].hp - 20
        end
    },
    [5] = {
        name = "Stun",
        txt1 = "MP -30",
        txt2 = "Stun 1",
        cost = 30,
        cl1 = eve.theme.blue,
        cl2 = eve.theme.orange,
        func = function()
            efn.mp = efn.mp - 30
            efn.CurEnymies[efn.selected].moves = efn.CurEnymies[efn.selected].moves - 1
        end
    },
    [6] = {
        name = "Gun",
        txt1 = "Damage 50",
        txt2 = "",
        cost = 0,
        cl1 = eve.theme.red,
        cl2 = eve.theme.blue,
        func = function()
            efn.CurEnymies[efn.selected].hp = efn.CurEnymies[efn.selected].hp - 50
        end
    },
    [7] = {
        name = "Chaos",
        txt1 = "Random",
        txt2 = "Effect",
        cost = 0,
        cl1 = eve.theme.red,
        cl2 = eve.theme.green,
        func = efn.efc[math.random(1, table.Count(efn.efc))]
    },
    [8] = {
        name = "Red Bull",
        txt1 = "MP +30",
        txt2 = "HP -5",
        cost = 0,
        cl1 = eve.theme.blue,
        cl2 = eve.theme.red,
        func = function()
            efn.hp = efn.hp - 5
            efn.mp = efn.mp + 30
        end
    },
    [9] = {
        name = "Reshufle",
        txt1 = "New Cards",
        txt2 = "",
        cost = 0,
        cl1 = eve.theme.green,
        cl2 = eve.theme.red,
        func = function()
            local amt = table.Count(efn.hotBar:GetChildren())
            if amt > 0 then
                for k, v in ipairs(efn.inv) do
                    v:Remove()
                end
            end
            efn.inv = {}
            efn.insertRandom(amt)
        end
    },
    [10] = {
        name = "Fireball",
        txt1 = "MP -50",
        txt2 = "Damage 80",
        cost = 50,
        cl1 = eve.theme.blue,
        cl2 = eve.theme.red,
        func = function()
            efn.mp = efn.mp - 50
            efn.CurEnymies[efn.selected].hp = efn.CurEnymies[efn.selected].hp - 80
        end
    }
}

efn.enymies = {
    [1] = {
        name = "Goblin",
        hp = 80,
        moves = 1,
        action = {
            [1] = function()
                    efn.hp = efn.hp - math.random(1, 15)
                end,
            [2] = function()
                    if table.Count(efn.inv) > 0 then
                        efn.inv[math.random(1, table.Count(efn.inv))]:Remove()
                    end
                end
        }
    },
    [2] = {
        name = "Orc",
        hp = 150,
        moves = 1,
        action = {
            [1] = function()
                    efn.hp = efn.hp - math.random(1, 30)
                end,
            [2] = function()
                    efn.stunned = true
                end,
            [3] = function()
                efn.hp = efn.hp - math.random(1, 20)
            end
        }
    },
    [3] = {
        name = "Necromancer",
        hp = 70,
        moves = 2,
        action = {
            [1] = function()
                    efn.hp = efn.hp - math.random(1, 20)
                end,
            [2] = function(v)
                    v.hp = v.hp + math.random(1, 20)
                    if v.hp > 70 then
                        v.hp = 70
                    end
                end,
            [3] = function(v)
                if table.Count(efn.CurEnymies) < 8 then
                    efn.addEnymy(4)
                end
            end
        }
    },
    [4] = {
        name = "Skeleton",
        hp = 30,
        moves = 1,
        action = {
            [1] = function()
                    efn.hp = efn.hp - math.random(1, 20)
                end
        }
    }
}