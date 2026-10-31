using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$bg = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\assets\bg_nature.png")
Write-Host "bg_nature size: $($bg.Width) x $($bg.Height)"

# Crop a 500x320 meadow showcase banner from bg_nature
# The center/bottom of bg_nature has the green meadow, rolling hills, and cute plants
$meadow = New-Object Bitmap(500, 320, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [Graphics]::FromImage($meadow)
$g.InterpolationMode = [Drawing2D.InterpolationMode]::HighQualityBicubic
# Let's crop from y=480..800, x=260..760 of bg_nature
$g.DrawImage($bg, [Rectangle]::new(0, 0, 500, 320), [Rectangle]::new(262, 480, 500, 320), [GraphicsUnit]::Pixel)
$g.Dispose()

$meadow.Save("c:\Users\kunde\Desktop\Crack the egg\scratch\meadow_stage_sample.png", [System.Drawing.Imaging.ImageFormat]::Png)
$meadow.Dispose()
$bg.Dispose()
Write-Host "Saved meadow_stage_sample.png"
