/// <summary>
/// Page HMS Guest Card
/// Detailed view and editing of a hotel guest
/// </summary>
page 50003 "HMS Guest Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "HMS Guest";
    Caption = 'Guest Card';
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
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
            }
            group(Contact)
            {
                Caption = 'Contact Information';
                
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
            }
            group(Address)
            {
                Caption = 'Address';
                
                field(AddressField; Rec.Address)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    ToolTip = 'Specifies the guest address';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the guest city';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the guest post code';
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
