using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Collections.Generic;

public class PerfectFoxExtractor {
    public static void Extract(string srcPath, string outPath) {
        using (Bitmap src = new Bitmap(srcPath)) {
            double cx = 387.0;
            double cy = 500.0;
            double segAngle = 2.0 * Math.PI / 11.0;
            // Fox is segment 4: center angle = 4 * segAngle = 130.9 deg
            double centerAngle = 4.0 * segAngle;

            // Fox center on wheel
            double rCenter = 240.0;
            int scx = (int)(cx + rCenter * Math.Sin(centerAngle));
            int scy = (int)(cy - rCenter * Math.Cos(centerAngle));

            int S = 180;
            int half = S / 2;

            using (Bitmap result = new Bitmap(S, S, PixelFormat.Format32bppArgb)) {
                for (int y = 0; y < S; y++) {
                    int sy = scy - half + y;
                    for (int x = 0; x < S; x++) {
                        int sx = scx - half + x;
                        if (sx < 0 || sx >= src.Width || sy < 0 || sy >= src.Height) {
                            result.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            continue;
                        }

                        double dx = sx - cx;
                        double dy = sy - cy;
                        double r = Math.Sqrt(dx * dx + dy * dy);
                        double angle = Math.Atan2(dx, -dy);
                        if (angle < 0) angle += 2.0 * Math.PI;

                        double diff = angle - centerAngle;
                        while (diff > Math.PI) diff -= 2.0 * Math.PI;
                        while (diff < -Math.PI) diff += 2.0 * Math.PI;

                        // 1. Angular wedge constraint: strictly inside Fox's wedge
                        // Fox wedge is 32.72 degrees wide (half is 16.36 degrees)
                        // Fox animal itself is within +/- 11 degrees of center ray!
                        if (Math.Abs(diff) > (segAngle * 0.36)) {
                            result.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            continue;
                        }

                        // 2. Radial constraint: Fox is strictly between r = 180 and r = 310
                        if (r < 185.0 || r > 310.0) {
                            result.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            continue;
                        }

                        Color c = src.GetPixel(sx, sy);

                        // 3. Remove wedge orange-red background:
                        // Background has high Red (>190) and low Blue (<60) and G in [50..130]
                        // Fox fur has either:
                        // - White chest/tail: R>210, G>210, B>210
                        // - Orange coat: R>230, G in [130..190], B in [50..120]
                        // - Black eyes/ear tips: R<70, G<70, B<70
                        // Background wedge is: R > 200, G < 125, B < 45 (or B < 35)
                        bool isWedgeBg = (c.R > 180 && c.G < 125 && c.B < 48 && (c.R - c.G > 75));
                        // Dark shadow/label at bottom
                        bool isDarkLabel = (c.R < 110 && c.G < 70 && c.B < 40);

                        if (isWedgeBg || isDarkLabel) {
                            result.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                        } else {
                            result.SetPixel(x, y, c);
                        }
                    }
                }

                // Flood-fill / clean stray pixels and anti-alias
                result.Save(outPath, ImageFormat.Png);
            }
        }
    }
}
