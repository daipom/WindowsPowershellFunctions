$imageSrc = ""

Function Toast {
    #AppID調べる:Get-StartApps
    $AppId = "{}\WindowsPowerShell\v1.0\powershell.exe"

    #ロード済み一覧:[System.AppDomain]::CurrentDomain.GetAssemblies() | % { $_.GetName().Name }
    #WinRTAPIを呼び出す:[-Class-,-Namespace-,ContentType=WindowsRuntime]
    $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    $null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
    
    #XmlDocumentクラスをインスタンス化
    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    #LoadXmlメソッドを呼び出し、変数templateをWinRT型のxmlとして読み込む
    $xml.LoadXml($template)

    #ToastNotificationクラスのCreateToastNotifierメソッドを呼び出し、変数xmlをトースト
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($xml)
}

#トーストテンプレート
$template = @"
<toast scenario="reminder">
    <visual>
        <binding template="ToastGeneric">
            <text>ゲスくま</text>
            <text>＞ リマインダーだよ！</text>
            <image placement="appLogoOverride" src="$imageSrc"/>
        </binding>
    </visual>
    <actions>
        <input id="snoozeTime" type="selection" defaultInput="10">
            <selection id="3" content="3 minute"/>
            <selection id="5" content="5 minutes"/>
            <selection id="10" content="10 minutes"/>
            <selection id="30" content="30 minutes"/>
            <selection id="60" content="1 hour"/>
        </input>
        <action activationType="system" arguments="snooze" hint-inputId="snoozeTime" content=""/>
        <action activationType="system" arguments="dismiss" content=""/>
    </actions>
</toast>
"@

Toast
