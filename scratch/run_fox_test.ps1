Add-Type -TypeDefinition (Get-Content "c:\Users\kunde\Desktop\Crack the egg\scratch\PerfectFoxExtractor.cs" -Raw) -ReferencedAssemblies System.Drawing
[PerfectFoxExtractor]::Extract(
    "C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg",
    "c:\Users\kunde\Desktop\Crack the egg\scratch\fox_clean_test.png"
)
Write-Host "Saved fox_clean_test.png"
