pageextension 50306 "CSD User Setup" extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field("CSD Allowed change Bank Acc.";Rec."CSD Allowed change Bank Acc.")
            {
                ApplicationArea=All;
            }
        }
    }
}