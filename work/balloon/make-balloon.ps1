# Generates the images of the bundled balloon "shiories_balloon" into shiories_balloon/.
#
#   balloons0.png          \0 speech balloon (250x200)
#   balloonk0.png          \1 speech balloon (250x159)
#   balloonp2def0.png      \p[2] speech balloon (250x159)
#   balloonp3def0.png      \p[3] speech balloon (250x159)
#   balloonc0-4.png        input boxes (400x57), balloonc5.png textarea box (400x150)
#   arrow*, online*, sstp* scroll arrows (13x13), online marker (77x11), SSTP marker (9x9)
#   thumbnail.pnr          logo shown in the balloon menu (200x40)
#
# The sizes and the positions of the contents are fixed by shiories_balloon/descript.txt
# (origin, validrect, arrow*, onlinemarker, sstpmarker, communicatebox ...). Do not move anything
# the descript.txt points to. Negative coordinates there count from the bottom/right edge.
#
# Shapes: straight lines only. The corners are cut at 45 degrees (chamfer), never rounded.
# No shadow, no gradient, no anti-aliasing next to the transparent color (#00ff00).
# A 1px outline in main, and a stripe on the top edge (main 3px, sub 1px; DESIGN.md 6:2 scaled).
# Colors and rules: DESIGN.md.
#
# Images are 8-bit palette PNGs with the transparent color #00ff00 kept in the image (no alpha).
# Keep ASCII only in this file (Windows PowerShell 5.1).
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File work/balloon/make-balloon.ps1

param(
    [string]$OutDir = (Join-Path $PSScriptRoot '..\..\shiories_balloon')
)

Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'

function RGB($hex) {
    [System.Drawing.Color]::FromArgb(255, [Convert]::ToInt32($hex.Substring(1, 2), 16), [Convert]::ToInt32($hex.Substring(3, 2), 16), [Convert]::ToInt32($hex.Substring(5, 2), 16))
}

$bg = RGB '#fafaf8'
$ink = RGB '#1c1d21'
$muted = RGB '#5e616b'
$key = RGB '#00ff00'

# main / sub of each character. The last one (neutral) is for the parts that belong to no character.
$sets = @{
    s   = @{ Main = (RGB '#1c1d21'); Sub = (RGB '#c4262e') }   # \0 Kawari
    k   = @{ Main = (RGB '#2f6b3f'); Sub = (RGB '#b48e3e') }   # \1 Satori
    p2  = @{ Main = (RGB '#9b3f3a'); Sub = (RGB '#1c1d21') }   # \p[2] Aya (YAYA)
    p3  = @{ Main = (RGB '#5e616b'); Sub = (RGB '#8a8d96') }   # \p[3] guest
    neu = @{ Main = (RGB '#5e616b'); Sub = (RGB '#8a8d96') }
}

$chamfer = 4     # corner cut of the big shapes (DESIGN.md: 4px grid)
$bandMain = 3    # top stripe: main 3px (the outline row is the first one) + sub 1px
$bandSub = 1

function New-Canvas($w, $h, $color) {
    $bm = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bm)
    $g.Clear($color)
    $g.Dispose()
    return $bm
}

function Fill-Rect($bm, $x, $y, $w, $h, $color) {
    for ($j = $y; $j -lt $y + $h; $j++) {
        for ($i = $x; $i -lt $x + $w; $i++) { $bm.SetPixel($i, $j, $color) }
    }
}

# Writes an 8-bit palette PNG (no alpha). The colors must fit in 256.
function Save-Indexed($bm, $path) {
    $w = $bm.Width
    $h = $bm.Height
    $index = @{}
    $colors = New-Object System.Collections.ArrayList
    $data = New-Object 'byte[]' ($w * $h)
    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            $c = $bm.GetPixel($x, $y)
            $k = $c.ToArgb()
            if (-not $index.ContainsKey($k)) {
                if ($colors.Count -ge 256) { throw "too many colors: $path" }
                $index[$k] = $colors.Count
                [void]$colors.Add($c)
            }
            $data[$y * $w + $x] = [byte]$index[$k]
        }
    }
    $out = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format8bppIndexed)
    $pal = $out.Palette
    for ($i = 0; $i -lt 256; $i++) {
        if ($i -lt $colors.Count) { $pal.Entries[$i] = [System.Drawing.Color]::FromArgb(255, $colors[$i].R, $colors[$i].G, $colors[$i].B) }
        else { $pal.Entries[$i] = [System.Drawing.Color]::FromArgb(255, 0, 0, 0) }
    }
    $out.Palette = $pal
    $rect = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
    $bd = $out.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::WriteOnly, [System.Drawing.Imaging.PixelFormat]::Format8bppIndexed)
    for ($y = 0; $y -lt $h; $y++) {
        [System.Runtime.InteropServices.Marshal]::Copy($data, $y * $w, [IntPtr]($bd.Scan0.ToInt64() + $y * $bd.Stride), $w)
    }
    $out.UnlockBits($bd)
    $out.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $out.Dispose()
}

# Is (x, y) inside a w x (bottom + 1) box whose four corners are cut at 45 degrees by c pixels?
function In-Chamfer($x, $y, $w, $bottom, $c) {
    if ($x -lt 0 -or $y -lt 0 -or $x -ge $w -or $y -gt $bottom) { return $false }
    if (($x + $y) -lt $c) { return $false }
    if ((($w - 1 - $x) + $y) -lt $c) { return $false }
    if (($x + ($bottom - $y)) -lt $c) { return $false }
    if ((($w - 1 - $x) + ($bottom - $y)) -lt $c) { return $false }
    return $true
}

# The tail: a right triangle under the bottom edge. Straight edge on the left at $tx (the tip is
# at the bottom of the image), 45 degree edge on the right. $tailH rows below the bottom row.
function In-Tail($x, $y, $bottom, $tx, $tailH) {
    $k = $y - $bottom   # 1..tailH
    if ($k -lt 1 -or $k -gt $tailH) { return $false }
    return ($x -ge $tx -and $x -le ($tx + ($tailH - $k)))
}

# The frame of a card: 1px outline in main, top stripe, flat bg inside, transparent outside.
# $bottom is the last row of the box; $tailH = 0 for no tail.
function New-Frame($w, $h, $bottom, $tailH, $tx, $main, $sub) {
    $bm = New-Canvas $w $h $key
    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            $inside = (In-Chamfer $x $y $w $bottom $chamfer) -or (In-Tail $x $y $bottom $tx $tailH)
            if (-not $inside) { continue }
            $edge = $false
            foreach ($d in @(@(-1, 0), @(1, 0), @(0, -1), @(0, 1))) {
                $nx = $x + $d[0]
                $ny = $y + $d[1]
                $nin = (In-Chamfer $nx $ny $w $bottom $chamfer) -or (In-Tail $nx $ny $bottom $tx $tailH)
                if (-not $nin) { $edge = $true; break }
            }
            $color = $bg
            if ($edge) { $color = $main }
            elseif ($y -lt $bandMain) { $color = $main }
            elseif ($y -lt ($bandMain + $bandSub)) { $color = $sub }
            $bm.SetPixel($x, $y, $color)
        }
    }
    if ($tailH -gt 0) { $bm.SetPixel($tx, $bottom, $main) }   # keep the straight edge of the tail unbroken
    return $bm
}

function Draw-Label($bm, $text, $x, $y) {
    $g = [System.Drawing.Graphics]::FromImage($bm)
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $font = New-Object System.Drawing.Font('Consolas', 13.0, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
    $brush = New-Object System.Drawing.SolidBrush($muted)
    $g.DrawString($text, $font, $brush, [single]$x, [single]$y, [System.Drawing.StringFormat]::GenericTypographic)
    $brush.Dispose(); $font.Dispose(); $g.Dispose()
}

if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
$OutDir = (Resolve-Path $OutDir).Path

# --- speech balloons (250 wide; the bottom row of the body is 10 rows above the image bottom) ---
$tailH = 9
$tailX = 124
foreach ($b in @(
        @{ Name = 'balloons0'; H = 200; Set = 's' },
        @{ Name = 'balloonk0'; H = 159; Set = 'k' },
        @{ Name = 'balloonp2def0'; H = 159; Set = 'p2' },
        @{ Name = 'balloonp3def0'; H = 159; Set = 'p3' })) {
    $bm = New-Frame 250 $b.H ($b.H - 10) $tailH $tailX $sets[$b.Set].Main $sets[$b.Set].Sub
    Save-Indexed $bm (Join-Path $OutDir ($b.Name + '.png'))
    $bm.Dispose()
}

# --- input boxes (neutral; the label sits under the stripe, the edit control is placed by descript.txt) ---
$labels = @('Send', 'Communicate', 'Teach', 'Input', 'Address Bar', 'Textarea')
for ($n = 0; $n -lt 6; $n++) {
    $h = 57
    if ($n -eq 5) { $h = 150 }
    $bm = New-Frame 400 $h ($h - 1) 0 0 $sets['neu'].Main $sets['neu'].Sub
    Draw-Label $bm $labels[$n] 13 6
    Save-Indexed $bm (Join-Path $OutDir ("balloonc$n.png"))
    $bm.Dispose()
}

# --- scroll arrows 13x13: a solid triangle, 13 wide, 7 high, 45 degree sides ---
function New-Arrow($up, $color) {
    $bm = New-Canvas 13 13 $bg
    for ($r = 0; $r -lt 7; $r++) {
        $half = $r
        if (-not $up) { $half = 6 - $r }
        for ($x = 6 - $half; $x -le 6 + $half; $x++) { $bm.SetPixel($x, 3 + $r, $color) }
    }
    return $bm
}

# --- online marker 77x11: ONLINE in a 5x7 pixel font between two lines, a block runs left/right ---
$glyph = @{
    O = @('01110', '10001', '10001', '10001', '10001', '10001', '01110')
    N = @('10001', '11001', '10101', '10101', '10011', '10001', '10001')
    L = @('10000', '10000', '10000', '10000', '10000', '10000', '11111')
    I = @('11111', '00100', '00100', '00100', '00100', '00100', '11111')
    E = @('11111', '10000', '10000', '11110', '10000', '10000', '11111')
}
function New-Online($frame, $main, $sub) {
    $bm = New-Canvas 77 11 $bg
    $word = 'ONLINE'
    $textW = $word.Length * 6 - 1          # 35
    $x0 = [int][Math]::Floor((77 - $textW) / 2)   # 21
    for ($i = 0; $i -lt $word.Length; $i++) {
        $rows = $glyph[[string]$word[$i]]
        for ($r = 0; $r -lt 7; $r++) {
            for ($c = 0; $c -lt 5; $c++) {
                if ($rows[$r][$c] -eq '1') { $bm.SetPixel($x0 + $i * 6 + $c, 2 + $r, $main) }
            }
        }
    }
    $leftEnd = $x0 - 5
    $rightStart = $x0 + $textW + 4
    for ($x = 0; $x -le $leftEnd; $x++) { $bm.SetPixel($x, 5, $main) }
    for ($x = $rightStart; $x -le 76; $x++) { $bm.SetPixel($x, 5, $main) }
    if ($frame -eq 0) { Fill-Rect $bm 0 4 3 3 $sub } else { Fill-Rect $bm 74 4 3 3 $sub }
    return $bm
}

# --- SSTP marker 9x9: a square with the corner pixels cut (a 2px cut looks round at this size) ---
function New-Sstp($color) {
    $bm = New-Canvas 9 9 $bg
    for ($y = 0; $y -lt 9; $y++) {
        for ($x = 0; $x -lt 9; $x++) {
            if (In-Chamfer $x $y 9 8 1) { $bm.SetPixel($x, $y, $color) }
        }
    }
    return $bm
}

# name suffix -> set used for the colors
$parts = @(
    @{ Arrow = 'arrow'; Online = 'online'; Set = 'neu'; Num = $true },
    @{ Arrow = 'arrows'; Online = 'onlines'; Set = 's'; Num = $true },
    @{ Arrow = 'arrowk'; Online = 'onlinek'; Set = 'k'; Num = $true },
    @{ Arrow = 'arrowp2def'; Online = 'onlinep2def'; Set = 'p2'; Num = $true },
    @{ Arrow = 'arrowp3def'; Online = 'onlinep3def'; Set = 'p3'; Num = $true })
foreach ($p in $parts) {
    $m = $sets[$p.Set].Main
    $sb = $sets[$p.Set].Sub
    $bm = New-Arrow $true $m;  Save-Indexed $bm (Join-Path $OutDir ($p.Arrow + '0.png')); $bm.Dispose()
    $bm = New-Arrow $false $m; Save-Indexed $bm (Join-Path $OutDir ($p.Arrow + '1.png')); $bm.Dispose()
    for ($f = 0; $f -lt 2; $f++) {
        $bm = New-Online $f $m $sb
        Save-Indexed $bm (Join-Path $OutDir ($p.Online + $f + '.png'))
        $bm.Dispose()
    }
}
$sstp = @(
    @{ Name = 'sstp'; Set = 'neu' },
    @{ Name = 'sstp_new'; Set = 's' },
    @{ Name = 'sstp_news'; Set = 's' },
    @{ Name = 'sstp_newk'; Set = 'k' },
    @{ Name = 'sstp_newp2def'; Set = 'p2' },
    @{ Name = 'sstp_newp3def'; Set = 'p3' })
foreach ($s in $sstp) {
    $bm = New-Sstp $sets[$s.Set].Main
    Save-Indexed $bm (Join-Path $OutDir ($s.Name + '.png'))
    $bm.Dispose()
}

# --- thumbnail.pnr 200x40: the top-left pixel (the transparent color) is #00ff00 ---
# Top stripe split in four (Kawari, Satori, Aya, guest), the title in Consolas regular, letter-spaced.
$bm = New-Canvas 200 40 $key
for ($y = 0; $y -lt 40; $y++) {
    for ($x = 0; $x -lt 200; $x++) {
        if (-not (In-Chamfer $x $y 200 39 $chamfer)) { continue }
        $edge = -not ((In-Chamfer ($x - 1) $y 200 39 $chamfer) -and (In-Chamfer ($x + 1) $y 200 39 $chamfer) -and (In-Chamfer $x ($y - 1) 200 39 $chamfer) -and (In-Chamfer $x ($y + 1) 200 39 $chamfer))
        $seg = [Math]::Min(3, [int][Math]::Floor($x / 50))
        $set = @('s', 'k', 'p2', 'p3')[$seg]
        $color = $bg
        if ($y -lt $bandMain) { $color = $sets[$set].Main }
        elseif ($y -lt ($bandMain + $bandSub) -and -not $edge) { $color = $sets[$set].Sub }
        elseif ($edge) { $color = $muted }
        $bm.SetPixel($x, $y, $color)
    }
}
$g = [System.Drawing.Graphics]::FromImage($bm)
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$font = New-Object System.Drawing.Font('Consolas', 18.0, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$brush = New-Object System.Drawing.SolidBrush($ink)
$title = 'SHIORIES'
for ($i = 0; $i -lt $title.Length; $i++) {
    $g.DrawString([string]$title[$i], $font, $brush, [single](16 + $i * 21), [single]12, [System.Drawing.StringFormat]::GenericTypographic)
}
$brush.Dispose(); $font.Dispose(); $g.Dispose()
Save-Indexed $bm (Join-Path $OutDir 'thumbnail.pnr')
$bm.Dispose()

Write-Host "done: $OutDir"
