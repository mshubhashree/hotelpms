/// <summary>
/// Page HMS Room Card
/// Detailed view and editing of a hotel room
/// </summary>
page 50001 "HMS Room Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "HMS Room";
    Caption = 'Room Card';
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Room No."; Rec."Room No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the room number';
                }
                field("Room Type"; Rec."Room Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of room';
                }
                field("Room Status"; Rec."Room Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the room';
                }
                field("Rate per Night"; Rec."Rate per Night")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rate per night for the room';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the room';
                    MultiLine = true;
                }
                field("Max Occupancy"; Rec."Max Occupancy")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum number of guests for the room';
                }
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action("Set Available")
            {
                ApplicationArea = All;
                Caption = 'Set Available';
                Image = Approve;
                ToolTip = 'Set the room status to Available';
                
                trigger OnAction()
                begin
                    Rec."Room Status" := Rec."Room Status"::Available;
                    Rec.Modify(true);
                    Message('Room %1 set to Available', Rec."Room No.");
                end;
            }
            action("Set Out of Order")
            {
                ApplicationArea = All;
                Caption = 'Set Out of Order';
                Image = Stop;
                ToolTip = 'Set the room status to Out of Order';
                
                trigger OnAction()
                begin
                    Rec."Room Status" := Rec."Room Status"::"Out of Order";
                    Rec.Modify(true);
                    Message('Room %1 set to Out of Order', Rec."Room No.");
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
                ToolTip = 'View all bookings for this room';
                RunObject = page "HMS Booking List";
                RunPageLink = "Room No." = field("Room No.");
            }
        }
    }
}
