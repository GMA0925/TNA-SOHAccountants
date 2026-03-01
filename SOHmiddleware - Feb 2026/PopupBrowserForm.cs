using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Web.WebView2.Core;
using Microsoft.Web.WebView2.WinForms;

namespace SOHmiddleware
{
    // Simple popup form that hosts its own WebView2 and uses the provided CoreWebView2Environment.
    public partial class PopupBrowserForm : Form
    {
        private readonly CoreWebView2Environment _env;
        private readonly string _url;
        private readonly string _username;
        private readonly string _password;
        private WebView2 _webView;

        public PopupBrowserForm(CoreWebView2Environment env, string url, string username = null, string password = null)
        {
            _env = env;
            _url = url;
            _username = username;
            _password = password;

            Initialize();
        }

        private void Initialize()
        {
            _webView = new WebView2
            {
                Dock = DockStyle.Fill
            };
            Controls.Add(_webView);
            Load += PopupBrowserForm_Load;
        }

        private async void PopupBrowserForm_Load(object sender, EventArgs e)
        {
            try
            {
                if (_env != null)
                    await _webView.EnsureCoreWebView2Async(_env);
                else
                    await _webView.EnsureCoreWebView2Async(null);

                // Optionally open DevTools for debugging during development:
                // _webView.CoreWebView2.OpenDevToolsWindow();

                if (!string.IsNullOrEmpty(_username) || !string.IsNullOrEmpty(_password))
                {
                    // attach navigation handler that injects creds once
                    _webView.NavigationCompleted += Popup_NavigationCompleted;
                }

                _webView.Source = new Uri(_url);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Popup WebView2 init failed: " + ex.Message);
            }
        }

        private async void Popup_NavigationCompleted(object sender, CoreWebView2NavigationCompletedEventArgs e)
        {
            // detach immediately to run one-time
            _webView.NavigationCompleted -= Popup_NavigationCompleted;

            if (e == null || !e.IsSuccess) return;

            try
            {
                string userEncoded = Uri.EscapeDataString(_username ?? string.Empty);
                string passEncoded = Uri.EscapeDataString(_password ?? string.Empty);

                string script =
                    "(function() {" +
                    " try { var user = decodeURIComponent('" + userEncoded + "'); var pass = decodeURIComponent('" + passEncoded + "'); " +
                    " var u = document.querySelector('input[type=text], input[type=email], input[name*=user], input[id*=user]');" +
                    " var p = document.querySelector('input[type=password]');" +
                    " function set(el, v) { if (!el) return false; el.focus && el.focus(); el.value = v; el.dispatchEvent(new Event('input', {bubbles:true})); el.dispatchEvent(new Event('change', {bubbles:true})); return true; }" +
                    " var didU = set(u, user); var didP = set(p, pass);" +
                    " var btn = document.querySelector('button[type=submit], input[type=submit]'); if (btn) btn.click(); else { var f = (p && p.form) || (u && u.form); if (f) { try { f.submit(); } catch(e){} } }" +
                    " return { setUser: !!didU, setPass: !!didP };" +
                    " } catch (err) { return { error: err && err.message ? err.message : String(err) }; } })();";

                await _webView.ExecuteScriptAsync(script);
            }
            catch
            {
                // ignore
            }
        }

        private void PopupBrowserForm_Load_1(object sender, EventArgs e)
        {

        }

        //private void InitializeComponent()
        //{
        //    this.SuspendLayout();
        //    // 
        //    // PopupBrowserForm
        //    // 
        //    this.ClientSize = new System.Drawing.Size(284, 261);
        //    this.Name = "PopupBrowserForm";
        //    this.Text = "SOH-Employee Enrollment";
        //    this.ResumeLayout(false);

        //}
    }
}
