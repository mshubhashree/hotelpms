/// <summary>
/// Page HMS Room List
/// Displays a list of all hotel rooms with filtering and actions
/// </summary>
page 50000 "HMS Room List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "HMS Room";
    Caption = 'Room List';
    CardPageId = "HMS Room Card";
    Editable = true;
    
    layout
    {
        area(Content)
        {
            repeater(Rooms)
            {
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
