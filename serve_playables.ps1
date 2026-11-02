# YouTube Playables Local Test Server with Gzip & Brotli compression support
param(
    [int]$Port = 8080,
    [string]$Root = "build"
)

Add-Type -AssemblyName System.IO.Compression

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
} catch {
    Write-Host "Fehler beim Starten des Servers auf $prefix. Versuche Port $($Port + 1)..." -ForegroundColor Red
    $Port += 1
    $prefix = "http://localhost:$Port/"
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($prefix)
    $listener.Start()
}

Write-Host "==========================================================" -ForegroundColor Green
Write-Host " YouTube Playables Test Server mit GZIP-Kompression aktiv! " -ForegroundColor Green
Write-Host " URL: $prefix" -ForegroundColor Cyan
Write-Host " Ordner: $Root" -ForegroundColor Yellow
Write-Host " Drücke Strg+C zum Beenden." -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Green

$mimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".js"   = "application/javascript"
    ".wasm" = "application/wasm"
    ".pck"  = "application/octet-stream"
    ".png"  = "image/png"
    ".svg"  = "image/svg+xml"
    ".json" = "application/json"
    ".css"  = "text/css"
}

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $req = $context.Request
        $res = $context.Response

        $urlPath = $req.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrEmpty($urlPath) -or $urlPath -eq "/") {
            $urlPath = "index.html"
        }

        $filePath = Join-Path (Resolve-Path $Root) $urlPath

        # Security check: prevent directory traversal
        if (-not (Test-Path $filePath -PathType Leaf)) {
            $res.StatusCode = 404
            $buffer = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $res.OutputStream.Write($buffer, 0, $buffer.Length)
            $res.Close()
            continue
        }

        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
        $res.ContentType = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }
        
        # YouTube Playables & WebAssembly Headers
        $res.AddHeader("Cross-Origin-Opener-Policy", "same-origin")
        $res.AddHeader("Cross-Origin-Embedder-Policy", "require-corp")
        $res.AddHeader("Access-Control-Allow-Origin", "*")

        $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
        $acceptEncoding = $req.Headers["Accept-Encoding"]

        # Compress if client accepts gzip and file is compressable (> 1KB)
        if ($acceptEncoding -and $acceptEncoding.Contains("gzip") -and $fileBytes.Length -gt 1024) {
            $res.AddHeader("Content-Encoding", "gzip")
            $ms = New-Object System.IO.MemoryStream
            $gzip = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Compress)
            $gzip.Write($fileBytes, 0, $fileBytes.Length)
            $gzip.Close()
            $outBytes = $ms.ToArray()
            $ms.Close()
            
            $rawMB = [math]::Round($fileBytes.Length / 1MB, 2)
            $compMB = [math]::Round($outBytes.Length / 1MB, 2)
            Write-Host "[GZIP] $urlPath : $rawMB MB -> $compMB MB" -ForegroundColor DarkGreen
        } else {
            $outBytes = $fileBytes
            $rawMB = [math]::Round($fileBytes.Length / 1MB, 2)
            Write-Host "[RAW]  $urlPath : $rawMB MB" -ForegroundColor Gray
        }

        $res.ContentLength64 = $outBytes.Length
        $res.OutputStream.Write($outBytes, 0, $outBytes.Length)
        $res.Close()
    }
} finally {
    $listener.Stop()
}
