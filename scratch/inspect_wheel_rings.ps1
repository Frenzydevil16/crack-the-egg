Add-Type -AssemblyName System.Drawing

$srcPath = "C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)

# Let's scan along a diagonal or at 45 degrees from ~ (384, 512) to find the exact center and radii of:
# 1) The inner purple paw circle
# 2) The golden ring around the center paw
# 3) The outer boundary of the colored wedges (where the outer golden rim starts)
# 4) The outer edge of the golden rim (excluding the 4 diamond studs)

# First, let's find the exact center of the purple paw circle by scanning horizontal & vertical lines through (385, 510)
# Inside the purple paw circle, the background is purple (high B and R, low G, except on the yellow paw in the very middle).
# Wait: the golden ring around the center cap has high R, high G, low B!
# Let's print RGB values along y=510 for x=260..510 and along x=385 for y=380..640:
Write-Host "=== Horizontal scan at y=510 (x=0..750 step 10) ==="
for ($x = 30; $x -le 740; $x += 5) {
    $c = $bmp.GetPixel($x, 510)
    if ($x -le 100 -or ($x -ge 270 -and $x -le 500) -or $x -ge 660) {
        Write-Host ("x={0} : R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
    }
}

Write-Host "=== Vertical scan at x=385 (y=100..880 step 5) ==="
for ($y = 100; $y -le 880; $y += 5) {
    $c = $bmp.GetPixel(385, $y)
    if ($y -le 220 -or ($y -ge 390 -and $y -le 620) -or $y -ge 800) {
        Write-Host ("y={0} : R={1} G={2} B={3}" -f $y, $c.R, $c.G, $c.B)
    }
}

# Also let's find the Right Panel bounding box (x > 720)
$pMinX = 1024; $pMaxX = 0; $pMinY = 1024; $pMaxY = 0
for ($y = 200; $y -lt 900; $y += 2) {
    for ($x = 724; $x -lt 1020; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 35 -or $c.G -gt 35 -or $c.B -gt 35) {
            if ($x -lt $pMinX) { $pMinX = $x }
            if ($x -gt $pMaxX) { $pMaxX = $x }
            if ($y -lt $pMinY) { $pMinY = $y }
            if ($y -gt $pMaxY) { $pMaxY = $y }
        }
    }
}
Write-Host "Right Panel bbox: X=[$pMinX .. $pMaxX], Y=[$pMinY .. $pMaxY]"

# Scan vertically at x=860 from y=650 to 840 to find the exact y range of the 'Dreh kostenlos' button and '1 Dreh verfügbar' label
Write-Host "=== Right Panel Vertical Scan at x=860 (y=660..830) ==="
for ($y = 660; $y -le 830; $y += 4) {
    $c = $bmp.GetPixel(860, $y)
    Write-Host ("y={0} : R={1} G={2} B={3}" -f $y, $c.R, $c.G, $c.B)
}

$bmp.Dispose()
