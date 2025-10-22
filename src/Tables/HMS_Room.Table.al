/// <summary>
/// Table HMS Room
/// Represents a physical hotel room with properties and availability status
/// </summary>
table 50000 "HMS Room"
{
    Caption = 'HMS Room';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Room No."; Code[20])
        {
            Caption = 'Room No.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        
        field(2; "Room Type"; Enum "HMS Room Type")
        {
            Caption = 'Room Type';
            DataClassification = CustomerContent;
        }
        
        field(3; "Room Status"; Enum "HMS Room Status")
        {
            Caption = 'Room Status';
            DataClassification = CustomerContent;
            InitValue = Available;
        }
        
        field(4; "Rate per Night"; Decimal)
        {
            Caption = 'Rate per Night';
            DataClassification = CustomerContent;
            DecimalPlaces = 2:2;
            MinValue = 0;
            
            trigger OnValidate()
            begin
                if "Rate per Night" < 0 then
                    Error('Rate per night cannot be negative');
            end;
        }
        
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        
        field(6; "Max Occupancy"; Integer)
        {
            Caption = 'Max Occupancy';
            DataClassification = CustomerContent;
            MinValue = 1;
            InitValue = 2;
        }
    }
    
    keys
    {
        key(PK; "Room No.")
        {
            Clustered = true;
        }
        key(TypeStatus; "Room Type", "Room Status")
        {
        }
    }
    
    trigger OnInsert()
    begin
        if "Room No." = '' then
            Error('Room number is required');
    end;
    
    trigger OnDelete()
    var
        Booking: Record "HMS Booking";
    begin
        Booking.SetRange("Room No.", "Room No.");
        Booking.SetFilter("Booking Status", '<>%1', Booking."Booking Status"::Cancelled);
        Booking.SetFilter("Booking Status", '<>%1', Booking."Booking Status"::"Checked-Out");
        if not Booking.IsEmpty() then
            Error('Cannot delete room %1. Active bookings exist for this room.', "Room No.");
    end;
}
