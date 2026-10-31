param(
    [int]$Port = 8085,
    [string]$Directory = "build"
)

$targetDir = (Resolve-Path $Directory).Path
Write-Host "Serving files from: $targetDir"
Write-Host "Listening on: http://localhost:$Port/"

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Prefixes.Add("http://127.0.0.1:$Port/")

try {
    $listener.Start()
} catch {
    Write-Error "Failed to start HttpListener: $_"
    exit 1
}

$mimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".wasm" = "application/wasm"
    ".pck"  = "application/octet-stream"
    ".png"  = "image/png"
    ".svg"  = "image/svg+xml"
    ".json" = "application/json"
}

$csp = "default-src 'none'; script-src 'report-sample' 'self' 'unsafe-eval' 'unsafe-inline' blob: https://www.youtube.com/game_api/v0 https://www.youtube.com/game_api/v0/ https://www.youtube.com/game_api/v1 https://www.youtube.com/game_api/v1/; object-src 'none'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; img-src 'self' blob: data:; media-src 'self' blob:; font-src 'self' data: https://fonts.googleapis.com https://fonts.gstatic.com; connect-src 'self' blob: data:; sandbox allow-pointer-lock allow-same-origin allow-scripts; base-uri 'self'; manifest-src 'self'; worker-src 'self' blob:"

Write-Host "Server started. Press Ctrl+C to stop."

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $urlPath = $request.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrEmpty($urlPath) -or $urlPath -eq "/") {
            $urlPath = "index.html"
        }

        # Prevent directory traversal
        $filePath = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($targetDir, $urlPath))
        if (-not $filePath.StartsWith($targetDir, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path $filePath -PathType Leaf)) {
            $response.StatusCode = 404
            $errBytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $response.ContentLength64 = $errBytes.Length
            if ($request.HttpMethod -ne "HEAD") {
                $response.OutputStream.Write($errBytes, 0, $errBytes.Length)
            }
            $response.Close()
            continue
        }

        $ext = [System.IO.Path]::GetExtension($filePath).ToLowerInvariant()
        $mime = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }
        $response.ContentType = $mime

        # YouTube CSP and CORS headers
        $response.Headers.Add("Access-Control-Allow-Origin", "*")
        $response.Headers.Add("Cross-Origin-Resource-Policy", "cross-origin")
        if ($ext -eq ".html") {
            $response.Headers.Add("Content-Security-Policy", $csp)
        }

        $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
        $acceptEncoding = $request.Headers["Accept-Encoding"]

        # Support GZip compression
        $isGzip = $acceptEncoding -and $acceptEncoding.Contains("gzip") -and $fileBytes.Length -gt 512
        if ($isGzip) {
            $response.Headers.Add("Content-Encoding", "gzip")
            $ms = New-Object System.IO.MemoryStream
            $gzip = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Compress)
            $gzip.Write($fileBytes, 0, $fileBytes.Length)
            $gzip.Close()
            $outBytes = $ms.ToArray()
        } else {
            $outBytes = $fileBytes
        }

        $response.ContentLength64 = $outBytes.Length
        if ($request.HttpMethod -ne "HEAD") {
            $response.OutputStream.Write($outBytes, 0, $outBytes.Length)
        }
        $response.Close()
    } catch {
        if (-not $listener.IsListening) { break }
    }
}
