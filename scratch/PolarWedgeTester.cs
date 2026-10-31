using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public class PolarWedgeTester {
    public static void TestSegment(string srcPath, int segIndex, string outPath) {
        using (Bitmap src = new Bitmap(srcPath)) {
            double cx = 387.0;
            double cy = 500.0;
            double segAngle = 2.0 * Math.PI / 11.0;
            // Segment 0 (Dog) is at top: angle [-segAngle/2, +segAngle/2]
            double centerAngle = segIndex * segAngle;

            int W = src.Width;
            int H = src.Height;

            // Crop a 240x240 image centered around the segment's visual center (r ~ 240 px)
            double rCenter = 240.0;
            int scx = (int)(cx + rCenter * Math.Sin(centerAngle));
            int scy = (int)(cy - rCenter * Math.Cos(centerAngle));

            int cropSize = 220;
            int half = cropSize / 2;

            using (Bitmap crop = new Bitmap(cropSize, cropSize, PixelFormat.Format32bppArgb)) {
                for (int y = 0; y < cropSize; y++) {
                    int sy = scy - half + y;
                    for (int x = 0; x < cropSize; x++) {
                        int sx = scx - half + x;
                        if (sx < 0 || sx >= W || sy < 0 || sy >= H) {
                            crop.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            continue;
                        }

                        double dx = sx - cx;
                        double dy = sy - cy;
                        double r = Math.Sqrt(dx * dx + dy * dy);
                        // Angle from top, clockwise in [0, 2*PI)
                        double angle = Math.Atan2(dx, -dy);
                        if (angle < 0) angle += 2.0 * Math.PI;

                        // Difference from centerAngle
                        double diff = angle - centerAngle;
                        while (diff > Math.PI) diff -= 2.0 * Math.PI;
                        while (diff < -Math.PI) diff += 2.0 * Math.PI;

                        // Check if strictly inside this segment's wedge:
                        // Each wedge is segAngle = 32.72 degrees wide (half is 16.36 degrees)
                        if (Math.Abs(diff) > (segAngle * 0.485)) {
                            // Outside wedge! 100% transparent (no neighbor bleed!)
                            crop.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            continue;
                        }

                        // Check if outside wheel disc:
                        if (r > 324.0 || r < 120.0) {
                            crop.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            continue;
                        }

                        Color c = src.GetPixel(sx, sy);
                        crop.SetPixel(x, y, c);
                    }
                }
                crop.Save(outPath, ImageFormat.Png);
            }
        }
    }
}
