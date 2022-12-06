codeunit 50301 "CSD Event Subscriptions"
{
    //################# Sales Subscriptions ##############
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
local procedure SendEmailOnAfterPostShipment(var SalesHeader: Record "Sales Header";SalesShptHdrNo: Code[20])
var
    SalesShipHdr : Record "Sales Shipment Header";
    MailFunctions:Codeunit "Mail Functions";
begin
    if not SalesHeader.Ship then 
        exit;
    if SalesShipHdr.Get(SalesShptHdrNo) then 
        MailFunctions.SendDeliveryNoteByMail(SalesShipHdr);   
end;
    //################# Purchase Subscriptions ##############

    //################# Finance Subscriptions ##############
}