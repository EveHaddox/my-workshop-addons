// Addon made by Eve Haddox
// my discord "evehaddox"

function ehc.CreateFont(name, size, weight)
    surface.CreateFont("ehc." .. name, {
        font = "Comfortaa",
        size = size or 16,
        weight = weight or 500,
		shadow = true
    })
end

ehc.CreateFont("28", 28)
ehc.CreateFont("22", 22)

// door hud
ehc.CreateFont("80", 80)
ehc.CreateFont("100", 100)

// crash screen
ehc.CreateFont("60", 60)