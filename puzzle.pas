unit puzzle;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    PB: TPaintBox;
    Timer1: TTimer;
    BReset: TButton;
    GroupBox1: TGroupBox;
    RB2: TRadioButton;
    RB3: TRadioButton;
    GBRot: TGroupBox;
    RBS1: TRadioButton;
    RBS2: TRadioButton;
    RBS5: TRadioButton;
    BScramble: TButton;
    RB5: TRadioButton;
    TimerFlare: TTimer;
    ButtonRotate: TButton;
    ButtonReflect: TButton;
    CBDisk: TCheckBox;
    GroupBox2: TGroupBox;
    CBOrient: TCheckBox;
    CBId: TCheckBox;
    CBMDir: TCheckBox;
    procedure PBPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BScrambleClick(Sender: TObject);
    procedure PBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure CBOrientClick(Sender: TObject);
    procedure BResetClick(Sender: TObject);
    procedure RB2Click(Sender: TObject);
    procedure RB3Click(Sender: TObject);
    procedure RBS1Click(Sender: TObject);
    procedure RBS2Click(Sender: TObject);
    procedure RBS5Click(Sender: TObject);
    procedure CBDiskClick(Sender: TObject);
    procedure RB5Click(Sender: TObject);
    procedure TimerFlareTimer(Sender: TObject);
    procedure ButtonRotateClick(Sender: TObject);
    procedure ButtonReflectClick(Sender: TObject);
    procedure CBIdClick(Sender: TObject);
  private

  public
    procedure resetPuzzle;
  end;

  TDPoint = record
    X: Double;
    Y: Double;
  end;

  TIndices = 0 .. 70; // indices of the pentagons

var
  Form1: TForm1;

const
  pg: array [0 .. 4] of TDPoint = ((X: 0; Y: 1), (X: - 0.951056516295154;
    Y: 0.309016994374947), (X: - 0.587785252292473; Y: - 0.809016994374947),
    (X: 0.587785252292473; Y: - 0.809016994374947), (X: 0.951056516295154;
    Y: 0.309016994374947));
  dg: array [0 .. 9] of TDPoint = ((X: 0; Y: 1), (X: - 0.587785252292473;
    Y: 0.809016994374947), (X: - 0.951056516295154; Y: 0.309016994374947),
    (X: - 0.951056516295154; Y: - 0.309016994374947), (X: - 0.587785252292473;
    Y: - 0.809016994374947), (X: 0; Y: - 1), (X: 0.587785252292473;
    Y: - 0.809016994374947), (X: 0.951056516295154; Y: - 0.309016994374947),
    (X: 0.951056516295154; Y: 0.309016994374947), (X: 0.587785252292473;
    Y: 0.809016994374947));
  ori: array [0 .. 70] of Integer = (1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1,
    1, 1, -1, -1, 1, -1, -1, 1, 1, -1, -1, 1, -1, -1, 1, 1, -1, -1, 1, -1, -1,
    1, 1, -1, -1, 1, -1, -1, 1, 1, -1, -1, 1, -1, -1, 1);

  s_sm = 0.07;
  s_lg = 0.2;

  circle: array [0 .. 4, 0 .. 9] of Integer = ((0, 5, 6, 20, 21, 22, 23, 24, 9,
    2), (0, 4, 14, 16, 17, 18, 19, 20, 7, 1), (0, 3, 12, 32, 33, 34, 35, 16, 15,
    5), (0, 2, 10, 28, 29, 30, 31, 32, 13, 4), (0, 1, 8, 24, 25, 26, 27,
    28, 11, 3));
  circleSet: array [0 .. 4] of Set of TIndices = ([0, 5, 6, 20, 21, 22, 23, 24,
    9, 2], [0, 4, 14, 16, 17, 18, 19, 20, 7, 1], [0, 3, 12, 32, 33, 34, 35, 16,
    15, 5], [0, 2, 10, 28, 29, 30, 31, 32, 13, 4], [0, 1, 8, 24, 25, 26, 27,
    28, 11, 3]);
  centCircle: array [0 .. 4, 0 .. 9] of Integer = ((1, 42, 41, 7, 40, 39, 38, 8,
    37, 36), (5, 49, 48, 15, 47, 46, 45, 6, 44, 43), (4, 56, 55, 13, 54, 53, 52,
    14, 51, 50), (3, 63, 62, 11, 61, 60, 59, 12, 58, 57),
    (2, 70, 69, 9, 68, 67, 66, 10, 65, 64));
  centCircleSet: array [0 .. 4] of Set of TIndices = ([1, 42, 41, 7, 40, 39, 38,
    8, 37, 36], [5, 49, 48, 15, 47, 46, 45, 6, 44, 43],
    [4, 56, 55, 13, 54, 53, 52, 14, 51, 50], [3, 63, 62, 11, 61, 60, 59, 12, 58,
    57], [2, 70, 69, 9, 68, 67, 66, 10, 65, 64]);
  incenter: array [0 .. 4] of Set of TIndices = ([1, 7, 8], [5, 15, 6],
    [4, 13, 14], [3, 11, 12], [2, 9, 10]);
  centerturn: array [0 .. 14, 0 .. 4] of Integer = ((0, 0, 0, 0, 0),
    (1, 2, 3, 4, 5), (6, 8, 10, 12, 14), (7, 9, 11, 13, 15),
    (16, 20, 24, 28, 32), (17, 21, 25, 29, 33), (18, 22, 26, 30, 34),
    (19, 23, 27, 31, 35), (36, 64, 57, 50, 43), (37, 65, 58, 51, 44),
    (38, 66, 59, 52, 45), (39, 67, 60, 53, 46), (40, 68, 61, 54, 47),
    (41, 69, 62, 55, 48), (42, 70, 63, 56, 49));
  reflect: array [0 .. 37, 0 .. 1] of Integer = ((0, 0), (1, 1), (2, 5), (3, 4),
    (6, 9), (7, 8), (10, 15), (11, 14), (12, 13), (16, 28), (17, 27), (18, 26),
    (19, 25), (20, 24), (21, 23), (22, 22), (29, 35), (30, 34), (31, 33),
    (32, 32), (36, 42), (37, 41), (38, 40), (39, 39), (43, 70), (44, 69),
    (45, 68), (46, 67), (47, 66), (48, 65), (49, 64), (50, 63), (51, 62),
    (52, 61), (53, 60), (54, 59), (55, 58), (56, 57));

implementation

uses math, MMSystem;
{$R *.dfm}

type
  poly = array [0 .. 4] of TPoint;

var
  p: poly;
  clr, tileID: array [0 .. 70] of Integer;
  // color indices of the pentagons
  twist: array [0 .. 70] of Integer; // twists of the pentagons
  colors: array [0 .. 5] of TColor;
  pencol: TColor;
  cc: array [0 .. 5] of TDPoint; // centers of the circles
  cx, cy: Integer; // center of Canvas
  sz: Integer; // relevant size of Canvas
  ct: array [0 .. 70] of TDPoint; // centers of the pentagons
  isRotating: boolean; // true during rotation
  rotAngle: Double; // rotation angle during rotation
  circleIdx: Integer; // index of the rotating circle
  centerState: array [0 .. 4] of Integer; // used only in interlocking mode
  validCenterHash: array [0 .. 99999] of Int8;

function centerStateHash(var a: array of Integer): Integer;

var
  i: Integer;
begin
  result := 0;
  for i := 4 downto 0 do
  begin
    result := 10 * result + a[i];
  end;

end;

procedure InvCenterStateHash(h: Integer; var a: array of Integer);

var
  i: Integer;
begin

  for i := 0 to 4 do
  begin
    a[i] := h mod 10;
    h := h div 10
  end;

end;

procedure getValidCenterStates;

var
  i, j, k, cnt, cnt2, oldcnt, depth: Integer;
begin
  for i := 0 to 99999 do
    validCenterHash[i] := -1;
  validCenterHash[0] := 0;
  cnt := 1;
  oldcnt := 0;
  depth := 0;
  while oldcnt < cnt do
  begin
    Inc(depth);
    oldcnt := cnt;
    for i := 0 to 99999 do
    begin
      if validCenterHash[i] = depth - 1 then
        InvCenterStateHash(i, centerState);
      for j := 0 to 4 do
      begin
        if (centerState[(j + 1) mod 5] <> 0) and
          (centerState[(j + 1) mod 5] <> 3) then
          continue; // move is blocked
        if (centerState[(j + 4) mod 5] <> 0) and
          (centerState[(j + 4) mod 5] <> 7) then
          continue; // move is blocked

        centerState[j] := (centerState[j] + 1) mod 10; // move clockwise
        // check if in the new state at least two disks are movable.
        // Else we move into a dead end which is useless
        cnt2 := 0;
        for k := 0 to 4 do
        begin
          if (centerState[(k + 1) mod 5] <> 0) and
            (centerState[(k + 1) mod 5] <> 3) then
            continue;
          if (centerState[(k + 4) mod 5] <> 0) and
            (centerState[(k + 4) mod 5] <> 7) then
            continue;
          Inc(cnt2);
        end;
        if (validCenterHash[centerStateHash(centerState)] = -1) and (cnt2 > 1)
        then
        begin
          validCenterHash[centerStateHash(centerState)] := depth;
          Inc(cnt);
        end;

        // undo clockwise turn and move anticlockwise
        centerState[j] := (centerState[j] + 8) mod 10;
        // check if in the new state at least two disks are movable.
        // Else we move into a dead end which is useless
        cnt2 := 0;
        for k := 0 to 4 do
        begin
          if (centerState[(k + 1) mod 5] <> 0) and
            (centerState[(k + 1) mod 5] <> 3) then
            continue;
          if (centerState[(k + 4) mod 5] <> 0) and
            (centerState[(k + 4) mod 5] <> 7) then
            continue;
          Inc(cnt2);
        end;
        if (validCenterHash[centerStateHash(centerState)] = -1) and (cnt2 > 1)
        then
        begin
          validCenterHash[centerStateHash(centerState)] := depth;
          Inc(cnt);
        end;
        // undo anticlockwise turn
        centerState[j] := (centerState[j] + 1) mod 10;
      end;
    end;
  end;
  // maximum depth is 13, 1301 different states
end;

function solidAllowed(n: Integer): boolean;
// true if move is allowed on circle n (0..4)
begin
  if (centerState[(n + 1) mod 5] <> 0) and (centerState[(n + 1) mod 5] <> 3)
  then
    exit(false);

  if (centerState[(n + 4) mod 5] <> 0) and (centerState[(n + 4) mod 5] <> 7)
  then
    exit(false);
  result := true;
end;

// rotate circles (n = 0..4) 36° clockwise  or puzzle 72° (n = 5) clockwise
// or reflect puzzle vertical (n = 6)
procedure move(n: Integer);

var
  i, j, tmp, tmpclr, tmptwist, tmpID: Integer;
begin
  if Form1.CBDisk.Checked and not solidAllowed(n) and (n < 5) then
    exit;

  if n = 6 then
  begin
    for j := 0 to 37 do
    begin
      tmpclr := clr[reflect[j, 0]];
      tmpID := tileID[reflect[j, 0]];
      tmptwist := twist[reflect[j, 0]];
      clr[reflect[j, 0]] := clr[reflect[j, 1]];
      tileID[reflect[j, 0]] := tileID[reflect[j, 1]];
      twist[reflect[j, 0]] := twist[reflect[j, 1]];
      clr[reflect[j, 1]] := tmpclr;
      tileID[reflect[j, 1]] := tmpID;
      twist[reflect[j, 1]] := tmptwist;
      if twist[reflect[j, 0]] <> -1 then
        twist[reflect[j, 0]] := (5 - twist[reflect[j, 0]]) mod 5;
      if (twist[reflect[j, 1]] <> -1) and (reflect[j, 0] <> reflect[j, 1]) then
        twist[reflect[j, 1]] := (5 - twist[reflect[j, 1]]) mod 5;
    end;
    // rotational state of the disk
    centerState[0] := (10 - centerState[0]) mod 10;
    tmp := centerState[1];
    centerState[1] := (10 - centerState[4]) mod 10;
    centerState[4] := (10 - tmp) mod 10;
    tmp := centerState[2];
    centerState[2] := (10 - centerState[3]) mod 10;
    centerState[3] := (10 - tmp) mod 10;
  end
  else if n = 5 then // full puzzle rotation
  begin
    for j := 0 to 14 do
    begin
      tmpclr := clr[centerturn[j, 0]];
      tmpID := tileID[centerturn[j, 0]];
      tmptwist := twist[centerturn[j, 0]];

      for i := 0 to 3 do
      begin
        clr[centerturn[j, i]] := clr[centerturn[j, i + 1]];
        tileID[centerturn[j, i]] := tileID[centerturn[j, i + 1]];
        if twist[centerturn[j, i + 1]] <> -1 then
          twist[centerturn[j, i]] := (twist[centerturn[j, i + 1]] + 2) mod 5
        else
          twist[centerturn[j, i]] := -1;
      end;

      clr[centerturn[j, 4]] := tmpclr;
      tileID[centerturn[j, 4]] := tmpID;
      if tmptwist <> -1 then
        twist[centerturn[j, 4]] := (tmptwist + 2) mod 5
      else
        twist[centerturn[j, 4]] := -1;
    end;

    tmp := centerState[4];
    for i := 4 downto 1 do
      centerState[i] := centerState[(i + 4) mod 5];
    centerState[0] := tmp;

  end
  else if n < 5 then
  begin
    tmpclr := clr[circle[n, 0]];
    tmpID := tileID[circle[n, 0]];
    tmptwist := twist[circle[n, 0]];
    for i := 0 to 8 do
    begin
      clr[circle[n, i]] := clr[circle[n, i + 1]];
      tileID[circle[n, i]] := tileID[circle[n, i + 1]];
      twist[circle[n, i]] := (twist[circle[n, i + 1]] + 1) mod 5;
    end;
    clr[circle[n, 9]] := tmpclr;
    tileID[circle[n, 9]] := tmpID;
    twist[circle[n, 9]] := (tmptwist + 1) mod 5;
    if Form1.CBDisk.Checked then
    begin
      centerState[n] := (centerState[n] + 1) mod 10;
      tmpclr := clr[centCircle[n, 0]];
      tmpID := tileID[centCircle[n, 0]];
      tmptwist := twist[centCircle[n, 0]];
      for i := 0 to 8 do
      begin
        clr[centCircle[n, i]] := clr[centCircle[n, i + 1]];
        tileID[centCircle[n, i]] := tileID[centCircle[n, i + 1]];
        if twist[centCircle[n, i + 1]] <> -1 then
          twist[centCircle[n, i]] := (twist[centCircle[n, i + 1]] + 1) mod 5
        else
          twist[centCircle[n, i]] := -1;
      end;
      clr[centCircle[n, 9]] := tmpclr;
      tileID[centCircle[n, 9]] := tmpID;
      if tmptwist <> -1 then
        twist[centCircle[n, 9]] := (tmptwist + 1) mod 5
      else
        twist[centCircle[n, 9]] := -1;
    end;
  end;
end;

procedure TForm1.CBOrientClick(Sender: TObject);
begin
  PB.Invalidate;
end;

procedure initPuzzle(n: Integer);

var
  i, j: Integer;
begin
  if n = 5 then
  begin
    for i := 0 to 35 do
      clr[i] := 0;
    for i := 0 to 35 do
      for j := 0 to 4 do
        if i in incenter[j] then
          clr[i] := j + 1;

  end
  else if n = 3 then
  begin
    for i := 0 to 5 do
      clr[i] := 2;
    for i := 6 to 15 do
      clr[i] := 1;
    for i := 16 to 35 do
      clr[i] := 0;
  end
  else if n = 2 then
  begin
    // for i := 0 to 35 do
    // clr[i] := 0;
    // clr[0] := 1;
    // clr[2] := 1;
    // clr[5] := 1;

    for i := 0 to 5 do
      clr[i] := 0;
    for i := 6 to 15 do
      clr[i] := 1;
    for i := 16 to 35 do
      clr[i] := 0;
  end;

  for i := 0 to 35 do
    twist[i] := 0;
  for i := 36 to 70 do
    twist[i] := -1;
  for i := 36 to 70 do
    clr[i] := -1;
  for i := 0 to 4 do
    centerState[i] := 0;
  for i := 0 to 70 do
    tileID[i] := i;
end;

procedure TForm1.FormCreate(Sender: TObject);

var
  i: Integer;
begin
  initPuzzle(3);
  colors[0] := clBlack;
  colors[1] := clRed;
  colors[2] := $0000CCFF; // orange
  colors[3] := $0000FFFF; // yellow
  colors[4] := $0000FF00; // green
  colors[5] := $00FF0000; // blue
  pencol := clWHite;
  PB.controlstyle := PB.controlstyle + [csopaque];

  // getValidCenterStates;
end;

function pointRot(p: TDPoint; angle: Double): TDPoint;

var
  w: Double;
begin
  w := angle * pi / 180;
  result.X := p.X * cos(w) - p.Y * sin(w);
  result.Y := p.Y * cos(w) + p.X * sin(w);
end;

function diff(p1, p2: TDPoint): TDPoint;
begin
  result.X := p1.X - p2.X;
  result.Y := p1.Y - p2.Y;
end;

function sum(p1, p2: TDPoint): TDPoint;
begin
  result.X := p1.X + p2.X;
  result.Y := p1.Y + p2.Y;
end;

function prod(p: TDPoint; c: Double): TDPoint;
begin
  result.X := c * p.X;
  result.Y := c * p.Y;
end;

procedure rotate(n: Integer; angle: Double);

var
  i, j, k, cnt: Integer;
  pt, np: TDPoint;
  c: TCanvas;
  fsz: TSize;
begin
  c := Form1.PB.Canvas;
  if n = 5 then // rotation of complete puzzle about center
    cnt := 36
  else
    cnt := 10; // rotation of ring/disk

  for j := 0 to cnt - 1 do // rotate ring/disk or complete puzzle
  begin
    if n < 5 then
      k := circle[n, j] // select index of circle pentagon
    else
    begin
      k := j;
      if clr[k] = -1 then // no pentagon there
        continue;
    end;
    c.Pen.color := clBlack;
    c.Pen.width := 1;
    c.Brush.color := colors[clr[k]];
    for i := 0 to 4 do
    begin
      // move rotation center to origin
      // pt.X := ori[k] * pg[i].X * sz * s_sm + ct[k].X - cc[n].X;
      // pt.Y := ori[k] * pg[i].Y * sz * s_sm + ct[k].Y - cc[n].Y;
      pt := diff(sum(prod(pg[i], ori[k] * sz * s_sm), ct[k]), cc[n]);

      np := pointRot(pt, angle);
      // move back after rotation
      np.X := np.X + cc[n].X;
      np.Y := np.Y + cc[n].Y;
      p[i].X := round(np.X) + cx;
      p[i].Y := round(np.Y) + cy;
    end;
    c.Polygon(p);

    if Form1.CBId.Checked then
    begin
      np := pointRot(diff(ct[k], cc[n]), angle);
      c.Font.color := clWHite;
      c.Font.Size := sz div 30;
      fsz := c.TextExtent(IntToStr(tileID[k]));
      c.TextOut(round(np.X + cc[n].X) + cx - fsz.width div 2,
        round(np.Y + cc[n].Y) + cy - fsz.height div 2, IntToStr(tileID[k]));
    end;

    c.Pen.color := pencol;
    c.Pen.width := sz div 200;

    pt.X := dg[twist[k]].X * sz * s_sm * 0.5 + ct[k].X - cc[n].X;
    pt.Y := dg[twist[k]].Y * sz * s_sm * 0.5 + ct[k].Y - cc[n].Y;
    np := pointRot(pt, angle);
    // move back after rotation
    np.X := np.X + cc[n].X;
    np.Y := np.Y + cc[n].Y;
    c.MoveTo(round(np.X) + cx, round(np.Y) + cy);

    pt.X := dg[(twist[k] + 5) mod 10].X * sz * s_sm * 0.5 + ct[k].X - cc[n].X;
    pt.Y := dg[(twist[k] + 5) mod 10].Y * sz * s_sm * 0.5 + ct[k].Y - cc[n].Y;
    np := pointRot(pt, angle);
    // move back afer rotation
    np.X := np.X + cc[n].X;
    np.Y := np.Y + cc[n].Y;
    if Form1.CBOrient.Checked then
      c.LineTo(round(np.X) + cx, round(np.Y) + cy);
  end;

  if Form1.CBDisk.Checked then
  begin
    if n = 5 then // rotation of complete puzzle about center
      cnt := 35
    else
      cnt := 10; // rotation of ring/disk
    for j := 0 to cnt - 1 do // rotate the three inner pentagons
    begin
      if n < 5 then
        k := centCircle[n, j] // select index of circle pentagon
      else
      begin
        k := j + 36
      end;
      if clr[k] = -1 then // no pentagon there
        continue;

      c.Pen.color := clBlack;
      c.Pen.width := 1;
      c.Brush.color := colors[clr[k]];
      for i := 0 to 4 do
      begin
        // translate rotation center to origin
        // pt.X := ori[k] * pg[i].X * sz * s_sm + ct[k].X - cc[n].X;
        // pt.Y := ori[k] * pg[i].Y * sz * s_sm + ct[k].Y - cc[n].Y;
        pt := diff(sum(prod(pg[i], ori[k] * sz * s_sm), ct[k]), cc[n]);

        np := pointRot(pt, angle);
        // translate back after rotation
        np.X := np.X + cc[n].X;
        np.Y := np.Y + cc[n].Y;
        p[i].X := round(np.X) + cx;
        p[i].Y := round(np.Y) + cy;
      end;
      c.Polygon(p);

      if Form1.CBId.Checked then
      begin
        np := pointRot(diff(ct[k], cc[n]), angle);
        c.Font.color := clWHite;
        c.Font.Size := sz div 30;
        fsz := c.TextExtent(IntToStr(tileID[k]));
        c.TextOut(round(np.X + cc[n].X) + cx - fsz.width div 2,
          round(np.Y + cc[n].Y) + cy - fsz.height div 2, IntToStr(tileID[k]));
      end;

      c.Pen.color := pencol;
      c.Pen.width := sz div 200;

      pt.X := dg[twist[k]].X * sz * s_sm * 0.5 + ct[k].X - cc[n].X;
      pt.Y := dg[twist[k]].Y * sz * s_sm * 0.5 + ct[k].Y - cc[n].Y;
      np := pointRot(pt, angle);
      // translate back after rotation
      np.X := np.X + cc[n].X;
      np.Y := np.Y + cc[n].Y;
      c.MoveTo(round(np.X) + cx, round(np.Y) + cy);

      pt.X := dg[(twist[k] + 5) mod 10].X * sz * s_sm * 0.5 + ct[k].X - cc[n].X;
      pt.Y := dg[(twist[k] + 5) mod 10].Y * sz * s_sm * 0.5 + ct[k].Y - cc[n].Y;
      np := pointRot(pt, angle);
      // translate back afer rotation
      np.X := np.X + cc[n].X;
      np.Y := np.Y + cc[n].Y;
      if Form1.CBOrient.Checked then
        c.LineTo(round(np.X) + cx, round(np.Y) + cy);
    end;
  end;
end;

procedure TForm1.PBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var
  i, dist: Integer;
begin

  dist := maxint;
  for i := 0 to 4 do
    if Sqr(X - cc[i].X - cx) + Sqr(Y - cc[i].Y - cy) < dist then
    begin
      dist := round(Sqr(X - cc[i].X - cx) + Sqr(Y - cc[i].Y - cy));
      circleIdx := i;
    end;

  if CBDisk.Checked and (centerState[(circleIdx + 1) mod 5] <> 0) and
    (centerState[(circleIdx + 1) mod 5] <> 3) then
  // impossible rotation
  begin
    TimerFlare.Tag := 4;
    TimerFlare.Enabled := true;
    exit;
  end;

  if CBDisk.Checked and (centerState[(circleIdx + 4) mod 5] <> 0) and
    (centerState[(circleIdx + 4) mod 5] <> 7) then
  // impossible rotation
  begin
    TimerFlare.Tag := 4;
    TimerFlare.Enabled := true;
    exit;
  end;

  isRotating := true;
  rotAngle := 0;
  Timer1.Enabled := true;
  if Button = mbLeft then
    Timer1.Tag := 1
  else
    Timer1.Tag := -1;
  if CBMDir.Checked then
    Timer1.Tag := Timer1.Tag * (-1);

end;

procedure TForm1.PBPaint(Sender: TObject);

var
  i, k: Integer;
  r, r1: Double;
  fsz: TSize;

begin
  cx := PB.width div 2;
  cy := PB.height div 2;
  sz := min(PB.width, PB.height);

  r := sz * s_lg; // radius of the 5 circles
  for i := 0 to 4 do // centers of the 5 circles
  begin
    cc[i].X := -pg[i].X * r;
    cc[i].Y := -pg[i].Y * r;
  end;
  cc[5].X := 0; // center of puzzle
  cc[5].Y := 0;
  r := sz * s_lg; // radius of the 5 large circles
  r1 := r / (2 * cos(pi / 5) + 1); // radius of the 5 small circles

  ct[0] := sum(cc[0], prod(dg[0], r));
  ct[1] := sum(cc[1], prod(dg[3], r));
  ct[2] := sum(cc[0], prod(dg[1], r));
  ct[3] := sum(cc[2], prod(dg[3], r));
  ct[4] := sum(cc[1], prod(dg[1], r));
  ct[5] := sum(cc[2], prod(dg[5], r));
  ct[6] := sum(cc[0], prod(dg[8], r));
  ct[7] := sum(cc[1], prod(dg[4], r));
  ct[8] := sum(cc[4], prod(dg[6], r));
  ct[9] := sum(cc[0], prod(dg[2], r));
  ct[10] := sum(cc[3], prod(dg[4], r));
  ct[11] := sum(cc[4], prod(dg[0], r));
  ct[12] := sum(cc[2], prod(dg[2], r));
  ct[13] := sum(cc[3], prod(dg[8], r));
  ct[14] := sum(cc[1], prod(dg[0], r));
  ct[15] := sum(cc[2], prod(dg[6], r));
  ct[16] := sum(cc[2], prod(dg[7], r));
  ct[17] := sum(cc[1], prod(dg[8], r));
  ct[18] := sum(cc[1], prod(dg[7], r));
  ct[19] := sum(cc[1], prod(dg[6], r));
  ct[20] := sum(cc[1], prod(dg[5], r));
  ct[21] := sum(cc[0], prod(dg[6], r));
  ct[22] := sum(cc[0], prod(dg[5], r));
  ct[23] := sum(cc[0], prod(dg[4], r));
  ct[24] := sum(cc[0], prod(dg[3], r));
  ct[25] := sum(cc[4], prod(dg[4], r));
  ct[26] := sum(cc[4], prod(dg[3], r));
  ct[27] := sum(cc[4], prod(dg[2], r));
  ct[28] := sum(cc[4], prod(dg[1], r));
  ct[29] := sum(cc[3], prod(dg[2], r));
  ct[30] := sum(cc[3], prod(dg[1], r));
  ct[31] := sum(cc[3], prod(dg[0], r));
  ct[32] := sum(cc[3], prod(dg[9], r));
  ct[33] := sum(cc[2], prod(dg[0], r));
  ct[34] := sum(cc[2], prod(dg[9], r));
  ct[35] := sum(cc[2], prod(dg[8], r));

  if CBDisk.Checked then
  begin
    ct[36] := sum(pointRot(diff(ct[1], cc[0]), 36), cc[0]);
    ct[37] := sum(pointRot(diff(ct[36], cc[0]), 36), cc[0]);
    ct[38] := sum(pointRot(diff(ct[8], cc[0]), 36), cc[0]);
    ct[39] := sum(pointRot(diff(ct[38], cc[0]), 36), cc[0]);
    ct[40] := sum(pointRot(diff(ct[39], cc[0]), 36), cc[0]);
    ct[41] := sum(pointRot(diff(ct[7], cc[0]), 36), cc[0]);
    ct[42] := sum(pointRot(diff(ct[41], cc[0]), 36), cc[0]);

    ct[43] := sum(pointRot(diff(ct[5], cc[1]), 36), cc[1]);
    ct[44] := sum(pointRot(diff(ct[43], cc[1]), 36), cc[1]);
    ct[45] := sum(pointRot(diff(ct[6], cc[1]), 36), cc[1]);
    ct[46] := sum(pointRot(diff(ct[45], cc[1]), 36), cc[1]);
    ct[47] := sum(pointRot(diff(ct[46], cc[1]), 36), cc[1]);
    ct[48] := sum(pointRot(diff(ct[15], cc[1]), 36), cc[1]);
    ct[49] := sum(pointRot(diff(ct[48], cc[1]), 36), cc[1]);

    ct[50] := sum(pointRot(diff(ct[4], cc[2]), 36), cc[2]);
    ct[51] := sum(pointRot(diff(ct[50], cc[2]), 36), cc[2]);
    ct[52] := sum(pointRot(diff(ct[14], cc[2]), 36), cc[2]);
    ct[53] := sum(pointRot(diff(ct[52], cc[2]), 36), cc[2]);
    ct[54] := sum(pointRot(diff(ct[53], cc[2]), 36), cc[2]);
    ct[55] := sum(pointRot(diff(ct[13], cc[2]), 36), cc[2]);
    ct[56] := sum(pointRot(diff(ct[55], cc[2]), 36), cc[2]);

    ct[57] := sum(pointRot(diff(ct[3], cc[3]), 36), cc[3]);
    ct[58] := sum(pointRot(diff(ct[57], cc[3]), 36), cc[3]);
    ct[59] := sum(pointRot(diff(ct[12], cc[3]), 36), cc[3]);
    ct[60] := sum(pointRot(diff(ct[59], cc[3]), 36), cc[3]);
    ct[61] := sum(pointRot(diff(ct[60], cc[3]), 36), cc[3]);
    ct[62] := sum(pointRot(diff(ct[11], cc[3]), 36), cc[3]);
    ct[63] := sum(pointRot(diff(ct[62], cc[3]), 36), cc[3]);

    ct[64] := sum(pointRot(diff(ct[2], cc[4]), 36), cc[4]);
    ct[65] := sum(pointRot(diff(ct[64], cc[4]), 36), cc[4]);
    ct[66] := sum(pointRot(diff(ct[10], cc[4]), 36), cc[4]);
    ct[67] := sum(pointRot(diff(ct[66], cc[4]), 36), cc[4]);
    ct[68] := sum(pointRot(diff(ct[67], cc[4]), 36), cc[4]);
    ct[69] := sum(pointRot(diff(ct[9], cc[4]), 36), cc[4]);
    ct[70] := sum(pointRot(diff(ct[69], cc[4]), 36), cc[4]);
  end;

  for k := 0 to 70 do
  begin
    if isRotating then
    begin
      if circleIdx = 5 then
        break;
      if k in circleSet[circleIdx] then
        continue;
      if CBDisk.Checked and (k in centCircleSet[circleIdx]) then
        continue;
    end;

    if not CBDisk.Checked and (k > 35) then
      break;

    PB.Canvas.Pen.color := clBlack;
    PB.Canvas.Pen.width := 1;
    if clr[k] = -1 then
      continue; // empty

    PB.Canvas.Brush.color := colors[clr[k]];
    for i := 0 to 4 do
    begin
      p[i].X := round(ori[k] * pg[i].X * sz * s_sm + ct[k].X) + cx;
      p[i].Y := round(ori[k] * pg[i].Y * sz * s_sm + ct[k].Y) + cy;
    end;
    PB.Canvas.Polygon(p);

    if Form1.CBId.Checked then
    begin
      PB.Canvas.Font.color := clWHite;
      PB.Canvas.Font.Size := sz div 30;
      fsz := PB.Canvas.TextExtent(IntToStr(tileID[k]));
      PB.Canvas.TextOut(round(ct[k].X) + cx - fsz.width div 2,
        round(ct[k].Y) + cy - fsz.height div 2, IntToStr(tileID[k]));
    end;

    // falls center Polygon gegebenenfalls noch rotieren!
    PB.Canvas.Pen.color := pencol;
    PB.Canvas.Pen.width := sz div 200;
    PB.Canvas.MoveTo(round(dg[twist[k]].X * sz * s_sm * 0.5 + ct[k].X) + cx,
      round(dg[twist[k]].Y * sz * s_sm * 0.5 + ct[k].Y) + cy);
    if CBOrient.Checked then
      PB.Canvas.LineTo(round(dg[(twist[k] + 5) mod 10].X * sz * s_sm * 0.5 +
        ct[k].X) + cx, round(dg[(twist[k] + 5) mod 10].Y * sz * s_sm * 0.5 +
        ct[k].Y) + cy);
  end;
  if isRotating then
    rotate(circleIdx, rotAngle)
end;

procedure TForm1.RB2Click(Sender: TObject);
begin
  initPuzzle(2);
  PB.Invalidate;
end;

procedure TForm1.RB3Click(Sender: TObject);
begin
  initPuzzle(3);
  PB.Invalidate;
end;

procedure TForm1.RB5Click(Sender: TObject);
begin
  initPuzzle(5);
  PB.Invalidate;
end;

procedure TForm1.RBS1Click(Sender: TObject);
begin
  GBRot.Tag := 1;
  resetPuzzle;
end;

procedure TForm1.RBS2Click(Sender: TObject);
begin
  GBRot.Tag := 2;
  resetPuzzle;
end;

procedure TForm1.RBS5Click(Sender: TObject);
begin
  GBRot.Tag := 5;
  resetPuzzle;
end;

procedure TForm1.resetPuzzle;
begin
  if RB2.Checked then
    initPuzzle(2)
  else if RB3.Checked then
    initPuzzle(3)
  else if RB5.Checked then
    initPuzzle(5);
  PB.Invalidate;
end;

procedure TForm1.CBDiskClick(Sender: TObject);
begin
  resetPuzzle;
end;

procedure TForm1.CBIdClick(Sender: TObject);
begin
  PB.Invalidate;
end;

procedure TForm1.Timer1Timer(Sender: TObject);

var
  i, j: Integer;
begin
  if Timer1.Tag = 1 then
  begin
    if circleIdx = 5 then
    begin
      rotAngle := rotAngle + 3.6 * 2;
      if rotAngle > 37 * 2 then
      begin
        Timer1.Enabled := false;
        isRotating := false;
        move(circleIdx);
      end
      else
        PB.Invalidate;
    end
    else
    begin
      rotAngle := rotAngle + 3.6 * GBRot.Tag;
      if rotAngle > 37 * GBRot.Tag then
      begin
        Timer1.Enabled := false;
        isRotating := false;
        for i := 1 to GBRot.Tag do
          move(circleIdx);
      end
      else
        PB.Invalidate;
    end
  end
  else
  begin
    rotAngle := rotAngle - 3.6 * GBRot.Tag;
    if rotAngle < -37 * GBRot.Tag then
    begin
      Timer1.Enabled := false;
      isRotating := false;
      for j := 1 to GBRot.Tag do
        for i := 0 to 8 do
          move(circleIdx);
    end
    else
      PB.Invalidate;
  end
end;

procedure TForm1.TimerFlareTimer(Sender: TObject);
begin
  if Panel1.color = clBtnFace then
  begin
    Panel1.color := clSkyBlue;
  end
  else
    Panel1.color := clBtnFace;
  TimerFlare.Tag := TimerFlare.Tag - 1;
  if TimerFlare.Tag = 0 then
  begin
    Panel1.color := clBtnFace;
    TimerFlare.Enabled := false;
  end;
  PB.Repaint;
end;

procedure TForm1.BResetClick(Sender: TObject);
begin
  resetPuzzle;
end;

procedure TForm1.BScrambleClick(Sender: TObject);

var
  i, j, k, n, m: Integer;
begin
  for i := 1 to 10000 do
  begin
    k := Random(9);
    n := Random(5);
    for j := 0 to k do
      for m := 1 to GBRot.Tag do
        move(n);
  end;
  PB.Invalidate;
end;

procedure TForm1.ButtonReflectClick(Sender: TObject);
begin
  circleIdx := 6;
  move(6);
  PB.Invalidate;
end;

procedure TForm1.ButtonRotateClick(Sender: TObject);
begin
  circleIdx := 5;

  isRotating := true;
  rotAngle := 0;
  Timer1.Enabled := true;
  Timer1.Tag := 1;
end;

end.
