/// <summary>
/// Page HMS Booking List
/// Displays a list of all hotel bookings with filtering and actions
/// </summary>
page 50004 "HMS Booking List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "HMS Booking";
    Caption = 'Booking List';
    CardPageId = "HMS Booking Card";
    Editable = false;
    
    layout
    {
        area(Content)
        {
            repeater(Bookings)
            {
                field("Booking No."; Rec."Booking No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the booking number';
                }
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
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount for the booking';
                }
                field("Booking Status"; Rec."Booking Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the booking status';
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
