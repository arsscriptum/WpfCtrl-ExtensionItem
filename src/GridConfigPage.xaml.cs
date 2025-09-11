using System;
using System.Diagnostics;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Navigation;
using System.Collections.Generic;
using System.Text;
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
            dialog.Filter = "Log files (*.log)|*.log|All files (*.*)|*.*";
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
        }


        private void btnRestoreDefaultSettings_Click(object sender, RoutedEventArgs e)
        {
            // _settings.ResetSettings();
        }

        private void UserControl_LostKeyboardFocus(object sender, KeyboardFocusChangedEventArgs e)
        {
            // Find all TextBoxes in this control force the Text bindings to fire to make sure all changes have been saved.
            // This is required because if the user changes some text, then clicks on the Options Window's OK button, it closes
            // the window before the TextBox's Text bindings fire, so the new value will not be saved.
            /* foreach (var textBox in DiffAllFilesHelper.FindVisualChildren<TextBox>(sender as UserControl))
             {
                 var bindingExpression = textBox.GetBindingExpression(TextBox.TextProperty);
                 if (bindingExpression != null) bindingExpression.UpdateSource();
             }*/
        }

        private void TabControl_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }
    }
}