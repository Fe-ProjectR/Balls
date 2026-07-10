-- ╔════════════════════════════════════════════════════════════════════════════════╗
-- ║                 NETFLIX THEMED GUI MENU v3 - LocalScript                      ║
-- ║                          Made by: noli_0. & Claude                            ║
-- ╚════════════════════════════════════════════════════════════════════════════════╝

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🎬 MOVIE DATABASE - EASY TO ADD MOVIES
-- ═══════════════════════════════════════════════════════════════════════════════

local MOVIES = {
    {
        Title = "Attach Script",
        Description = "Its simple, just choose your target and attach to them, there are different modes to choose from.",
        Loadstring = "loadstring(game:HttpGet('https://raw.githubusercontent.com/Fe-ProjectR/Patchma/refs/heads/main/obfuscated_script-1783668496595.lua.txt'))()",
        Img = "https://raw.githubusercontent.com/Fe-ProjectR/GAME-IMAGES/refs/heads/main/Untitled225_20260710145622.png",
        Creator = "NOLI",
        Date = "2024"
    },
    {
        Title = "idk",
        Description = "Another exciting movie with lots of action and adventure.",
        Loadstring = "print('Movie 2 executed')",
        Img = "https://via.placeholder.com/300x450?text=Movie+2",
        Creator = "Your Name",
        Date = "2024"
    },
    {
        Title = "idk2",
        Description = "A thrilling experience you won't forget.",
        Loadstring = "print('Movie 3 executed')",
        Img = "https://via.placeholder.com/300x450?text=Movie+3",
        Creator = "Your Name",
        Date = "2024"
    },
    {
        Title = "idk3",
        Description = "Epic storytelling at its finest.",
        Loadstring = "print('Movie 4 executed')",
        Img = "https://via.placeholder.com/300x450?text=Movie+4",
        Creator = "Your Name",
        Date = "2024"
    },
    {
        Title = "penis",
        Description = "An unforgettable journey awaits.",
        Loadstring = "print('Movie 5 executed')",
        Img = "https://via.placeholder.com/300x450?text=Movie+5",
        Creator = "Your Name",
        Date = "2024"
    }
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🖼️ IMAGE LOADER (EXTERNAL URL SUPPORT)
-- ═══════════════════════════════════════════════════════════════════════════════

local function LoadImageAsync(imageLabel, url)
    if not url or url == "" then return end
    
    -- If it's a Roblox asset ID, load it normally
    if not (url:find("^http://") or url:find("^https://")) then
        imageLabel.Image = url
        return
    end

    -- Download and load custom web assets asynchronously
    task.spawn(function()
        local getAsset = getcustomasset or getsynasset
        if not (writefile and isfile and getAsset) then
            warn("Your executor does not support downloading external images (writefile/getcustomasset missing).")
            return
        end

        -- Create a safe filename for the image
        local safeUrl = url:gsub("[^%w]", "")
        if #safeUrl > 40 then
            safeUrl = safeUrl:sub(#safeUrl - 40)
        end
        local filePath = "NFX_" .. safeUrl .. ".png"

        -- Download and write file if it hasn't been cached yet
        if not isfile(filePath) then
            local success, data = pcall(function()
                return game:HttpGet(url)
            end)
            if success and data then
                writefile(filePath, data)
            else
                warn("Failed to download image: " .. url)
                return
            end
        end

        -- Apply the downloaded asset to the ImageLabel
        if isfile(filePath) then
            imageLabel.Image = getAsset(filePath)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🎨 THEME
-- ═══════════════════════════════════════════════════════════════════════════════

local COLORS = {
    Background = Color3.fromRGB(15, 15, 15),
    Surface = Color3.fromRGB(24, 24, 24),
    SurfaceLight = Color3.fromRGB(34, 34, 34),
    Border = Color3.fromRGB(45, 45, 45),
    Red = Color3.fromRGB(229, 9, 20),
    RedDark = Color3.fromRGB(180, 6, 15),
    White = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(150, 150, 150),
}

local FONT_HEAVY = Enum.Font.GothamBlack
local FONT_BOLD = Enum.Font.GothamBold
local FONT_REG = Enum.Font.Gotham

-- ═══════════════════════════════════════════════════════════════════════════════
-- 📐 RESPONSIVE SIZING
-- ═══════════════════════════════════════════════════════════════════════════════

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

-- Base design size (desktop reference) — much smaller / compact than before
local BASE_SIZE = UDim2.new(0, 620, 0, 420)

local function getStartSize()
    local viewport = Camera.ViewportSize
    if isMobile() or viewport.X < 700 then
        local scale = math.clamp(viewport.X / 700, 0.55, 0.85)
        return UDim2.new(0, 620 * scale, 0, 420 * scale)
    end
    return BASE_SIZE
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 📦 ROOT GUI
-- ═══════════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NetflixMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function corner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = inst
    return c
end

local function stroke(inst, thickness, color, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 1
    s.Color = color or COLORS.Border
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = inst
    return s
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🪟 WINDOW SHELL
-- ═══════════════════════════════════════════════════════════════════════════════

local startSize = getStartSize()

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = startSize
MainFrame.Position = UDim2.new(0.5, -startSize.X.Offset / 2, 0.5, -startSize.Y.Offset / 2)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
corner(MainFrame, 12)
stroke(MainFrame, 1, COLORS.Border, 0.4)

local WindowShadow = Instance.new("ImageLabel")
WindowShadow.Name = "WindowShadow"
WindowShadow.BackgroundTransparency = 1
WindowShadow.Image = "rbxassetid://6014261993"
WindowShadow.ImageColor3 = Color3.new(0, 0, 0)
WindowShadow.ImageTransparency = 0.35
WindowShadow.ScaleType = Enum.ScaleType.Slice
WindowShadow.SliceCenter = Rect.new(49, 49, 450, 450)
WindowShadow.Size = UDim2.new(1, 60, 1, 60)
WindowShadow.Position = UDim2.new(0, -30, 0, -30)
WindowShadow.ZIndex = 0
WindowShadow.Parent = MainFrame

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🖱️ DRAGGABLE (mouse + touch)
-- ═══════════════════════════════════════════════════════════════════════════════

local function makeDraggable(dragHandle, target)
    local dragging = false
    local dragInput
    local startPos
    local startInputPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = target.Position
            startInputPos = input.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startInputPos
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🎭 INTRO ANIMATION
-- ═══════════════════════════════════════════════════════════════════════════════

local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = COLORS.Background
IntroFrame.BorderSizePixel = 0
IntroFrame.ZIndex = 20
IntroFrame.Parent = MainFrame
corner(IntroFrame, 12)

local UniversalText = Instance.new("TextLabel")
UniversalText.Name = "UniversalText"
UniversalText.AnchorPoint = Vector2.new(0.5, 0.5)
UniversalText.Size = UDim2.new(0, 260, 0, 44)
UniversalText.Position = UDim2.new(0.5, 0, 0.5, 0)
UniversalText.BackgroundTransparency = 1
UniversalText.TextColor3 = COLORS.White
UniversalText.TextScaled = true
UniversalText.Font = FONT_HEAVY
UniversalText.Text = "UNIVERSAL"
UniversalText.TextTransparency = 1
UniversalText.ZIndex = 21
UniversalText.Parent = IntroFrame

local ANLogo = Instance.new("TextLabel")
ANLogo.Name = "ANLogo"
ANLogo.AnchorPoint = Vector2.new(0.5, 0.5)
ANLogo.Size = UDim2.new(0, 30, 0, 14)
ANLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
ANLogo.BackgroundTransparency = 1
ANLogo.TextColor3 = COLORS.Red
ANLogo.TextScaled = true
ANLogo.Font = FONT_HEAVY
ANLogo.Text = "AN"
ANLogo.TextTransparency = 1
ANLogo.ZIndex = 22
ANLogo.Parent = IntroFrame

local function playIntroAnimation()
    local tweenIn = TweenService:Create(UniversalText, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    tweenIn:Play()
    tweenIn.Completed:Wait()
    task.wait(0.4)

    local shrink = TweenService:Create(UniversalText, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 20, 0, 10),
        TextTransparency = 1
    })
    shrink:Play()

    task.wait(0.22)
    local anGrow = TweenService:Create(ANLogo, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 90, 0, 40),
        TextTransparency = 0
    })
    anGrow:Play()
    anGrow.Completed:Wait()
    task.wait(0.3)

    local expand = TweenService:Create(ANLogo, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 900, 0, 900),
        TextTransparency = 1
    })
    local fadeBg = TweenService:Create(IntroFrame, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })
    expand:Play()
    fadeBg:Play()
    expand.Completed:Wait()

    IntroFrame:Destroy()
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🎬 TITLE BAR
-- ═══════════════════════════════════════════════════════════════════════════════

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = COLORS.Surface
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 5
TitleBar.Parent = MainFrame
corner(TitleBar, 12)

local TitleBarCoverBottom = Instance.new("Frame")
TitleBarCoverBottom.BackgroundColor3 = COLORS.Surface
TitleBarCoverBottom.BorderSizePixel = 0
TitleBarCoverBottom.Size = UDim2.new(1, 0, 0, 12)
TitleBarCoverBottom.Position = UDim2.new(0, 0, 1, -12)
TitleBarCoverBottom.ZIndex = 5
TitleBarCoverBottom.Parent = TitleBar

local TitleLogo = Instance.new("TextLabel")
TitleLogo.Name = "TitleLogo"
TitleLogo.Size = UDim2.new(0, 60, 1, 0)
TitleLogo.Position = UDim2.new(0, 12, 0, 0)
TitleLogo.BackgroundTransparency = 1
TitleLogo.TextColor3 = COLORS.Red
TitleLogo.TextSize = 17
TitleLogo.Font = FONT_HEAVY
TitleLogo.TextXAlignment = Enum.TextXAlignment.Left
TitleLogo.Text = "AN UNIVERSAL HUB"
TitleLogo.ZIndex = 6
TitleLogo.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -36, 0.5, -14)
MinimizeBtn.BackgroundColor3 = COLORS.SurfaceLight
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.TextColor3 = COLORS.White
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = FONT_BOLD
MinimizeBtn.Text = "—"
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.ZIndex = 6
MinimizeBtn.Parent = TitleBar
corner(MinimizeBtn, 6)

MinimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.Red}):Play()
end)
MinimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.SurfaceLight}):Play()
end)

makeDraggable(TitleBar, MainFrame)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🧲 MINIMIZED PILL
-- ═══════════════════════════════════════════════════════════════════════════════

local MinimizedPill = Instance.new("TextButton")
MinimizedPill.Name = "MinimizedPill"
MinimizedPill.Size = UDim2.new(0, 54, 0, 54)
MinimizedPill.Position = UDim2.new(0.5, -27, 0.5, -27)
MinimizedPill.BackgroundColor3 = COLORS.Red
MinimizedPill.BorderSizePixel = 0
MinimizedPill.Text = "AN"
MinimizedPill.Font = FONT_HEAVY
MinimizedPill.TextSize = 17
MinimizedPill.TextColor3 = COLORS.White
MinimizedPill.AutoButtonColor = false
MinimizedPill.Visible = false
MinimizedPill.ZIndex = 10
MinimizedPill.Parent = ScreenGui
corner(MinimizedPill, 27)
stroke(MinimizedPill, 2, COLORS.White, 0.7)
makeDraggable(MinimizedPill, MinimizedPill)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🎬 MENU FRAME
-- ═══════════════════════════════════════════════════════════════════════════════

local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Size = UDim2.new(1, 0, 1, -38)
MenuFrame.Position = UDim2.new(0, 0, 0, 38)
MenuFrame.BackgroundTransparency = 1
MenuFrame.Visible = false
MenuFrame.Parent = MainFrame

local ControlsRow = Instance.new("Frame")
ControlsRow.Name = "ControlsRow"
ControlsRow.Size = UDim2.new(1, -24, 0, 32)
ControlsRow.Position = UDim2.new(0, 12, 0, 10)
ControlsRow.BackgroundTransparency = 1
ControlsRow.Parent = MenuFrame

local SearchFrame = Instance.new("Frame")
SearchFrame.Name = "SearchFrame"
SearchFrame.Size = UDim2.new(0.55, 0, 1, 0)
SearchFrame.BackgroundColor3 = COLORS.Surface
SearchFrame.BorderSizePixel = 0
SearchFrame.Parent = ControlsRow
corner(SearchFrame, 8)
stroke(SearchFrame, 1, COLORS.Border, 0.3)

-- ✨ CHANGED: Transformed SearchIcon from a TextLabel into an ImageLabel
local SearchIcon = Instance.new("ImageLabel")
SearchIcon.Name = "SearchIcon"
SearchIcon.Size = UDim2.new(0, 16, 0, 16)
SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
SearchIcon.Position = UDim2.new(0, 8, 0.5, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Parent = SearchFrame

-- Load your custom GitHub search icon using our external image downloader
LoadImageAsync(SearchIcon, "https://raw.githubusercontent.com/Fe-ProjectR/GAME-IMAGES/refs/heads/main/Untitled226_20260710163154.png")

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -32, 1, 0)
SearchBox.Position = UDim2.new(0, 28, 0, 0) -- Adjusted position slightly to accommodate new icon size
SearchBox.BackgroundTransparency = 1
SearchBox.BorderSizePixel = 0
SearchBox.TextColor3 = COLORS.White
SearchBox.PlaceholderColor3 = COLORS.Muted
SearchBox.PlaceholderText = "Search titles..."
SearchBox.TextSize = 12
SearchBox.Font = FONT_REG
SearchBox.ClearTextOnFocus = false
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.Parent = SearchFrame

local TabsHolder = Instance.new("Frame")
TabsHolder.Name = "TabsHolder"
TabsHolder.Size = UDim2.new(0.43, 0, 1, 0)
TabsHolder.Position = UDim2.new(0.57, 0, 0, 0)
TabsHolder.BackgroundColor3 = COLORS.Surface
TabsHolder.BorderSizePixel = 0
TabsHolder.Parent = ControlsRow
corner(TabsHolder, 8)
stroke(TabsHolder, 1, COLORS.Border, 0.3)

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabsLayout.Padding = UDim.new(0, 2)
TabsLayout.Parent = TabsHolder

local TabsPadding = Instance.new("UIPadding")
TabsPadding.PaddingLeft = UDim.new(0, 3)
TabsPadding.PaddingRight = UDim.new(0, 3)
TabsPadding.PaddingTop = UDim.new(0, 3)
TabsPadding.PaddingBottom = UDim.new(0, 3)
TabsPadding.Parent = TabsHolder

local function makeTab(name, order)
    local tab = Instance.new("TextButton")
    tab.Name = name .. "Tab"
    tab.Size = UDim2.new(0.5, -2, 1, 0)
    tab.LayoutOrder = order
    tab.BackgroundColor3 = COLORS.Red
    tab.AutoButtonColor = false
    tab.Text = name
    tab.Font = FONT_BOLD
    tab.TextSize = 11
    tab.TextColor3 = COLORS.White
    tab.Parent = TabsHolder
    corner(tab, 6)
    return tab
end

local MoviesTab = makeTab("Movies", 1)
local CreditsTab = makeTab("Credits", 2)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🎠 CAROUSEL
-- ═══════════════════════════════════════════════════════════════════════════════

local CarouselContainer = Instance.new("Frame")
CarouselContainer.Name = "CarouselContainer"
CarouselContainer.Size = UDim2.new(1, -24, 1, -104)
CarouselContainer.Position = UDim2.new(0, 12, 0, 50)
CarouselContainer.BackgroundTransparency = 1
CarouselContainer.ClipsDescendants = true
CarouselContainer.Parent = MenuFrame

local function makeArrow(name, alignRight, text)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 24, 0, 24)
    btn.AnchorPoint = Vector2.new(alignRight and 1 or 0, 0.5)
    btn.Position = alignRight and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    btn.BackgroundColor3 = COLORS.Surface
    btn.BackgroundTransparency = 0.15
    btn.AutoButtonColor = false
    btn.Text = text
    btn.TextColor3 = COLORS.White
    btn.TextSize = 13
    btn.Font = FONT_BOLD
    btn.ZIndex = 8
    btn.Parent = CarouselContainer
    corner(btn, 12)
    return btn
end

local LeftArrow = makeArrow("LeftArrow", false, "‹")
local RightArrow = makeArrow("RightArrow", true, "›")

local MovieCarousel = Instance.new("Frame")
MovieCarousel.Name = "MovieCarousel"
MovieCarousel.Size = UDim2.new(1, 0, 1, 0)
MovieCarousel.BackgroundTransparency = 1
MovieCarousel.Parent = CarouselContainer

local EmptyState = Instance.new("TextLabel")
EmptyState.Name = "EmptyState"
EmptyState.Size = UDim2.new(1, 0, 1, 0)
EmptyState.BackgroundTransparency = 1
EmptyState.Text = "No titles match your search"
EmptyState.TextColor3 = COLORS.Muted
EmptyState.Font = FONT_REG
EmptyState.TextSize = 12
EmptyState.Visible = false
EmptyState.Parent = CarouselContainer

local DotsHolder = Instance.new("Frame")
DotsHolder.Name = "DotsHolder"
DotsHolder.Size = UDim2.new(1, 0, 0, 14)
DotsHolder.Position = UDim2.new(0, 0, 1, -14)
DotsHolder.BackgroundTransparency = 1
DotsHolder.Parent = MenuFrame

-- ═══════════════════════════════════════════════════════════════════════════════
-- 📺 DETAIL VIEW
-- ═══════════════════════════════════════════════════════════════════════════════

local DetailFrame = Instance.new("Frame")
DetailFrame.Name = "DetailFrame"
DetailFrame.Size = UDim2.new(1, 0, 1, -38)
DetailFrame.Position = UDim2.new(0, 0, 0, 38)
DetailFrame.BackgroundTransparency = 1
DetailFrame.Visible = false
DetailFrame.Parent = MainFrame

local BackBtn = Instance.new("TextButton")
BackBtn.Name = "BackBtn"
BackBtn.Size = UDim2.new(0, 60, 0, 24)
BackBtn.Position = UDim2.new(0, 12, 0, 10)
BackBtn.BackgroundColor3 = COLORS.Surface
BackBtn.AutoButtonColor = false
BackBtn.Text = "‹ Back"
BackBtn.Font = FONT_BOLD
BackBtn.TextSize = 11
BackBtn.TextColor3 = COLORS.White
BackBtn.Parent = DetailFrame
corner(BackBtn, 6)
stroke(BackBtn, 1, COLORS.Border, 0.3)

local DetailScrollBody = Instance.new("Frame")
DetailScrollBody.Name = "DetailScrollBody"
DetailScrollBody.Size = UDim2.new(1, -24, 1, -48)
DetailScrollBody.Position = UDim2.new(0, 12, 0, 42)
DetailScrollBody.BackgroundTransparency = 1
DetailScrollBody.Parent = DetailFrame

local DetailImage = Instance.new("ImageLabel")
DetailImage.Name = "DetailImage"
DetailImage.Size = UDim2.new(1, 0, 0, 150)
DetailImage.BackgroundColor3 = COLORS.Surface
DetailImage.ScaleType = Enum.ScaleType.Crop
DetailImage.Parent = DetailScrollBody
corner(DetailImage, 8)
stroke(DetailImage, 1, COLORS.Border, 0.3)

local InfoPanel = Instance.new("Frame")
InfoPanel.Name = "InfoPanel"
InfoPanel.Size = UDim2.new(1, 0, 1, -160)
InfoPanel.Position = UDim2.new(0, 0, 0, 160)
InfoPanel.BackgroundTransparency = 1
InfoPanel.Parent = DetailScrollBody

local DetailTitle = Instance.new("TextLabel")
DetailTitle.Name = "DetailTitle"
DetailTitle.Size = UDim2.new(1, 0, 0, 22)
DetailTitle.BackgroundTransparency = 1
DetailTitle.TextColor3 = COLORS.White
DetailTitle.TextSize = 16
DetailTitle.Font = FONT_HEAVY
DetailTitle.TextXAlignment = Enum.TextXAlignment.Left
DetailTitle.TextTruncate = Enum.TextTruncate.AtEnd
DetailTitle.Parent = InfoPanel

local MetaRow = Instance.new("TextLabel")
MetaRow.Name = "MetaRow"
MetaRow.Size = UDim2.new(1, 0, 0, 14)
MetaRow.Position = UDim2.new(0, 0, 0, 24)
MetaRow.BackgroundTransparency = 1
MetaRow.TextColor3 = COLORS.Muted
MetaRow.TextSize = 10
MetaRow.Font = FONT_REG
MetaRow.TextXAlignment = Enum.TextXAlignment.Left
MetaRow.Parent = InfoPanel

local DetailDescription = Instance.new("TextLabel")
DetailDescription.Name = "DetailDescription"
DetailDescription.Size = UDim2.new(1, 0, 1, -96)
DetailDescription.Position = UDim2.new(0, 0, 0, 44)
DetailDescription.BackgroundTransparency = 1
DetailDescription.TextColor3 = Color3.fromRGB(210, 210, 210)
DetailDescription.TextSize = 11
DetailDescription.Font = FONT_REG
DetailDescription.TextXAlignment = Enum.TextXAlignment.Left
DetailDescription.TextYAlignment = Enum.TextYAlignment.Top
DetailDescription.TextWrapped = true
DetailDescription.Parent = InfoPanel

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Name = "ExecuteBtn"
ExecuteBtn.Size = UDim2.new(1, 0, 0, 32)
ExecuteBtn.Position = UDim2.new(0, 0, 1, -32)
ExecuteBtn.BackgroundColor3 = COLORS.Red
ExecuteBtn.AutoButtonColor = false
ExecuteBtn.Text = "▶  PLAY"
ExecuteBtn.Font = FONT_HEAVY
ExecuteBtn.TextSize = 12
ExecuteBtn.TextColor3 = COLORS.White
ExecuteBtn.Parent = InfoPanel
corner(ExecuteBtn, 6)

ExecuteBtn.MouseEnter:Connect(function()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.RedDark}):Play()
end)
ExecuteBtn.MouseLeave:Connect(function()
    TweenService:Create(ExecuteBtn, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.Red}):Play()
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 💳 CREDITS
-- ═══════════════════════════════════════════════════════════════════════════════

local CreditsFrame = Instance.new("Frame")
CreditsFrame.Name = "CreditsFrame"
CreditsFrame.Size = UDim2.new(1, 0, 1, -38)
CreditsFrame.Position = UDim2.new(0, 0, 0, 38)
CreditsFrame.BackgroundTransparency = 1
CreditsFrame.Visible = false
CreditsFrame.Parent = MainFrame

local CreditsBackBtn = Instance.new("TextButton")
CreditsBackBtn.Name = "CreditsBackBtn"
CreditsBackBtn.Size = UDim2.new(0, 60, 0, 24)
CreditsBackBtn.Position = UDim2.new(0, 12, 0, 10)
CreditsBackBtn.BackgroundColor3 = COLORS.Surface
CreditsBackBtn.AutoButtonColor = false
CreditsBackBtn.Text = "‹ Back"
CreditsBackBtn.Font = FONT_BOLD
CreditsBackBtn.TextSize = 11
CreditsBackBtn.TextColor3 = COLORS.White
CreditsBackBtn.Parent = CreditsFrame
corner(CreditsBackBtn, 6)
stroke(CreditsBackBtn, 1, COLORS.Border, 0.3)

local CreditsTitle = Instance.new("TextLabel")
CreditsTitle.Size = UDim2.new(1, 0, 0, 30)
CreditsTitle.Position = UDim2.new(0, 0, 0.3, 0)
CreditsTitle.BackgroundTransparency = 1
CreditsTitle.TextColor3 = COLORS.Red
CreditsTitle.TextSize = 22
CreditsTitle.Font = FONT_HEAVY
CreditsTitle.Text = "CREDITS"
CreditsTitle.Parent = CreditsFrame

local CreditsSub = Instance.new("TextLabel")
CreditsSub.Size = UDim2.new(1, 0, 0, 60)
CreditsSub.Position = UDim2.new(0, 0, 0.3, 36)
CreditsSub.BackgroundTransparency = 1
CreditsSub.TextColor3 = COLORS.White
CreditsSub.TextSize = 14
CreditsSub.Font = FONT_BOLD
CreditsSub.TextWrapped = true
CreditsSub.Text = "Created by\n\nnoli_0"
CreditsSub.Parent = CreditsFrame

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🎬 CAROUSEL LOGIC
-- ═══════════════════════════════════════════════════════════════════════════════

local currentIndex = 1
local visibleMovies = {}
local cardWidth, cardGap = 150, 14
local cardImgHeight = cardWidth * (400/600) -- 3:2 landscape ratio
local cardTitleHeight = 22
local cardHeight = cardImgHeight + cardTitleHeight

local function layoutCards(instant)
    local containerW = CarouselContainer.AbsoluteSize.X
    local centerX = containerW / 2

    for i, card in ipairs(MovieCarousel:GetChildren()) do
        if card:IsA("Frame") then
            local offsetFromCurrent = i - currentIndex
            local targetX = centerX + offsetFromCurrent * (cardWidth + cardGap) - cardWidth / 2

            local isCenter = (i == currentIndex)
            local dist = math.abs(offsetFromCurrent)
            local targetTransparency = isCenter and 0 or math.clamp(0.35 + dist * 0.3, 0.35, 0.9)
            local targetScale = isCenter and 1 or 0.8
            local targetZ = isCenter and 5 or (5 - dist)

            card.ZIndex = math.max(targetZ, 1)

            local goalPos = UDim2.new(0, targetX, 0.5, 0)
            local goalSize = UDim2.new(0, cardWidth * targetScale, 0, cardHeight * targetScale)

            if instant then
                card.Position = goalPos
                card.Size = goalSize
            else
                TweenService:Create(card, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = goalPos,
                    Size = goalSize
                }):Play()
            end

            local img = card:FindFirstChild("CardImage")
            local titleLbl = card:FindFirstChild("CardTitle")
            if img then TweenService:Create(img, TweenInfo.new(0.28), {ImageTransparency = targetTransparency}):Play() end
            if titleLbl then TweenService:Create(titleLbl, TweenInfo.new(0.28), {TextTransparency = targetTransparency}):Play() end
        end
    end
end

local function updateDots()
    DotsHolder:ClearAllChildren()
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 5)
    layout.Parent = DotsHolder

    for i = 1, #visibleMovies do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, i == currentIndex and 13 or 6, 0, 6)
        dot.BackgroundColor3 = i == currentIndex and COLORS.Red or COLORS.Border
        dot.BorderSizePixel = 0
        dot.LayoutOrder = i
        dot.Parent = DotsHolder
        corner(dot, 3)
    end
end

local showMovieDetail -- forward declare

local function createMovieCard(movie, index)
    local card = Instance.new("Frame")
    card.Name = "Card_" .. index
    card.AnchorPoint = Vector2.new(0, 0.5)
    card.Size = UDim2.new(0, cardWidth, 0, cardHeight)
    card.BackgroundColor3 = COLORS.Surface
    card.BorderSizePixel = 0
    card.Parent = MovieCarousel
    corner(card, 8)

    local img = Instance.new("ImageLabel")
    img.Name = "CardImage"
    img.Size = UDim2.new(1, 0, 0, cardImgHeight)
    img.BackgroundColor3 = COLORS.SurfaceLight
    img.ScaleType = Enum.ScaleType.Crop
    img.Parent = card
    corner(img, 8)
    
    -- Load External Image safely
    LoadImageAsync(img, movie.Img)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Name = "CardTitle"
    titleLbl.Size = UDim2.new(1, -6, 0, cardTitleHeight)
    titleLbl.Position = UDim2.new(0, 3, 0, cardImgHeight)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextColor3 = COLORS.White
    titleLbl.TextSize = 9
    titleLbl.Font = FONT_BOLD
    titleLbl.Text = movie.Title
    titleLbl.TextWrapped = true
    titleLbl.TextYAlignment = Enum.TextYAlignment.Top
    titleLbl.Parent = card

    local click = Instance.new("TextButton")
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.Parent = card

    click.MouseButton1Click:Connect(function()
        if index == currentIndex then
            showMovieDetail(movie)
        else
            currentIndex = index
            layoutCards(false)
            updateDots()
        end
    end)

    return card
end

local function updateCarousel()
    MovieCarousel:ClearAllChildren()

    local query = SearchBox.Text:lower()
    visibleMovies = {}
    for _, movie in ipairs(MOVIES) do
        if query == "" or movie.Title:lower():find(query, 1, true) then
            table.insert(visibleMovies, movie)
        end
    end

    EmptyState.Visible = (#visibleMovies == 0)
    currentIndex = math.clamp(currentIndex, 1, math.max(#visibleMovies, 1))

    for i, movie in ipairs(visibleMovies) do
        createMovieCard(movie, i)
    end

    task.defer(function()
        layoutCards(true)
        updateDots()
    end)
end

local function navigate(direction)
    if #visibleMovies == 0 then return end
    currentIndex = currentIndex + direction
    if currentIndex < 1 then currentIndex = #visibleMovies end
    if currentIndex > #visibleMovies then currentIndex = 1 end
    layoutCards(false)
    updateDots()
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 📱 VIEW SWITCHING
-- ═══════════════════════════════════════════════════════════════════════════════

local currentView = nil
local viewFrames = {
    menu = MenuFrame,
    detail = DetailFrame,
    credits = CreditsFrame
}

-- Give each view frame a UIScale + prep for tweening (position offset trick for slide)
local viewBasePos = {}
for name, frame in pairs(viewFrames) do
    viewBasePos[name] = frame.Position
end

local function showView(view)
    if view == currentView then return end
    local outgoing = viewFrames[currentView]
    local incoming = viewFrames[view]

    -- Animate outgoing frame: fade + slide out slightly
    if outgoing and outgoing.Visible then
        local outTargetPos = viewBasePos[currentView] + UDim2.new(0, 0, 0, 10)
        local tween = TweenService:Create(outgoing, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = outTargetPos
        })
        tween:Play()
    end

    task.delay(0.12, function()
        for name, frame in pairs(viewFrames) do
            frame.Visible = (name == view)
            if name ~= view then
                frame.Position = viewBasePos[name]
            end
        end

        if incoming then
            incoming.Position = viewBasePos[view] + UDim2.new(0, 0, 0, 10)
            TweenService:Create(incoming, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = viewBasePos[view]
            }):Play()
        end
    end)

    currentView = view
end

showMovieDetail = function(movie)
    DetailImage.Image = "" -- Clear previous image
    LoadImageAsync(DetailImage, movie.Img)
    
    DetailTitle.Text = movie.Title
    MetaRow.Text = movie.Creator .. "  •  " .. movie.Date
    DetailDescription.Text = movie.Description

    ExecuteBtn.MouseButton1Click:Connect(function()
        pcall(function()
            loadstring(movie.Loadstring)()
        end)
    end)

    showView("detail")
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🔘 CONNECTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

LeftArrow.MouseButton1Click:Connect(function() navigate(-1) end)
RightArrow.MouseButton1Click:Connect(function() navigate(1) end)
BackBtn.MouseButton1Click:Connect(function() showView("menu") end)

local function setActiveTab(tab)
    for _, t in ipairs({MoviesTab, CreditsTab}) do
        local active = (t == tab)
        TweenService:Create(t, TweenInfo.new(0.15), {
            BackgroundColor3 = active and COLORS.Red or COLORS.SurfaceLight
        }):Play()
    end
end

MoviesTab.MouseButton1Click:Connect(function()
    setActiveTab(MoviesTab)
    showView("menu")
end)

CreditsTab.MouseButton1Click:Connect(function()
    setActiveTab(CreditsTab)
    showView("credits")
end)

CreditsBackBtn.MouseButton1Click:Connect(function()
    setActiveTab(MoviesTab)
    showView("menu")
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    currentIndex = 1
    updateCarousel()
end)

CarouselContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    layoutCards(true)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 📦 MINIMIZE
-- ═══════════════════════════════════════════════════════════════════════════════

local minimized = false
local savedWindowPos = MainFrame.Position
local savedPillPos = nil -- set to a left-side default on first minimize

local function clampToScreen(pos, size)
    local viewport = Camera.ViewportSize
    local x = math.clamp(pos.X.Offset, 0, math.max(viewport.X - size.X.Offset, 0))
    local y = math.clamp(pos.Y.Offset, 0, math.max(viewport.Y - size.Y.Offset, 0))
    return UDim2.new(0, x, 0, y)
end

local function setMinimized(state)
    minimized = state
    if state then
        -- Remember exactly where the window was so maximize restores it
        savedWindowPos = MainFrame.Position

        -- First time minimizing, default the pill to the left-middle of the screen
        if not savedPillPos then
            local viewport = Camera.ViewportSize
            savedPillPos = UDim2.new(0, 20, 0, viewport.Y / 2 - 27)
        end

        MinimizedPill.Position = clampToScreen(savedPillPos, MinimizedPill.Size)
        MainFrame.Visible = false
        MinimizedPill.Visible = true
        MinimizedPill.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MinimizedPill, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 54, 0, 54)
        }):Play()
    else
        -- Remember exactly where the pill was left so the next minimize returns there
        savedPillPos = MinimizedPill.Position
        MinimizedPill.Visible = false
        MainFrame.Position = clampToScreen(savedWindowPos, MainFrame.Size)
        MainFrame.Visible = true
    end
end

MinimizeBtn.MouseButton1Click:Connect(function()
    setMinimized(true)
end)

-- Mobile friendly click detection for the Drag Pill 
-- (Ensures dragging doesn't count as a click)
local pillClickStartPos = nil

MinimizedPill.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pillClickStartPos = input.Position
    end
end)

MinimizedPill.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if pillClickStartPos then
            -- Measure how far the mouse/finger moved. If it's less than 10 pixels, count it as a click/tap.
            local moveMagnitude = (input.Position - pillClickStartPos).Magnitude
            if moveMagnitude < 10 then
                setMinimized(false)
            end
            pillClickStartPos = nil
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 📐 RESPONSIVE UPDATE ON SCREEN RESIZE (rotation, mobile keyboard, etc.)
-- ═══════════════════════════════════════════════════════════════════════════════

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local size = getStartSize()
    local viewport = Camera.ViewportSize
    MainFrame.Size = UDim2.new(
        0, math.min(size.X.Offset, viewport.X - 20),
        0, math.min(size.Y.Offset, viewport.Y - 20)
    )
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🎬 START
-- ═══════════════════════════════════════════════════════════════════════════════

playIntroAnimation()
setActiveTab(MoviesTab)
showView("menu")
updateCarousel()