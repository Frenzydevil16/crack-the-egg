using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg")

# Print the 11 animals and their label positions
# Dog: Top center (x ~ 387, y ~ 260)
# Cat: Upper right (x ~ 515, y ~ 290)
# Mouse: Right upper (x ~ 605, y ~ 400)
# Bunny: Right lower (x ~ 615, y ~ 545)
# Fox: Lower right (x ~ 535, y ~ 660)
# Frog: Bottom right (x ~ 438, y ~ 725)
# Panda: Bottom left (x ~ 328, y ~ 725)
# Dragon: Lower left (x ~ 226, y ~ 660)
# Phoenix: Left lower (x ~ 158, y ~ 540)
# Unicorn: Left upper (x ~ 166, y ~ 395)
# Cosmic Companion: Upper left (x ~ 260, y ~ 275)

Write-Host "Done setting up coordinates check."
$src.Dispose()
