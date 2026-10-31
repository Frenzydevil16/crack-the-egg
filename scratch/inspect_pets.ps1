using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg")

# Let's crop each animal in a 200x200 square without any circular mask to see the full animal and label
$crops = @(
    @{ Id="pet_dog"; Cx=387; Cy=252 },
    @{ Id="pet_cat"; Cx=514; Cy=286 },
    @{ Id="pet_mouse"; Cx=603; Cy=396 },
    @{ Id="pet_bunny"; Cx=612; Cy=538 },
    @{ Id="pet_fox"; Cx=536; Cy=654 },
    @{ Id="pet_frog"; Cx=438; Cy=724 },
    @{ Id="pet_panda"; Cx=328; Cy=724 },
    @{ Id="pet_dragon"; Cx=226; Cy=664 },
    @{ Id="pet_phoenix"; Cx=158; Cy=542 },
    @{ Id="pet_unicorn"; Cx=166; Cy=395 },
    @{ Id="pet_cosmic_companion"; Cx=260; Cy=275 }
)

foreach ($c in $crops) {
    $bmp = New-Object Bitmap(220, 220, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [Graphics]::FromImage($bmp)
    $g.DrawImage($src, [Rectangle]::new(0, 0, 220, 220), [Rectangle]::new($c.Cx - 110, $c.Cy - 110, 220, 220), [GraphicsUnit]::Pixel)
    $g.Dispose()
    $bmp.Save("c:\Users\kunde\Desktop\Crack the egg\scratch\raw_$($c.Id).png", [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Saved raw_$($c.Id).png"
}
$src.Dispose()
