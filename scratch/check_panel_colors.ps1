using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg")

# The right panel inner area:
# Inner left x ~ 725, inner right x ~ 972
# Bottom section starts around y = 682 (below the Mythic 1% row) and ends at y = 800 (above bottom golden border)
Write-Host "Card background color just above the button (e.g. at x=850, y=675):"
$c = $src.GetPixel(850, 675)
Write-Host "RGB: ($($c.R), $($c.G), $($c.B))"

Write-Host "Card background color near edges (e.g. at x=735, y=675):"
$c2 = $src.GetPixel(735, 675)
Write-Host "RGB: ($($c2.R), $($c2.G), $($c2.B))"

Write-Host "Card background color near bottom (e.g. at x=850, y=795):"
$c3 = $src.GetPixel(850, 795)
Write-Host "RGB: ($($c3.R), $($c3.G), $($c3.B))"

$src.Dispose()
