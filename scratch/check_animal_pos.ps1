Add-Type -AssemblyName System.Drawing
$imgPath = "C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg"
$src = [System.Drawing.Bitmap]::new($imgPath)

$cx = 387.0
$cy = 500.0
# The 11 animals:
# 0: Hund (-90 deg)
# 1: Katze (-90 + 32.73 deg = -57.27 deg)
# 2: Maus (-24.55 deg)
# 3: Hase (8.18 deg)
# 4: Fuchs (40.91 deg)
# 5: Frosch (73.64 deg)
# 6: Panda (106.36 deg)
# 7: Drache (139.09 deg)
# 8: Phönix (171.82 deg)
# 9: Einhorn (204.55 deg)
# 10: Kosmischer Begleiter (237.27 deg)

# Let's inspect where the animal center is for Fuchs (index 4) and Hund (index 0)
# Radius of animal center:
for ($r = 190; $r -le 250; $r += 10) {
    $xHund = [int]($cx)
    $yHund = [int]($cy - $r)
    Write-Output ("r={0} : Hund at ({1}, {2})" -f $r, $xHund, $yHund)
}

$degFuchs = -90.0 + 4 * (360.0 / 11.0)
$radFuchs = $degFuchs * [Math]::PI / 180.0
for ($r = 190; $r -le 250; $r += 10) {
    $xFuchs = [int]($cx + [Math]::Cos($radFuchs) * $r)
    $yFuchs = [int]($cy + [Math]::Sin($radFuchs) * $r)
    Write-Output ("r={0} : Fuchs at ({1}, {2})" -f $r, $xFuchs, $yFuchs)
}

$src.Dispose()
