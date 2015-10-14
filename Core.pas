unit Core;

interface
  uses
    SysUtils,
    RegExpr;

  type
    TL2Coord = array[0..2] of integer;
    TL2Path = array of TL2Coord;
    TL2MenuPath = array of string;

  function ToVillageIfDead: Boolean;
  function ToVillageIfNoBuff(BuffName: string): Boolean;
  procedure GoToGateKeeper(villageName: string);
  procedure Teleport(Npc: TL2Npc; MenuPath: TL2MenuPath);
  procedure ApplyBuff(Npc: TL2Npc; MenuPath: TL2MenuPath);
  function GoToSpot(MapName: string; CheckPoint: TL2Coord; Path: TL2Path): Boolean;
  procedure Farm;

implementation

  function ToVillageIfDead: Boolean;
  begin
    Result:=false;
    if User.Dead then
    begin
        Result:=true;
        Engine.Delay(1000);
        Engine.FaceControl(0, false);
        Engine.GoHome();
        Engine.Delay(10000);
    end;
  end;

  function ToVillageIfNoBuff(BuffName: string): Boolean;
  var Buff: TL2Buff;
  begin
    Result := false;
    if not User.Buffs.ByName(BuffName, Buff) or (Buff.EndTime < 30000) then
    begin
      Result := true;
      Engine.FaceControl(0, false);
      Engine.Unstuck();
      Engine.Delay(20000);
    end;
  end;

	procedure GoToGateKeeper(villageName: string);
  var NPC: TL2Npc;
	begin
		//Rune
		if villageName = 'Rune' then
		begin
      if User.inrange(38608,-47168,896, 250, 150)
      or User.inrange(38272,-49008,896, 250, 150)
      or User.inrange(38752,-47792,896, 250, 150)
      or User.inrange(38112,-49792,896, 250, 150)
      or User.inrange(38848,-48640,896, 250, 150)
      or User.inrange(38195,-46967,896, 250, 150) then begin
        Engine.MoveTo(39113,-48225,898);
        Engine.MoveTo(38294,-48089,898);

        NpcList.ByID(31698,NPC);
        Engine.SetTarget(NPC);
        Engine.DlgOpen;
        Engine.DlgSel(1);
        Engine.DlgSel(1);  
        Engine.CancelTarget;
        Delay(3000);

        Engine.MoveTo(39522,-48234,-784);
        Engine.MoveTo(41591,-48221,-801);
        Engine.MoveTo(43323,-48185,-795);
        Engine.MoveTo(43827,-47698,-794);
      end;
      if User.inrange(44368,-50592,-792, 250, 150) then begin
        Engine.MoveTo(44368,-50592,-792);
        Engine.MoveTo(43997,-49427,-795);
        Engine.MoveTo(43831,-48480,-795); 
        Engine.MoveTo(43827,-47698,-794);
      end;
      if User.inrange(44864,-47824,-792, 250, 150) then begin
        Engine.MoveTo(44864,-47824,-792);
        Engine.MoveTo(44025,-47893,-795);
        Engine.MoveTo(43827,-47698,-794);
      end;
      if User.inrange(43536,-50416,-792, 250, 150) then begin
        Engine.MoveTo(43536,-50416,-792);
        Engine.MoveTo(43833,-49293,-795);
        Engine.MoveTo(43847,-48397,-795); 
        Engine.MoveTo(43827,-47698,-794);
      end;
      if User.inrange(45632,-47968,-792, 250, 150) then begin
        Engine.MoveTo(45632,-47968,-792);
        Engine.MoveTo(44070,-47930,-795); 
        Engine.MoveTo(43827,-47698,-794);
      end;
      if User.inrange(45824,-49056,-792, 250, 150) then begin
        Engine.MoveTo(45824,-49056,-792);
        Engine.MoveTo(46022,-48351,-795);
        Engine.MoveTo(45441,-48000,-795);
        Engine.MoveTo(44189,-47900,-795);
        Engine.MoveTo(43827,-47698,-794);
      end;
      if User.inrange(44000,-49952,-792, 250, 150) then begin
        Engine.MoveTo(44000,-49952,-792);
        Engine.MoveTo(43862,-48669,-795); 
        Engine.MoveTo(43827,-47698,-794);
      end;
      if User.inrange(43792,-48928,-792, 250, 150) then begin
        Engine.MoveTo(43792,-48928,-792); 
        Engine.MoveTo(43827,-47698,-794);
      end;
      if User.inrange(45072,-49936,-792, 250, 150) then begin
        Engine.MoveTo(45072,-49936,-792);
        Engine.MoveTo(44258,-49647,-795);
        Engine.MoveTo(43864,-48552,-795); 
        Engine.MoveTo(43827,-47698,-794);
      end;
      if User.inrange(43408,-51120,-792, 250, 150) then begin
        Engine.MoveTo(43408,-51120,-792);
        Engine.MoveTo(43805,-49830,-795);
        Engine.MoveTo(43870,-48626,-795); 
        Engine.MoveTo(43827,-47698,-794);
      end;
      if User.inrange(43744,-47920,-792, 250, 150) then begin
        Engine.MoveTo(43744,-47920,-792); 
        Engine.MoveTo(43827,-47698,-794);
      end;
		end;
	end;

  procedure ApplyBuff(Npc: TL2Npc; MenuPath: TL2MenuPath);
  var Entry: string;
  begin
    Engine.SetTarget(Npc);
    Engine.MoveToTarget();
    Engine.Delay(3000);
    Engine.DlgOpen();
    Engine.Delay(300);
    for Entry in MenuPath do
    begin
      Engine.BypassToServer(ParseBypass(Engine.DlgText, Entry));
      Engine.Delay(300);
    end;
    Engine.Delay(2000);
  end;

  procedure Teleport(Npc: TL2Npc; MenuPath: TL2MenuPath);
  var Entry: string;
  begin
    Engine.SetTarget(Npc);
    Engine.DlgOpen();
    Engine.Delay(300);
    for Entry in MenuPath do
    begin
      Engine.DlgSel(Entry);
      Engine.Delay(300);
    end;
    Engine.Delay(10000);
  end;

  function GoToSpot(MapName: string; CheckPoint: TL2Coord; Path: TL2Path): Boolean;
  var
    Coord: TL2Coord;
    i: Cardinal;
  begin
    Result := false;
    if User.InRange(CheckPoint[0], CheckPoint[1], CheckPoint[2], 150) then
    begin
      Engine.LoadZone(MapName);
      Engine.FaceControl(0, true);
      for i := 0 to High(Path) do
      begin
        if i = High(Path) - 3 then Engine.FaceControl(0, false);
        Coord := Path[i];
        Engine.MoveTo(Coord[0], Coord[1], Coord[2]);
      end;
      Result := true;
    end;
  end;

  procedure Farm;
  begin
    Engine.FaceControl(0, true);
  end;

  function ParseBypass(Source, Keyword: string): string;
  var
      RegExp: TRegExpr;
      s: string;
      r: array of string;
      i: Cardinal;
  begin
      Result := '';
      r := ['<button[^>]+?value="' + Keyword + '[^>]*?>', '<a[^>]+?>' + Keyword + '</a>'];
      for s in r do
      begin
          RegExp := TRegExpr.Create;
          RegExp.Expression := s;
          if RegExp.Exec(Source) then
          begin
              Result := RegExp.Match[0];
              Break;
          end;
      end;

      if Result <> '' then
      begin
          RegExp := TRegExpr.Create;
          RegExp.Expression := 'action="bypass -h ([^"]+?)"';
          if RegExp.Exec(Result) then
          begin
              Result := RegExp.Match[1];
          end
          else
          begin
              Result := '';
          end;
      end;
  end;

begin

end.