using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.InteropServices;

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
    }
}




