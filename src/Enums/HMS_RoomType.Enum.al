/// <summary>
/// Enum HMS Room Type
/// Defines the types of rooms available in the hotel
/// </summary>
enum 50000 "HMS Room Type"
{
    Extensible = true;
    
    value(0; Standard)
    {
        Caption = 'Standard';
    }
    value(1; Deluxe)
    {
        Caption = 'Deluxe';
    }
    value(2; Suite)
    {
        Caption = 'Suite';
    }
    value(3; Executive)
    {
        Caption = 'Executive';
    }
}
