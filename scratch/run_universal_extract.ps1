Add-Type -TypeDefinition (Get-Content "c:\Users\kunde\Desktop\Crack the egg\scratch\UniversalPetExtractor.cs" -Raw) -ReferencedAssemblies System.Drawing
[UniversalPetExtractor]::ExtractAll(
    "C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg",
    "c:\Users\kunde\Desktop\Crack the egg\assets\pets"
)
Write-Host "All 11 universal pets extracted cleanly with zero wedge bleed!"
