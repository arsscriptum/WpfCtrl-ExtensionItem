using System;
using System.Diagnostics;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Navigation;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Windows.Forms; // WinForms dialog, add reference if needed
namespace WebExtensionPack.Controls
{
    /// <summary>
    /// Interaction logic for GridConfigPagePageControl.xaml
    /// </summary>
    public partial class GridConfigPagePageControl : System.Windows.Controls.UserControl
    {
        /// <summary>
        /// A handle to the Settings instance that this control is bound to.
        /// </summary>
        private GridConfigSettings _settings = null;


        private void BrowseLogFilePath_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new SaveFileDialog();
            //dialog.Filter = "Log files (*.log)|*.log|All files (*.*)|*.*";
            if (dialog.ShowDialog() == DialogResult.OK)
                _settings.LogFilePath = dialog.FileName;
        }

        private void BrowseTemporaryDirectory_Click(object sender, RoutedEventArgs e)
        {
            using (var dialog = new FolderBrowserDialog())
            {
                dialog.Description = "Select Temporary Directory";
                if (dialog.ShowDialog() == DialogResult.OK)
                    _settings.TemporaryDirectory = dialog.SelectedPath;
            }
        }

        private void BrowseFinalDestinationDirectory_Click(object sender, RoutedEventArgs e)
        {
            using (var dialog = new FolderBrowserDialog())
            {
                dialog.Description = "Select Final Destination Directory";
                if (dialog.ShowDialog() == DialogResult.OK)
                    _settings.FinalDestinationDirectory = dialog.SelectedPath;
            }
        }
        public GridConfigPagePageControl(GridConfigSettings settings)
        {
            InitializeComponent();
            _settings = settings;
            this.DataContext = _settings;

            // Set TemporaryDirectory = FinalDestinationDirectory if not set
            if (string.IsNullOrWhiteSpace(_settings.TemporaryDirectory) && !string.IsNullOrWhiteSpace(_settings.FinalDestinationDirectory))
            {
                _settings.TemporaryDirectory = _settings.FinalDestinationDirectory;
            }
        }


        private void btnRestoreDefaultSettings_Click(object sender, RoutedEventArgs e)
        {
            _settings.ResetSettings();
        }


        private void UserControl_LostKeyboardFocus(object sender, KeyboardFocusChangedEventArgs e)
        {
            // For every TextBox in this control, update the source of its Text binding
            foreach (var textBox in FindVisualChildren<System.Windows.Controls.TextBox>(this))
            {
                var bindingExpression = textBox.GetBindingExpression(System.Windows.Controls.TextBox.TextProperty);
                if (bindingExpression != null)
                    bindingExpression.UpdateSource();
            }
        }

        // Utility function to find all children of a certain type
        public static IEnumerable<T> FindVisualChildren<T>(DependencyObject depObj) where T : DependencyObject
        {
            if (depObj == null)
                yield break;
            for (int i = 0; i < System.Windows.Media.VisualTreeHelper.GetChildrenCount(depObj); i++)
            {
                DependencyObject child = System.Windows.Media.VisualTreeHelper.GetChild(depObj, i);
                if (child != null && child is T)
                    yield return (T)child;
                foreach (T childOfChild in FindVisualChildren<T>(child))
                    yield return childOfChild;
            }
        }


        private void TabControl_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }

        private void btnSave_Click(object sender, RoutedEventArgs e)
        {
            if (this.DataContext is GridConfigSettings settings)
            {
                settings.SaveToFile(); // This saves to settings.json in your app folder
            }
            // Save logic here
            var win = Window.GetWindow(this);
            if (win != null)
            {
                win.Close();
            }
        }

        private void btnCancel_Click(object sender, RoutedEventArgs e)
        {
            var win = Window.GetWindow(this);
            if (win != null)
            {
                win.Close();
            }
        }

        private void textboxCtrlTmpDirectory_TargetUpdated(object sender, DataTransferEventArgs e)
        {

        }
    }
}