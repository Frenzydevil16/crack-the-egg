Add-Type -AssemblyName System.Drawing
$imgPath = "C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg"
$src = [System.Drawing.Bitmap]::new($imgPath)

$cx = 387.0
$cy = 500.0
$outDir = "c:\Users\kunde\Desktop\Crack the egg\scratch"
$size = 240
$half = 120.0
$rCenter = 215.0

foreach ($idx in @(0, 4, 7, 8, 10)) {
    $angleDeg = -90.0 + $idx * (360.0 / 11.0)
    $angleRad = $angleDeg * [Math]::PI / 180.0

    # Animal center in source
    $ax = $cx + [Math]::Cos($angleRad) * $rCenter
    $ay = $cy + [Math]::Sin($angleRad) * $rCenter

    # The rotation angle to make it upright:
    # At idx=0, angleRad = -PI/2. We want it upright without rotation.
    # So rotRad = angleRad - (-PI/2) = angleRad + PI/2.
    # But wait, in 2D screen coords (y down):
    # dx = lx * cos(rot) - ly * sin(rot)
    # dy = lx * sin(rot) + ly * cos(rot)
    # If rotRad = angleRad + PI/2, at idx=0 rotRad=0.
    # Why was Fuchs upside down? Let's check idx=4:
    # angleDeg = 40.91 deg. ax is bottom-right.
    # lx=0, ly=-50 (top of portrait, head):
    # sy = ay - 50*cos(rot). If rot = 130 deg, cos(rot) is negative (-0.64), so sy = ay + 32 (moves DOWN)!
    # Moving DOWN moves towards higher y, which is further from center or down!
    # To move towards outer rim (away from center (cx, cy)):
    # Direction away from center is (cos(angleRad), sin(angleRad)).
    # We want top of portrait (ly < 0) to move away from center:
    # So (sx - ax, sy - ay) for lx=0, ly=-1 should be + (cos(angleRad), sin(angleRad))!
    # Therefore:
    # sx - ax = -ly * cos(angleRad)
    # sy - ay = -ly * sin(angleRad)
    # And for right of portrait (lx > 0), perpendicular to (cos, sin) clockwise:
    # perp = (-sin(angleRad), cos(angleRad))
    # So:
    # sx = ax + lx * (-sin(angleRad)) - ly * cos(angleRad)
    # sy = ay + lx * cos(angleRad) - ly * sin(angleRad)

    $bmp = [System.Drawing.Bitmap]::new($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    for ($y = 0; $y -lt $size; $y++) {
        $ly = $y - $half
        for ($x = 0; $x -lt $size; $x++) {
            $lx = $x - $half
            $distFromCenter = [Math]::Sqrt($lx * $lx + $ly * $ly)
            if ($distFromCenter -gt 114.0) {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
                continue
            }

            $sx = $ax + $lx * (-[Math]::Sin($angleRad)) - $ly * [Math]::Cos($angleRad)
            $sy = $ay + $lx * [Math]::Cos($angleRad) - $ly * [Math]::Sin($angleRad)

            if ($sx -ge 0 -and $sx -lt $src.Width -and $sy -ge 0 -and $sy -lt $src.Height) {
                $c = $src.GetPixel([int]$sx, [int]$sy)
                if ($distFromCenter -gt 110.0) {
                    $a = [int]((114.0 - $distFromCenter) / 4.0 * 255.0)
                    $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($a, 255, 215, 60))
                } else {
                    $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $c.R, $c.G, $c.B))
                }
            } else {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            }
        }
    }
    $bmp.Save("$outDir\upright_pet_$idx.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "Saved upright_pet_$idx.png"
}
$src.Dispose()
