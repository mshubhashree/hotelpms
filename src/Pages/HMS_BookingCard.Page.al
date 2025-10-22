/// <summary>
/// Page HMS Booking Card
/// Detailed view and editing of a hotel booking
/// </summary>
page 50005 "HMS Booking Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "HMS Booking";
    Caption = 'Booking Card';
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Booking No."; Rec."Booking No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the booking number';
                }
                field("Booking Status"; Rec."Booking Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the booking status';
                }
            }
            group(Guest)
            {
                Caption = 'Guest Information';
                
                field("Guest No."; Rec."Guest No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the guest number';
                }
                field("Guest Name"; Rec."Guest Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the guest name';
                }
            }
            group(Room)
            {
                Caption = 'Room Information';
                
                field("Room No."; Rec."Room No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the room number';
                }
                field("Room Type"; Rec."Room Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the room type';
                }
                field("Rate per Night"; Rec."Rate per Night")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rate per night';
                }
            }
            group(Dates)
            {
                Caption = 'Booking Dates';
                
                field("Check-in Date"; Rec."Check-in Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the check-in date';
                }
                field("Check-out Date"; Rec."Check-out Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the check-out date';
                }
                field("No. of Nights"; Rec."No. of Nights")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of nights';
                }
            }
            group(Financials)
            {
                Caption = 'Financial Information';
                
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount for the booking';
                    Style = Strong;
                    StyleExpr = true;
                }
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action("Check In")
            {
                ApplicationArea = All;
                Caption = 'Check In';
                Image = Approve;
                ToolTip = 'Check in the guest for this booking';
                Enabled = Rec."Booking Status" = Rec."Booking Status"::Confirmed;
                
                trigger OnAction()
                var
                    BookingMgt: Codeunit "HMS Booking Management";
                begin
                    BookingMgt.CheckIn(Rec."Booking No.");
                    CurrPage.Update(false);
                end;
            }
            action("Check Out")
            {
                ApplicationArea = All;
                Caption = 'Check Out';
                Image = Post;
                ToolTip = 'Check out the guest from this booking';
                Enabled = Rec."Booking Status" = Rec."Booking Status"::"Checked-In";
                
                trigger OnAction()
                var
                    BookingMgt: Codeunit "HMS Booking Management";
                begin
                    BookingMgt.CheckOut(Rec."Booking No.");
                    CurrPage.Update(false);
                end;
            }
            action(Cancel)
            {
                ApplicationArea = All;
                Caption = 'Cancel Booking';
                Image = Cancel;
                ToolTip = 'Cancel this booking';
                Enabled = Rec."Booking Status" <> Rec."Booking Status"::Cancelled;
                
                trigger OnAction()
                var
                    BookingMgt: Codeunit "HMS Booking Management";
                begin
                    if Confirm('Are you sure you want to cancel booking %1?', false, Rec."Booking No.") then begin
                        BookingMgt.CancelBooking(Rec."Booking No.");
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
        area(Navigation)
        {
            action("View Guest")
            {
                ApplicationArea = All;
                Caption = 'View Guest';
                Image = Customer;
                ToolTip = 'View the guest details';
                RunObject = page "HMS Guest Card";
                RunPageLink = "Guest No." = field("Guest No.");
            }
            action("View Room")
            {
                ApplicationArea = All;
                Caption = 'View Room';
                Image = Resource;
                ToolTip = 'View the room details';
                RunObject = page "HMS Room Card";
                RunPageLink = "Room No." = field("Room No.");
            }
        }
    }
}
