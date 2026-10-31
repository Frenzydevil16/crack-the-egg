using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\scratch\raw_pet_mouse.png")
Write-Host "Width: $($src.Width) Height: $($src.Height)"

for ($y = 0; $y -lt 220; $y += 10) {
    $line = ""
    for ($x = 0; $x -lt 220; $x += 10) {
        $c = $src.GetPixel($x, $y)
        if ($c.R -gt 180 -and $c.G -gt 180 -and $c.B -gt 180) {
            $line += "M" # Mouse fur
        } elseif ($c.B -gt 150 -and $c.R -lt 50) {
            $line += "~" # Wedge background
        } elseif ($c.R -lt 50 -and $c.G -lt 50 -and $c.B -lt 90) {
            $line += "#" # Dark label tag
        } else {
            $line += "."
        }
    }
    Write-Host ("{0:D3}: {1}" -f $y, $line)
}
$src.Dispose()
