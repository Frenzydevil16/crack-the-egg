using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\scratch\test_mitdrehen_65.png")
$crop = New-Object Bitmap(280, 280, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [Graphics]::FromImage($crop)
# Center is (387, 500)
$g.DrawImage($src, [Rectangle]::new(0, 0, 280, 280), [Rectangle]::new(387 - 140, 500 - 140, 280, 280), [GraphicsUnit]::Pixel)
$g.Dispose()
$crop.Save("c:\Users\kunde\Desktop\Crack the egg\scratch\crop_center_65.png", [System.Drawing.Imaging.ImageFormat]::Png)
$crop.Dispose()
$src.Dispose()
Write-Host "Saved crop_center_65.png"
