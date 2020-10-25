SolanyaTweaksMixin = {}

local guildCountButtonEnabled = true;
local hideHelmetButtonEnabled = true;
local randomStuffEnabled = true;

local function PersonalTweaks()
	PlayerPowerBarAlt:SetPoint("BOTTOM", 0, 220);
	CastingBarFrame:SetPoint("BOTTOM", 0, 220);
end

function SolanyaTweaksMixin:OnLoad()
	-- Guild count button
	if guildCountButtonEnabled then
		self:RegisterEvent("GUILD_ROSTER_UPDATE");
		self:RegisterEvent("PLAYER_GUILD_UPDATE");
		self:UpdateDisplayedGuildCount();
		self.button:SetDesaturated(1);
		self.button:SetVertexColor(0.3, 1, 0.3);
	else
		self:Hide();
	end
	-- Hide helmet in set collection
	if hideHelmetButtonEnabled then
		self:RegisterEvent("ADDON_LOADED");
	end
	-- Casting bar
	if randomStuffEnabled then
		self:RegisterEvent("PLAYER_ENTERING_WORLD");
	end
end

function SolanyaTweaksMixin:OnEvent(event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		-- Casting bar
		C_Timer.After(2, PersonalTweaks)
	elseif event == "ADDON_LOADED" then
		-- Hide helmet in set collection
		if ... == "Blizzard_Collections" then
			local hideHelmetButton = CreateFrame("Button", "SolanyaTweaksHideHelmetButton", WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame);
			hideHelmetButton:SetPoint("TOPLEFT", 10, -10);
			hideHelmetButton:SetSize(40, 40);
			hideHelmetButton:SetNormalAtlas("transmog-nav-slot-head");
			hideHelmetButton:SetHighlightAtlas("bags-roundhighlight", "ADD");
			hideHelmetButton:SetScript("OnClick", function() WardrobeCollectionFrame.SetsCollectionFrame.Model:UndressSlot(1) end)
		end
	else
		-- Guild count button
		self:UpdateDisplayedGuildCount();
	end
end

function SolanyaTweaksMixin:UpdateDisplayedGuildCount()
    if not IsInGuild() then return end

    C_GuildInfo.GuildRoster();
    local _, _, onlineMembers = GetNumGuildMembers();
    self.count:SetText(onlineMembers - 1);  -- Minus 1 to exclude myself
end

function SolanyaTweaksMixin:OnClick()
    ToggleGuildFrame();
end

function SolanyaTweaksMixin:OnMouseDown()
    self.button:SetAtlas("quickjoin-button-friendslist-down");
end

function SolanyaTweaksMixin:OnMouseUp()
    self.button:SetAtlas("quickjoin-button-friendslist-up");
end