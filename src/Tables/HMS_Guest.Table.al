/// <summary>
/// Table HMS Guest
/// Represents a hotel guest with personal and contact information
/// </summary>
table 50001 "HMS Guest"
{
    Caption = 'HMS Guest';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Guest No."; Code[20])
        {
            Caption = 'Guest No.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        
        field(3; Email; Text[80])
        {
            Caption = 'Email';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
            
            trigger OnValidate()
            begin
                if Email <> '' then
                    if not Email.Contains('@') then
                        Error('Invalid email format');
            end;
        }
        
        field(4; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
        }
        
        field(5; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        
        field(6; City; Text[50])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        }
        
        field(7; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
        }
        
        field(8; Country; Text[50])
        {
            Caption = 'Country';
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Guest No.")
        {
            Clustered = true;
        }
        key(NameKey; Name)
        {
        }
        key(EmailKey; Email)
        {
        }
    }
    
    trigger OnInsert()
    begin
        if "Guest No." = '' then
            Error('Guest number is required');
        if Name = '' then
            Error('Guest name is required');
    end;
    
    trigger OnDelete()
    var
        Booking: Record "HMS Booking";
    begin
        Booking.SetRange("Guest No.", "Guest No.");
        Booking.SetFilter("Booking Status", '<>%1', Booking."Booking Status"::Cancelled);
        Booking.SetFilter("Booking Status", '<>%1', Booking."Booking Status"::"Checked-Out");
        if not Booking.IsEmpty() then
            Error('Cannot delete guest %1. Active bookings exist for this guest.', Name);
    end;
}
