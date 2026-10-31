Add-Type -AssemblyName System.Drawing
$src = [System.Drawing.Bitmap]::new("C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg")

$cx = 387.0
$cy = 500.0

# Check rim at cx=387, cy=500
for ($deg = 0; $deg -lt 360; $deg += 30) {
    $rad = $deg * [Math]::PI / 180.0
    $firstGoldR = 0
    for ($r = 310; $r -le 345; $r++) {
        $x = [int]($cx + [Math]::Cos($rad) * $r)
        $y = [int]($cy + [Math]::Sin($rad) * $r)
        $c = $src.GetPixel($x, $y)
        if ($c.R -gt 155 -and $c.G -gt 85 -and $c.B -lt 80 -and $c.R -gt $c.G) {
            $firstGoldR = $r
            break
        }
    }
    Write-Output ("deg={0} : inner rim radius = {1}" -f $deg, $firstGoldR)
}

# Check center paw cap radius
for ($deg = 0; $deg -lt 360; $deg += 45) {
    $rad = $deg * [Math]::PI / 180.0
    $lastPawR = 0
    for ($r = 110; $r -ge 70; $r--) {
        $x = [int]($cx + [Math]::Cos($rad) * $r)
        $y = [int]($cy + [Math]::Sin($rad) * $r)
        $c = $src.GetPixel($x, $y)
        # Gold check of the paw rim
        if ($c.R -gt 160 -and $c.G -gt 100 -and $c.B -lt 80) {
            $lastPawR = $r
            break
        }
    }
    Write-Output ("deg={0} : paw cap outer radius = {1}" -f $deg, $lastPawR)
}

# Check top pointer tip
# Pointer tip is around y=190..210 at x=387
for ($y = 180; $y -le 210; $y++) {
    $c = $src.GetPixel(387, $y)
    Write-Output ("y={0} : R={1} G={2} B={3}" -f $y, $c.R, $c.G, $c.B)
}

$src.Dispose()
