/*  
    $VER: EjectADF 1.0 (23.05.2021)

    Eject one or more ADF(s) via Workbench tools menu for AmigaOS 3.2
    Michael Spindler - michael@amigaunix.de
*/

Address WORKBENCH
OPTIONS RESULTS

GETATTR WINDOW.ICONS.SELECTED NAME root STEM icon_selection

Address COMMAND 'C:DAControl INFO >ram:adftemp';

IF OPEN(tempFile, "ram:adftemp", read) THEN DO
    DO nCount = 1 UNTIL EOF(tempFile)
        contents.nCount = Readln(tempFile);
        PARSE VAR contents.nCount devName OtherStuff
        
        Do selCount = 0 to icon_selection.count-1
            FileName = icon_selection.selCount.Name;
        
            IF(SubStr(RIGHT(SubWord(OtherStuff, 5,1), Length(FileName) + 4),1, Length(FileName)) = FileName) THEN DO
                 ADDRESS COMMAND 'C:DAControl EJECT DEVICE ' devName || ':';
            END
        END        
     END
END;