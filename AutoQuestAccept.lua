local addonName = "AutoQuestAccept"
local addonVersion = "0.1.1"
local repoUrl = "https://github.com/sebastianvanhemelrijck/AutoQuestAccept"
local issuesUrl = "https://github.com/sebastianvanhemelrijck/AutoQuestAccept/issues"

local function AQA_UpdateStatusUI()
    if AQA_EnableCheck and AQA_DB then
        AQA_EnableCheck:SetChecked(not not AQA_DB.enabled)
    end
    if AQA_StatusText then
        if AQA_DB and AQA_DB.enabled then
            AQA_StatusText:SetText("Status: ON")
            AQA_StatusText:SetTextColor(0.2, 1.0, 0.2)
        else
            AQA_StatusText:SetText("Status: OFF")
            AQA_StatusText:SetTextColor(1.0, 0.2, 0.2)
        end
    end
end

local function AQA_PrintStatus()
    local status = "OFF"
    if AQA_DB and AQA_DB.enabled then
        status = "ON"
    end
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("AutoQuestAccept v" .. addonVersion .. ": " .. status .. ". Type /aq to open UI.")
    end
end

local function AQA_ShowUI()
    if not AQA_UI then
        AQA_CreateUI()
    end
    AQA_UI:Show()
    if AQA_UI.Raise then
        AQA_UI:Raise()
    end
    AQA_UpdateStatusUI()
end

local function AQA_SetEnabled(value)
    if not AQA_DB then
        AQA_DB = { enabled = true }
    end
    AQA_DB.enabled = value
    AQA_UpdateStatusUI()
    AQA_PrintStatus()
end

local function AQA_AcceptAndClose()
    AcceptQuest()
    if CloseQuest then
        CloseQuest()
    end
    if QuestFrame and QuestFrame:IsShown() and HideUIPanel then
        HideUIPanel(QuestFrame)
    end
end

local function AQA_ShowLinkPopup(title, url)
    if not AQA_LinkPopup then
        local pf = CreateFrame("Frame", "AQA_LinkPopup", UIParent)
        pf:SetWidth(420)
        pf:SetHeight(140)
        pf:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        pf:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            tileSize = 32,
            edgeSize = 32,
            insets = { left = 8, right = 8, top = 8, bottom = 8 }
        })
        pf:SetBackdropColor(0, 0, 0, 0.9)
        pf:SetMovable(true)
        pf:EnableMouse(true)
        pf:RegisterForDrag("LeftButton")
        pf:SetScript("OnDragStart", function()
            pf:StartMoving()
        end)
        pf:SetScript("OnDragStop", function()
            pf:StopMovingOrSizing()
        end)
        pf:SetClampedToScreen(true)
        pf:Hide()

        local titleText = pf:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        titleText:SetPoint("TOP", pf, "TOP", 0, -18)
        titleText:SetText("Link")

        local editBox = CreateFrame("EditBox", "AQA_LinkPopupEdit", pf, "InputBoxTemplate")
        editBox:SetWidth(320)
        editBox:SetHeight(20)
        editBox:SetPoint("TOP", titleText, "BOTTOM", 0, -14)
        editBox:SetAutoFocus(false)
        editBox:SetJustifyH("CENTER")
        editBox:SetScript("OnEditFocusGained", function()
            editBox:HighlightText()
        end)
        editBox:SetScript("OnEnterPressed", function()
            editBox:ClearFocus()
        end)
        editBox:SetScript("OnEscapePressed", function()
            pf:Hide()
        end)

        local close = CreateFrame("Button", nil, pf, "UIPanelButtonTemplate")
        close:SetWidth(80)
        close:SetHeight(20)
        close:SetPoint("BOTTOM", pf, "BOTTOM", 0, 16)
        close:SetText("Close")
        close:SetScript("OnClick", function()
            pf:Hide()
        end)

        pf.titleText = titleText
        pf.editBox = editBox
        AQA_LinkPopup = pf
        tinsert(UISpecialFrames, "AQA_LinkPopup")
    end

    AQA_LinkPopup.titleText:SetText(title)
    AQA_LinkPopup.editBox:SetText(url)
    AQA_LinkPopup:Show()
    AQA_LinkPopup.editBox:HighlightText()
    AQA_LinkPopup.editBox:SetFocus()
end

function AQA_CreateUI()
    if AQA_UI then
        return
    end
    if not AQA_DB then
        AQA_DB = { enabled = true }
    end
    if AQA_DB.enabled == nil then
        AQA_DB.enabled = true
    end

    local f = CreateFrame("Frame", "AQA_UI", UIParent)
    f:SetWidth(420)
    f:SetHeight(220)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })
    f:SetBackdropColor(0, 0, 0, 0.9)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function()
        f:StartMoving()
    end)
    f:SetScript("OnDragStop", function()
        f:StopMovingOrSizing()
    end)
    f:SetClampedToScreen(true)
    f:Hide()

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", f, "TOP", 0, -16)
    title:SetText("AutoQuestAccept")

    local versionText = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    versionText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -40, -18)
    versionText:SetText("v" .. addonVersion)

    local subtitle = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -40)
    subtitle:SetWidth(340)
    subtitle:SetJustifyH("LEFT")
    subtitle:SetText("Auto-accept quests on QUEST_DETAIL.")

    local check = CreateFrame("CheckButton", "AQA_EnableCheck", f, "UICheckButtonTemplate")
    check:SetPoint("TOPLEFT", f, "TOPLEFT", 24, -62)
    check:SetScript("OnClick", function()
        AQA_SetEnabled(not not check:GetChecked())
    end)
    getglobal(check:GetName() .. "Text"):SetText("Enable auto-accept")
    check:SetChecked(AQA_DB.enabled)

    local statusText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusText:SetPoint("TOPLEFT", check, "BOTTOMLEFT", 2, -6)
    AQA_StatusText = statusText

    local projectButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    projectButton:SetWidth(80)
    projectButton:SetHeight(20)
    projectButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 24, 36)
    projectButton:SetText("Project")
    projectButton:SetScript("OnClick", function()
        AQA_ShowLinkPopup("Project URL (copy):", repoUrl)
    end)

    local feedbackButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    feedbackButton:SetWidth(80)
    feedbackButton:SetHeight(20)
    feedbackButton:SetPoint("LEFT", projectButton, "RIGHT", 8, 0)
    feedbackButton:SetText("Feedback")
    feedbackButton:SetScript("OnClick", function()
        AQA_ShowLinkPopup("Issues URL (copy):", issuesUrl)
    end)

    local credit = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    credit:SetPoint("BOTTOM", f, "BOTTOM", 0, 12)
    credit:SetText("Made by: Sebastian Van Hemelrijck")

    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)

    AQA_UI = f
    tinsert(UISpecialFrames, "AQA_UI")
    AQA_UpdateStatusUI()
end

local frame = CreateFrame("Frame", "AQA_EventFrame", UIParent)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("QUEST_DETAIL")
frame:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == addonName then
        if not AQA_DB then
            AQA_DB = {}
        end
        if AQA_DB.enabled == nil then
            AQA_DB.enabled = true
        end
        AQA_CreateUI()
        AQA_PrintStatus()
        return
    end

    if event == "QUEST_DETAIL" then
        if AQA_DB and AQA_DB.enabled then
            AQA_AcceptAndClose()
        end
    end
end)

SLASH_AQA1 = "/aq"
SLASH_AQA2 = "/autoquest"
SlashCmdList["AQA"] = function(msg)
    msg = string.lower(msg or "")
    if msg == "on" then
        AQA_SetEnabled(true)
    elseif msg == "off" then
        AQA_SetEnabled(false)
    elseif msg == "feedback" then
        AQA_ShowLinkPopup("Issues URL (copy):", issuesUrl)
    elseif msg == "project" then
        AQA_ShowLinkPopup("Project URL (copy):", repoUrl)
    elseif msg == "ui" or msg == "" then
        AQA_ShowUI()
        AQA_PrintStatus()
    else
        AQA_ShowUI()
        AQA_PrintStatus()
    end
end
