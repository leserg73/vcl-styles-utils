
unit Vcl.Styles.NewCheckListBox;

interface

uses
 Vcl.StdCtrls,
 Vcl.Controls,
 Winapi.Messages;

type
  /// <summary> The <c>TEditStyleHookColor</c> vcl style hook allows you to use custom colors in the TCustomEdit descendent components
  /// </summary>
  /// <remarks>
  /// You can use this hook on these components
  /// TEdit, TButtonedEdit, TMaskEdit, TEditStyleHookColor
  /// <code>
  /// TStyleManager.Engine.RegisterStyleHook(TEdit, TEditStyleHookColor);
  /// </code>
  /// </remarks>
  TEditStyleHookColor = class(TMemoStyleHook)
  strict private
    procedure UpdateColors;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AControl: TWinControl); override;
  end;

implementation

Uses
  System.UITypes,
  Winapi.Windows,
  Vcl.Graphics,
  Vcl.Themes,
  Vcl.Styles;


type
 TWinControlClass= class(TWinControl);


constructor TEditStyleHookColor.Create(AControl: TWinControl);
begin
  inherited;
  UpdateColors;
end;

procedure TEditStyleHookColor.UpdateColors;
var
  LStyle: TCustomStyleServices;
begin
 if Control.Enabled then
 begin
  Brush.Color := TWinControlClass(Control).Color;
  FontColor   := TWinControlClass(Control).Font.Color;
 end
 else
 begin
  LStyle := StyleServices;
  Brush.Color := LStyle.GetStyleColor(scEditDisabled);
  FontColor := LStyle.GetStyleFontColor(sfEditBoxTextDisabled);
 end;
end;

procedure TEditStyleHookColor.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    CN_CTLCOLORMSGBOX..CN_CTLCOLORSTATIC:
      begin
        UpdateColors;
        SetTextColor(Message.WParam, ColorToRGB(FontColor));
        SetBkColor(Message.WParam, ColorToRGB(Brush.Color));
        Message.Result := LRESULT(Brush.Handle);
        Handled := True;
      end;
    CM_ENABLEDCHANGED:
      begin
        UpdateColors;
        Handled := False;
      end
  else
    inherited WndProc(Message);
  end;
end;

end.
