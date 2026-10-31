using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg")
$cx = 387.0
$cy = 500.0

# For Fox (center angle = 4 * 2*PI / 11 = 2.284 rad = 130.9 deg)
# Along the center ray of fox:
for ($r = 160; $r -le 320; $r += 10) {
    $x = [int]($cx + $r * [Math]::Sin(4 * [Math]::PI * 2 / 11))
    $y = [int]($cy - $r * [Math]::Cos(4 * [Math]::PI * 2 / 11))
    $c = $src.GetPixel($x, $y)
    Write-Host "r=$r : ($x, $y) -> R=$($c.R) G=$($c.G) B=$($c.B)"
}
$src.Dispose()
