codeunit 50300 "CSD Subscription Mgt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure UpdateSubscriptions(SalesInvHdrNo: Code[20])
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        CustomerSubscription: Record "CSD Customer Subscription";
        Subscription: Record "CSD Subscription";
    begin
        OnBeforePostingSalesDocUpdateSubscriptionsSetFilters(SalesInvoiceLine);
        SalesInvoiceLine.SetFilter("Document No.", SalesInvHdrNo);
        if SalesInvoiceLine.FindSet() then
            repeat
                OnBeforePostingSalesDocUpdateSubscriptions(CustomerSubscription, SalesInvoiceLine);
                CustomerSubscription.SetRange("Customer No.", SalesInvoiceLine."Sell-to Customer No.");
                CustomerSubscription.SetRange("Item No.", SalesInvoiceLine."No.");
                if CustomerSubscription.FindFirst() then begin
                    CustomerSubscription."Last Invoice Date" := SalesInvoiceLine."Posting Date";
                    Subscription.GET(CustomerSubscription."Subscription Code");
                    CustomerSubscription."Next Invoice Date" := CalcDate(Subscription."Invoicing Frequence", CustomerSubscription."Last Invoice Date");
                    CustomerSubscription.Modify();
                end;
            until SalesInvoiceLine.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostingSalesDocUpdateSubscriptions(var CustomerSubscription: Record "CSD Customer Subscription"; SalesInvoiceLine: Record "Sales Invoice Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostingSalesDocUpdateSubscriptionsSetFilters(var SalesInvoiceLine: Record "Sales Invoice Line")
    begin
    end;
}