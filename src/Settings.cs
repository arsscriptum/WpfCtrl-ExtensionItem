using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.InteropServices;
using System.IO;
using System.Text.Json;

namespace WebExtensionPack.Controls
{
    // Special guid to tell it that this is a custom Options dialog page, not the built-in grid dialog page.
    public class GridConfigSettings : INotifyPropertyChanged
    {
        #region Notify Property Changed
        /// <summary>
        /// Inherited event from INotifyPropertyChanged.
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;

        /// <summary>
        /// Fires the PropertyChanged event of INotifyPropertyChanged with the given property name.
        /// </summary>
        /// <param name="propertyName">The name of the property to fire the event against</param>
        public void NotifyPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
        }
        #endregion


        public static string SettingsFilePath =>
            Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "settings.json");

        public static GridConfigSettings LoadFromFile(string filePath = null)
        {
            filePath ??= SettingsFilePath;
            if (!File.Exists(filePath))
                return new GridConfigSettings(); // Default

            try
            {
                var json = File.ReadAllText(filePath);
                return System.Text.Json.JsonSerializer.Deserialize<GridConfigSettings>(json) ?? new GridConfigSettings();
            }
            catch
            {
                return new GridConfigSettings(); // Fallback to default on error
            }
        }

        public void SaveToFile(string filePath = null)
        {
            filePath ??= SettingsFilePath;
            var json = System.Text.Json.JsonSerializer.Serialize(this, new System.Text.Json.JsonSerializerOptions { WriteIndented = true });
            File.WriteAllText(filePath, json);
        }


        // In GridConfigSettings.cs

        private string _logLevel = "Info";
        public string LogLevel
        {
            get => _logLevel;
            set { _logLevel = value; NotifyPropertyChanged(nameof(LogLevel)); }
        }

        private string _logFilePath;
        public string LogFilePath
        {
            get => _logFilePath;
            set { _logFilePath = value; NotifyPropertyChanged(nameof(LogFilePath)); }
        }

        private bool _logChannelGui;
        public bool LogChannelGui
        {
            get => _logChannelGui;
            set { _logChannelGui = value; NotifyPropertyChanged(nameof(LogChannelGui)); }
        }

        private bool _logChannelFile;
        public bool LogChannelFile
        {
            get => _logChannelFile;
            set { _logChannelFile = value; NotifyPropertyChanged(nameof(LogChannelFile)); }
        }

        private bool _logChannelEvents;
        public bool LogChannelEvents
        {
            get => _logChannelEvents;
            set { _logChannelEvents = value; NotifyPropertyChanged(nameof(LogChannelEvents)); }
        }

        private bool _recordNetworkStatistics;
        public bool RecordNetworkStatistics
        {
            get => _recordNetworkStatistics;
            set { _recordNetworkStatistics = value; NotifyPropertyChanged(nameof(RecordNetworkStatistics)); }
        }

        private string _temporaryDirectory;
        public string TemporaryDirectory
        {
            get => _temporaryDirectory;
            set { _temporaryDirectory = value; NotifyPropertyChanged(nameof(TemporaryDirectory)); }
        }

        private string _finalDestinationDirectory;
        public string FinalDestinationDirectory
        {
            get => _finalDestinationDirectory;
            set { _finalDestinationDirectory = value; NotifyPropertyChanged(nameof(FinalDestinationDirectory)); }
        }

        private bool _autorunPackageCommand;
        public bool AutorunPackageCommand
        {
            get => _autorunPackageCommand;
            set { _autorunPackageCommand = value; NotifyPropertyChanged(nameof(AutorunPackageCommand)); }
        }


        private bool _versionCheckOnStart;
        public bool VersionCheckOnStart
        {
            get => _versionCheckOnStart;
            set { _versionCheckOnStart = value; NotifyPropertyChanged(nameof(VersionCheckOnStart)); }
        }

        private bool _autoUpdateEnabled;
        public bool AutoUpdateEnabled
        {
            get => _autoUpdateEnabled;
            set { _autoUpdateEnabled = value; NotifyPropertyChanged(nameof(AutoUpdateEnabled)); }
        }

        private bool _messageOfTheDayEnabled;
        public bool MessageOfTheDayEnabled
        {
            get => _messageOfTheDayEnabled;
            set { _messageOfTheDayEnabled = value; NotifyPropertyChanged(nameof(MessageOfTheDayEnabled)); }
        }


        /// <summary>
        /// Get / Set if new files being added to source control should be compared.
        /// </summary>
        public bool CompareNewFiles { get { return _compareNewFiles; } set { _compareNewFiles = value; NotifyPropertyChanged("CompareNewFiles"); } }
        private bool _compareNewFiles = false;

        #region Overridden Functions

        /// <summary>
        /// Gets the Windows Presentation Foundation (WPF) child element to be hosted inside the Options dialog page.
        /// </summary>
        /// <returns>The WPF child element.</returns>


        /// <summary>
        /// Should be overridden to reset settings to their default values.
        /// </summary>

        #endregion

        // Transfer Mode
        private string _transferMode = "BITS TRANSFER";
        public string TransferMode
        {
            get => _transferMode;
            set { _transferMode = value; NotifyPropertyChanged(nameof(TransferMode)); }
        }

        // Max Parallel Jobs
        private int _maxParallelJobs;
        public int MaxParallelJobs
        {
            get => _maxParallelJobs;
            set { _maxParallelJobs = value; NotifyPropertyChanged(nameof(MaxParallelJobs)); }
        }

        // Priority
        private int _priority;
        public int Priority
        {
            get => _priority;
            set { _priority = value; NotifyPropertyChanged(nameof(Priority)); }
        }

        // RetryInterval (seconds)
        private int _retryInterval;
        public int RetryInterval
        {
            get => _retryInterval;
            set { _retryInterval = value; NotifyPropertyChanged(nameof(RetryInterval)); }
        }

        // RetryTimeout (seconds)
        private int _retryTimeout;
        public int RetryTimeout
        {
            get => _retryTimeout;
            set { _retryTimeout = value; NotifyPropertyChanged(nameof(RetryTimeout)); }
        }

        // MaxDownloadTime (seconds)
        private int _maxDownloadTime;
        public int MaxDownloadTime
        {
            get => _maxDownloadTime;
            set { _maxDownloadTime = value; NotifyPropertyChanged(nameof(MaxDownloadTime)); }
        }

        // ProxyAuthentication
        private bool _proxyAuthentication;
        public bool ProxyAuthentication
        {
            get => _proxyAuthentication;
            set { _proxyAuthentication = value; NotifyPropertyChanged(nameof(ProxyAuthentication)); }
        }

        // ProxyBypass
        private string _proxyBypass;
        public string ProxyBypass
        {
            get => _proxyBypass;
            set { _proxyBypass = value; NotifyPropertyChanged(nameof(ProxyBypass)); }
        }

        // ProxyCredential
        private string _proxyCredential;
        public string ProxyCredential
        {
            get => _proxyCredential;
            set { _proxyCredential = value; NotifyPropertyChanged(nameof(ProxyCredential)); }
        }

        // ProxyUsage
        private bool _proxyUsage;
        public bool ProxyUsage
        {
            get => _proxyUsage;
            set { _proxyUsage = value; NotifyPropertyChanged(nameof(ProxyUsage)); }
        }

        // ProxyList
        private string _proxyList;
        public string ProxyList
        {
            get => _proxyList;
            set { _proxyList = value; NotifyPropertyChanged(nameof(ProxyList)); }
        }

        // NotifyFlags
        private string _notifyFlags = "None";
        public string NotifyFlags
        {
            get => _notifyFlags;
            set { _notifyFlags = value; NotifyPropertyChanged(nameof(NotifyFlags)); }
        }

        // NotifyCmdLine
        private string _notifyCmdLine;
        public string NotifyCmdLine
        {
            get => _notifyCmdLine;
            set { _notifyCmdLine = value; NotifyPropertyChanged(nameof(NotifyCmdLine)); }
        }



        // --- Stats ---
        private bool _generateErrorReportOnError;
        public bool GenerateErrorReportOnError
        {
            get => _generateErrorReportOnError;
            set { _generateErrorReportOnError = value; NotifyPropertyChanged(nameof(GenerateErrorReportOnError)); }
        }

        private bool _gatherSystemInformation;
        public bool GatherSystemInformation
        {
            get => _gatherSystemInformation;
            set { _gatherSystemInformation = value; NotifyPropertyChanged(nameof(GatherSystemInformation)); }
        }

        // --- License ---
        private string _licenseUsername;
        public string LicenseUsername
        {
            get => _licenseUsername;
            set { _licenseUsername = value; NotifyPropertyChanged(nameof(LicenseUsername)); }
        }

        private string _licenseCompanyName;
        public string LicenseCompanyName
        {
            get => _licenseCompanyName;
            set { _licenseCompanyName = value; NotifyPropertyChanged(nameof(LicenseCompanyName)); }
        }

        private string _licenseKey;
        public string LicenseKey
        {
            get => _licenseKey;
            set { _licenseKey = value; NotifyPropertyChanged(nameof(LicenseKey)); }
        }


    }
}




