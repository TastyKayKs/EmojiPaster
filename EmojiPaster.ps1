$MainBlock = {
[Void](Add-Type -ReferencedAssemblies System.Windows.Forms,System.Drawing,Microsoft.VisualBasic -TypeDefinition @'
using System; 
using System.Runtime.InteropServices;
using DR = System.Drawing;
using SWF = System.Windows.Forms;
namespace Emoji{
    public class Wind{
        [DllImport("Kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
        
        public static void Visual (){
            SWF.Application.EnableVisualStyles();
        }
    }

    public class F : SWF.Form{
        public F (int sx, int sy, string tx){this.Size = new DR.Size(sx,sy);this.Text = tx;}
    }

    public class L : SWF.Label{
        public L (int sx, int sy, int lx, int ly, string tx){this.Size = new DR.Size(sx,sy);this.Location = new DR.Point(lx,ly);this.Text = tx;}
    }

    public class TB : SWF.TextBox{
        public TB (int sx, int sy, int lx, int ly, string tx){this.Size = new DR.Size(sx,sy);this.Location = new DR.Point(lx,ly);this.Text = tx;}
    }

    public class B : SWF.Button{
        public B (int sx, int sy, int lx, int ly, string tx){this.Size = new DR.Size(sx,sy);this.Location = new DR.Point(lx,ly);this.Text = tx;}
    }

    public class SP{
        public static DR.Point PO (int sx, int sy){
            return (new DR.Point(sx, sy));
        }
        
        public static DR.Size SI (int sx, int sy){
            return (new DR.Size(sx, sy));
        }
    }
}
'@)

$Hide = [Emoji.Wind]::GetConsoleWindow()
[Void][Emoji.Wind]::ShowWindow($Hide,0)

[Emoji.Wind]::Visual()

Function Reparse($Ind)
{
    $ButtArr | %{$Count=1}{
        $PH = ($Count+($Ind*310))
        If($PH -le 1114111 -AND ($PH -lt 55296 -OR $PH -gt 57343))
        {
            $Temp = [Char]::ConvertFromUtf32(('0x'+[Convert]::ToString($PH,16)))
        }
        Else
        {
            $Temp = ''
        }

        $_.Text = $Temp
        $Count++
    }
}

$Window = [Emoji.F]::New(353, 1060, 'Emojis')
$Window.MaximizeBox = $False
$Window.FormBorderStyle = 'FixedDialog'

$Back = [Emoji.B]::New(25, 25, 15, 10, '-')
$Back.Add_Click({
    $PageNo.Text = ([Int]($PageNo.Text) - 1)
    Reparse([Int]($PageNo.Text))
})
$Back.Parent = $Window

$PageNo = [Emoji.TB]::New(225, 25, 50, 11, '413')
$PageNo.Add_KeyDown({
    If($_.KeyCode -eq 'Return')
    {
        Reparse([Int]($This.Text))
    }
})
$PageNo.Add_TextChanged({$This.Text = ($This.Text -replace '\D')})
$PageNo.Parent = $Window

$Forward = [Emoji.B]::New(25, 25, 285, 10, '+')
$Forward.Add_Click({
    $PageNo.Text = ([Int]($PageNo.Text) + 1)
    Reparse([Int]($PageNo.Text))
})
$Forward.Parent = $Window

$Countx = 0
$County = 0

$ToolTip = New-Object System.Windows.Forms.ToolTip

$Script:ButtArr = (1..310 | %{
    $Temp = [Char]::ConvertFromUtf32(('0x'+[Convert]::ToString(($_+(413*310)),16)))

    (New-Object Emoji.B -ArgumentList (0, 0, 0, 0, '')) | %{
        $_.Text = $Temp
        $_.Font = New-Object System.Drawing.Font('Segoe UI Emoji',12,[System.Drawing.FontStyle]::Regular)
        $_.Size  = [Emoji.SP]::SI(25, 25)
        $_.Location = [Emoji.SP]::PO(((($Countx % 10) * 30) + 10 + 5),((($County % 31) * 30) + 10 + 35))
        $_.Add_Click({[System.Windows.Forms.Clipboard]::SetText($This.Text); $Text.Text+=$This.Text})
        $_.Add_MouseHover({$ToolTip.Show(([Char]::ConvertToUtf32($This.Text, 0)), $This)})
        $_.Add_MouseEnter({$This.Size = [Emoji.SP]::SI(50, 50); $This.Font = New-Object System.Drawing.Font('Segoe UI Emoji',30,[System.Drawing.FontStyle]::Regular)})
        $_.Add_MouseLeave({$This.Size = [Emoji.SP]::SI(25, 25); $This.Font = New-Object System.Drawing.Font('Segoe UI Emoji',12,[System.Drawing.FontStyle]::Regular)})
        $_.Parent = $Window
        $_
    }

    $Countx++
    If($Countx % 10 -eq 0)
    {
        $County++
    }
})

$Text = [Emoji.TB]::New(237, 25, 42, 990, '')
$Text.Font = New-Object System.Drawing.Font('Segoe UI Emoji',12,[System.Drawing.FontStyle]::Regular)
$Text.Add_MouseDown({If($_.Button -eq 'right'){$This.Text = ''}Else{If($This.Text.Length -ge 1){[System.Windows.Forms.Clipboard]::SetText($This.Text)}Else{[System.Windows.Forms.Clipboard]::SetText(' ')}}})
$Text.Parent = $Window

$Window.ShowDialog()
}

If($(Try{[Void][PSObject]::New()}Catch{$True})){
    $MainBlock = ($MainBlock.toString().Split([System.Environment]::NewLine) | %{
        $FlipFlop = $True
    }{
        If($FlipFLop){$_}

        $FlipFlop = !$FlipFlop
    } | %{
        If($_ -match '::New\('){
            (($_.Split('[')[0]+'(New-Object '+$_.Split('[')[-1]+')') -replace ']::New',' -ArgumentList ').Replace(' -ArgumentList ()','')
        }Else{
            $_
        }
    }) -join [System.Environment]::NewLine
}
$MainBlock = [ScriptBlock]::Create($MainBlock)
$MainBlock.Invoke()
