Add-Type -AssemblyName System.Drawing
$src = [System.Drawing.Bitmap]::new("C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg")

# Find the inner edge of the golden rim across all 360 degrees!
# For angles 0..350 step 10 deg:
# We know the golden rim has gold color: R is high (150..255), G is (80..200), B is low (< 70)
# Let's search from r=280 to r=350 from center (cx=387, cy=510)
for ($deg = 0; $deg -lt 360; $deg += 20) {
    $rad = $deg * [Math]::PI / 180.0
    $firstGoldR = 0
    for ($r = 290; $r -le 350; $r++) {
        $x = [int](387 + [Math]::Cos($rad) * $r)
        $y = [int](510 + [Math]::Sin($rad) * $r)
        $c = $src.GetPixel($x, $y)
        # Gold check: R > 160, G > 90, B < 80, and R > G
        if ($c.R -gt 160 -and $c.G -gt 90 -and $c.B -lt 90 -and $c.R -gt $c.G) {
            $firstGoldR = $r
            break
        }
    }
    Write-Output ("Angle {0} deg : first gold at radius {1}" -f $deg, $firstGoldR)
}
$src.Dispose()
