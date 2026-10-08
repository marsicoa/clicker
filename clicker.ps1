$url = "https://www.google.com"
Start-Process "chrome.exe" $url

Start-Sleep -Seconds 3

$scSource = @'
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
public class Clicker
{
    [StructLayout(LayoutKind.Sequential)]
    struct INPUT
    {
        public int type;
        public MOUSEINPUT mi;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct MOUSEINPUT
    {
        public int dx;
        public int dy;
        public int mouseData;
        public int dwFlags;
        public int time;
        public IntPtr dwExtraInfo;
    }

    const int MOUSEEVENTF_MOVED      = 0x0001;
    const int MOUSEEVENTF_LEFTDOWN   = 0x0002;
    const int MOUSEEVENTF_LEFTUP     = 0x0004;
    const int MOUSEEVENTF_ABSOLUTE   = 0x8000;

    [System.Runtime.InteropServices.DllImport("user32.dll")]
    extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

    public static void LeftClickAtPoint(int x, int y)
    {
        INPUT[] input = new INPUT[3];
        input[0].mi.dx = x * (65535 / System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width);
        input[0].mi.dy = y * (65535 / System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height);
        input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
        input[1].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
        input[2].mi.dwFlags = MOUSEEVENTF_LEFTUP;
        SendInput(3, input, Marshal.SizeOf(input[0]));
    }
}
'@

Add-Type -TypeDefinition $scSource -ReferencedAssemblies System.Windows.Forms,System.Drawing

[Clicker]::LeftClickAtPoint(500, 300)
