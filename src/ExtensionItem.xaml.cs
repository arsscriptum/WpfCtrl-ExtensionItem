using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WebExtensionPack.Controls
{
    public enum ExtensionStatus
    {
        None,
        Pending,
        Loading,
        Completed,
        Warning,
        Error,
        Idle
    }

    public partial class ExtensionItem : UserControl
    {

        public ExtensionItem()
        {
            InitializeComponent();
            Status = ExtensionStatus.Pending;
        }

        public string ExtensionGuid { get; }
        private ExtensionStatus _status;
        public ExtensionStatus Status
        {
            get => _status;
            set
            {
                _status = value;
                UpdateStatus();
            }
        }
        public void ResetExtensionStatus()
        {
            _status = ExtensionStatus.Idle;
        }

        public string SetNextExtensionStatus()
        {
            // Define custom sequence
            var sequence = new ExtensionStatus[]
            {
        ExtensionStatus.Idle,       // ❒
        ExtensionStatus.Warning,    // ⚠
        ExtensionStatus.Error,      // ❌
        ExtensionStatus.Loading,    // Spinner
        ExtensionStatus.Completed   // Tick
            };

            int idx = Array.IndexOf(sequence, _status);
            idx = (idx + 1) % sequence.Length;
            _status = sequence[idx];
            UpdateStatus();

            return _status.ToString();
        }


        public string GetExtensionStatusString()
        {
            return _status.ToString();
        }


        private void UpdateStatus()
        {
            GridPending.Visibility = (_status == ExtensionStatus.Pending) ? Visibility.Visible : Visibility.Collapsed;
            GridLoading.Visibility = (_status == ExtensionStatus.Loading) ? Visibility.Visible : Visibility.Collapsed;
            GridTick.Visibility = (_status == ExtensionStatus.Completed) ? Visibility.Visible : Visibility.Collapsed;
            GridWarning.Visibility = (_status == ExtensionStatus.Warning) ? Visibility.Visible : Visibility.Collapsed;
            GridError.Visibility = (_status == ExtensionStatus.Error) ? Visibility.Visible : Visibility.Collapsed;
            GridIdle.Visibility = (_status == ExtensionStatus.Idle || _status == ExtensionStatus.None) ? Visibility.Visible : Visibility.Collapsed;
        }


        public string ExtensionLabel
        {
            get => ExtensionName.Text;
            set => ExtensionName.Text = value;
        }


    }
}

