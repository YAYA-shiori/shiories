# Generates ghost/master/icon.ico of SHIORIES: a DLL file (folded page with a gear)
# with a band of the four SHIORI colors (Kawari, Satori, Aya/Yaya, guest) at the bottom.
# Colors and rules: DESIGN.md. 32x32 and 16x16, 32bit BMP entries (the sizes UKADOC names).
# No letters: they would not be readable at these sizes.
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File work/icon/make-icon.ps1
#   ... -PreviewDir <folder>     also writes icon_32.png and icon_16.png there
#
# Keep ASCII only in this file (Windows PowerShell 5.1).

param(
    [string]$Out = (Join-Path $PSScriptRoot '..\..\ghost\master\icon.ico'),
    [string]$PreviewDir = ''
)

Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'

function RGB($hex) {
    [System.Drawing.Color]::FromArgb(255, [Convert]::ToInt32($hex.Substring(1, 2), 16), [Convert]::ToInt32($hex.Substring(3, 2), 16), [Convert]::ToInt32($hex.Substring(5, 2), 16))
}

$ink = RGB '#1c1d21'
$surface = RGB '#ffffff'
$line = RGB '#e3e3df'
$mains = @((RGB '#1c1d21'), (RGB '#2f6b3f'), (RGB '#9b3f3a'), (RGB '#5e616b'))
$subs = @((RGB '#c4262e'), (RGB '#b48e3e'), (RGB '#1c1d21'), (RGB '#8a8d96'))

function P($x, $y) { New-Object System.Drawing.PointF ([single]$x), ([single]$y) }

# Draws the icon on a 128x128 canvas (units). 32px = 4 units per pixel, 16px = 8 units per pixel;
# all straight edges are put on that pixel grid so that they stay crisp.
function DrawIcon($g, $simple) {
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    $u = if ($simple) { 8 } else { 4 }       # units per pixel
    $pen = New-Object System.Drawing.Pen $ink, $u
    $pen.Alignment = [System.Drawing.Drawing2D.PenAlignment]::Inset
    $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Miter

    # page with the folded corner (45 degrees)
    if ($simple) {
        $page = @((P 16 8), (P 88 8), (P 112 32), (P 112 120), (P 16 120))
    } else {
        $page = @((P 16 4), (P 82 4), (P 112 34), (P 112 124), (P 16 124))
    }
    $g.FillPolygon((New-Object System.Drawing.SolidBrush $surface), $page)
    if ($simple) {
        $fold = @((P 88 8), (P 88 32), (P 112 32))
    } else {
        $fold = @((P 82 4), (P 82 34), (P 112 34))
    }
    $g.FillPolygon((New-Object System.Drawing.SolidBrush $line), $fold)
    $g.DrawPolygon($pen, $page)
    if (-not $simple) {
        $fp = New-Object System.Drawing.Pen $ink, $u
        $g.DrawLine($fp, (P 82 6), (P 82 34))
        $g.DrawLine($fp, (P 80 34), (P 112 34))
        $fp.Dispose()
    }

    # gear: 8 teeth, with a hole
    $cx = 62
    if ($simple) { $cy = 62; $R = 36; $r = 25; $hole = 10 } else { $cy = 64; $R = 36; $r = 25; $hole = 10 }
    $teeth = 8
    $step = 2 * [Math]::PI / $teeth
    $pts = New-Object System.Collections.Generic.List[System.Drawing.PointF]
    for ($i = 0; $i -lt $teeth; $i++) {
        $a0 = $step * $i - $step / 2
        foreach ($d in @(@(0.16, $r), @(0.28, $R), @(0.72, $R), @(0.84, $r))) {
            $a = $a0 + $d[0] * $step
            $pts.Add((P ($cx + $d[1] * [Math]::Cos($a)) ($cy + $d[1] * [Math]::Sin($a))))
        }
    }
    $gp = New-Object System.Drawing.Drawing2D.GraphicsPath ([System.Drawing.Drawing2D.FillMode]::Alternate)
    $gp.AddPolygon($pts.ToArray())
    $gp.AddEllipse([single]($cx - $hole), [single]($cy - $hole), [single](2 * $hole), [single](2 * $hole))
    $g.FillPath((New-Object System.Drawing.SolidBrush $ink), $gp)

    # band: one segment per SHIORI (main color), a thin sub line above it (32px only)
    if ($simple) {
        $xs = @(24, 48, 64, 80, 104)             # 3px, 2px, 2px, 3px
        $bandTop = 96; $bandBottom = 112; $subH = 0
    } else {
        $xs = @(20, 40, 64, 88, 108)             # 5px, 6px, 6px, 5px
        $bandTop = 108; $bandBottom = 120; $subH = 4
    }
    for ($i = 0; $i -lt 4; $i++) {
        $sx = $xs[$i]; $sw = $xs[$i + 1] - $xs[$i]
        if ($subH -gt 0) {
            $g.FillRectangle((New-Object System.Drawing.SolidBrush $subs[$i]), [single]$sx, [single]($bandTop - $subH), [single]$sw, [single]$subH)
        }
        $g.FillRectangle((New-Object System.Drawing.SolidBrush $mains[$i]), [single]$sx, [single]$bandTop, [single]$sw, [single]($bandBottom - $bandTop))
    }
    $pen.Dispose()
}

function Render($size, $simple) {
    $master = New-Object System.Drawing.Bitmap 512, 512, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($master)
    $g.Clear([System.Drawing.Color]::Transparent)
    $g.ScaleTransform(4.0, 4.0)
    DrawIcon $g $simple
    $g.Dispose()

    $bmp = New-Object System.Drawing.Bitmap $size, $size, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g2 = [System.Drawing.Graphics]::FromImage($bmp)
    $g2.Clear([System.Drawing.Color]::Transparent)
    $g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g2.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g2.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g2.DrawImage($master, 0, 0, $size, $size)
    $g2.Dispose()
    $master.Dispose()
    $bmp
}

# One ICO entry as a 32bit BMP (BITMAPINFOHEADER, bottom-up BGRA, then the 1bit AND mask)
function EntryBytes($bmp) {
    $w = $bmp.Width; $h = $bmp.Height
    $ms = New-Object System.IO.MemoryStream
    $bw = New-Object System.IO.BinaryWriter $ms
    $bw.Write([int]40); $bw.Write([int]$w); $bw.Write([int]($h * 2))
    $bw.Write([int16]1); $bw.Write([int16]32); $bw.Write([int]0)
    $bw.Write([int]($w * $h * 4)); $bw.Write([int]0); $bw.Write([int]0); $bw.Write([int]0); $bw.Write([int]0)
    for ($y = $h - 1; $y -ge 0; $y--) {
        for ($x = 0; $x -lt $w; $x++) {
            $c = $bmp.GetPixel($x, $y)
            $bw.Write([byte]$c.B); $bw.Write([byte]$c.G); $bw.Write([byte]$c.R); $bw.Write([byte]$c.A)
        }
    }
    $maskRow = [int]([Math]::Ceiling($w / 32.0) * 4)
    for ($y = 0; $y -lt $h; $y++) { for ($i = 0; $i -lt $maskRow; $i++) { $bw.Write([byte]0) } }
    $bw.Flush()
    , $ms.ToArray()
}

$sizes = @(@(32, $false), @(16, $true))
$entries = @()
foreach ($s in $sizes) {
    $bmp = Render $s[0] $s[1]
    if ($PreviewDir -ne '') {
        New-Item -ItemType Directory -Force -Path $PreviewDir | Out-Null
        $bmp.Save((Join-Path (Resolve-Path $PreviewDir).Path ('icon_{0}.png' -f $s[0])), [System.Drawing.Imaging.ImageFormat]::Png)
    }
    $entries += , @($s[0], (EntryBytes $bmp))
    $bmp.Dispose()
}

$ms = New-Object System.IO.MemoryStream
$bw = New-Object System.IO.BinaryWriter $ms
$bw.Write([int16]0); $bw.Write([int16]1); $bw.Write([int16]$entries.Count)
$offset = 6 + 16 * $entries.Count
foreach ($e in $entries) {
    $sz = $e[0]; $bytes = $e[1]
    $bw.Write([byte]$sz); $bw.Write([byte]$sz); $bw.Write([byte]0); $bw.Write([byte]0)
    $bw.Write([int16]1); $bw.Write([int16]32); $bw.Write([int]$bytes.Length); $bw.Write([int]$offset)
    $offset += $bytes.Length
}
foreach ($e in $entries) { $bw.Write($e[1]) }
$bw.Flush()

$outDir = Split-Path -Parent $Out
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
[System.IO.File]::WriteAllBytes((Join-Path (Resolve-Path $outDir).Path (Split-Path -Leaf $Out)), $ms.ToArray())
Write-Output ('wrote {0} ({1} bytes)' -f $Out, $ms.Length)
