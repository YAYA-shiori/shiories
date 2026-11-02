# Generates the introduction image of the repository (1280x640): the OGP image (GitHub social
# preview) and the hero image of README.md.
#
#   title.png (ghost root)  1280x640, 24-bit PNG (GitHub's social preview wants 1280x640 and under 1MB)
#
# The sizes of DESIGN.md are doubled (the thumbnail is 320x240; this is a 640x320 layout at 2x):
# the cards, the names, the margins (32px), the balloons, the menu. The title alone is 3x (84px),
# as the heading of the picture. The parts are the ones of the ghost:
#   - the speech balloons: the shape rules of work/balloon/make-balloon.ps1 (chamfer, top
#     stripe, tail), drawn at 1x and enlarged by nearest neighbour;
#   - the right-click menu: the real sidebar image (ghost/master/menu/menu_1_sidebar.png), cut at
#     its bottom and enlarged by nearest neighbour; the frame and the selected row follow
#     work/menu/make-menu.ps1;
#   - the character cards: DESIGN.md "character card", with the portraits cut from the shell
#     (surface0000.png, surface1000.png, surface2000.png; the green key color becomes white).
# The Japanese texts are in work/ogp/ogp-text.txt (UTF-8), so that this file stays ASCII only
# (Windows PowerShell 5.1). Colors and rules: DESIGN.md.
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File work/ogp/make-ogp.ps1

param(
    [string]$OutFile = (Join-Path $PSScriptRoot '../../title.png')
)

Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'

$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

function RGB($hex) {
    [System.Drawing.Color]::FromArgb(255, [Convert]::ToInt32($hex.Substring(1, 2), 16), [Convert]::ToInt32($hex.Substring(3, 2), 16), [Convert]::ToInt32($hex.Substring(5, 2), 16))
}
function Mix($a, $b, $t) {
    [System.Drawing.Color]::FromArgb(255,
        [int][Math]::Round($a.R * (1 - $t) + $b.R * $t),
        [int][Math]::Round($a.G * (1 - $t) + $b.G * $t),
        [int][Math]::Round($a.B * (1 - $t) + $b.B * $t))
}

# --- texts ---
$T = @{}
foreach ($line in [System.IO.File]::ReadAllLines((Join-Path $PSScriptRoot 'ogp-text.txt'), [System.Text.Encoding]::UTF8)) {
    $i = $line.IndexOf('=')
    if ($i -gt 0) { $T[$line.Substring(0, $i)] = $line.Substring($i + 1) }
}

# --- colors (DESIGN.md) ---
$bg = RGB '#fafaf8'
$white = RGB '#ffffff'
$ink = RGB '#1c1d21'
$muted = RGB '#5e616b'
$line = RGB '#e3e3df'
$sepColor = RGB '#c9c9c4'
$chars = @(
    @{ Main = (RGB '#1c1d21'); Sub = (RGB '#c4262e'); Shiori = 'KAWARI'; Key = 0; Surface = 'surface0000.png'; Crop = @(18, 25, 215, 250) },
    @{ Main = (RGB '#2f6b3f'); Sub = (RGB '#b48e3e'); Shiori = 'SATORI'; Key = 1; Surface = 'surface1000.png'; Crop = @(38, 116, 188, 218) },
    @{ Main = (RGB '#9b3f3a'); Sub = (RGB '#1c1d21'); Shiori = 'AYA'; Key = 2; Surface = 'surface2000.png'; Crop = @(22, 0, 215, 250) }
)
$guest = @{ Main = (RGB '#5e616b'); Sub = (RGB '#8a8d96') }

$W = 1280
$H = 640
$S = 2    # scale from the sizes of DESIGN.md

$bmp = New-Object System.Drawing.Bitmap($W, $H, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

function Fill($color, $x, $y, $w, $h) {
    $b = New-Object System.Drawing.SolidBrush($color)
    $g.FillRectangle($b, $x, $y, $w, $h)
    $b.Dispose()
}

function New-Font($name, $size, $bold) {
    $style = [System.Drawing.FontStyle]::Regular
    if ($bold) { $style = [System.Drawing.FontStyle]::Bold }
    New-Object System.Drawing.Font($name, [single]$size, $style, [System.Drawing.GraphicsUnit]::Pixel)
}

# Text with its top at y (the line box of the font), left at x.
function Draw-Text($text, $font, $color, $x, $y) {
    $b = New-Object System.Drawing.SolidBrush($color)
    $g.DrawString($text, $font, $b, [single]$x, [single]$y, [System.Drawing.StringFormat]::GenericTypographic)
    $b.Dispose()
}

# Text centered on cx (width measured), top at y.
function Draw-Center($text, $font, $color, $cx, $y) {
    $w = $g.MeasureString($text, $font, 2000, [System.Drawing.StringFormat]::GenericTypographic).Width
    Draw-Text $text $font $color ($cx - $w / 2) $y
}

# One letter at a time, $step px apart (letter-spaced title; the width of the whole is $step * n).
function Draw-Spaced($text, $font, $color, $x, $y, $step) {
    for ($i = 0; $i -lt $text.Length; $i++) { Draw-Text ([string]$text[$i]) $font $color ($x + $i * $step) $y }
}

function Draw-SpacedCenter($text, $font, $color, $cx, $y, $step) {
    $x = $cx - ($step * ($text.Length - 1) + $g.MeasureString([string]$text[0], $font, 2000, [System.Drawing.StringFormat]::GenericTypographic).Width) / 2
    Draw-Spaced $text $font $color $x $y $step
}

# =====================================================================================
# ground: bg and a line frame, the stripe of four on the top edge (thumbnail.pnr, 2x: main 12px, sub 4px)
# =====================================================================================
$g.Clear($bg)
Fill $line 0 0 $W 2
Fill $line 0 ($H - 2) $W 2
Fill $line 0 0 2 $H
Fill $line ($W - 2) 0 2 $H
$stripe = @($chars[0], $chars[1], $chars[2], $guest)
for ($i = 0; $i -lt 4; $i++) {
    Fill $stripe[$i].Main ($i * $W / 4) 0 ($W / 4) 12
    Fill $stripe[$i].Sub ($i * $W / 4) 12 ($W / 4) 4
}

# =====================================================================================
# the speech balloon: the shape rules of work/balloon/make-balloon.ps1 at 1x (chamfer 4, outline 1px,
# stripe main 3 + sub 1, tail 9x9), then enlarged 2x by nearest neighbour
# =====================================================================================
function In-Chamfer($x, $y, $w, $bottom, $c) {
    if ($x -lt 0 -or $y -lt 0 -or $x -ge $w -or $y -gt $bottom) { return $false }
    if (($x + $y) -lt $c) { return $false }
    if ((($w - 1 - $x) + $y) -lt $c) { return $false }
    if (($x + ($bottom - $y)) -lt $c) { return $false }
    if ((($w - 1 - $x) + ($bottom - $y)) -lt $c) { return $false }
    return $true
}
function In-Tail($x, $y, $bottom, $tx, $tailH) {
    $k = $y - $bottom
    if ($k -lt 1 -or $k -gt $tailH) { return $false }
    return ($x -ge $tx -and $x -le ($tx + ($tailH - $k)))
}
function New-Balloon($w, $bodyH, $main, $sub) {
    $tailH = 9
    $tx = [int][Math]::Floor($w / 2) - 1
    $bottom = $bodyH - 1
    $h = $bodyH + $tailH
    $bm = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            $inside = (In-Chamfer $x $y $w $bottom 4) -or (In-Tail $x $y $bottom $tx $tailH)
            if (-not $inside) { $bm.SetPixel($x, $y, [System.Drawing.Color]::Transparent); continue }
            $edge = $false
            foreach ($d in @(@(-1, 0), @(1, 0), @(0, -1), @(0, 1))) {
                if (-not ((In-Chamfer ($x + $d[0]) ($y + $d[1]) $w $bottom 4) -or (In-Tail ($x + $d[0]) ($y + $d[1]) $bottom $tx $tailH))) { $edge = $true; break }
            }
            $color = $bg
            if ($edge) { $color = $main }
            elseif ($y -lt 3) { $color = $main }
            elseif ($y -lt 4) { $color = $sub }
            $bm.SetPixel($x, $y, $color)
        }
    }
    $bm.SetPixel($tx, $bottom, $main)
    return $bm
}
function Draw-Scaled($bm, $x, $y) {
    $old = $g.InterpolationMode
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $dest = New-Object System.Drawing.Rectangle($x, $y, ($bm.Width * $S), ($bm.Height * $S))
    $g.DrawImage($bm, $dest, 0, 0, $bm.Width, $bm.Height, [System.Drawing.GraphicsUnit]::Pixel)
    $g.InterpolationMode = $old
}

# =====================================================================================
# the character cards (DESIGN.md: 92x152 at 1x; portrait 86 wide; main 6 + sub 2 on top)
# =====================================================================================
$cardW = 92 * $S
$cardH = 152 * $S
$cardGap = 6 * $S
$cardsW = 3 * $cardW + 2 * $cardGap
$margin = 16 * $S    # DESIGN.md: 16px around the picture
$cardX0 = $W - $margin - $cardsW
$cardY = $H - $margin - $cardH
$fontName = New-Font 'Meiryo' 26 $true
$fontShiori = New-Font 'Consolas' 22 $false
$fontBal = New-Font 'Meiryo' 21 $false

for ($n = 0; $n -lt 3; $n++) {
    $c = $chars[$n]
    $x = $cardX0 + $n * ($cardW + $cardGap)
    $y = $cardY

    # card body: surface (white) with a 2px frame in line
    Fill $line $x $y $cardW $cardH
    Fill $white ($x + 2) ($y + 2) ($cardW - 4) ($cardH - 4)
    Fill $c.Main $x $y $cardW 12
    Fill $c.Sub $x ($y + 12) $cardW 4

    # portrait: the key color becomes white, then the upper body is cut and shrunk to 172 wide
    $src = New-Object System.Drawing.Bitmap((Join-Path $root ('shell\master\' + $c.Surface)))
    $px = New-Object System.Drawing.Bitmap($src.Width, $src.Height, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
    for ($yy = 0; $yy -lt $src.Height; $yy++) {
        for ($xx = 0; $xx -lt $src.Width; $xx++) {
            $p = $src.GetPixel($xx, $yy)
            if ($p.R -eq 0 -and $p.G -eq 255 -and $p.B -eq 0) { $p = $white }
            $px.SetPixel($xx, $yy, $p)
        }
    }
    $src.Dispose()
    $portraitW = 86 * $S
    $portraitH = 100 * $S
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $dest = New-Object System.Drawing.Rectangle(($x + 3 * $S), ($y + 12 * $S), $portraitW, $portraitH)
    $g.DrawImage($px, $dest, $c.Crop[0], $c.Crop[1], $c.Crop[2], $c.Crop[3], [System.Drawing.GraphicsUnit]::Pixel)
    $px.Dispose()

    # rule, name, SHIORI name
    Fill $line ($x + 2) ($y + 114 * $S) ($cardW - 4) 2
    $cx = $x + $cardW / 2
    Draw-Center $T["name$n"] $fontName $ink $cx ($y + 120 * $S - 2)
    Draw-SpacedCenter $c.Shiori $fontShiori $muted $cx ($y + 120 * $S + 32) 13

    # the balloon above the card, the tail pointing at it
    $balW = 92
    $balBody = 62
    $b = New-Balloon $balW $balBody $c.Main $c.Sub
    $by = $y - 6 - $b.Height * $S
    Draw-Scaled $b $x $by
    Draw-Text $T["bal${n}a"] $fontBal $ink ($x + 16) ($by + 8 * $S + 22)
    Draw-Text $T["bal${n}b"] $fontBal $ink ($x + 16) ($by + 8 * $S + 22 + 34)
    $b.Dispose()
}

# =====================================================================================
# title and text (left column)
# =====================================================================================
$leftX = $margin
# the title is the one exception to the 2x: 3x of DESIGN.md (28 -> 84, 22px step -> 66), it is the heading of the picture
$fontTitle = New-Font 'Consolas' (28 * 3) $false
# the first letter in reverse: an ink box with a bg letter (the thumbnail and the sidebar do the same)
Fill $ink $leftX 52 56 76
Draw-Text 'S' $fontTitle $bg ($leftX + 5) 40
Draw-Spaced 'HIORIES' $fontTitle $ink ($leftX + 66) 40 66
$fontTag = New-Font 'Meiryo' 26 $false
Draw-Text $T.tagline1 $fontTag $ink $leftX 168
Draw-Text $T.tagline2 $fontTag $ink $leftX 210
$fontMono = New-Font 'Consolas' 22 $false
Draw-Text 'for SSP  /  YAYA 6 core' $fontMono $muted $leftX 268

# =====================================================================================
# the right-click menu (Satori's set), 2x: frame 2px main, sidebar from the real image, selected row
# =====================================================================================
$menu = $chars[1]
$mw = 376
$sbW = 22 * $S
$padV = 6
$rowH = 44
$sepH = 16
$innerH = $padV + $rowH * 2 + $sepH + $rowH * 2 + $padV
$mh = $innerH + 4
$mx = $leftX
$my = $H - $margin - $mh
$fontMenu = New-Font 'Meiryo' 22 $false

Fill $menu.Main $mx $my $mw $mh
Fill $bg ($mx + 2) ($my + 2) ($mw - 4) $innerH
# sidebar: the bottom of the real image (it is bottom-aligned; its first letter is drawn in
# reverse, a light box with a dark letter), 1x rows = innerH / 2, enlarged 2x by nearest neighbour
$sbRows = $innerH / $S
$sb = New-Object System.Drawing.Bitmap((Join-Path $root 'ghost\master\menu\menu_1_sidebar.png'))
$part = $sb.Clone((New-Object System.Drawing.Rectangle(0, ($sb.Height - $sbRows), $sb.Width, $sbRows)), $sb.PixelFormat)
Draw-Scaled $part ($mx + 2) ($my + 2)
$part.Dispose()
$sb.Dispose()
# items
$ix = $mx + 2 + $sbW
$iw = $mw - 4 - $sbW
$ty = $my + 2 + $padV
# selected row: main mixed 10% into white, 6px (3px at 1x) mark on its left edge
Fill (Mix $white $menu.Main 0.10) $ix $ty $iw $rowH
Fill $menu.Main $ix $ty 6 $rowH
Draw-Text $T.menu0 $fontMenu $ink ($ix + 20) ($ty + 5)
Draw-Text $T.menu1 $fontMenu $ink ($ix + 20) ($ty + $rowH + 5)
Fill $sepColor ($ix + 12) ($ty + $rowH * 2 + $sepH / 2 - 1) ($iw - 24) 2
Draw-Text $T.menu2 $fontMenu $ink ($ix + 20) ($ty + $rowH * 2 + $sepH + 5)
Draw-Text $T.menu3 $fontMenu $ink ($ix + 20) ($ty + $rowH * 3 + $sepH + 5)

$g.Dispose()
$bmp.Save($OutFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "done: $OutFile"
