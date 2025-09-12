using System;
using System.Windows;
using WebExtensionPack.Controls;

namespace TestHarness
{
    public class Program : Application
    {
        [STAThread]
        public static void Main()
        {
            var settings = GridConfigSettings.LoadFromFile();
            var ctrl = new GridConfigPagePageControl(settings);
            
            var window = new Window
            {
                Title = "Test GridConfigPage",
                Content = ctrl,
                Width = 500,
                Height = 400
            };
            var app = new Application();
            app.Run(window);
        }
    }
}
