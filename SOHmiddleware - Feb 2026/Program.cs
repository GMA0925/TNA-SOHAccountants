using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SOHmiddleware
{
    internal static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            try
            {
                // attempt to initialize SQLitePCL (will throw if native binary missing/mismatched)
                //SQLitePCL.Batteries_V2.Init();
            }
            catch (DllNotFoundException dllEx)
            {
                // Show helpful diagnostic information to locate native DLL / architecture mismatch
                string bin = AppDomain.CurrentDomain.BaseDirectory;
                string files = string.Join(Environment.NewLine, Directory.GetFiles(bin).Select(Path.GetFileName));
                string arch = Environment.Is64BitProcess ? "x64 process" : "x86 process";
                MessageBox.Show(
                    $"Failed to load native SQLite library: {dllEx.Message}{Environment.NewLine}{Environment.NewLine}" +
                    $"App folder: {bin}{Environment.NewLine}" +
                    $"Process architecture: {arch}{Environment.NewLine}{Environment.NewLine}" +
                    $"Files in folder:{Environment.NewLine}{files}",
                    "Startup error - missing native SQLite",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error
                );
                // Continue startup without Batteries init so the UI loads and you can inspect files
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Unexpected error initializing SQLite provider: {ex.Message}", "Startup error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }
}
