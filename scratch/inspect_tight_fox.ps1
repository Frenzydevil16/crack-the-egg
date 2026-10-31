using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\scratch\tight_fox.png")
Write-Host "Width: $($src.Width), Height: $($src.Height)"

for ($y = 0; $y -lt $src.Height; $y += 5) {
    $line = ""
    for ($x = 0; $x -lt $src.Width; $x += 3) {
        $c = $src.GetPixel($x, $y)
        # Background:
        # Wedge is warm orange-red / sparkles / or dark label
        $isBg = ($c.R -gt 210 -and $c.G -lt 120 -and $c.B -lt 50) -or ($c.R -lt 100 -and $c.G -lt 80 -and $c.B -lt 50)
        if ($isBg) { $line += "." }
        else { $line += "#" }
    }
    Write-Host ("{0:D3}: {1}" -f $y, $line)
}
$src.Dispose()
