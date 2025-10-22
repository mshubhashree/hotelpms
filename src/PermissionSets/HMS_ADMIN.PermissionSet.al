/// <summary>
/// Permission Set HMS ADMIN
/// Full administrative permissions for Hotel PMS
/// </summary>
permissionset 50000 "HMS ADMIN"
{
    Assignable = true;
    Caption = 'HMS Admin';
    
    Permissions = 
        tabledata "HMS Room" = RIMD,
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
