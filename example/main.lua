local gui = require("Quickie")
local vivid = require("vivid")

local CS = {
  "RGB",
  "HSL",
  "HSV",
  "XYZ",
  "Lab",
  "LCH",
  "Luv",
}
local sliderInfos =  {
  RGB = {
    {value=65,min=0,max=255},
    {value=128,min=0,max=255},
    {value=44,min=0,max=255},
  },
  HSL = {
    {value=0,min=0,max=1},
    {value=0,min=0,max=1},
    {value=0,min=0,max=1},
  },
  HSV = {
    {value=0,min=0,max=1},
    {value=0,min=0,max=1},
    {value=0,min=0,max=1},
  },
  XYZ = {
    {value=0,min=0,max=95.05},
    {value=0,min=0,max=100},
    {value=0,min=0,max=108.9},
  },
  Lab = {
    {value=0,min=0,max=100},
    {value=0,min=-86.185,max=98.254},
    {value=0,min=-107.863,max=94.482},
  },
  LCH = {
    {value=0,min=0,max=100},
    {value=0,min=0,max=133},
    {value=0,min=0,max=360},
  },
  Luv = {
    {value=0,min=0,max=100},
    {value=0,min=-83.079,max=175.053},
    {value=0,min=-134.116,max=107.401},
  },
}
function love.load()
  -- preload fonts
  fonts = {
    [12] = love.graphics.newFont(12),
    [20] = love.graphics.newFont(20),
  }
  love.graphics.setBackgroundColor(17,17,17)
  love.graphics.setFont(fonts[12])

  -- group defaults
  gui.group.default.size[1] = 150
  gui.group.default.size[2] = 25
  gui.group.default.spacing = 5
  love.filesystem.setSymlinksEnabled( true )
  updateColor("RGB")
end

function updateColor(space)
  local color = getColor(space)
  if space ~= "RGB" then -- RGB
    local fun = vivid[space.."toRGB"]
    color = {fun(color)}
  end
  for k,infos in pairs(sliderInfos) do
    local tempcolor = color
    if k ~= "RGB" then
      local fun = vivid["RGBto"..k]
      tempcolor = {fun(color)}
    end
    infos[1].value = math.min(infos[1].max,math.max(infos[1].min,tempcolor[1]))
    infos[2].value = math.min(infos[2].max,math.max(infos[2].min,tempcolor[2]))
    infos[3].value = math.min(infos[3].max,math.max(infos[3].min,tempcolor[3]))
  end
end

function setColor(space, color)
  sliderInfos[space][1].value = color[1]
  sliderInfos[space][2].value = color[2]
  sliderInfos[space][3].value = color[3]
end

function getColor(space)
  if space == nil then
    space = "RGB"
  end
  local color = {sliderInfos[space][1].value,
                 sliderInfos[space][2].value,
                 sliderInfos[space][3].value}
   return color
 end

function copyColor(space)
  local color = getColor(space)
  local text = "{"..table.concat(color,", ").."}"
  love.system.setClipboardText(text)
end

function love.update(dt)
  gui.group.push{grow = "down", pos={30,200}}
  gui.group.push{grow = "right"}
  -- Make the sliders and stuff
  for i,colorspace in ipairs(CS) do
    if i%3 == 1 and i ~= 1 then
      gui.group.pop{}
      gui.Label{text = "", size = {10,10}} -- Spacer
      gui.group.push{grow = "right"}
    end
    gui.group.push{grow = "down"}
    gui.group.push{grow = "right"}
      gui.Label{text = colorspace, size = {70}}
      if gui.Button{text = "Copy to Clipboard", size={"tight","tight"}} then
        copyColor(colorspace)
      end
    gui.group.pop{}
    for j=1,3 do
      gui.group{grow = "right", spacing = 0, function()
        local vstr = string.format("%.2f",sliderInfos[colorspace][j].value)
        gui.Label{text = vstr, size = {50,"tight"}}
        if gui.Slider{info = sliderInfos[colorspace][j],size={180,10}} then
          updateColor(colorspace)
        end
      end}
    end
    gui.group.pop{}
    gui.Label{text = "", size = {10}} -- Spacer
  end

  gui.group.push{grow = "down"}
    if gui.Button{text = "Lighten"} then
      setColor("RGB",{vivid.lighten(0.05,getColor())})
      updateColor("RGB")
    end
    if gui.Button{text = "Darken"} then
      setColor("RGB",{vivid.darken(0.05,getColor())})
      updateColor("RGB")
    end
  gui.group.pop{}
  gui.group.push{grow = "down"}
    if gui.Button{text = "Saturate"} then
      setColor("RGB",{vivid.saturate(0.05,getColor())})
      updateColor("RGB")
    end
    if gui.Button{text = "Desaturate"} then
      setColor("RGB",{vivid.desaturate(0.05,getColor())})
      updateColor("RGB")
    end
  gui.group.pop{}
  gui.group.push{grow = "down"}
    if gui.Button{text = "Invert"} then
      setColor("RGB",{vivid.invert(getColor())})
      updateColor("RGB")
    end
    if gui.Button{text = "Invert Hue"} then
      setColor("RGB",{vivid.invertHue(getColor())})
      updateColor("RGB")
    end
  gui.group.pop{}
  gui.group.pop{}
  gui.group.pop{}
end

function love.draw()
  local color = getColor()
  love.graphics.setColor(color)
  love.graphics.rectangle("fill",30,30,love.graphics.getWidth()-60,200-60)

  --Color spreads:
  local function drawSpread(cspace,x)
    local h,s,l = unpack(getColor(cspace))
    local colors = vivid[cspace.."Spread"](10,h,s,l)
    for i,color in ipairs(colors) do
      love.graphics.setColor(color)
      love.graphics.rectangle("fill",x+20*(i-1),love.graphics.getHeight()-90,20,60)
    end
    love.graphics.setColor(vivid.invert(colors[1]))
    love.graphics.print(cspace,x,love.graphics.getHeight()-90)
  end
  drawSpread("HSL",30)
  drawSpread("HSV",30 + 20 * 11)
  drawSpread("LCH",30 + 20 * 22)
  gui.core.draw()
end

function love.keypressed(key, code)
    gui.keyboard.pressed(key)
end

-- LÖVE 0.9
function love.textinput(str)
    gui.keyboard.textinput(str)
end
