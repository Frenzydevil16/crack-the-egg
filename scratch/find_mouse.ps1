using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg")

# Search in x=530..680, y=320..460
$minX = 1000; $maxX = 0; $minY = 1000; $maxY = 0;
for ($y = 320; $y -le 460; $y++) {
    for ($x = 540; $x -le 680; $x++) {
        $c = $src.GetPixel($x, $y)
        # Mouse fur/body has high brightness (R>140, G>140, B>160) or pink ears (R>200, G>130, B>140)
        # and NOT blue wedge background (B > G+40 or B > R+40)
        $isMouse = ($c.R -gt 150 -and $c.G -gt 140 -and $c.B -gt 150 -and [Math]::Abs($c.R - $c.G) -lt 60) -or
                   ($c.R -gt 190 -and $c.G -lt 160 -and $c.B -lt 170) # Pink ear
        if ($isMouse) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}
Write-Host "Mouse body bounds: X=($minX, $maxX), Y=($minY, $maxY)"
Write-Host "Center: X=$(([double]($minX + $maxX)/2.0)), Y=$(([double]($minY + $maxY)/2.0))"
Write-Host "Size: W=$($maxX - $minX), H=$($maxY - $minY)"
$src.Dispose()
