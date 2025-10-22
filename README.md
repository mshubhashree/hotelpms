# Hotel PMS - Business Central Extension

A comprehensive Hotel Property Management System (PMS) extension for Microsoft Dynamics 365 Business Central v22.0.

## Overview

This AL extension implements a Hotel PMS system that manages Rooms, Guests, and Bookings with full validation and availability checking.

## Features

### Room Management
- Create and manage hotel rooms with room numbers, types, and rates
- Track room status (Available, Occupied, Out of Order, Maintenance)
- Support for different room types (Standard, Deluxe, Suite, Executive)
- Set maximum occupancy per room

### Guest Management
- Register guests with complete contact information
- Store guest details including name, email, phone, and address
- Email format validation
- Search guests by name or email

### Booking Management
- Create bookings linking guests to rooms
- Date validation (check-out must be after check-in)
- **Automatic availability checking** - prevents double bookings
- **Overlapping booking prevention** - validates date ranges
- Automatic calculation of nights and total amount
- Booking status workflow: Confirmed → Checked-In → Checked-Out
- Cancellation support with validation
- Room status automatically updates based on booking status

## Object Structure

### Tables
- **HMS Room (50000)**: Room inventory with properties
- **HMS Guest (50001)**: Guest profiles and contact information
- **HMS Booking (50002)**: Bookings with relationships to rooms and guests

### Enums
- **HMS Room Type (50000)**: Standard, Deluxe, Suite, Executive
- **HMS Room Status (50001)**: Available, Occupied, Out of Order, Maintenance
- **HMS Booking Status (50002)**: Confirmed, Checked-In, Checked-Out, Cancelled

### Pages
- **HMS Room List (50000)**: List view of all rooms
- **HMS Room Card (50001)**: Detailed room information
- **HMS Guest List (50002)**: List view of all guests
- **HMS Guest Card (50003)**: Detailed guest information
- **HMS Booking List (50004)**: List view of all bookings
- **HMS Booking Card (50005)**: Detailed booking information

### Codeunits
- **HMS Booking Management (50002)**: Business logic for bookings
  - CreateBooking: Create new bookings with validation
  - CheckRoomAvailability: Verify room availability for date range
  - CheckIn/CheckOut: Guest check-in and check-out operations
  - CancelBooking: Cancel bookings with validation

### Permission Sets
- **HMS ADMIN (50000)**: Full administrative access
- **HMS USER (50001)**: Front desk user access (read-only for rooms)

## Key Validation Logic

### Availability Checking
The system prevents overlapping bookings by:
1. Checking if the room status is Available (not Out of Order or Maintenance)
2. Searching for existing active bookings (not Cancelled or Checked-Out)
3. Validating that date ranges don't overlap using the formula: `(StartA < EndB) AND (EndA > StartB)`

### Date Validation
- Check-out date must be after check-in date
- Check-in date cannot be in the past for new bookings
- Dates are required (non-zero)

### Business Rules
- Cannot delete rooms with active bookings
- Cannot delete guests with active bookings
- Cannot delete or modify checked-in bookings
- Room status automatically updates when booking status changes
- Total amount calculated automatically: Rate × Number of Nights

## Installation

This is a Business Central AL extension for v22.0 or later.

### Prerequisites
- Microsoft Dynamics 365 Business Central v22.0 or later
- AL Language Extension for Visual Studio Code
- Business Central Sandbox environment (for testing)

### Deployment
1. Compile the AL extension
2. Publish to your Business Central environment
3. Assign appropriate permission sets to users:
   - HMS ADMIN for administrators
   - HMS USER for front desk staff

## Usage

### Creating a Room
1. Open "HMS Room List" page
2. Create a new room with room number, type, rate, and max occupancy
3. Room status defaults to "Available"

### Registering a Guest
1. Open "HMS Guest List" page
2. Enter guest information including name (required), email, phone, and address
3. Email format is validated automatically

### Creating a Booking
1. Open "HMS Booking List" or "HMS Booking Card"
2. Select or enter Guest No. and Room No.
3. Enter check-in and check-out dates
4. System automatically:
   - Validates dates
   - Checks for overlapping bookings
   - Calculates number of nights
   - Calculates total amount based on room rate
5. Booking is created with "Confirmed" status

### Check-in Process
1. Open the booking from "HMS Booking List"
2. Click "Check In" action
3. Booking status changes to "Checked-In"
4. Room status automatically updates to "Occupied"

### Check-out Process
1. Open the checked-in booking
2. Click "Check Out" action
3. Booking status changes to "Checked-Out"
4. Room status automatically updates to "Available"

## Architecture Notes

### Constitutional Compliance
This implementation follows all HMS constitutional requirements:
- ✅ HMS prefix on all AL objects
- ✅ PascalCase for object names
- ✅ XML documentation on public procedures
- ✅ Proper error handling with meaningful messages
- ✅ Single responsibility principle
- ✅ Data classification and field sensitivity
- ✅ Event-driven design (status changes)
- ✅ Permission sets with least privilege

### Performance Considerations
- Secondary keys on commonly filtered fields (Room Type, Status)
- FlowFields for calculated values (Guest Name, Room Type, Rate per Night)
- Efficient date overlap checking algorithm
- Proper filtering before loops to minimize database queries

### Data Relationships
```
HMS Guest (1) ──< (M) HMS Booking (M) >── (1) HMS Room
```

The Booking table acts as a junction table linking Guests to Rooms with additional booking-specific information (dates, status, amount).

## Testing Scenarios

### Test 1: Create and Book a Room
1. Create Room "101", Type "Standard", Rate "150.00"
2. Create Guest "John Smith" with email
3. Create Booking for Guest in Room 101 for future dates
4. Verify booking is created with status "Confirmed"
5. Verify total amount = Rate × Nights

### Test 2: Prevent Double Booking
1. Create Booking for Room 101 from 2025-10-25 to 2025-10-27
2. Try to create another booking for same room with overlapping dates
3. Verify system prevents the booking with error message

### Test 3: Check-in/Check-out Workflow
1. Create confirmed booking
2. Check in the guest
3. Verify room status = "Occupied"
4. Check out the guest
5. Verify room status = "Available"

### Test 4: Date Validation
1. Try to create booking with check-out date before check-in date
2. Verify system shows error
3. Try to create booking with past check-in date
4. Verify system shows error for confirmed bookings

## Future Enhancements

Potential features for future versions:
- Multi-property support
- Rate management and seasonal pricing
- Guest preferences and loyalty programs
- Housekeeping management
- Payment processing integration
- Reporting and analytics
- Integration with external booking platforms
- Room service and billing

## License

Copyright (c) 2025 HMS. All rights reserved.

## Support

For issues or questions, please contact the HMS development team.
