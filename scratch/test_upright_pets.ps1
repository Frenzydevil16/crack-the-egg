Add-Type -AssemblyName System.Drawing
$imgPath = "C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg"
$src = [System.Drawing.Bitmap]::new($imgPath)

$cx = 387.0
$cy = 500.0

# Test extracting upright Fuchs (index 4)
# When Fuchs is at 12 o'clock, the wheel was rotated by -4 * (360/11) degrees!
# So to sample Fuchs upright, for each pixel (dx, dy) in the output 200x200 portrait (center 100, 100):
# The animal center is at dist rCenter = 215 along angle theta = -90 + index*(360/11).
# In animal-local coords (lx, ly), upright has +ly pointing towards wheel center (or away from wheel center).
# Let's verify by testing both orientations for Hund and Fuchs.

$outDir = "c:\Users\kunde\Desktop\Crack the egg\scratch"
$size = 220
$half = 110.0
$rCenter = 215.0

foreach ($idx in @(0, 4, 7, 8, 10)) {
    $angleDeg = -90.0 + $idx * (360.0 / 11.0)
    $angleRad = $angleDeg * [Math]::PI / 180.0

    # Animal center in source
    $ax = $cx + [Math]::Cos($angleRad) * $rCenter
    $ay = $cy + [Math]::Sin($angleRad) * $rCenter

    # Rotation angle of the animal on the wheel:
    # At top (idx=0, angleDeg=-90), animal is upright, rot = 0.
    # So rotRad = angleRad - (-PI/2) = angleRad + PI/2.
    $rotRad = $angleRad + [Math]::PI / 2.0

    $bmp = [System.Drawing.Bitmap]::new($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    for ($y = 0; $y -lt $size; $y++) {
        $ly = $y - $half
        for ($x = 0; $x -lt $size; $x++) {
            $lx = $x - $half
            $distFromCenter = [Math]::Sqrt($lx * $lx + $ly * $ly)
            if ($distFromCenter -gt 104.0) {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
                continue
            }

            # Rotate (lx, ly) by rotRad to get source offset
            $sx = $ax + $lx * [Math]::Cos($rotRad) - $ly * [Math]::Sin($rotRad)
            $sy = $ay + $lx * [Math]::Sin($rotRad) + $ly * [Math]::Cos($rotRad)

            if ($sx -ge 0 -and $sx -lt $src.Width -and $sy -ge 0 -and $sy -lt $src.Height) {
                $c = $src.GetPixel([int]$sx, [int]$sy)
                if ($distFromCenter -gt 100.0) {
                    # Golden rim border
                    $a = [int]((104.0 - $distFromCenter) / 4.0 * 255.0)
                    $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($a, 255, 215, 60))
                } else {
                    $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $c.R, $c.G, $c.B))
                }
            } else {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            }
        }
    }
    $bmp.Save("$outDir\test_pet_$idx.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "Saved test_pet_$idx.png"
}
$src.Dispose()
