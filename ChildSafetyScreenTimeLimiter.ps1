[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $breakTimeWarning,
    [Parameter()]
    [switch]
    $breakTimeStart
)

<#
    THIS FUNCTION EXISTS ONLY TO CREATE AND DISPLAY THE MESSAGEBOX
#>
Function New-WPFMessageBox {

    # For examples for use, see my blog:
    # https://smsagent.wordpress.com/2017/08/24/a-customisable-wpf-messagebox-for-powershell/
    
    # CHANGES
    # 2017-09-11 - Added some required assemblies in the dynamic parameters to avoid errors when run from the PS console host.
    
    # Define Parameters
    [CmdletBinding()]
    Param
    (
        # The popup Content
        [Parameter(Mandatory = $True, Position = 0)]
        [Object]$Content,

        # The window title
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$Title,

        # Content font size
        [Parameter(Mandatory = $false, Position = 4)]
        [int]$ContentFontSize = 14,

        # Title font size
        [Parameter(Mandatory = $false, Position = 5)]
        [int]$TitleFontSize = 14,

        # BorderThickness
        [Parameter(Mandatory = $false, Position = 6)]
        [int]$BorderThickness = 0,

        # CornerRadius
        [Parameter(Mandatory = $false, Position = 7)]
        [int]$CornerRadius = 8,

        # ShadowDepth
        [Parameter(Mandatory = $false, Position = 8)]
        [int]$ShadowDepth = 3,

        # BlurRadius
        [Parameter(Mandatory = $false, Position = 9)]
        [int]$BlurRadius = 20,

        # WindowHost
        [Parameter(Mandatory = $false, Position = 10)]
        [object]$WindowHost,

        # Timeout in seconds,
        [Parameter(Mandatory = $false, Position = 11)]
        [int]$Timeout,

        # Code for Window Loaded event,
        [Parameter(Mandatory = $false, Position = 12)]
        [scriptblock]$OnLoaded,

        # Code for Window Closed event,
        [Parameter(Mandatory = $false, Position = 13)]
        [scriptblock]$OnClosed

    )

    # Dynamically Populated parameters
    DynamicParam {
        
        # Add assemblies for use in PS Console 
        Add-Type -AssemblyName System.Drawing, PresentationCore
        
        # ContentBackground
        $ContentBackground = 'ContentBackground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute)
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.ContentBackground = "White"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ContentBackground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ContentBackground, $RuntimeParameter)
        

        # FontFamily
        $FontFamily = 'FontFamily'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute)  
        $arrSet = [System.Drawing.FontFamily]::Families.Name | Select-Object -Skip 1 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($FontFamily, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($FontFamily, $RuntimeParameter)
        $PSBoundParameters.FontFamily = "Segoe UI"

        # TitleFontWeight
        $TitleFontWeight = 'TitleFontWeight'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Windows.FontWeights] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.TitleFontWeight = "Normal"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($TitleFontWeight, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($TitleFontWeight, $RuntimeParameter)

        # ContentFontWeight
        $ContentFontWeight = 'ContentFontWeight'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Windows.FontWeights] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.ContentFontWeight = "Normal"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ContentFontWeight, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ContentFontWeight, $RuntimeParameter)
        

        # ContentTextForeground
        $ContentTextForeground = 'ContentTextForeground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.ContentTextForeground = "Black"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ContentTextForeground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ContentTextForeground, $RuntimeParameter)

        # TitleTextForeground
        $TitleTextForeground = 'TitleTextForeground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.TitleTextForeground = "Black"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($TitleTextForeground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($TitleTextForeground, $RuntimeParameter)

        # BorderBrush
        $BorderBrush = 'BorderBrush'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.BorderBrush = "Black"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($BorderBrush, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($BorderBrush, $RuntimeParameter)


        # TitleBackground
        $TitleBackground = 'TitleBackground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.TitleBackground = "White"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($TitleBackground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($TitleBackground, $RuntimeParameter)

        return $RuntimeParameterDictionary
    }

    Begin {
        Add-Type -AssemblyName PresentationFramework
    }
    
    Process {

        # Define the XAML markup
        [XML]$Xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" Title="" SizeToContent="WidthAndHeight" WindowStartupLocation="CenterScreen" WindowStyle="None" ResizeMode="NoResize" AllowsTransparency="True" Background="Transparent" Opacity="1">
    <Border x:Name="MainBorder" Margin="10" CornerRadius="$CornerRadius" BorderThickness="$BorderThickness" BorderBrush="$($PSBoundParameters.BorderBrush)" Padding="0" >
        <Border.Effect>
            <DropShadowEffect x:Name="DSE" Color="Black" Direction="270" BlurRadius="$BlurRadius" ShadowDepth="$ShadowDepth" Opacity="0.6" />
        </Border.Effect>
        <Border.Triggers>
            <EventTrigger RoutedEvent="Window.Loaded">
                <BeginStoryboard>
                    <Storyboard>
                        <DoubleAnimation Storyboard.TargetName="DSE" Storyboard.TargetProperty="ShadowDepth" From="0" To="$ShadowDepth" Duration="0:0:1" AutoReverse="False" />
                        <DoubleAnimation Storyboard.TargetName="DSE" Storyboard.TargetProperty="BlurRadius" From="0" To="$BlurRadius" Duration="0:0:1" AutoReverse="False" />
                    </Storyboard>
                </BeginStoryboard>
            </EventTrigger>
        </Border.Triggers>
        <Grid >
            <Border Name="Mask" CornerRadius="$CornerRadius" Background="$($PSBoundParameters.ContentBackground)" />
            <Grid x:Name="Grid" Background="$($PSBoundParameters.ContentBackground)">
                <Grid.OpacityMask>
                    <VisualBrush Visual="{Binding ElementName=Mask}"/>
                </Grid.OpacityMask>
                <StackPanel Name="StackPanel" >                   
                    <TextBox Name="TitleBar" IsReadOnly="True" IsHitTestVisible="False" Text="$Title" Padding="10" FontFamily="$($PSBoundParameters.FontFamily)" FontSize="48" Foreground="$($PSBoundParameters.TitleTextForeground)" FontWeight="$($PSBoundParameters.TitleFontWeight)" Background="$($PSBoundParameters.TitleBackground)" HorizontalAlignment="Stretch" VerticalAlignment="Center" Width="Auto" HorizontalContentAlignment="Center" BorderThickness="0"/>
                    <DockPanel Name="ContentHost" Margin="1280,710,1280,710"  >
                    </DockPanel>
                </StackPanel>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

        [XML]$ContentTextXaml = @"
<TextBlock xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Text="$Content" Foreground="$($PSBoundParameters.ContentTextForeground)" DockPanel.Dock="Right" HorizontalAlignment="Center" VerticalAlignment="Center" FontFamily="$($PSBoundParameters.FontFamily)" FontSize="32" FontWeight="$($PSBoundParameters.ContentFontWeight)" TextWrapping="Wrap" Height="Auto" MaxWidth="500" MinWidth="50" Padding="10"/>
"@

        # Helper functions to modify window style
        function Get-WindowLong {
            param (
                [Parameter(Mandatory = $true)]
                [IntPtr]$hwnd,
                [Parameter(Mandatory = $true)]
                [int]$nIndex
            )
            return [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
        }

        function Set-WindowLong {
            param (
                [Parameter(Mandatory = $true)]
                [IntPtr]$hwnd,
                [Parameter(Mandatory = $true)]
                [int]$nIndex,
                [Parameter(Mandatory = $true)]
                [int]$dwNewLong
            )
            return [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
        }
        # Load the window from XAML
        $Window = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $xaml))
        
        # Disable moving the window
        $window.Add_Loaded({
                $hwnd = [System.Windows.Interop.WindowInteropHelper]::new($window).Handle
                $style = Get-WindowLong $hwnd -20
                Set-WindowLong $hwnd -20 ($style -bor 0x00000080)
            })


        # Remove the title bar if no title is provided
        If ($Title -eq "") {
            $TitleBar = $Window.FindName('TitleBar')
            $Window.FindName('StackPanel').Children.Remove($TitleBar)
        }

        # Add the Content
        If ($Content -is [String]) {
            # Replace double quotes with single to avoid quote issues in strings
            If ($Content -match '"') {
                $Content = $Content.Replace('"', "'")
            }
        
            # Use a text box for a string value...
            $ContentTextBox = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $ContentTextXaml))
            $Window.FindName('ContentHost').AddChild($ContentTextBox)
        }
        Else {
            # ...or add a WPF element as a child
            Try {
                $Window.FindName('ContentHost').AddChild($Content) 
            }
            Catch {
                $_
            }        
        }

        # Activate the window on loading
        If ($OnLoaded) {
            $Window.Add_Loaded({
                    $This.Activate()
                    Invoke-Command $OnLoaded
                })
        }
        Else {
            $Window.Add_Loaded({
                    $This.Activate()
                })
        }
    

        # Stop the dispatcher timer if exists
        If ($OnClosed) {
            $Window.Add_Closed({
                    If ($DispatcherTimer) {
                        $DispatcherTimer.Stop()
                    }
                    Invoke-Command $OnClosed
                })
        }
        Else {
            $Window.Add_Closed({
                    If ($DispatcherTimer) {
                        $DispatcherTimer.Stop()
                    }
                })
        }
    

        # If a window host is provided assign it as the owner
        If ($WindowHost) {
            $Window.Owner = $WindowHost
            $Window.WindowStartupLocation = "CenterOwner"
        }

        # If a timeout value is provided, use a dispatcher timer to close the window when timeout is reached
        If ($Timeout) {
            $Stopwatch = New-object System.Diagnostics.Stopwatch
            $TimerCode = {
                If ($Stopwatch.Elapsed.TotalSeconds -ge $Timeout) {
                    $Stopwatch.Stop()
                    $Window.Close()
                }
            }
            $DispatcherTimer = New-Object -TypeName System.Windows.Threading.DispatcherTimer
            $DispatcherTimer.Interval = [TimeSpan]::FromSeconds(1)
            $DispatcherTimer.Add_Tick($TimerCode)
            $Stopwatch.Start()
            $DispatcherTimer.Start()
        }

        # Display the window
        $null = $window.Dispatcher.InvokeAsync{ $window.ShowDialog() }.Wait()

    }
}

<#
    END OF MESSAGE BOX FUNCTION
#>

## THIS IS THE PART OF THS SCRIPT THAT WILL BE RUN TO BE THE BREAK TIME WARNING
##
if ($breakTimeWarning) {
    $Content = "IN 15 MINUTES THE COMPUTER WILL SAFELY GO TO SLEEP FOR 2 HOURS | THIS MESSAGE WILL AUTOMATICALLY DISAPPEAR IN 10 SECONDS"
    
    $Params = @{
        Content             = $Content
        Title               = " BREAK TIME IS IN 15 MINUTES "
        TitleFontSize       = 30
        TitleTextForeground = 'Red'
        TitleFontWeight     = 'Bold'
        TitleBackground     = 'Silver'
        FontFamily          = 'Lucida Console'
        Timeout             = 10
    }

    # message box pop-up on timer to close
    New-WPFMessageBox @Params

    try {
        # disable auto-hide the taskbar
        $p = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'; $v = (Get-ItemProperty -Path $p).Settings; $v[8] = 2; `
            &Set-ItemProperty -Path $p -Name Settings -Value $v; &Stop-Process -f -ProcessName explorer
    }
    catch {
        Write-Debug $Error.ToString()
    }
    try {
        Add-Type -Assembly System.Windows.Forms
        [System.Windows.Forms.Application]::SetSuspendState("Suspend", $false, $true)
    }
    catch {
        Write-Debug $Error.ToString()
    }
}
##
## BREAK TIME WARNING CODE CHUNK ENDS HERE

## THIS IS THE PART OF THS SCRIPT THAT WILL BE THE BREAK TIME START
##
if ($breakTimeStart) {
    try {
        # enable auto-hide the taskbar
        $p = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'; $v = (Get-ItemProperty -Path $p).Settings; $v[8] = 3; `
            & Set-ItemProperty -Path $p -Name Settings -Value $v; &Stop-Process -f -ProcessName explorer
    }
    catch {
        Write-Debug $Error.ToString()
    }

    Read-Host "open the message box next"
    $Content = "YOU CAN RETURN TO USE THE COMPUTER IN 2 HOURS YOU WILL SEE THIS MESSAGE FOR 30 SECONDS AND THE COMPUTER WILL SAFELY GO TO SLEEP FOR 2 HOURS"
        
    $Params = @{
        Content             = $Content
        Title               = " BREAK TIME IS NOW "
        TitleFontSize       = 30
        TitleTextForeground = 'Red'
        TitleFontWeight     = 'Bold'
        TitleBackground     = 'Silver'
        FontFamily          = 'Lucida Console'
        Timeout             = 30
    }

    # message box pop-up on timer to close
    New-WPFMessageBox @Params

    try {
        # disable auto-hide the taskbar
        $p = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'; $v = (Get-ItemProperty -Path $p).Settings; $v[8] = 2; `
            &Set-ItemProperty -Path $p -Name Settings -Value $v; &Stop-Process -f -ProcessName explorer
    }
    catch {
        Write-Debug $Error.ToString()
    }
            
    try {
        Add-Type -Assembly System.Windows.Forms
        [System.Windows.Forms.Application]::SetSuspendState("Suspend", $false, $true)
    }
    catch {
        Write-Debug $Error.ToString()
    }
}
##
## BREAK TIME STARTS CODE CHUNK ENDS HERE
