Add-Type -AssemblyName System.Drawing
$src = [System.Drawing.Bitmap]::new("C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg")

# Find the exact boundary of the top pointer
# Top pointer starts at the top frame and points down with its tip near (387, 197).
# Let's inspect x=330..445, y=100..205
for ($y = 150; $y -le 205; $y += 5) {
    $line = ""
    for ($x = 345; $x -le 430; $x += 3) {
        $c = $src.GetPixel($x, $y)
        # Gold or purple gemstone:
        # Gold: R > 150, G > 90, B < 80
        # Gemstone: purple R > 80, B > 120
        $isPointer = ($c.R -gt 140 -and $c.G -gt 80 -and $c.B -lt 90) -or ($c.B -gt 150 -and $c.R -gt 80)
        $line += if ($isPointer) { "#" } else { "." }
    }
    Write-Output ("y={0:D3} : {1}" -f $y, $line)
}

$src.Dispose()
