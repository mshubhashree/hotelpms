/// <summary>
/// Codeunit HMS Booking Management
/// Provides business logic for hotel booking operations including availability checking and validation
/// </summary>
codeunit 50002 "HMS Booking Management"
{
    /// <summary>
    /// Creates a new booking with validation
    /// </summary>
    /// <param name="GuestNo">Guest number for the booking</param>
    /// <param name="RoomNo">Room number to book</param>
    /// <param name="CheckInDate">Check-in date</param>
    /// <param name="CheckOutDate">Check-out date</param>
    /// <returns>The created booking number</returns>
    procedure CreateBooking(GuestNo: Code[20]; RoomNo: Code[20]; CheckInDate: Date; CheckOutDate: Date): Code[20]
    var
        Booking: Record "HMS Booking";
        BookingNo: Code[20];
    begin
        // Validate inputs
        if GuestNo = '' then
            Error('Guest number is required');
        if RoomNo = '' then
            Error('Room number is required');
        
        // Check if room is available
        if not CheckRoomAvailability(RoomNo, CheckInDate, CheckOutDate) then
            Error('Room %1 is not available for the selected dates', RoomNo);
        
        // Generate booking number
        BookingNo := GenerateBookingNo();
        
        // Create booking
        Booking.Init();
        Booking."Booking No." := BookingNo;
        Booking."Guest No." := GuestNo;
        Booking."Room No." := RoomNo;
        Booking."Check-in Date" := CheckInDate;
        Booking."Check-out Date" := CheckOutDate;
        Booking."Booking Status" := Booking."Booking Status"::Confirmed;
        Booking.Insert(true);
        
        exit(BookingNo);
    end;
    
    /// <summary>
    /// Checks if a room is available for the given date range
    /// </summary>
    /// <param name="RoomNo">Room number to check</param>
    /// <param name="CheckInDate">Proposed check-in date</param>
    /// <param name="CheckOutDate">Proposed check-out date</param>
    /// <returns>True if room is available, false otherwise</returns>
    procedure CheckRoomAvailability(RoomNo: Code[20]; CheckInDate: Date; CheckOutDate: Date): Boolean
    var
        Room: Record "HMS Room";
        Booking: Record "HMS Booking";
    begin
        // Verify room exists
        if not Room.Get(RoomNo) then
            exit(false);
        
        // Check if room is available status
        if Room."Room Status" = Room."Room Status"::"Out of Order" then
            exit(false);
        
        if Room."Room Status" = Room."Room Status"::Maintenance then
            exit(false);
        
        // Check for overlapping bookings
        Booking.SetRange("Room No.", RoomNo);
        Booking.SetFilter("Booking Status", '<>%1&<>%2', 
            Booking."Booking Status"::Cancelled,
            Booking."Booking Status"::"Checked-Out");
        
        if Booking.FindSet() then
            repeat
                // Check if date ranges overlap
                if (CheckInDate < Booking."Check-out Date") and (CheckOutDate > Booking."Check-in Date") then
                    exit(false);
            until Booking.Next() = 0;
        
        exit(true);
    end;
    
    /// <summary>
    /// Checks in a guest for their booking
    /// </summary>
    /// <param name="BookingNo">Booking number to check in</param>
    procedure CheckIn(BookingNo: Code[20])
    var
        Booking: Record "HMS Booking";
    begin
        if not Booking.Get(BookingNo) then
            Error('Booking %1 not found', BookingNo);
        
        if Booking."Booking Status" <> Booking."Booking Status"::Confirmed then
            Error('Only confirmed bookings can be checked in. Current status: %1', Booking."Booking Status");
        
        Booking."Booking Status" := Booking."Booking Status"::"Checked-In";
        Booking.Modify(true);
        
        Message('Guest checked in successfully for booking %1', BookingNo);
    end;
    
    /// <summary>
    /// Checks out a guest from their booking
    /// </summary>
    /// <param name="BookingNo">Booking number to check out</param>
    procedure CheckOut(BookingNo: Code[20])
    var
        Booking: Record "HMS Booking";
    begin
        if not Booking.Get(BookingNo) then
            Error('Booking %1 not found', BookingNo);
        
        if Booking."Booking Status" <> Booking."Booking Status"::"Checked-In" then
            Error('Only checked-in bookings can be checked out. Current status: %1', Booking."Booking Status");
        
        Booking."Booking Status" := Booking."Booking Status"::"Checked-Out";
        Booking.Modify(true);
        
        Message('Guest checked out successfully for booking %1', BookingNo);
    end;
    
    /// <summary>
    /// Cancels a booking
    /// </summary>
    /// <param name="BookingNo">Booking number to cancel</param>
    procedure CancelBooking(BookingNo: Code[20])
    var
        Booking: Record "HMS Booking";
    begin
        if not Booking.Get(BookingNo) then
            Error('Booking %1 not found', BookingNo);
        
        if Booking."Booking Status" = Booking."Booking Status"::"Checked-In" then
            Error('Cannot cancel a checked-in booking. Please check out the guest first.');
        
        if Booking."Booking Status" = Booking."Booking Status"::"Checked-Out" then
            Error('Cannot cancel a booking that is already checked out.');
        
        Booking."Booking Status" := Booking."Booking Status"::Cancelled;
        Booking.Modify(true);
        
        Message('Booking %1 cancelled successfully', BookingNo);
    end;
    
    local procedure GenerateBookingNo(): Code[20]
    var
        Booking: Record "HMS Booking";
        BookingNo: Code[20];
        MaxNo: Integer;
    begin
        if Booking.FindLast() then begin
            BookingNo := Booking."Booking No.";
            if Evaluate(MaxNo, CopyStr(BookingNo, 4)) then
                MaxNo += 1
            else
                MaxNo := 1;
        end else
            MaxNo := 1;
        
        exit('BK-' + Format(MaxNo, 0, '<Integer,5><Filler Character,0>'));
    end;
}
