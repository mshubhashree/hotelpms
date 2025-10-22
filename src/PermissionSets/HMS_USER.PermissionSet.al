/// <summary>
/// Permission Set HMS USER
/// Front desk user permissions for Hotel PMS
/// </summary>
permissionset 50001 "HMS USER"
{
    Assignable = true;
    Caption = 'HMS User';
    
    Permissions = 
        tabledata "HMS Room" = R,
        tabledata "HMS Guest" = RIMD,
        tabledata "HMS Booking" = RIMD,
        table "HMS Room" = X,
        table "HMS Guest" = X,
        table "HMS Booking" = X,
        page "HMS Room List" = X,
        page "HMS Room Card" = X,
        page "HMS Guest List" = X,
        page "HMS Guest Card" = X,
        page "HMS Booking List" = X,
        page "HMS Booking Card" = X,
        codeunit "HMS Booking Management" = X;
}
