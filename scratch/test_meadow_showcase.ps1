using namespace System.Drawing
using namespace System.Drawing.Drawing2D
Add-Type -AssemblyName System.Drawing

$stage = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\assets\pets\pet_meadow_stage.png")

foreach ($petId in @("pet_dog", "pet_mouse", "pet_fox", "pet_unicorn")) {
    $pet = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\assets\pets\$petId.png")
    
    # Showcase window 540x400
    $outBmp = New-Object Bitmap(540, 400, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [Graphics]::FromImage($outBmp)
    $g.SmoothingMode = [SmoothingMode]::AntiAlias
    $g.InterpolationMode = [InterpolationMode]::HighQualityBicubic

    # Draw meadow stage background
    $g.DrawImage($stage, [Rectangle]::new(0, 0, 540, 400), [Rectangle]::new(0, 0, $stage.Width, $stage.Height), [GraphicsUnit]::Pixel)

    # Soft drop shadow under the pet on the grass
    $shadowBrush = New-Object SolidBrush([Color]::FromArgb(70, 20, 50, 10))
    $g.FillEllipse($shadowBrush, 170, 310, 200, 35)
    $shadowBrush.Dispose()

    # Draw pet standing in the center of the meadow
    $g.DrawImage($pet, [Rectangle]::new(145, 110, 250, 250))

    $g.Dispose()
    $outBmp.Save("c:\Users\kunde\Desktop\Crack the egg\scratch\showcase_$petId.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $outBmp.Dispose()
    $pet.Dispose()
    Write-Host "Saved showcase_$petId.png"
}
$stage.Dispose()
