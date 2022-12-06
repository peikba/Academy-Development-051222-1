codeunit 50303 "CSD Test Runner"
{
    Subtype=TestRunner;
    trigger OnRun()
    begin
        Codeunit.Run(Codeunit::"CSD Test Solution");
    end;
}