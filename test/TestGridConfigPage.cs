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
            var settings = new GridConfigSettings();
            var ctrl = new GridConfigPagePageControl(settings);
            var window = new Window
            {
                Title = "Test GridConfigPage",
                Content = ctrl,
                SizeToContent = SizeToContent.WidthAndHeight,
                ResizeMode = ResizeMode.CanMinimize
            };
            var app = new Application();
            app.Run(window);
        }
    }
}
