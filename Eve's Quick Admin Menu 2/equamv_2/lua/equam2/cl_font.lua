function equam2.CreateFont(name, size, weight)
    surface.CreateFont("equam2." .. name, {
        font = "Comfortaa",
        size = size or 16,
        weight = weight or 500,
        shadow = true
    })
end