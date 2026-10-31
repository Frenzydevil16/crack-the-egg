Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap('C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg')
Write-Host "Width: $($bmp.Width) Height: $($bmp.Height)"

$minX = 1000; $maxX = 0; $minY = 1000; $maxY = 0;
for ($y = 400; $y -le 600; $y++) {
    for ($x = 280; $x -le 500; $x++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.B -gt 90 -and $c.R -gt 60 -and $c.G -lt 60) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}
Write-Host "Purple circle bounds: X=($minX, $maxX), Y=($minY, $maxY)"
Write-Host "Center: X=$(([double]($minX + $maxX)/2.0)), Y=$(([double]($minY + $maxY)/2.0))"
Write-Host "Radius: X=$(([double]($maxX - $minX)/2.0)), Y=$(([double]($maxY - $minY)/2.0))"

# Check gold ring outer edge around center paw:
$gMinX = 1000; $gMaxX = 0; $gMinY = 1000; $gMaxY = 0;
for ($y = 380; $y -le 620; $y++) {
    for ($x = 260; $x -le 520; $x++) {
        $c = $bmp.GetPixel($x, $y)
        # Gold color: high R (>160), high G (>110), low B (<80)
        if ($c.R -gt 160 -and $c.G -gt 110 -and $c.B -lt 80) {
            # Only consider within distance 100 of (387, 500)
            $dist = [Math]::Sqrt(($x - 387)*($x - 387) + ($y - 500)*($y - 500))
            if ($dist -ge 60 -and $dist -le 105) {
                if ($x -lt $gMinX) { $gMinX = $x }
                if ($x -gt $gMaxX) { $gMaxX = $x }
                if ($y -lt $gMinY) { $gMinY = $y }
                if ($y -gt $gMaxY) { $gMaxY = $y }
            }
        }
    }
}
Write-Host "Gold ring around paw: X=($gMinX, $gMaxX), Y=($gMinY, $gMaxY)"
Write-Host "Gold Center: X=$(([double]($gMinX + $gMaxX)/2.0)), Y=$(([double]($gMinY + $gMaxY)/2.0))"
Write-Host "Gold Radius: X=$(([double]($gMaxX - $gMinX)/2.0)), Y=$(([double]($gMaxY - $gMinY)/2.0))"
$bmp.Dispose()
