SolanyaTweaksMixin = {}

local function PersonalTweaks()
	PlayerPowerBarAlt:SetPoint("BOTTOM", 0, 220);
	CastingBarFrame:SetPoint("BOTTOM", 0, 220);
end

function SolanyaTweaksMixin:OnLoad()
    self:RegisterEvent("GUILD_ROSTER_UPDATE");
    self:RegisterEvent("PLAYER_GUILD_UPDATE");
    self:RegisterEvent("ADDON_LOADED");	-- Set collection checkbox
	self:RegisterEvent("PLAYER_ENTERING_WORLD");	-- Casting bar
    self:UpdateDisplayedGuildCount();
    self.button:SetDesaturated(1);
    self.button:SetVertexColor(0.3, 1, 0.3);
end

function SolanyaTweaksMixin:OnEvent(event, ...)
	if event == "PLAYER_ENTERING_WORLD" then	-- Casting bar
		C_Timer.After(2, PersonalTweaks)
	elseif event == "ADDON_LOADED" then	-- Set collection checkbox
		if ... == "Blizzard_Collections" then
			local hideHelmetButton = CreateFrame("Button", "SolanyaTweaksHideHelmetButton", WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame);
			hideHelmetButton:SetPoint("TOPLEFT", 10, -10);
			hideHelmetButton:SetSize(40, 40);
			hideHelmetButton:SetNormalAtlas("transmog-nav-slot-head");
			hideHelmetButton:SetHighlightAtlas("bags-roundhighlight", "ADD");
			hideHelmetButton:SetScript("OnClick", function() WardrobeCollectionFrame.SetsCollectionFrame.Model:UndressSlot(1) end)
		end
	else
		self:UpdateDisplayedGuildCount();
	end
end

function SolanyaTweaksMixin:UpdateDisplayedGuildCount()
    if not IsInGuild() then return end

    C_GuildInfo.GuildRoster();
    local _, _, onlineMembers = GetNumGuildMembers();
    self.count:SetText(onlineMembers - 1);  -- Minus 1 to exclude myself
end

function SolanyaTweaksMixin:OnClick(button)
    ToggleGuildFrame();
end

function SolanyaTweaksMixin:OnMouseDown()
    self.button:SetAtlas("quickjoin-button-friendslist-down");
end

function SolanyaTweaksMixin:OnMouseUp()
    self.button:SetAtlas("quickjoin-button-friendslist-up");
end