using namespace System.Drawing
using namespace System.Drawing.Drawing2D
Add-Type -AssemblyName System.Drawing

$disc = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\scratch\wheel_disc_mitdrehen.png")
$frame = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\scratch\wheel_frame_ui_mitdrehen.png")

foreach ($angle in @(0, 65, 180)) {
    $outBmp = New-Object Bitmap(1024, 1024, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [Graphics]::FromImage($outBmp)
    $g.SmoothingMode = [SmoothingMode]::AntiAlias
    $g.InterpolationMode = [InterpolationMode]::HighQualityBicubic

    # Dark background behind wheel
    $g.Clear([Color]::FromArgb(255, 15, 18, 40))

    # Draw rotated disc: center at (387, 500)
    $state = $g.Save()
    $g.TranslateTransform(387.0, 500.0)
    $g.RotateTransform($angle)
    $g.DrawImage($disc, -338, -338, 676, 676)
    $g.Restore($state)

    # Draw stationary frame
    $g.DrawImage($frame, 0, 0, 1024, 1024)

    $g.Dispose()
    $outBmp.Save("c:\Users\kunde\Desktop\Crack the egg\scratch\test_mitdrehen_$angle.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $outBmp.Dispose()
    Write-Host "Saved test_mitdrehen_$angle.png"
}
$disc.Dispose()
$frame.Dispose()
