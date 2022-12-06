codeunit 50304 "CSD Test Solution"
{
    Subtype = Test;

    [Test]
    procedure TestPostingInvoices()
    begin
        CreateandPostSalesOrder(CreateCustomer(), CreateItem());
        asserterror
        Error('Ups');
    end;

    local procedure CreateCustomer(): code[20]
    var
        Cust: Record Customer;
        CustomerTemplMgt: Codeunit "Customer Templ. Mgt.";
        CustomerTempl: Record "Customer Templ.";
    begin
        Cust.Insert(true);
        Cust.Name := 'Automatic Created';
        CustomerTempl.Get('KUNDENS VIRKSOMHED');
        CustomerTemplMgt.ApplyCustomerTemplate(Cust, CustomerTempl);
        Cust.Modify();
        exit(cust."No.");
    end;

    local procedure CreateItem(): code[20]
    var
        Item: Record Item;
        ItemTemplMgt: Codeunit "Item Templ. Mgt.";
        ItemTempl: Record "Item Templ.";
    begin
        Item.Insert(true);
        Item.Description := 'Automatic Created';
        ItemTempl.Get('VARE');
        ItemTemplMgt.ApplyItemTemplate(Item, ItemTempl);
        Item.Modify();
        exit(Item."No.");
    end;

    local procedure CreateandPostSalesOrder(inCustNo: code[20]; inItemNo: code[20])
    var
        SalesOrder: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesOrder."Document Type" := SalesOrder."Document Type"::Order;
        SalesOrder.Insert(true);
        SalesOrder.Ship := true;
        SalesOrder.Invoice := true;
        SalesOrder.Validate("Sell-to Customer No.", inCustNo);
        SalesOrder.Validate("Posting Date", Today());
        SalesOrder.Modify();
        Salesline."Document Type" := SalesOrder."Document Type";
        Salesline."Document No." := SalesOrder."No.";
        Salesline."Line No." := 10000;
        Salesline.Insert();
        Salesline.Validate(Type, Salesline.Type::Item);
        Salesline.Validate("No.", InItemNo);
        Salesline.Validate(Quantity, 1);
        Salesline.Validate("Unit Price", 4000);
        Salesline.Modify();
        Codeunit.Run(Codeunit::"Sales-Post", SalesOrder);
    end;
}