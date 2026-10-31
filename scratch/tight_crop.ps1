using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg")

# In 1024x1024 src:
# Fox center was (536, 654)
# Let's crop tight around the fox: 100x100 centered at (536, 654)
$tight = New-Object Bitmap(110, 110, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [Graphics]::FromImage($tight)
$g.DrawImage($src, [Rectangle]::new(0, 0, 110, 110), [Rectangle]::new(536 - 55, 654 - 55, 110, 110), [GraphicsUnit]::Pixel)
$g.Dispose()
$tight.Save("c:\Users\kunde\Desktop\Crack the egg\scratch\tight_fox.png", [System.Drawing.Imaging.ImageFormat]::Png)
$tight.Dispose()
$src.Dispose()
Write-Host "Saved tight_fox.png"
