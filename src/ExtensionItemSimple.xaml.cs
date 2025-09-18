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
#if USE_ANIMATED_GIFS
using WpfAnimatedGif;
#endif

namespace WebExtensionPack.Controls
{
    #if USE_ANIMATED_GIFS
    private string urlGifCloud = "pack://application:,,,/WebExtensionPack.Controls;component/res/cloud.gif";
    private string urlGifDecryptAes = "pack://application:,,,/WebExtensionPack.Controls;component/res/decryptaes.gif";
    private string urlGifLockAndKey = "pack://application:,,,/WebExtensionPack.Controls;component/res/lockandkey.gif";
    private string urlGifLockSecurity = "pack://application:,,,/WebExtensionPack.Controls;component/res/locksecurity.gif";
    private string urlGifScan = "pack://application:,,,/WebExtensionPack.Controls;component/res/scan.gif";
    private string urlGifUnpack = "pack://application:,,,/WebExtensionPack.Controls;component/res/unpack.gif";
    private BitmapImage gifCloud;
    private BitmapImage gifDecryptAes;
    private BitmapImage gifLockAndKey;
    private BitmapImage gifLockSecurity;
    private BitmapImage gifScan;
    private BitmapImage gifUnpack;
    #endif

    public enum ExtensionStatus
    {
        None,
        Pending,
        CloudDownload,
        Decryption,
        Completed,
        Warning,
        Error,
        Cloud,
        DecryptAes,
        LockAndKey,
        LockSecurity,
        Scan,
        Unpack,
        Idle
    }

    public partial class ExtensionItemSimple : UserControl
    {

        public ExtensionItemSimple()
        {
            InitializeComponent();
            Status = ExtensionStatus.Pending;
            #if USE_ANIMATED_GIFS
            InitializeAnimatedGifs();
            #endif

        }


 
        
        public void InitializeAnimatedGifs()
        {
            #if USE_ANIMATED_GIFS
            var urlCloud = new Uri(urlGifCloud, UriKind.Absolute);
            var urlDecryptAes = new Uri(urlGifDecryptAes, UriKind.Absolute);
            var urlLockAndKey = new Uri(urlGifLockAndKey, UriKind.Absolute);
            var urlLockSecurity = new Uri(urlGifLockSecurity, UriKind.Absolute);
            var urlScan = new Uri(urlGifScan, UriKind.Absolute);
            var urlUnpack = new Uri(urlGifUnpack, UriKind.Absolute);

            gifCloud = new BitmapImage(urlCloud);
            gifDecryptAes = new BitmapImage(urlDecryptAes);
            gifLockAndKey = new BitmapImage(urlLockAndKey);
            gifLockSecurity = new BitmapImage(urlLockSecurity);
            gifScan = new BitmapImage(urlScan);
            gifUnpack = new BitmapImage(urlUnpack);

            ImageBehavior.SetAnimatedSource(imgDecryptionGif, gifDecryptAes);
            ImageBehavior.SetAnimatedSource(imgCloudGif, gifCloud);
            ImageBehavior.SetAnimatedSource(imgScanGif, gifScan);
            ImageBehavior.SetAnimatedSource(imgUnpackGif, gifUnpack);
            ImageBehavior.SetAnimatedSource(imgLockSecurityGif, gifLockSecurity);
            ImageBehavior.SetAnimatedSource(imgLockAndKeyGif, gifLockAndKey);
            #endif
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
                ExtensionStatus.Idle,      
                ExtensionStatus.Warning,    
                ExtensionStatus.Error,     
                ExtensionStatus.Pending,
                ExtensionStatus.Decryption,
                ExtensionStatus.CloudDownload,
                ExtensionStatus.Cloud,
                ExtensionStatus.DecryptAes,
                ExtensionStatus.LockAndKey,
                ExtensionStatus.LockSecurity,
                ExtensionStatus.Scan,
                ExtensionStatus.Unpack,
                ExtensionStatus.Completed
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

        public void SetLabelBold(bool isBold)
        {
            if (isBold)
                ExtensionName.FontWeight = FontWeights.Bold;
            else
                ExtensionName.FontWeight = FontWeights.Normal;
        }

        public void SetLabelColor(string colorName)
        {
            switch (colorName.ToLower())
            {
                case "black":
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Black);
                    break;
                case "springgreen":
                    ExtensionName.Foreground = new SolidColorBrush(Colors.SpringGreen);
                    break;
                case "orange":
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Orange);
                    break;
                case "orangered":
                    ExtensionName.Foreground = new SolidColorBrush(Colors.OrangeRed);
                    break;
                case "blue":
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Blue);
                    break;
                case "gray":
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Gray);
                    break;
                case "dimgray":
                    ExtensionName.Foreground = new SolidColorBrush(Colors.DimGray);
                    break;
                case "red":
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Red);
                    break;
                case "darkred":
                    ExtensionName.Foreground = new SolidColorBrush(Colors.DarkRed);
                    break;
                case "darkgreen":
                    ExtensionName.Foreground = new SolidColorBrush(Colors.DarkGreen);
                    ExtensionName.Foreground = new SolidColorBrush(Colors.DarkGreen);
                    break;
                case "green":
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Green);
                    break;
                default:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Black);
                    break;
            }
        }

        public enum LabelColor { Black, SpringGreen, Orange, OrangeRed, Blue, Gray, DimGray, Red, DarkRed, DarkGreen, Green }
        public void SetLabelColor(LabelColor color)
        {
            switch (color)
            {
                case LabelColor.Black:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Black); break;
                case LabelColor.Red:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Red); break;
                case LabelColor.SpringGreen:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.SpringGreen); break;
                case LabelColor.Orange:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Orange); break;
                case LabelColor.OrangeRed:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.OrangeRed); break;
                case LabelColor.DarkGreen:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.DarkGreen); break;
                case LabelColor.Blue:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Blue); break;
                case LabelColor.Gray:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Gray); break;
                case LabelColor.DimGray:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.DimGray); break;
                case LabelColor.Green:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Green); break;
                case LabelColor.DarkRed:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.DarkRed); break;
                default:
                    ExtensionName.Foreground = new SolidColorBrush(Colors.Black); break;
            }
        }



        private void UpdateStatus()
        {
            GridCloudDownload.Visibility = (_status == ExtensionStatus.CloudDownload) ? Visibility.Visible : Visibility.Collapsed;
            GridPending.Visibility = (_status == ExtensionStatus.Pending) ? Visibility.Visible : Visibility.Collapsed;
            GridTick.Visibility = (_status == ExtensionStatus.Completed) ? Visibility.Visible : Visibility.Collapsed;
            GridWarning.Visibility = (_status == ExtensionStatus.Warning) ? Visibility.Visible : Visibility.Collapsed;
            GridDecryption.Visibility = (_status == ExtensionStatus.Decryption) ? Visibility.Visible : Visibility.Collapsed;
            GridError.Visibility = (_status == ExtensionStatus.Error) ? Visibility.Visible : Visibility.Collapsed;
            GridIdle.Visibility = (_status == ExtensionStatus.Idle || _status == ExtensionStatus.None) ? Visibility.Visible : Visibility.Collapsed;
            GridDecryption.Visibility = (_status == ExtensionStatus.DecryptAes || _status == ExtensionStatus.None) ? Visibility.Visible : Visibility.Collapsed;
            GridCloud.Visibility = (_status == ExtensionStatus.Cloud || _status == ExtensionStatus.None) ? Visibility.Visible : Visibility.Collapsed;
            GridLockAndKey.Visibility = (_status == ExtensionStatus.LockAndKey || _status == ExtensionStatus.None) ? Visibility.Visible : Visibility.Collapsed;
            GridUnpack.Visibility = (_status == ExtensionStatus.Unpack || _status == ExtensionStatus.None) ? Visibility.Visible : Visibility.Collapsed;
            GridScan.Visibility = (_status == ExtensionStatus.Scan || _status == ExtensionStatus.None) ? Visibility.Visible : Visibility.Collapsed;
            GridLockSecurity.Visibility = (_status == ExtensionStatus.LockSecurity || _status == ExtensionStatus.None) ? Visibility.Visible : Visibility.Collapsed;
        }


        public string ExtensionLabel
        {
            get => ExtensionName.Text;
            set => ExtensionName.Text = value;
        }


    }
}

