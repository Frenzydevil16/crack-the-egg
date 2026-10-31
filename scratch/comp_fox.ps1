using namespace System.Drawing
using namespace System.Drawing.Drawing2D
Add-Type -AssemblyName System.Drawing

$fox = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\scratch\fox_clean_test.png")
$outBmp = New-Object Bitmap(240, 240, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [Graphics]::FromImage($outBmp)
$g.Clear([Color]::FromArgb(255, 95, 185, 45)) # Green meadow grass
$g.DrawImage($fox, [Rectangle]::new(30, 30, 180, 180))
$g.Dispose()

$outBmp.Save("c:\Users\kunde\Desktop\Crack the egg\scratch\test_fox_on_green.png", [System.Drawing.Imaging.ImageFormat]::Png)
$outBmp.Dispose()
$fox.Dispose()
Write-Host "Saved test_fox_on_green.png"
