Add-Type -AssemblyName System.Drawing

$srcPath = "C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg"
$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)
Write-Host "Image Dimensions: $($bmp.Width) x $($bmp.Height)"

# Find bounding box of non-black pixels on left (wheel) vs right (panel)
# Notice the gap between the wheel (x around 710) and the right panel (x around 720)
for ($x = 680; $x -le 740; $x++) {
    $nonBlack = 0
    for ($y = 0; $y -lt $bmp.Height; $y += 4) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 25 -or $c.G -gt 25 -or $c.B -gt 25) { $nonBlack++ }
    }
    Write-Host "x=$x : nonBlack=$nonBlack"
}

# Find center of the purple paw circle: look around x=350..420, y=450..550
# Let's find the bounding box of the wheel outer ring (x < 715)
$minX = 1000; $maxX = 0; $minY = 1000; $maxY = 0
for ($y = 50; $y -lt 950; $y += 2) {
    for ($x = 10; $x -lt 712; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 35 -or $c.G -gt 35 -or $c.B -gt 35) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}
Write-Host "Wheel bbox: X=[$minX .. $maxX], Y=[$minY .. $maxY]"

# Also find wheel horizontal span at y=500..520 (middle of wheel excluding left/right diamond tips)
for ($y = 480; $y -le 540; $y += 10) {
    $lx = -1; $rx = -1
    for ($x = 10; $x -lt 712; $x++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 40 -or $c.G -gt 40 -or $c.B -gt 40) {
            if ($lx -eq -1) { $lx = $x }
            $rx = $x
        }
    }
    Write-Host "y=$y : lx=$lx, rx=$rx, midX=$(($lx + $rx) / 2.0)"
}

# Find vertical span at x=380..390
for ($x = 376; $x -le 392; $x += 4) {
    $ty = -1; $by = -1
    for ($y = 50; $y -lt 950; $y++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 40 -or $c.G -gt 40 -or $c.B -gt 40) {
            if ($ty -eq -1) { $ty = $y }
            $by = $y
        }
    }
    Write-Host "x=$x : ty=$ty, by=$by, midY=$(($ty + $by) / 2.0)"
}

$bmp.Dispose()
