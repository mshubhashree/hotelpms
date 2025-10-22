/// <summary>
/// Page HMS Guest List
/// Displays a list of all hotel guests with search capability
/// </summary>
page 50002 "HMS Guest List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "HMS Guest";
    Caption = 'Guest List';
    CardPageId = "HMS Guest Card";
    Editable = true;
    
    layout
    {
        area(Content)
        {
            repeater(Guests)
            {
                field("Guest No."; Rec."Guest No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the guest number';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the guest name';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the guest email address';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the guest phone number';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the guest city';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the guest country';
                }
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action("New Booking")
            {
                ApplicationArea = All;
                Caption = 'New Booking';
                Image = NewDocument;
                ToolTip = 'Create a new booking for this guest';
                
                trigger OnAction()
                var
                    BookingCard: Page "HMS Booking Card";
                    Booking: Record "HMS Booking";
                begin
                    Booking.Init();
                    Booking."Guest No." := Rec."Guest No.";
                    BookingCard.SetRecord(Booking);
                    BookingCard.Run();
                end;
            }
        }
        area(Navigation)
        {
            action("View Bookings")
            {
                ApplicationArea = All;
                Caption = 'View Bookings';
                Image = ViewDetails;
                ToolTip = 'View all bookings for this guest';
                RunObject = page "HMS Booking List";
                RunPageLink = "Guest No." = field("Guest No.");
            }
        }
    }
}
