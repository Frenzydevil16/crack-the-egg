Add-Type -AssemblyName System.Drawing

$petDir = "c:\Users\kunde\Desktop\Crack the egg\assets\pets"
if (-not (Test-Path $petDir)) { New-Item -ItemType Directory -Force -Path $petDir | Out-Null }

$petDefinitions = @(
    # Hund (Bello) - Warm brown dog with floppy ears & snout
    @{ Id="pet_dog"; Kind="dog"; Main=[System.Drawing.Color]::FromArgb(215, 155, 95); Sub=[System.Drawing.Color]::FromArgb(145, 90, 45); EarStyle="floppy" },
    # Katze (Mimi) - Cute ginger/creamy cat with pointy ears & whiskers
    @{ Id="pet_cat"; Kind="cat"; Main=[System.Drawing.Color]::FromArgb(255, 175, 110); Sub=[System.Drawing.Color]::FromArgb(255, 230, 200); EarStyle="pointy" },
    # Maus (Pip) - Light grey mouse with huge round pink ears
    @{ Id="pet_mouse"; Kind="mouse"; Main=[System.Drawing.Color]::FromArgb(185, 195, 205); Sub=[System.Drawing.Color]::FromArgb(255, 185, 200); EarStyle="round" },
    # Hase (Hoppel) - Pure snow white fluffy bunny with long tall ears
    @{ Id="pet_bunny"; Kind="bunny"; Main=[System.Drawing.Color]::FromArgb(245, 248, 255); Sub=[System.Drawing.Color]::FromArgb(255, 175, 195); EarStyle="long" },
    # Frosch (Quaki) - Vibrant bright green frog with big round bulb eyes on top
    @{ Id="pet_frog"; Kind="frog"; Main=[System.Drawing.Color]::FromArgb(90, 205, 80); Sub=[System.Drawing.Color]::FromArgb(210, 255, 150); EarStyle="none" },
    # Fuchs (Foxy) - Brilliant vibrant orange-red fox with white snout & dark ear tips
    @{ Id="pet_fox"; Kind="fox"; Main=[System.Drawing.Color]::FromArgb(235, 100, 35); Sub=[System.Drawing.Color]::FromArgb(255, 240, 225); EarStyle="fox" },
    # Panda (Bao) - Classic black and white panda with black ear circles & eye patches
    @{ Id="pet_panda"; Kind="panda"; Main=[System.Drawing.Color]::FromArgb(245, 245, 250); Sub=[System.Drawing.Color]::FromArgb(40, 42, 50); EarStyle="panda" },
    # Kristall-Hirsch - Pearlescent crystalline white deer with ice-blue antlers
    @{ Id="pet_crystal_stag"; Kind="stag"; Main=[System.Drawing.Color]::FromArgb(225, 240, 255); Sub=[System.Drawing.Color]::FromArgb(70, 190, 255); EarStyle="antlers" },
    # Nebel-Eule - Deep violet owl with glowing cyan starry chest & owl tufts
    @{ Id="pet_nebula_owl"; Kind="owl"; Main=[System.Drawing.Color]::FromArgb(110, 50, 165); Sub=[System.Drawing.Color]::FromArgb(195, 130, 255); EarStyle="tufts" },
    # Drache (Pyroth) - Regal golden-red dragon with horns, dragon wings & snout
    @{ Id="pet_dragon"; Kind="dragon"; Main=[System.Drawing.Color]::FromArgb(245, 180, 40); Sub=[System.Drawing.Color]::FromArgb(220, 50, 40); EarStyle="horns" },
    # Kosmischer Phönix - Magnificent cosmic galaxy bird with glowing fiery nebula aura
    @{ Id="pet_cosmic_phoenix"; Kind="phoenix"; Main=[System.Drawing.Color]::FromArgb(50, 20, 85); Sub=[System.Drawing.Color]::FromArgb(255, 60, 200); EarStyle="crest" }
)

foreach ($p in $petDefinitions) {
    $outPath = Join-Path $petDir "$($p.Id).png"
    $bmp = New-Object System.Drawing.Bitmap 256, 256
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    # 1. Ground Drop Shadow
    $shadowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(55, 0, 0, 0))
    $g.FillEllipse($shadowBrush, 48, 205, 160, 36)
    $shadowBrush.Dispose()

    # 2. Distinct Ears / Wings / Horns behind head
    $subBrush = New-Object System.Drawing.SolidBrush $p.Sub
    $mainBrush = New-Object System.Drawing.SolidBrush $p.Main
    $darkPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(230, 30, 30, 40), 6)

    switch ($p.EarStyle) {
        "floppy" { # Dog
            $g.FillEllipse($subBrush, 30, 75, 45, 90)
            $g.DrawEllipse($darkPen, 30, 75, 45, 90)
            $g.FillEllipse($subBrush, 181, 75, 45, 90)
            $g.DrawEllipse($darkPen, 181, 75, 45, 90)
        }
        "pointy" { # Cat
            $ptsL = @( (New-Object System.Drawing.Point 45, 80), (New-Object System.Drawing.Point 75, 30), (New-Object System.Drawing.Point 95, 75) )
            $ptsR = @( (New-Object System.Drawing.Point 161, 75), (New-Object System.Drawing.Point 181, 30), (New-Object System.Drawing.Point 211, 80) )
            $g.FillPolygon($mainBrush, $ptsL); $g.DrawPolygon($darkPen, $ptsL)
            $g.FillPolygon($mainBrush, $ptsR); $g.DrawPolygon($darkPen, $ptsR)
            $pinkBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 170, 190))
            $g.FillPolygon($pinkBrush, @( (New-Object System.Drawing.Point 55, 75), (New-Object System.Drawing.Point 75, 45), (New-Object System.Drawing.Point 88, 72) ))
            $g.FillPolygon($pinkBrush, @( (New-Object System.Drawing.Point 168, 72), (New-Object System.Drawing.Point 181, 45), (New-Object System.Drawing.Point 201, 75) ))
            $pinkBrush.Dispose()
        }
        "round" { # Mouse
            $g.FillEllipse($subBrush, 20, 30, 72, 72)
            $g.DrawEllipse($darkPen, 20, 30, 72, 72)
            $g.FillEllipse($subBrush, 164, 30, 72, 72)
            $g.DrawEllipse($darkPen, 164, 30, 72, 72)
        }
        "long" { # Bunny
            $g.FillEllipse($mainBrush, 65, 12, 38, 95)
            $g.DrawEllipse($darkPen, 65, 12, 38, 95)
            $g.FillEllipse($subBrush, 73, 24, 22, 72)
            $g.FillEllipse($mainBrush, 153, 12, 38, 95)
            $g.DrawEllipse($darkPen, 153, 12, 38, 95)
            $g.FillEllipse($subBrush, 161, 24, 22, 72)
        }
        "fox" { # Fox
            $ptsL = @( (New-Object System.Drawing.Point 42, 85), (New-Object System.Drawing.Point 68, 20), (New-Object System.Drawing.Point 100, 80) )
            $ptsR = @( (New-Object System.Drawing.Point 156, 80), (New-Object System.Drawing.Point 188, 20), (New-Object System.Drawing.Point 214, 85) )
            $g.FillPolygon($mainBrush, $ptsL); $g.DrawPolygon($darkPen, $ptsL)
            $g.FillPolygon($mainBrush, $ptsR); $g.DrawPolygon($darkPen, $ptsR)
            # Dark Tips
            $tipBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(40, 40, 50))
            $g.FillPolygon($tipBrush, @( (New-Object System.Drawing.Point 54, 52), (New-Object System.Drawing.Point 68, 20), (New-Object System.Drawing.Point 84, 52) ))
            $g.FillPolygon($tipBrush, @( (New-Object System.Drawing.Point 172, 52), (New-Object System.Drawing.Point 188, 20), (New-Object System.Drawing.Point 202, 52) ))
            $tipBrush.Dispose()
        }
        "panda" { # Panda
            $g.FillEllipse($subBrush, 38, 48, 52, 52)
            $g.DrawEllipse($darkPen, 38, 48, 52, 52)
            $g.FillEllipse($subBrush, 166, 48, 52, 52)
            $g.DrawEllipse($darkPen, 166, 48, 52, 52)
        }
        "antlers" { # Stag
            $antlerPen = New-Object System.Drawing.Pen $p.Sub, 8
            $g.DrawLine($antlerPen, 80, 75, 45, 20)
            $g.DrawLine($antlerPen, 60, 45, 30, 40)
            $g.DrawLine($antlerPen, 176, 75, 211, 20)
            $g.DrawLine($antlerPen, 196, 45, 226, 40)
            $antlerPen.Dispose()
        }
        "tufts" { # Owl
            $g.FillPolygon($mainBrush, @( (New-Object System.Drawing.Point 55, 75), (New-Object System.Drawing.Point 40, 35), (New-Object System.Drawing.Point 90, 70) ))
            $g.FillPolygon($mainBrush, @( (New-Object System.Drawing.Point 201, 75), (New-Object System.Drawing.Point 216, 35), (New-Object System.Drawing.Point 166, 70) ))
        }
        "horns" { # Dragon
            $hornBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(235, 60, 50))
            $g.FillPolygon($hornBrush, @( (New-Object System.Drawing.Point 55, 80), (New-Object System.Drawing.Point 30, 25), (New-Object System.Drawing.Point 90, 68) ))
            $g.FillPolygon($hornBrush, @( (New-Object System.Drawing.Point 201, 80), (New-Object System.Drawing.Point 226, 25), (New-Object System.Drawing.Point 166, 68) ))
            # Small Dragon Wings
            $g.FillPolygon($hornBrush, @( (New-Object System.Drawing.Point 25, 120), (New-Object System.Drawing.Point 5, 85), (New-Object System.Drawing.Point 40, 145) ))
            $g.FillPolygon($hornBrush, @( (New-Object System.Drawing.Point 231, 120), (New-Object System.Drawing.Point 251, 85), (New-Object System.Drawing.Point 216, 145) ))
            $hornBrush.Dispose()
        }
        "crest" { # Phoenix
            $auraPen = New-Object System.Drawing.Pen $p.Sub, 10
            $g.DrawArc($auraPen, 18, 18, 220, 220, 0, 360)
            $auraPen.Dispose()
            $g.FillPolygon($subBrush, @( (New-Object System.Drawing.Point 128, 15), (New-Object System.Drawing.Point 112, 60), (New-Object System.Drawing.Point 144, 60) ))
            $g.FillPolygon($subBrush, @( (New-Object System.Drawing.Point 96, 28), (New-Object System.Drawing.Point 90, 68), (New-Object System.Drawing.Point 118, 68) ))
            $g.FillPolygon($subBrush, @( (New-Object System.Drawing.Point 160, 28), (New-Object System.Drawing.Point 138, 68), (New-Object System.Drawing.Point 166, 68) ))
        }
    }

    # 3. Main Head / Body (Chubby Cute Shape)
    if ($p.Kind -eq "frog") {
        # Frog Eye Bulbs on top
        $g.FillEllipse($mainBrush, 50, 48, 56, 56)
        $g.DrawEllipse($darkPen, 50, 48, 56, 56)
        $g.FillEllipse($mainBrush, 150, 48, 56, 56)
        $g.DrawEllipse($darkPen, 150, 48, 56, 56)
    }

    $g.FillEllipse($mainBrush, 38, 62, 180, 145)
    $g.DrawEllipse($darkPen, 38, 62, 180, 145)

    # 4. Belly / Snout / Patches
    if ($p.Kind -eq "dog" -or $p.Kind -eq "fox" -or $p.Kind -eq "cat") {
        $g.FillEllipse($subBrush, 90, 125, 76, 54)
    } elseif ($p.Kind -eq "panda") {
        # Eye Patches
        $g.FillEllipse($subBrush, 68, 102, 42, 52)
        $g.FillEllipse($subBrush, 146, 102, 42, 52)
    } elseif ($p.Kind -eq "owl" -or $p.Kind -eq "phoenix") {
        $g.FillEllipse($subBrush, 82, 135, 92, 65)
    }

    # 5. Glossy Eyes & Highlights
    $eyeBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(25, 20, 30))
    $hlBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)

    if ($p.Kind -eq "frog") {
        $g.FillEllipse($eyeBrush, 64, 62, 28, 34); $g.FillEllipse($hlBrush, 68, 66, 12, 14)
        $g.FillEllipse($eyeBrush, 164, 62, 28, 34); $g.FillEllipse($hlBrush, 168, 66, 12, 14)
    } elseif ($p.Kind -eq "panda") {
        $g.FillEllipse($hlBrush, 78, 114, 22, 26); $g.FillEllipse($eyeBrush, 82, 118, 14, 18)
        $g.FillEllipse($hlBrush, 156, 114, 22, 26); $g.FillEllipse($eyeBrush, 160, 118, 14, 18)
    } else {
        $g.FillEllipse($eyeBrush, 80, 110, 24, 32); $g.FillEllipse($hlBrush, 84, 114, 10, 14)
        $g.FillEllipse($eyeBrush, 152, 110, 24, 32); $g.FillEllipse($hlBrush, 156, 114, 10, 14)
    }
    $eyeBrush.Dispose(); $hlBrush.Dispose()

    # 6. Cute Nose / Beak & Smile
    $mouthPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(220, 20, 20, 30), 4)
    $noseBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(40, 30, 45))

    if ($p.Kind -eq "dog" -or $p.Kind -eq "fox" -or $p.Kind -eq "cat" -or $p.Kind -eq "bunny" -or $p.Kind -eq "mouse") {
        $g.FillEllipse($noseBrush, 120, 132, 16, 12)
        $g.DrawArc($mouthPen, 112, 138, 16, 14, 0, 180)
        $g.DrawArc($mouthPen, 128, 138, 16, 14, 0, 180)
    } elseif ($p.Kind -eq "frog") {
        $g.DrawArc($mouthPen, 96, 130, 64, 30, 20, 140)
    } elseif ($p.Kind -eq "owl" -or $p.Kind -eq "phoenix") {
        $beakBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 175, 40))
        $g.FillPolygon($beakBrush, @( (New-Object System.Drawing.Point 128, 146), (New-Object System.Drawing.Point 120, 130), (New-Object System.Drawing.Point 136, 130) ))
        $beakBrush.Dispose()
    } else {
        $g.FillEllipse($noseBrush, 122, 134, 12, 10)
        $g.DrawArc($mouthPen, 114, 140, 28, 14, 20, 140)
    }
    $mouthPen.Dispose(); $noseBrush.Dispose()

    # 7. Rosy Cheeks
    $blushBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(95, 255, 100, 130))
    $g.FillEllipse($blushBrush, 62, 135, 22, 12)
    $g.FillEllipse($blushBrush, 172, 135, 22, 12)
    $blushBrush.Dispose()

    $mainBrush.Dispose(); $subBrush.Dispose(); $darkPen.Dispose()
    $g.Dispose()
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Write-Host "Created all distinct Pet Animal PNGs successfully in $petDir"
