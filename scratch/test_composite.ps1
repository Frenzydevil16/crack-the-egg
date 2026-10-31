Add-Type -AssemblyName System.Drawing
$frame = [System.Drawing.Bitmap]::new("c:\Users\kunde\Desktop\Crack the egg\assets\wheel\wheel_frame_ui.png")
$disc = [System.Drawing.Bitmap]::new("c:\Users\kunde\Desktop\Crack the egg\assets\wheel\wheel_disc.png")

# Combine on a dark navy background (like in the game)
$composite = [System.Drawing.Bitmap]::new(1024, 1024, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($composite)
$g.Clear([System.Drawing.Color]::FromArgb(255, 10, 15, 35))

# Draw rotated disc (e.g. rotated by 130 degrees like in user's screenshot where Fuchs was at top!)
$g.TranslateTransform(387, 500)
$g.RotateTransform(131.0)
$g.DrawImage($disc, -338, -338, 676, 676)
$g.ResetTransform()

# Draw frame
$g.DrawImage($frame, 0, 0, 1024, 1024)
$g.Dispose()

$composite.Save("c:\Users\kunde\Desktop\Crack the egg\scratch\test_composite_fuchs_top.png", [System.Drawing.Imaging.ImageFormat]::Png)
$composite.Dispose()
$frame.Dispose()
$disc.Dispose()
Write-Output "Saved test_composite_fuchs_top.png"
