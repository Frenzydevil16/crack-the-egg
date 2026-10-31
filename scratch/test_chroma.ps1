using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$code = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;

public class ChromaTest {
    public static void RemoveBackground(string inPath, string outPath) {
        using (Bitmap bmp = new Bitmap(inPath)) {
            int W = bmp.Width;
            int H = bmp.Height;

            // Sample background colors from the 4 corners
            Color cTL = bmp.GetPixel(4, 4);
            Color cTR = bmp.GetPixel(W - 5, 4);
            Color cBL = bmp.GetPixel(4, H - 5);
            Color cBR = bmp.GetPixel(W - 5, H - 5);

            // Let's do a flood-fill from edges for pixels matching the background hue
            bool[,] isBg = new bool[W, H];
            Queue<Point> q = new Queue<Point>();

            // Enqueue border pixels that match background
            for (int x = 0; x < W; x++) {
                TryEnqueue(bmp, 0, x, 0, isBg, q);
                TryEnqueue(bmp, 0, x, H - 1, isBg, q);
            }
            for (int y = 0; y < H; y++) {
                TryEnqueue(bmp, 0, 0, y, isBg, q);
                TryEnqueue(bmp, 0, W - 1, y, isBg, q);
            }

            int[] dx = { -1, 1, 0, 0, -1, 1, -1, 1 };
            int[] dy = { 0, 0, -1, 1, -1, -1, 1, 1 };

            while (q.Count > 0) {
                Point p = q.Dequeue();
                Color cp = bmp.GetPixel(p.X, p.Y);
                for (int d = 0; d < 8; d++) {
                    int nx = p.X + dx[d];
                    int ny = p.Y + dy[d];
                    if (nx >= 0 && nx < W && ny >= 0 && ny < H && !isBg[nx, ny]) {
                        Color cn = bmp.GetPixel(nx, ny);
                        // Check if cn is background-like (similar hue/chroma to cp or border)
                        if (IsBackgroundSimilar(cn, cp)) {
                            isBg[nx, ny] = true;
                            q.Enqueue(new Point(nx, ny));
                        }
                    }
                }
            }

            using (Bitmap outBmp = new Bitmap(W, H, PixelFormat.Format32bppArgb)) {
                for (int y = 0; y < H; y++) {
                    for (int x = 0; x < W; x++) {
                        if (isBg[x, y]) {
                            outBmp.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                        } else {
                            Color c = bmp.GetPixel(x, y);
                            // Check if near border of isBg for soft antialiasing
                            int bgNeighbors = 0;
                            for (int d = 0; d < 8; d++) {
                                int nx = x + dx[d];
                                int ny = y + dy[d];
                                if (nx >= 0 && nx < W && ny >= 0 && ny < H && isBg[nx, ny]) bgNeighbors++;
                            }
                            int a = 255;
                            if (bgNeighbors > 3) a = 160;
                            else if (bgNeighbors > 1) a = 210;
                            outBmp.SetPixel(x, y, Color.FromArgb(a, c.R, c.G, c.B));
                        }
                    }
                }
                outBmp.Save(outPath, ImageFormat.Png);
            }
        }
    }

    private static void TryEnqueue(Bitmap bmp, int seed, int x, int y, bool[,] isBg, Queue<Point> q) {
        Color c = bmp.GetPixel(x, y);
        // If not white/fur, it's wedge background or label
        // For mouse, background is cyan/blue (B > 140, G > 100, R < 100) or dark label
        if ((c.B > 130 && c.R < 120) || (c.R < 60 && c.G < 60 && c.B < 120)) {
            isBg[x, y] = true;
            q.Enqueue(new Point(x, y));
        }
    }

    private static bool IsBackgroundSimilar(Color c, Color refCol) {
        // Background is cyan/blue wedge:
        bool isCyanWedge = (c.B > 120 && c.R < 110);
        // Or dark label:
        bool isDarkLabel = (c.R < 65 && c.G < 65 && c.B < 130);
        return isCyanWedge || isDarkLabel;
    }
}
"@
Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing
[ChromaTest]::RemoveBackground(
    "c:\Users\kunde\Desktop\Crack the egg\scratch\box_pet_mouse.png",
    "c:\Users\kunde\Desktop\Crack the egg\scratch\test_clean_mouse.png"
)
Write-Host "Done test_clean_mouse.png"
