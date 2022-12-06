codeunit 50302 "Mail Functions"
{
    procedure SendDeliveryNoteByMail(inShipShipHeader: Record "Sales Shipment Header");
    var
        Customer: Record Customer;
        ReportSelection: Record "Report Selections";
        RecordLink: Record "Record Link";
        RecRef: RecordRef;
        ConfirmTxt: Label 'Send mail to %1 and including %2 attachments';
        MailToAddress: List of [Text];
        RecipientList: List of [Text];
        BCCList: List of [Text];

    begin
        Customer.get(inShipShipHeader."Sell-to Customer No.");
        if MailToAddress.Count = 0 then begin
            Customer.TestField("E-Mail");
            MailToAddress.Add(Customer."E-Mail");
        end;


        RecRef.OPEN(Database::"Sales Shipment Header");
        RecRef.GETTABLE(inShipShipHeader);
        RecordLink.setrange("Record ID", RecRef.RecordId());

        if GuiAllowed() then
            if NOT CONFIRM(ConfirmTxt, false, MailToAddress, RecordLink.Count()) then
                EXIT;

        ReportSelection.setrange(Usage, ReportSelection.Usage::"S.Shipment");
        ReportSelection.SetRange("Use for Email Attachment", true);
        inShipShipHeader.SetRecFilter();
        if ReportSelection.FindSet() then
            repeat
                ReportSelection.SendEmailToCust(ReportSelection.Usage::"S.Shipment".AsInteger(),
                                                inShipShipHeader,
                                                inShipShipHeader."No.",
                                                '',
                                                false,
                                                inShipShipHeader."Sell-to Customer No.");
            until ReportSelection.Next() = 0;
    end;
}