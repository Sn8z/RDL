local addonName, rDL = ...

-- Death Counter Text
local deathCounter = UIParent:CreateFontString("RdlCounterText", "BACKGROUND", "GameTooltipText")
deathCounter:SetPoint("TOP", UIParent, "TOP", 0, -5)

-- Event frame
local rdlFrame = CreateFrame("Frame")
rdlFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
rdlFrame:SetScript("OnEvent", function(self, event)
	self:OnEvent(event, CombatLogGetCurrentEventInfo())
end)

local function updateCounter()
	RdlDB.deaths = RdlDB.deaths + 1
	deathCounter:SetText(tostring(RdlDB.deaths))
	RdlDB.last = date("%m/%d/%y %H:%M:%S")
	PlaySound(9036)
	SendChatMessage("LUL, du har nu dött" .. " " .. RdlDB.deaths .. " " .. "gånger med mig.", "WHISPER", "Common", "Drakbrink")
	print("Robin |cffff0000 died|r.")
end

function rdlFrame:OnEvent(event, ...)
	local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

	if subevent == "UNIT_DIED" then
		if destName == "Drakbrink" then
			updateCounter()
		end
	end
end

-- savedvariables stuff
local dbFrame = CreateFrame("Frame")
dbFrame:RegisterEvent("ADDON_LOADED")
dbFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == addonName then
		RdlDB = RdlDB or {}
		RdlDB.deaths = RdlDB.deaths or 0
		RdlDB.last = RdlDB.last or "aldrig"
		deathCounter:SetText(tostring(RdlDB.deaths))
		print("|cffff0000 RDL|r loaded.")
	end
end)

-- slash cmds
local function rdlPrint(msg)
	local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
	if cmd == nil then
		print("Robin har dött" .. " " .. RdlDB.deaths .. " " .. "gånger.")
	elseif cmd == "last" then
		print("Robin dog senast" .. " " .. RdlDB.last)
	elseif cmd == "reset" then
		RdlDB = {}
		RdlDB.deaths = 0
		RdlDB.last = "aldrig"
		print("RDL data have been reset.")
	elseif cmd == "test" then
		updateCounter()
	end
end

SlashCmdList['RDL_SLASHCMD'] = rdlPrint
SLASH_RDL_SLASHCMD1 = '/rdl'
