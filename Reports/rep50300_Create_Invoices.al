report 50300 "CSD Create Invoices"
{
    Caption = 'Create Invoices';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Customer Subscription"; "CSD Customer Subscription")
        {
            RequestFilterFields = "Customer No.", "Item No.";
            trigger OnPreDataItem()
            var
                CreateWarningTxt: Label 'Create Invoices for subscriptions?';
            begin
                if not Confirm(CreateWarningTxt) then
                    exit;
                OnPreDataItemAfterConfirm("Customer Subscription");
                "Customer Subscription".SetRange(Active, true);
                "Customer Subscription".SetFilter("Next Invoice Date", '<=%1', WorkDate());
            end;

            trigger OnAfterGetRecord()
            var
                OldCustomerNo: Code[20];
                OldInvoiceDate: Date;
                NextLineNo: Integer;
                SalesHeader: Record "Sales Header";
                SalesLine: Record "Sales Line";
            begin
                OnBeforeAfterGetRecord("Customer Subscription");
                if ("Customer No." <> OldCustomerNo) or ("Next Invoice Date" <> OldInvoiceDate) then begin
                    OldCustomerNo := "Customer Subscription"."Customer No.";
                    OldInvoiceDate := "Customer Subscription"."Next Invoice Date";
                    NextLineNo := 0;
                    Clear(SalesHeader);
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                    SalesHeader.Insert(true);
                    SalesHeader.Validate("Sell-to Customer No.", "Customer Subscription"."Customer No.");
                    SalesHeader.Validate("Location Code", '');
                    SalesHeader.Validate("Posting Date", "Customer Subscription"."Next Invoice Date");
                    OnBeforeSalesHeaderModify("Customer Subscription", SalesHeader);
                    SalesHeader.Modify();
                    InvoiceCounter += 1;
                end;
                NextLineNo += 10000;
                SalesLine.Init();
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Line No." := NextLineNo;
                SalesLine.Validate("Sell-to Customer No.", "Customer Subscription"."Customer No.");
                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine.Insert(true);
                SalesLine.Validate("No.", "Customer Subscription"."Item No.");
                SalesLine.Validate(Quantity, 1);
                SalesLine.Validate("Allow Line Disc.", "Customer Subscription"."Allow Line Discount");
                SalesLine.Validate("Unit Price", "Customer Subscription"."Invoicing Price");
                SalesLine.Modify();
            end;

            trigger OnPostDataItem()
            var
                InvCounterTxt: Label '%1 Invoices created';
            begin
                Message(InvCounterTxt, InvoiceCounter);
            end;
        }
    }

    var
        InvoiceCounter: Integer;

    [IntegrationEvent(false, false)]
    local procedure OnPreDataItemAfterConfirm("Customer Subscription": Record "CSD Customer Subscription");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAfterGetRecord("Customer Subscription": Record "CSD Customer Subscription");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesHeaderModify("Customer Subscription": Record "CSD Customer Subscription"; var SalesHeader: Record "Sales Header")
    begin
    end;
}