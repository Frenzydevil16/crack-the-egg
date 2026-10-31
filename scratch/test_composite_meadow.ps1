using namespace System.Drawing
using namespace System.Drawing.Drawing2D
Add-Type -AssemblyName System.Drawing

$mouse = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\scratch\test_clean_mouse.png")
$outBmp = New-Object Bitmap(300, 300, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [Graphics]::FromImage($outBmp)
$g.SmoothingMode = [SmoothingMode]::AntiAlias

# Draw meadow background
$g.Clear([Color]::FromArgb(255, 135, 206, 235)) # Sky
# Green grass hill
$brush = New-Object SolidBrush([Color]::FromArgb(255, 106, 190, 48))
$g.FillEllipse($brush, -50, 160, 400, 200)
$brush.Dispose()

# Draw mouse standing on the grass
$g.DrawImage($mouse, [Rectangle]::new(75, 70, 150, 150))
$g.Dispose()

$outBmp.Save("c:\Users\kunde\Desktop\Crack the egg\scratch\test_mouse_on_meadow.png", [System.Drawing.Imaging.ImageFormat]::Png)
$outBmp.Dispose()
$mouse.Dispose()
Write-Host "Saved test_mouse_on_meadow.png"
