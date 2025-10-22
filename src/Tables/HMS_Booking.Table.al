/// <summary>
/// Table HMS Booking
/// Represents a hotel booking linking a guest to a room for specific dates
/// </summary>
table 50002 "HMS Booking"
{
    Caption = 'HMS Booking';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Booking No."; Code[20])
        {
            Caption = 'Booking No.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        
        field(2; "Guest No."; Code[20])
        {
            Caption = 'Guest No.';
            DataClassification = CustomerContent;
            TableRelation = "HMS Guest"."Guest No.";
            NotBlank = true;
        }
        
        field(3; "Guest Name"; Text[100])
        {
            Caption = 'Guest Name';
            FieldClass = FlowField;
            CalcFormula = lookup("HMS Guest".Name where("Guest No." = field("Guest No.")));
            Editable = false;
        }
        
        field(4; "Room No."; Code[20])
        {
            Caption = 'Room No.';
            DataClassification = CustomerContent;
            TableRelation = "HMS Room"."Room No.";
            NotBlank = true;
        }
        
        field(5; "Room Type"; Enum "HMS Room Type")
        {
            Caption = 'Room Type';
            FieldClass = FlowField;
            CalcFormula = lookup("HMS Room"."Room Type" where("Room No." = field("Room No.")));
            Editable = false;
        }
        
        field(6; "Check-in Date"; Date)
        {
            Caption = 'Check-in Date';
            DataClassification = CustomerContent;
            NotBlank = true;
            
            trigger OnValidate()
            begin
                ValidateDates();
            end;
        }
        
        field(7; "Check-out Date"; Date)
        {
            Caption = 'Check-out Date';
            DataClassification = CustomerContent;
            NotBlank = true;
            
            trigger OnValidate()
            begin
                ValidateDates();
                CalculateTotalAmount();
            end;
        }
        
        field(8; "Booking Status"; Enum "HMS Booking Status")
        {
            Caption = 'Booking Status';
            DataClassification = CustomerContent;
            InitValue = Confirmed;
            
            trigger OnValidate()
            begin
                UpdateRoomStatus();
            end;
        }
        
        field(9; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2:2;
            Editable = false;
        }
        
        field(10; "Rate per Night"; Decimal)
        {
            Caption = 'Rate per Night';
            FieldClass = FlowField;
            CalcFormula = lookup("HMS Room"."Rate per Night" where("Room No." = field("Room No.")));
            Editable = false;
        }
        
        field(11; "No. of Nights"; Integer)
        {
            Caption = 'No. of Nights';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    
    keys
    {
        key(PK; "Booking No.")
        {
            Clustered = true;
        }
        key(GuestKey; "Guest No.")
        {
        }
        key(RoomKey; "Room No.", "Check-in Date", "Check-out Date")
        {
        }
    }
    
    trigger OnInsert()
    begin
        if "Booking No." = '' then
            Error('Booking number is required');
        
        ValidateDates();
        CheckDoubleBooking();
        CalculateTotalAmount();
    end;
    
    trigger OnModify()
    begin
        ValidateDates();
        CheckDoubleBooking();
        CalculateTotalAmount();
    end;
    
    trigger OnDelete()
    begin
        if "Booking Status" = "Booking Status"::"Checked-In" then
            Error('Cannot delete a checked-in booking. Please check out the guest first.');
    end;
    
    local procedure ValidateDates()
    begin
        if "Check-in Date" = 0D then
            Error('Check-in date is required');
        
        if "Check-out Date" = 0D then
            Error('Check-out date is required');
        
        if "Check-out Date" <= "Check-in Date" then
            Error('Check-out date must be after check-in date');
        
        if "Check-in Date" < WorkDate() then
            if "Booking Status" = "Booking Status"::Confirmed then
                Error('Check-in date cannot be in the past for new bookings');
    end;
    
    local procedure CheckDoubleBooking()
    var
        ExistingBooking: Record "HMS Booking";
    begin
        if "Room No." = '' then
            exit;
        
        ExistingBooking.SetRange("Room No.", "Room No.");
        ExistingBooking.SetFilter("Booking No.", '<>%1', "Booking No.");
        ExistingBooking.SetFilter("Booking Status", '<>%1&<>%2', 
            ExistingBooking."Booking Status"::Cancelled,
            ExistingBooking."Booking Status"::"Checked-Out");
        
        if ExistingBooking.FindSet() then
            repeat
                if CheckDateOverlap(ExistingBooking) then
                    Error('Room %1 is already booked from %2 to %3 (Booking No.: %4)',
                        "Room No.",
                        ExistingBooking."Check-in Date",
                        ExistingBooking."Check-out Date",
                        ExistingBooking."Booking No.");
            until ExistingBooking.Next() = 0;
    end;
    
    local procedure CheckDateOverlap(ExistingBooking: Record "HMS Booking"): Boolean
    begin
        // Check if date ranges overlap
        // Overlap occurs if: (StartA < EndB) and (EndA > StartB)
        exit(("Check-in Date" < ExistingBooking."Check-out Date") and 
             ("Check-out Date" > ExistingBooking."Check-in Date"));
    end;
    
    local procedure CalculateTotalAmount()
    var
        Room: Record "HMS Room";
    begin
        if ("Check-in Date" <> 0D) and ("Check-out Date" <> 0D) and ("Room No." <> '') then begin
            "No. of Nights" := "Check-out Date" - "Check-in Date";
            
            if Room.Get("Room No.") then
                "Total Amount" := Room."Rate per Night" * "No. of Nights";
        end;
    end;
    
    local procedure UpdateRoomStatus()
    var
        Room: Record "HMS Room";
    begin
        if Room.Get("Room No.") then begin
            case "Booking Status" of
                "Booking Status"::"Checked-In":
                    Room."Room Status" := Room."Room Status"::Occupied;
                "Booking Status"::"Checked-Out",
                "Booking Status"::Cancelled:
                    Room."Room Status" := Room."Room Status"::Available;
            end;
            Room.Modify();
        end;
    end;
}
