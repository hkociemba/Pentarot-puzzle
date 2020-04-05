object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Pentarot'
  ClientHeight = 740
  ClientWidth = 783
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    783
    740)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 788
    Height = 700
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentBackground = False
    ParentDoubleBuffered = False
    TabOrder = 0
    DesignSize = (
      788
      700)
    object PB: TPaintBox
      Left = 0
      Top = 0
      Width = 788
      Height = 700
      Align = alClient
      OnMouseDown = PBMouseDown
      OnPaint = PBPaint
      ExplicitWidth = 650
      ExplicitHeight = 641
    end
    object ButtonReflect: TButton
      Left = 664
      Top = 39
      Width = 105
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Reflect'
      TabOrder = 0
      OnClick = ButtonReflectClick
    end
    object B2PairSwap: TButton
      Left = 23
      Top = 125
      Width = 106
      Height = 25
      Caption = 'Double Pair Swap'
      TabOrder = 1
      OnClick = B2PairSwapClick
    end
    object BPairSwap: TButton
      Left = 23
      Top = 94
      Width = 106
      Height = 25
      BiDiMode = bdLeftToRight
      Caption = 'Single Pair Swap'
      ParentBiDiMode = False
      TabOrder = 2
      OnClick = BPairSwapClick
    end
    object Button1: TButton
      Left = 23
      Top = 46
      Width = 106
      Height = 25
      Caption = 'Single Pair Twist'
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object BReset: TButton
    Left = 624
    Top = 671
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Reset puzzle'
    TabOrder = 1
    OnClick = BResetClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 629
    Width = 121
    Height = 103
    Anchors = [akLeft, akBottom]
    Caption = 'Puzzle type'
    TabOrder = 2
    DesignSize = (
      121
      103)
    object RB2: TRadioButton
      Left = 15
      Top = 22
      Width = 65
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = '2 colors'
      TabOrder = 0
      OnClick = RB2Click
    end
    object RB3: TRadioButton
      Left = 15
      Top = 42
      Width = 66
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = '3 colors'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = RB3Click
    end
    object RB5: TRadioButton
      Left = 15
      Top = 62
      Width = 66
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = '6 colors'
      TabOrder = 2
      OnClick = RB5Click
    end
    object CBDisk: TCheckBox
      Left = 15
      Top = 82
      Width = 145
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = 'Rotate centers'
      TabOrder = 3
      OnClick = CBDiskClick
    end
  end
  object GBRot: TGroupBox
    Tag = 1
    Left = 135
    Top = 651
    Width = 63
    Height = 81
    Anchors = [akLeft, akBottom]
    Caption = 'Step size'
    TabOrder = 3
    Visible = False
    DesignSize = (
      63
      81)
    object RBS1: TRadioButton
      Left = 8
      Top = 20
      Width = 80
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = '36'#176
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RBS1Click
    end
    object RBS2: TRadioButton
      Left = 8
      Top = 40
      Width = 80
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = '72'#176
      TabOrder = 1
      OnClick = RBS2Click
    end
    object RBS5: TRadioButton
      Left = 8
      Top = 60
      Width = 80
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = '180'#176
      TabOrder = 2
      OnClick = RBS5Click
    end
  end
  object BScramble: TButton
    Left = 624
    Top = 702
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Scramble'
    TabOrder = 4
    OnClick = BScrambleClick
  end
  object ButtonRotate: TButton
    Left = 664
    Top = 70
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Rotate'
    TabOrder = 5
    OnClick = ButtonRotateClick
  end
  object GroupBox2: TGroupBox
    Left = 143
    Top = 655
    Width = 145
    Height = 77
    Anchors = [akLeft, akBottom]
    Caption = 'Miscellaneous '
    TabOrder = 6
    DesignSize = (
      145
      77)
    object CBOrient: TCheckBox
      Left = 16
      Top = 20
      Width = 113
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = 'Show orientations'
      TabOrder = 0
      OnClick = CBOrientClick
    end
    object CBId: TCheckBox
      Left = 16
      Top = 40
      Width = 97
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = 'Show tile ID'#39's'
      TabOrder = 1
      OnClick = CBIdClick
    end
    object CBMDir: TCheckBox
      Left = 16
      Top = 60
      Width = 124
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = 'Swap mouse buttons'
      TabOrder = 2
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 5
    OnTimer = Timer1Timer
    Left = 576
    Top = 592
  end
  object TimerFlare: TTimer
    Enabled = False
    Interval = 50
    OnTimer = TimerFlareTimer
    Left = 624
    Top = 592
  end
  object TimerWait: TTimer
    Left = 664
    Top = 592
  end
end
