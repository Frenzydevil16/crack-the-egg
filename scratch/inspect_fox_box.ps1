using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\scratch\box_pet_fox.png")
Write-Host "box_pet_fox: $($src.Width) x $($src.Height)"

# In box_pet_fox: let's inspect colors in the 4 corners:
Write-Host "Top-left (5, 5):" ($src.GetPixel(5, 5))
Write-Host "Top-right (W-5, 5):" ($src.GetPixel($src.Width - 5, 5))
Write-Host "Bottom-left (5, H-5):" ($src.GetPixel(5, $src.Height - 5))
Write-Host "Bottom-right (W-5, H-5):" ($src.GetPixel($src.Width - 5, $src.Height - 5))

# What is the fox itself?
# Fox center (75, 65):
Write-Host "Fox center (75, 65):" ($src.GetPixel(75, 65))
$src.Dispose()
