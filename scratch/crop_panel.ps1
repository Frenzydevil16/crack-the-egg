using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg")
$crop = New-Object Bitmap(290, 160, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [Graphics]::FromImage($crop)
# Crop x=700..990, y=660..820
$g.DrawImage($src, [Rectangle]::new(0, 0, 290, 160), [Rectangle]::new(700, 660, 290, 160), [GraphicsUnit]::Pixel)
$g.Dispose()
$crop.Save("c:\Users\kunde\Desktop\Crack the egg\scratch\crop_right_panel_bottom.png", [System.Drawing.Imaging.ImageFormat]::Png)
$crop.Dispose()
$src.Dispose()
Write-Host "Saved crop_right_panel_bottom.png"
