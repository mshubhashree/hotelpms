/// <summary>
/// Enum HMS Room Status
/// Defines the availability status of a hotel room
/// </summary>
enum 50001 "HMS Room Status"
{
    Extensible = true;
    
    value(0; Available)
    {
        Caption = 'Available';
    }
    value(1; Occupied)
    {
        Caption = 'Occupied';
    }
    value(2; "Out of Order")
    {
        Caption = 'Out of Order';
    }
    value(3; Maintenance)
    {
        Caption = 'Maintenance';
    }
}
