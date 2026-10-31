using namespace System.Drawing
using namespace System.Drawing.Drawing2D
Add-Type -AssemblyName System.Drawing

$frame = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\scratch\wheel_frame_ui_mitdrehen.png")
$outBmp = New-Object Bitmap($frame.Width, $frame.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [Graphics]::FromImage($outBmp)
$g.DrawImage($frame, 0, 0)

# Fill the bottom slot inside right panel: x=734..966, y=682..794
# Vertical gradient from RGB(18, 16, 52) to RGB(30, 24, 76)
$rect = [Rectangle]::new(734, 682, 232, 112)
$brush = New-Object LinearGradientBrush($rect, [Color]::FromArgb(255, 18, 16, 52), [Color]::FromArgb(255, 28, 22, 70), [LinearGradientMode]::Vertical)
$g.FillRectangle($brush, $rect)
$brush.Dispose()

$g.Dispose()
$outBmp.Save("c:\Users\kunde\Desktop\Crack the egg\scratch\frame_clean_slot.png", [System.Drawing.Imaging.ImageFormat]::Png)
$outBmp.Dispose()
$frame.Dispose()
Write-Host "Saved frame_clean_slot.png"
