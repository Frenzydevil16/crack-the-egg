using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\scratch\box_pet_fox.png")
Write-Host "Width: $($src.Width), Height: $($src.Height)"

# Let's map out what colors exist in box_pet_fox
# Fox has:
# - Orange fur: R > 200, G ~ 100..180, B ~ 30..120
# - White fur / chest / tail: R > 220, G > 220, B > 220
# - Black eyes / nose / ear tips: R < 60, G < 60, B < 60 (near center only!)
# Background has:
# - Pink (top-right): B > 150, R > 200, G > 140 (or B > 180)
# - Green (bottom-left): G > 160, R < 180
# - Red-orange gradient: R > 200, G < 120, B < 50
# - Star sparkles: white dots in background

for ($y = 0; $y -lt $src.Height; $y += 6) {
    $line = ""
    for ($x = 0; $x -lt $src.Width; $x += 4) {
        $c = $src.GetPixel($x, $y)
        # Check if background:
        # Pink:
        $isPink = ($c.R -gt 200 -and $c.B -gt 160 -and $c.G -lt 210)
        # Green:
        $isGreen = ($c.G -gt 150 -and $c.R -lt 180)
        # Deep red/orange wedge:
        $isRedWedge = ($c.R -gt 180 -and $c.G -lt 110 -and $c.B -lt 40)
        # Dark brown / shadow:
        $isBrown = ($c.R -lt 150 -and $c.G -lt 80 -and $c.B -lt 40)

        if ($isPink) { $line += "P" }
        elseif ($isGreen) { $line += "G" }
        elseif ($isRedWedge) { $line += "R" }
        elseif ($isBrown) { $line += "B" }
        else { $line += "F" } # Fox!
    }
    Write-Host ("{0:D3}: {1}" -f $y, $line)
}
$src.Dispose()
