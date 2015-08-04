#vivid.lua

One file simple color manipulation library. Used for color conversion and math.

All functions can take an `alpha` after the three components of a color. This variable is not modified, but passed through for convenience. Whenever you pass a color, you can either pass a table or an unpacked list of arguments.

Included in this repository is a simple example using Quickie that demonstrates the uses of this library. It can also serve as a tool if you need a good color picking utility for when you use this library. If it has problems finding vivid you will either need to make a symlink or just copy the file over.

All conversion formulas are taken from [EasyRGB] with the exception of [HuSL] (which is not included yet).

##Available Colorspaces
This library works in the following colorspaces:
 * RGB (0-255)
 * HSL (0-1)
 * HSV (0-1)
 * XYZ
 * CIE L*ab (Known as `Lab` in the code)
 * CIE-L*CH (Known as `LCH` in the code)
 * CIE-L*uv (Known as `Luv` in the code)

 And hopefully soon:
 * HuSL (not supported, I do not want to decipher coffeescript just yet)

## Conversion from RGB

### vivid.RGBto`colorspace`(r,g,b,a)
Returns the four components of `colorspace`.
```lua
print(vivid.RGBtoHSL(10,20,10,100))
```


## Conversion to RGB

### vivid.`colorspace`toRGB(h,s,l,alpha)
Return `r`,`g`,`b`,`a` components of the `colorspace` input.
```lua
print(vivid.HSVtoRGB(0,255,127))
```

##Additional Conversion Functions
### vivid.XYZtoLab(x,y,z,alpha)
### vivid.LabtoXYZ(l,a,b,alpha)
### vivid.XYZtoLuv(x,y,z,alpha)
### vivid.LuvtoXYZ(l,u,v,alpha)
### vivid.LabtoLCH(l,a,b,alpha)
### vivid.LCHtoLab(l,c,h,alpha)

##Color Manipulations
Most of these manipulations take `color` which looks like `{r,g,b,a}` or just four more arguments `r,g,b,a`, performs the operation, and returns the modified color. Color spaces used are chosen due to my somewhat limited understanding on how each performs.
### vivid.lighten(amount, color)
Uses the HSL colorspace.
### vivid.darken(amount, color)
Uses the HSL colorspace.
### vivid.saturate(amount, color)
Uses the HSV colorspace.
### vivid.desaturate(amount, color)
Uses the HSV colorspace.
### vivid.hue(hue, color)
Sets the hue using HSL.
### vivid.invert(color)
Inverts the color using simple RGB inversion.
### vivid.invertHue(color)
Inverts the color using simple `1-hue` inversion in HSL.


## Utility Functions

### vivid.HSVSpread(count,hoffset,s,l,a)
### vivid.HSLSpread(count,hoffset,s,v,a)
### vivid.LCHSpread(count,l,c,hoffset,a)
These functions return an even spread of colors across a color space. It will take evenly spaced h values across the whole colorspace and use the other given values for colors. Useful for quick and easy color scheme generation for random colors and such.
`count` is how many colors you want, and `hoffset` is the hue offset.

### vivid.wrap`colorspace`(fn)
Wraps fn that may normally take RGBA arguments to take `colorspace` argument.

[EasyRGB]: http://www.easyrgb.com/?X=MATH
[HuSL]: https://github.com/husl-colors/husl
