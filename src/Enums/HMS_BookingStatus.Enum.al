/// <summary>
/// Enum HMS Booking Status
/// Defines the status workflow for hotel bookings
/// </summary>
enum 50002 "HMS Booking Status"
{
    Extensible = true;
    
    value(0; Confirmed)
    {
        Caption = 'Confirmed';
    }
    value(1; "Checked-In")
    {
        Caption = 'Checked-In';
    }
    value(2; "Checked-Out")
    {
        Caption = 'Checked-Out';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
