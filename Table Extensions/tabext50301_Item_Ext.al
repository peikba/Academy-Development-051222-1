tableextension 50301 "CSD Item" extends Item
{
    fields
    {
        field(50300; "CSD Subscription Item"; Boolean)
        {
            Caption = 'Subscription Item';
            FieldClass = FlowField;
            CalcFormula = exist("CSD Subscription" where("Item Number" = field("No.")));
            Editable = false;
        }
    }
}