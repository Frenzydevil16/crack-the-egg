Add-Type -AssemblyName System.Drawing
$imgPath = "C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg"
$src = [System.Drawing.Bitmap]::new($imgPath)

Write-Output "=== Vertical scan at x=387 (y=160..240) ==="
for ($y = 160; $y -le 240; $y += 2) {
    $c = $src.GetPixel(387, $y)
    Write-Output ("y={0} : R={1} G={2} B={3}" -f $y, $c.R, $c.G, $c.B)
}

Write-Output "=== Bottom vertical scan at x=387 (y=800..860) ==="
for ($y = 800; $y -le 860; $y += 2) {
    $c = $src.GetPixel(387, $y)
    Write-Output ("y={0} : R={1} G={2} B={3}" -f $y, $c.R, $c.G, $c.B)
}

Write-Output "=== Left horizontal scan at y=510 (x=50..100) ==="
for ($x = 50; $x -le 100; $x += 2) {
    $c = $src.GetPixel($x, 510)
    Write-Output ("x={0} : R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}

Write-Output "=== Right horizontal scan at y=510 (x=680..730) ==="
for ($x = 680; $x -le 730; $x += 2) {
    $c = $src.GetPixel($x, 510)
    Write-Output ("x={0} : R={1} G={2} B={3}" -f $x, $c.R, $c.G, $c.B)
}

# Also inspect near top at x=300 (where the rim is curved, without pointer)
Write-Output "=== Top vertical scan at x=300 (y=160..240) ==="
for ($y = 160; $y -le 240; $y += 2) {
    $c = $src.GetPixel(300, $y)
    Write-Output ("y={0} : R={1} G={2} B={3}" -f $y, $c.R, $c.G, $c.B)
}
$src.Dispose()
