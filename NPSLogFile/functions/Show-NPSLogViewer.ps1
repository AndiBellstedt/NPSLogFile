function Show-NPSLogViewer {
    <#
    .Synopsis
        Display a graphical user interface for viewing and analyzing NPS log files.

    .DESCRIPTION
        Provides a modern WPF-based interface for viewing, filtering, and exporting NPS log data.
        The GUI offers an intuitive way to browse log files, apply filters, and export results to CSV.

    .INPUTS
        None. This function does not accept pipeline input.

    .OUTPUTS
        None. This function displays a GUI and does not return objects to the pipeline.

    .NOTES
        This function requires Windows with WPF support.

    .EXAMPLE
        Show-NPSLogViewer

        Opens the NPS Log Viewer interface.
    #>
    [CmdletBinding(
        ConfirmImpact = 'Low',
        SupportsShouldProcess = $false
    )]
    [OutputType([void])]
    param()

    begin {
        Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase
        Add-Type -AssemblyName System.Windows.Forms

        # Get screen dimensions for 65% window size
        $screenWidth = [System.Windows.SystemParameters]::PrimaryScreenWidth
        $screenHeight = [System.Windows.SystemParameters]::PrimaryScreenHeight
        $windowWidth = $screenWidth * 0.65
        $windowHeight = $screenHeight * 0.65

        # Window initialization

        # Load XAML
        $xamlFile = Join-Path (Split-Path $PSScriptRoot -Parent) "forms\Get-NPSLogGUI.xaml"

        if (-not (Test-Path $xamlFile)) {
            throw "XAML file not found at: $xamlFile"
        }

        try {
            $inputXML = Get-Content -Path $xamlFile -Raw -ErrorAction Stop
            if (-not $inputXML) {
                throw "XAML file is empty"
            }
            $inputXML = $inputXML -replace "x:N", 'N'
            [xml]$xaml = $inputXML
        } catch {
            throw "Failed to load XAML: $($_.Exception.Message)"
        }

        $reader = (New-Object System.Xml.XmlNodeReader $xaml)
        $window = [Windows.Markup.XamlReader]::Load($reader)

        # Set window size to 65% of screen before any other window operations
        $window.Width = $windowWidth
        $window.Height = $windowHeight

        # Get controls
        $controls = @{}
        $xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
            $controls.Add($_.Name, $window.FindName($_.Name))
        }

        # Initialize ComboBoxes
        $controls.FormatComboBox.ItemsSource = @('DTS', 'IAS', 'ODBC')
        $controls.FormatComboBox.SelectedItem = 'DTS'

        $controls.EncodingComboBox.ItemsSource = @('Default', 'ASCII', 'UTF8', 'UTF7', 'UTF32', 'Unicode', 'BigEndianUnicode')
        $controls.EncodingComboBox.SelectedItem = 'UTF8'

        # Hide specific columns in the DataGrid
        $controls.ResultsGrid.Add_AutoGeneratingColumn({
                $columnInfo = $args[1]
                if ($columnInfo.PropertyName -in @('PropertylistHash', 'Event', 'Class', 'Childnodes')) {
                    $columnInfo.Cancel = $true
                }
            })

        # Enable sorting for DataGrid
        $controls.ResultsGrid.IsReadOnly = $true
        $controls.ResultsGrid.CanUserSortColumns = $true

        $filterOptions = @(
            'Access-Request', 'Access-Accept', 'Access-Reject', 'Accounting-Request', 'Accounting-Response',
            'Accounting-Status (now Interim Accounting)', 'Password-Request', 'Password-Ack', 'Password-Reject',
            'Accounting-Message', 'Access-Challenge', 'Status-Server (experimental)', 'Status-Client (experimental)',
            'Resource-Free-Request', 'Resource-Free-Response', 'Resource-Query-Request', 'Resource-Query-Response',
            'Alternate-Resource-Reclaim-Request', 'NAS-Reboot-Request', 'NAS-Reboot-Response', 'Next-Passcode',
            'New-Pin', 'Terminate-Session', 'Password-Expired', 'Event-Request', 'Event-Response',
            'Disconnect-Request', 'Disconnect-ACK', 'Disconnect-NAK', 'CoA-Request', 'CoA-ACK', 'CoA-NAK',
            'Unassigned', 'IP-Address-Allocate', 'IP-Address-Release', 'Protocol-Error', 'Experimental Use', 'Reserved'
        )
        $controls.FilterListBox.ItemsSource = $filterOptions

        # Ensure all items are unselected by default
        $controls.FilterListBox.AddHandler(
            [System.Windows.Controls.ListView]::LoadedEvent,
            [System.Windows.RoutedEventHandler] {
                foreach ($item in $controls.FilterListBox.Items) {
                    $listViewItem = $controls.FilterListBox.ItemContainerGenerator.ContainerFromItem($item)
                    if ($listViewItem) {
                        $listViewItem.IsSelected = $false
                    }
                }
            }
        )

        # Add Select/Unselect All handlers
        $controls.SelectAllButton.Add_Click({
                foreach ($item in $controls.FilterListBox.Items) {
                    $listViewItem = $controls.FilterListBox.ItemContainerGenerator.ContainerFromItem($item)
                    if ($listViewItem) {
                        $listViewItem.IsSelected = $true
                    }
                }
            })

        $controls.UnselectAllButton.Add_Click({
                foreach ($item in $controls.FilterListBox.Items) {
                    $listViewItem = $controls.FilterListBox.ItemContainerGenerator.ContainerFromItem($item)
                    if ($listViewItem) {
                        $listViewItem.IsSelected = $false
                    }
                }
            })

        # Add event handlers
        $controls.BrowseButton.Add_Click({
                $openFileDialog = New-Object Microsoft.Win32.OpenFileDialog
                $openFileDialog.Filter = "Log files (*.log)|*.log|All files (*.*)|*.*"
                $openFileDialog.FilterIndex = 1

                if ($openFileDialog.ShowDialog()) {
                    $controls.PathTextBox.Text = $openFileDialog.FileName
                }
            })

        $controls.CloseButton.Add_Click({
                $window.Close()
            })

        $controls.GetLogsButton.Add_Click({
                try {
                    $params = @{
                        Path     = $controls.PathTextBox.Text
                        Format   = $controls.FormatComboBox.SelectedItem
                        Encoding = $controls.EncodingComboBox.SelectedItem
                    }

                    $selectedFilters = $controls.FilterListBox.SelectedItems
                    if ($selectedFilters -and $selectedFilters.Count -gt 0) {
                        $params.Filter = [string[]]@($selectedFilters | ForEach-Object { $_.ToString() })
                    }

                    $results = Get-NPSLog @params
                    $controls.ResultsGrid.ItemsSource = $results
                } catch {
                    [System.Windows.MessageBox]::Show($_.Exception.Message, "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
                }
            })

        $controls.ExportButton.Add_Click({
                if (-not $controls.ResultsGrid.ItemsSource) {
                    [System.Windows.MessageBox]::Show("No data to export.", "Warning", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
                    return
                }

                try {
                    $saveFileDialog = New-Object Microsoft.Win32.SaveFileDialog
                    $saveFileDialog.Filter = "CSV file (*.csv)|*.csv|All files (*.*)|*.*"
                    $saveFileDialog.DefaultExt = "csv"
                    $saveFileDialog.Title = "Export NPS Log Data"

                    if ($saveFileDialog.ShowDialog()) {
                        $controls.ResultsGrid.ItemsSource | Export-Csv -Path $saveFileDialog.FileName -NoTypeInformation
                        [System.Windows.MessageBox]::Show("Data exported successfully.", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
                    }
                } catch {
                    [System.Windows.MessageBox]::Show("Failed to export data: $($_.Exception.Message)", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
                }
            })

        # Window control buttons
        $controls.MinimizeButton.Add_Click({
                $window.WindowState = [System.Windows.WindowState]::Minimized
            })

        $controls.MaximizeButton.Add_Click({
                if ($window.WindowState -eq [System.Windows.WindowState]::Maximized) {
                    $window.WindowState = [System.Windows.WindowState]::Normal
                    $controls.MaximizeButton.Content = [char]0xE739
                } else {
                    $window.WindowState = [System.Windows.WindowState]::Maximized
                    $controls.MaximizeButton.Content = [char]0xE923
                }
            })

        # Enable window drag and maximize on double click
        $controls.TitleBar.Add_MouseLeftButtonDown({
                try {
                    if ($_.Source -is [System.Windows.Controls.Button]) {
                        return
                    }
                    if ($_.ClickCount -eq 2) {
                        if ($window.WindowState -eq [System.Windows.WindowState]::Maximized) {
                            $window.WindowState = [System.Windows.WindowState]::Normal
                            $controls.MaximizeButton.Content = [char]0xE739
                        } else {
                            $window.WindowState = [System.Windows.WindowState]::Maximized
                            $controls.MaximizeButton.Content = [char]0xE923
                        }
                    } else {
                        $window.DragMove()
                    }
                } catch {
                    Write-Warning $_.Exception.Message
                }
            })

        # No window theme initialization needed - using static dark theme resources

        # Register window closing event
        $window.Add_Closed({
                Write-Verbose "Window closed"
            })

        # Show window
        [void]$window.ShowDialog()
    }

    process {}

    end {}
}