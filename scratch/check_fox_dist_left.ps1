Add-Type -AssemblyName System.Drawing
$src = [System.Drawing.Bitmap]::new("C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg")

# Check distance from Fuchs center (536, 654) towards bottom-left (dx = -d*0.707, dy = d*0.707)
for ($d = 40; $d -le 75; $d += 2) {
    $x = [int](536 - $d * 0.707)
    $y = [int](654 + $d * 0.707)
    $c = $src.GetPixel($x, $y)
    Write-Output ("dist={0} (x={1}, y={2}) : R={3} G={4} B={5}" -f $d, $x, $y, $c.R, $c.G, $c.B)
}
$src.Dispose()
