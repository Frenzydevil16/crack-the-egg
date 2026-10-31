Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap('C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg')
$cx = 387.0
$cy = 500.0

Write-Host "Checking radial profile from center out to 150px at various angles:"
$angles = @(0, 45, 90, 135, 180, 225, 270, 315)
foreach ($a in $angles) {
    $rad = $a * [Math]::PI / 180.0
    Write-Host "--- Angle $a deg ---"
    for ($r = 80; $r -le 130; $r += 5) {
        $x = [int]($cx + $r * [Math]::Sin($rad))
        $y = [int]($cy - $r * [Math]::Cos($rad))
        $c = $bmp.GetPixel($x, $y)
        Write-Host "r=$r : ($x, $y) -> R=$($c.R) G=$($c.G) B=$($c.B)"
    }
}
$bmp.Dispose()
