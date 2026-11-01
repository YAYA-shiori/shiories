# Generates the owner-draw menu images of SHIORIES into ghost/master/menu/.
#
#   menu_background.png        shared by all four sets (flat bg color)
#   menu_<n>_foreground.png    selected row: tint of main + 3px main mark on the left edge
#                              (the same 1-row pattern over the whole image)
#   menu_<n>_sidebar.png       main fill, 2px sub line on the right edge, vertical SHIORI name
#
#   n = 0 (Kawari), 1 (Satori), 2 (Aya/Yaya), 3 (guest)  = the SHIORI scope number
#
# The ghost picks one set from ghost/master/dic/normal/yaya_string.dic (On_menu.*)
# depending on which character was pressed last (OnMouseDown in yaya_mouse.dic).
# Colors and rules: DESIGN.md. The alignment is set in ghost/master/descript.txt (it overrides
# the shell's descript.txt): background lefttop+repeat-x+repeat-y, foreground lefttop+repeat-y,
# sidebar bottom. The images are also as tall as the longest SSP menu (1024px) and 360px wide,
# so they look the same even if SSP does not repeat them.
# Keep ASCII only in this file (Windows PowerShell 5.1).
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File work/menu/make-menu.ps1

param(
    [string]$OutDir = (Join-Path $PSScriptRoot '..\..\ghost\master\menu')
)

Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'

function RGB($hex) {
    [System.Drawing.Color]::FromArgb(255, [Convert]::ToInt32($hex.Substring(1, 2), 16), [Convert]::ToInt32($hex.Substring(3, 2), 16), [Convert]::ToInt32($hex.Substring(5, 2), 16))
}

function Mix($a, $b, $t) {
    # t = share of b
    [System.Drawing.Color]::FromArgb(255,
        [int][Math]::Round($a.R * (1 - $t) + $b.R * $t),
        [int][Math]::Round($a.G * (1 - $t) + $b.G * $t),
        [int][Math]::Round($a.B * (1 - $t) + $b.B * $t))
}

$bg = RGB '#fafaf8'
$white = RGB '#ffffff'

$sbW = 22
$sbH = 1024
$bgW = 360
$bgH = 1024
$fgW = 360
$fgH = 1024
$markW = 3
$tint = 0.10
$labelStep = 11
$labelBottom = 6
$labelSize = 18.0

# Consolas is the --font-mono of the design system.
$sets = @(
    @{ N = 0; Main = (RGB '#1c1d21'); Sub = (RGB '#c4262e'); Label = 'KAWARI' },
    @{ N = 1; Main = (RGB '#2f6b3f'); Sub = (RGB '#b48e3e'); Label = 'SATORI' },
    @{ N = 2; Main = (RGB '#9b3f3a'); Sub = (RGB '#1c1d21'); Label = 'AYA/YAYA' },
    @{ N = 3; Main = (RGB '#5e616b'); Sub = (RGB '#8a8d96'); Label = 'GUEST' }
)

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$OutDir = (Resolve-Path $OutDir).Path

function SavePng($bmp, $name) {
    $path = Join-Path $OutDir $name
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "wrote $path"
}

# --- background: flat -------------------------------------------------------
$bmp = New-Object System.Drawing.Bitmap $bgW, $bgH, ([System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear($bg)
$g.Dispose()
SavePng $bmp 'menu_background.png'

foreach ($s in $sets) {
    # --- foreground: tint + mark on the left edge ---------------------------
    $bmp = New-Object System.Drawing.Bitmap $fgW, $fgH, ([System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear((Mix $white $s.Main $tint))
    $brush = New-Object System.Drawing.SolidBrush $s.Main
    $g.FillRectangle($brush, 0, 0, $markW, $fgH)
    $brush.Dispose()
    $g.Dispose()
    SavePng $bmp ("menu_{0}_foreground.png" -f $s.N)

    # --- sidebar: main fill, sub line, vertical label ------------------------
    $bmp = New-Object System.Drawing.Bitmap $sbW, $sbH, ([System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear($s.Main)
    $brush = New-Object System.Drawing.SolidBrush $s.Sub
    $g.FillRectangle($brush, $sbW - 2, 0, 2, $sbH)
    $brush.Dispose()

    # label: tracked horizontally on a scratch bitmap, then turned to read bottom to top
    $font = New-Object System.Drawing.Font 'Consolas', $labelSize, ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
    $len = $s.Label.Length
    $lw = $len * $labelStep
    $lh = 22
    $tmp = New-Object System.Drawing.Bitmap $lw, $lh, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $tg = [System.Drawing.Graphics]::FromImage($tmp)
    $tg.Clear([System.Drawing.Color]::Transparent)
    $tg.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $tb = New-Object System.Drawing.SolidBrush $bg
    for ($i = 0; $i -lt $len; $i++) {
        $tg.DrawString($s.Label.Substring($i, 1), $font, $tb, [single]($i * $labelStep), [single]0)
    }
    $tb.Dispose(); $tg.Dispose(); $font.Dispose()
    $tmp.RotateFlip([System.Drawing.RotateFlipType]::Rotate270FlipNone)
    # centered in the main part (without the 2px sub line), close to the bottom:
    # the sidebar is bottom-aligned and the menus of the guests are short
    $dx = [int](($sbW - 2 - $lh) / 2)
    $dy = $sbH - $labelBottom - $lw
    $g.DrawImage($tmp, $dx, $dy)
    $tmp.Dispose()
    $g.Dispose()
    SavePng $bmp ("menu_{0}_sidebar.png" -f $s.N)
}
