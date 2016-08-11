Attribute VB_Name = "NewMacros"
'TODO: �ʖ��ۑ����t�@�C��Close�ƌJ��Ԃ��e���v���[�g�t�@�C�����J���Ă̏���

Dim workBook, excelApp

Sub Macro1()
    ReplaceAll "�T�[�o([!�[])", "�T�[�o�[\1"
    ReplaceAll "���[�U([!�[])", "���[�U�[\1"
End Sub

Sub ReplaceAll(FromStr As String, ToStr As String)
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .text = FromStr
        .Replacement.text = ToStr
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchByte = False
        .MatchAllWordForms = False
        .MatchSoundsLike = False
        .MatchFuzzy = False
        .MatchWildcards = True
    End With
    Selection.Find.Execute Replace:=wdReplaceAll
End Sub

Sub Test()
    Dim Shap As Shape
    Dim ABC As String
    Dim r As Integer
    Dim i As Integer
    i = 1
    
    OpenExcelFile

    r = 1
    While GetValueFromExcel(r, 1) <> ""
        For Each Shp In ActiveDocument.Shapes
            Shp.TextFrame.TextRange.Find.Execute FindText:="�����@�����@�l", ReplaceWith:=GetValueFromExcel(r, 1), Replace:=wdReplaceAll
            r = r + 1
        Next
    
        newFileName = "hoge" & i & ".docx"
        ActiveDocument.SaveAs2 fileName:=newFileName
        'ActiveWindow.Close
        Documents.Open fileName:="template.docx"
        'Windows(newFileName).Activate
        i = i + 1
    Wend
    
    CloseExcelFile
End Sub

Sub Hoge()
    OpenExcelFile
    MsgBox GetValueFromExcel(1, 1)
    MsgBox GetValueFromExcel(2, 1)
    CloseExcelFile
End Sub

Function GetValueFromExcel(r As Integer, c As Integer)
    GetValueFromExcel = excelApp.Cells(r, c).Value
End Function

Private Function SelectDictionary() As String
    MsgBox "Excel �����t�@�C����I�����Ă��������B"
    
    Dim dlg As Dialog
    Dim dlgFind As Dialog
    Set dlg = Dialogs(wdDialogFileOpen)
    Set dlgFind = Dialogs(wdDialogFileFind)

    With dlg
        .name = "*.xls"
        Select Case .Display
        Case -1 '�t�@�C�����I�����ꂽ�Ƃ�
            dlgFind.Update
            SelectDictionary = dlgFind.SearchPath & "\" & dlg.name
        Case Else '�L�����Z���{�^���������ꂽ�Ƃ�
            SelectDictionary = vbNullString
        End Select
    
    End With
End Function

Private Sub OpenExcelFile()
    Dim fileName As String
    fileName = SelectDictionary
    Set excelApp = CreateObject("Excel.Application")
    Set workBook = excelApp.Workbooks.Open(fileName)
End Sub

Private Sub CloseExcelFile()
    workBook.Close SaveChanges:=False
    excelApp.Quit
End Sub

Sub Macro2()
Attribute Macro2.VB_ProcData.VB_Invoke_Func = "Normal.NewMacros.Macro2"
'
' Macro2 Macro
'
'
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
