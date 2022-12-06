tableextension 50302 "CSD User Setup" extends "User Setup"
{
    fields
    {
        field(50301; "CSD Allowed change Bank Acc."; Boolean)
        {
            Caption='Allowed to change Bank Account';
            DataClassification = AccountData;
        }
    }
}