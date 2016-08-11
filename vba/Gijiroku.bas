Attribute VB_Name = "Gijiroku"
Dim lineno As Integer
Dim actions As Integer
Dim todos As Integer
Dim curpos As Range
Const ALLOW As String = "->"

Sub GoHome()
    ActiveDocument.Range(0, 0).Select
End Sub

Sub MoveToTodo(no)
    GoHome
    
    '指定した番号分の行がなければ追加する
    Selection.MoveStart unit:=wdTable, Count:=3
    Do While Selection.Tables.Item(1).Rows.Count <= no
        Selection.Tables.Item(1).Rows.Add
    Loop
    
    Selection.MoveDown unit:=wdLine, Count:=no
End Sub

Sub MoveToAction(no)
    GoHome
    
    '指定した番号分の行がなければ追加する
    Selection.MoveStart unit:=wdTable, Count:=2
    Do While Selection.Tables.Item(1).Rows.Count <= no
        Selection.Tables.Item(1).Rows.Add
    Loop
    
    Selection.MoveDown unit:=wdLine, Count:=no
End Sub

Sub MoveToActionText()
    '宿題事項/決定事項が記載されている列の先頭（ヘッダ除く）に移動
    GoHome
    Selection.MoveStart unit:=wdTable, Count:=4
    Selection.MoveDown unit:=wdLine, Count:=2
    Selection.MoveRight unit:=wdCell
    Selection.MoveLeft unit:=wdCharacter, Count:=1
End Sub

Sub MoveToContentText()
    '議事内容が記載されている列の先頭（ヘッダ除く）に移動
    GoHome
    Selection.MoveStart unit:=wdTable, Count:=4
    Selection.MoveDown unit:=wdLine, Count:=1
    Selection.MoveRight unit:=wdCell
    Selection.MoveLeft unit:=wdCharacter, Count:=1
End Sub

Function SelectLine()
    '現在の行列番号を保存
    c = Selection.Information(wdStartOfRangeColumnNumber)
    r = Selection.Information(wdFirstCharacterLineNumber)
    
    '空白行判定（右に1文字移動してみて別の行列が移動したら空白行）
    Selection.MoveRight unit:=wdCharacter, Count:=1
    If (Selection.Information(wdStartOfRangeColumnNumber) <> c) Or (Selection.Information(wdFirstCharacterLineNumber) <> r) Then
        Selection.MoveLeft unit:=wdCharacter, Count:=1
        SelectLine = ""
    Else
        '空白行でなければ1行選択
        Selection.Paragraphs(1).Range.Select
        Selection.MoveLeft unit:=wdCharacter, Count:=1, Extend:=wdExtend
        SelectLine = Selection.text
    End If
    
    lineno = Selection.Information(wdFirstCharacterLineNumber)
End Function

Sub MoveToLeftColumn()
    Selection.MoveLeft unit:=wdCell
    Selection.Collapse direction:=wdCollapseStart
    
    'カーソルがセルの先頭に設定されるので、移動前と同じ行まで戻す
    MoveLineNo
End Sub

Sub MoveToRightColumn()
    Selection.MoveRight unit:=wdCell
    Selection.Collapse direction:=wdCollapseStart
    
    'カーソルがセルの先頭に設定されるので、移動前と同じ行まで戻す
    MoveLineNo
End Sub

Sub MoveLineNo()
    Dim templineno As Integer
    Dim c As Integer
    c = 0
    
    templineno = Selection.Information(wdFirstCharacterLineNumber)
    Do While lineno > templineno
        '無限ループ防止用の保険
        If c > 20 Then Exit Sub
        c = c + 1
        
        Selection.MoveDown unit:=wdLine, Count:=1
        
        '行が不足していて別のセルに移動した場合は戻って改行を挿入
        If Selection.Information(wdFirstCharacterLineNumber) <= templineno Then
            Selection.MoveUp unit:=wdLine, Count:=1
            Selection.TypeText (Chr(13))
        End If
        
        templineno = Selection.Information(wdFirstCharacterLineNumber)
    Loop
End Sub

Sub AddTodo(no, content, name)
    MoveToTodo (no)
    
    SelectLine
    Selection.TypeText (no)
    
    MoveToRightColumn
    SelectLine
    Selection.TypeText (content)
    
    MoveToRightColumn
    MoveToRightColumn
    SelectLine
    Selection.TypeText (name)
End Sub

Sub AddAction(no, content)
    MoveToAction (no)
    
    SelectLine
    Selection.TypeText (no)
    
    MoveToRightColumn
    SelectLine
    Selection.TypeText (content)
End Sub

Function HasArrow(line)
    HasArrow = (Left(line, 2) = ALLOW) Or (Left(line, 3) = " " & ALLOW)
End Function

Function TrimArrow(line)
    Dim ar As String
    
    ar = ALLOW
    If Left(line, 1) = " " Then ar = " " & ALLOW
    
    TrimArrow = Right(line, Len(line) - Len(ar))
End Function

Sub ResetPosition()
    Selection.SetRange Start:=curpos.Start, End:=curpos.End
End Sub

Function GetContent()
    Dim line As String
    Dim buff As String
    Dim i As Integer
    
    GetContent = ""
    
    line = SelectLine
    If line = "" Then Exit Function
    If HasArrow(line) Then line = TrimArrow(line)
    
    buff = line
    
    '同じ人の発言をまとめて取得
    i = 0
    Selection.MoveDown unit:=wdLine, Count:=1
    line = SelectLine
    Do While (Not HasArrow(line)) And (line <> "")
        '無限ループ防止用の保険
        If i > 10 Then Exit Function
        i = i + 1
        
        buff = buff & Chr(13) & line
        
        Selection.MoveDown unit:=wdLine, Count:=1
        line = SelectLine
    Loop
    
    GetContent = buff
End Function

Sub SetIndent()
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find.Replacement.ParagraphFormat
        .SpaceBeforeAuto = False
        .SpaceAfterAuto = False
        .FirstLineIndent = MillimetersToPoints(1.8)
        .CharacterUnitFirstLineIndent = 1
        .WordWrap = True
    End With
    With Selection.Find
        .text = "->"
        .Replacement.text = "->"
        .Forward = True
        .Wrap = wdFindContinue
        .Format = True
        .MatchCase = False
        .MatchWholeWord = False
        .MatchByte = False
        .MatchAllWordForms = False
        .MatchSoundsLike = False
        .MatchWildcards = False
        .MatchFuzzy = True
    End With
    Selection.Find.Execute Replace:=wdReplaceAll
End Sub

Sub GijirokuFormat()
    Dim line As String
    Dim content As String
    Dim name As String
    Dim i As Integer
    
    i = 0
    todos = 1
    actions = 1
    
    Application.ScreenUpdating = False
    
    MoveToActionText
    
    Do While Selection.Information(wdWithInTable)
        '無限ループ防止用の保険
        If i > 200 Then Exit Sub
        i = i + 1
        
        'セクション？行をスキップ
        If Selection.Information(wdStartOfRangeColumnNumber) = 1 Then
            Selection.MoveDown unit:=wdLine, Count:=1
        End If
        If Selection.Information(wdStartOfRangeColumnNumber) = 1 Then MoveToRightColumn
        If Selection.Information(wdStartOfRangeColumnNumber) = 3 Then MoveToLeftColumn
        
        'テキストを取得
        line = SelectLine
        Set curpos = Selection.Range
        
        If Left(line, 4) = "宿題事項" Then
            Selection.TypeText ("宿題事項#" & todos)
            
            MoveToLeftColumn
            content = GetContent
            ResetPosition
            
            MoveToRightColumn
            name = SelectLine
            ResetPosition
            
            AddTodo todos, content, name
            ResetPosition
            
            todos = todos + 1
        ElseIf Left(line, 4) = "決定事項" Then
            Selection.TypeText ("決定事項" & actions)
            
            MoveToLeftColumn
            content = GetContent
            ResetPosition
            
            AddAction actions, content
            ResetPosition
            
            actions = actions + 1
        End If
        
        Selection.MoveDown unit:=wdLine, Count:=1
    Loop
    
    
    SetIndent
    
    GoHome
    
    Application.ScreenUpdating = True
End Sub

