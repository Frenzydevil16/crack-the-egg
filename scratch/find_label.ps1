using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg")

# Search in x=480..600, y=380..480
$minX = 1000; $maxX = 0; $minY = 1000; $maxY = 0;
for ($y = 400; $y -le 480; $y++) {
    for ($x = 480; $x -le 600; $x++) {
        $c = $src.GetPixel($x, $y)
        # Dark label tag has low brightness (R<60, G<60, B<120)
        if ($c.R -lt 40 -and $c.G -lt 60 -and $c.B -lt 140) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}
Write-Host "Label bounds: X=($minX, $maxX), Y=($minY, $maxY)"
$src.Dispose()
