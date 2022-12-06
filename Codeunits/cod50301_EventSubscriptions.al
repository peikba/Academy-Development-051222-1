codeunit 50301 "CSD Event Subscriptions"
{
    //################# Sales Subscriptions ##############
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure SendEmailOnAfterPostShipment(var SalesHeader: Record "Sales Header"; SalesShptHdrNo: Code[20])
    var
        SalesShipHdr: Record "Sales Shipment Header";
        MailFunctions: Codeunit "Mail Functions";
    begin
        if not SalesHeader.Ship then
            exit;
        if SalesShipHdr.Get(SalesShptHdrNo) then
            MailFunctions.SendDeliveryNoteByMail(SalesShipHdr);
    end;
    //################# Purchase Subscriptions ##############

    //################# Finance Subscriptions ##############
    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'Bank Account No.', true, true)]
    local procedure TestIfAllowedChangeBankAccount(var Rec: Record "Vendor Bank Account")
    begin
        TestIfAllowedChangeBank(Rec);
    end;
    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'Bank Branch No.', true, true)]
    local procedure TestIfAllowedChangeBankBranch(var Rec: Record "Vendor Bank Account")
    begin
        TestIfAllowedChangeBank(Rec);
    end;

    local procedure TestIfAllowedChangeBank(VendorBank: Record "Vendor Bank Account")
    var
        UserSetup: Record "User Setup";
        ErrorMessageTxt: Label 'User %1 does not have permissions to change %2';
    begin
        if not UserSetup.Get(UserId) then
            Error(ErrorMessageTxt, UserId, VendorBank.TableCaption);

        if not UserSetup."CSD Allowed change Bank Acc." then
            Error(ErrorMessageTxt, UserId, VendorBank.TableCaption);
    end;
}