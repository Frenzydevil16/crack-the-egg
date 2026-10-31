Add-Type -AssemblyName System.Drawing

$frame = [System.Drawing.Bitmap]::new("c:\Users\kunde\Desktop\Crack the egg\assets\wheel\wheel_frame_ui.png")
$disc = [System.Drawing.Bitmap]::new("c:\Users\kunde\Desktop\Crack the egg\assets\wheel\wheel_disc.png")

Write-Output "Frame Size: $($frame.Width) x $($frame.Height)"
Write-Output "Disc Size: $($disc.Width) x $($disc.Height)"

# Inspect the alpha of wheel_frame_ui.png along angle 60 deg (towards top right) and straight top (x=387)
# Center is (387, 510)
$cx = 387
$cy = 510

Write-Output "=== Alpha of wheel_frame_ui.png from dist 300 to 335 at angle -60 deg ==="
$rad = -60.0 * [Math]::PI / 180.0
for ($d = 300; $d -le 335; $d += 2) {
    $x = [int]($cx + [Math]::Cos($rad) * $d)
    $y = [int]($cy + [Math]::Sin($rad) * $d)
    $c = $frame.GetPixel($x, $y)
    Write-Output ("dist={0} (x={1}, y={2}) : Alpha={3} R={4} G={5} B={6}" -f $d, $x, $y, $c.A, $c.R, $c.G, $c.B)
}

Write-Output "=== Alpha of wheel_disc.png at angle -60 deg (center 320, 320) ==="
for ($d = 300; $d -le 325; $d += 2) {
    $x = [int](320 + [Math]::Cos($rad) * $d)
    $y = [int](320 + [Math]::Sin($rad) * $d)
    if ($x -ge 0 -and $x -lt $disc.Width -and $y -ge 0 -and $y -lt $disc.Height) {
        $c = $disc.GetPixel($x, $y)
        Write-Output ("dist={0} (x={1}, y={2}) : Alpha={3} R={4} G={5} B={6}" -f $d, $x, $y, $c.A, $c.R, $c.G, $c.B)
    }
}
$frame.Dispose()
$disc.Dispose()
