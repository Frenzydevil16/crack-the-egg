Add-Type -AssemblyName System.Drawing
$src = [System.Drawing.Bitmap]::new("C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg")
$frame = [System.Drawing.Bitmap]::new("c:\Users\kunde\Desktop\Crack the egg\assets\wheel\wheel_frame_ui.png")

Write-Output "=== Checking pixels near pointer left (x=335..360, y=180..215) ==="
for ($y = 180; $y -le 215; $y += 3) {
    for ($x = 335; $x -le 360; $x += 5) {
        $cs = $src.GetPixel($x, $y)
        $cf = $frame.GetPixel($x, $y)
        Write-Output ("x={0} y={1} : SRC(R={2} G={3} B={4}) -> FRAME(A={5} R={6} G={7} B={8})" -f $x, $y, $cs.R, $cs.G, $cs.B, $cf.A, $cf.R, $cf.G, $cf.B)
    }
}
$src.Dispose()
$frame.Dispose()
