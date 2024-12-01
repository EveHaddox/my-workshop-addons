// Script made by Eve Haddox
// discord evehaddox

eds.delay = 5 -- the respawn cooldown
eds.notiftime = 1 -- how long the wait notiffication stays on screen

eds.title = {}
eds.title.default = "You Died" -- default text in left right
eds.title.suicide = "Suicide" -- text in left right if it was a suicide

eds.name = {}
eds.name.killer = "Defeated By" -- text above killer
eds.name.weapon = "Using a" -- text above weapon

eds.nokiller = "player" -- the killer name if no killer detected (usualy when killed by fall damage) if its set to "player" it displays player's nick

eds.noweapon = "Command" -- when no weapon detected (killed by a command)
eds.falldamage = "Fall Damage" -- if died by falling

eds.color = {}
eds.color.disabled = Color(59,77,85) -- auto respawn button color when disabled
eds.color.enabled = Color(44,140,76) -- auto respawn button color when enabled

eds.color.txt = Color(240,240,240) -- text color

eds.color.main = Color(39, 41, 44)
eds.color.secondary = Color(51, 53, 56)
eds.color.accent = Color(192, 57, 43)