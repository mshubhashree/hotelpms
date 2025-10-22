# Hotel PMS - System Architecture Overview

## System Components Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     Business Central v22.0                      │
│                    Hotel PMS Extension (v1.0)                   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                         USER INTERFACE                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │ HMS Room     │  │ HMS Guest    │  │ HMS Booking  │        │
│  │ List (50000) │  │ List (50002) │  │ List (50004) │        │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘        │
│         │                 │                  │                 │
│         │                 │                  │                 │
│  ┌──────▼───────┐  ┌──────▼───────┐  ┌──────▼───────┐        │
│  │ HMS Room     │  │ HMS Guest    │  │ HMS Booking  │        │
│  │ Card (50001) │  │ Card (50003) │  │ Card (50005) │        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                       BUSINESS LOGIC                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│         ┌───────────────────────────────────────┐              │
│         │  HMS Booking Management (50002)       │              │
│         ├───────────────────────────────────────┤              │
│         │ • CreateBooking()                     │              │
│         │ • CheckRoomAvailability()             │              │
│         │ • CheckIn()                           │              │
│         │ • CheckOut()                          │              │
│         │ • CancelBooking()                     │              │
│         └───────────────────────────────────────┘              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        DATA LAYER                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│  │  HMS Room    │         │ HMS Booking  │         │  HMS Guest   │
│  │  (50000)     │◄────────│   (50002)    │────────►│   (50001)    │
│  ├──────────────┤   M:1   ├──────────────┤   M:1   ├──────────────┤
│  │ Room No. PK  │         │ Booking No.  │         │ Guest No. PK │
│  │ Room Type    │         │ Guest No. FK │         │ Name         │
│  │ Room Status  │         │ Room No. FK  │         │ Email        │
│  │ Rate/Night   │         │ Check-in     │         │ Phone No.    │
│  │ Description  │         │ Check-out    │         │ Address      │
│  │ Max Occupancy│         │ Status       │         │ City         │
│  └──────────────┘         │ Total Amount │         │ Post Code    │
│                           │ No. of Nights│         │ Country      │
│                           └──────────────┘         └──────────────┘
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     SUPPORTING OBJECTS                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ENUMS (Type Safety):                                          │
│  • HMS Room Type (50000)                                       │
│  • HMS Room Status (50001)                                     │
│  • HMS Booking Status (50002)                                  │
│                                                                 │
│  PERMISSION SETS (Security):                                   │
│  • HMS ADMIN (50000) - Full RIMD access                        │
│  • HMS USER (50001) - Front desk access                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Core Validation Flow

```
User Action: Create Booking
       │
       ▼
┌─────────────────────────┐
│ HMS Booking Card        │
│ User enters:            │
│ - Guest No.             │
│ - Room No.              │
│ - Check-in Date         │
│ - Check-out Date        │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│ OnInsert Trigger        │
│ HMS Booking Table       │
└──────────┬──────────────┘
           │
           ├──► ValidateDates()
           │    └─► Check-out > Check-in?
           │    └─► Dates not in past?
           │
           ├──► CheckDoubleBooking()
           │    │
           │    ├─► Find existing bookings for room
           │    │
           │    ├─► Filter: Not Cancelled/Checked-Out
           │    │
           │    └─► For each existing booking:
           │         └─► CheckDateOverlap()
           │              └─► If (StartA < EndB) AND (EndA > StartB)
           │                   └─► ERROR: "Room already booked"
           │
           └──► CalculateTotalAmount()
                └─► Nights = Check-out - Check-in
                └─► Total = Rate × Nights
```

## Booking Workflow State Machine

```
┌──────────────┐
│   NEW        │
│   BOOKING    │
└──────┬───────┘
       │
       ▼
┌──────────────┐      CheckIn()       ┌──────────────┐
│  CONFIRMED   │───────────────────────►│ CHECKED-IN   │
└──────┬───────┘                       └──────┬───────┘
       │                                      │
       │ CancelBooking()                      │ CheckOut()
       │                                      │
       ▼                                      ▼
┌──────────────┐                       ┌──────────────┐
│  CANCELLED   │                       │ CHECKED-OUT  │
└──────────────┘                       └──────────────┘

Room Status Updates:
• CONFIRMED → Room Status: Available
• CHECKED-IN → Room Status: Occupied
• CHECKED-OUT → Room Status: Available
• CANCELLED → Room Status: Available
```

## Key Algorithms

### 1. Date Overlap Detection
```
Algorithm: CheckDateOverlap(ExistingBooking)
──────────────────────────────────────────────
Input: 
  - Current booking: CheckInA, CheckOutA
  - Existing booking: CheckInB, CheckOutB

Logic:
  Overlap = (CheckInA < CheckOutB) AND (CheckOutA > CheckInB)

Examples:
  A: |────────|
  B:     |────────|  ✗ Overlap (StartA < EndB AND EndA > StartB)
  
  A: |────────|
  B:           |────────|  ✓ No overlap (StartA >= EndB)
  
  A:           |────────|
  B: |────────|  ✓ No overlap (EndA <= StartB)
```

### 2. Availability Check
```
Algorithm: CheckRoomAvailability(RoomNo, CheckIn, CheckOut)
──────────────────────────────────────────────────────────
1. Verify room exists
   └─► If not found → Return FALSE

2. Check room status
   └─► If "Out of Order" OR "Maintenance" → Return FALSE

3. Find all bookings for room
   └─► Filter: Status NOT IN (Cancelled, Checked-Out)
   
4. For each active booking:
   └─► If dates overlap → Return FALSE

5. Return TRUE (Available)
```

### 3. Total Amount Calculation
```
Algorithm: CalculateTotalAmount()
─────────────────────────────────
1. Calculate nights
   Nights = Check-out Date - Check-in Date

2. Lookup room rate
   Rate = HMS Room."Rate per Night"

3. Calculate total
   Total Amount = Rate × Nights
```

## Data Relationships

### Primary Keys
- **HMS Room**: Room No. (Code[20])
- **HMS Guest**: Guest No. (Code[20])
- **HMS Booking**: Booking No. (Code[20])

### Foreign Keys
- **HMS Booking.Guest No.** → HMS Guest.Guest No.
- **HMS Booking.Room No.** → HMS Room.Room No.

### FlowFields (Calculated)
- **HMS Booking.Guest Name** ← HMS Guest.Name
- **HMS Booking.Room Type** ← HMS Room.Room Type
- **HMS Booking.Rate per Night** ← HMS Room.Rate per Night

### Indexes (Performance)
- **HMS Room**: (Room Type, Room Status)
- **HMS Guest**: (Name), (Email)
- **HMS Booking**: (Guest No.), (Room No., Check-in Date, Check-out Date)

## Security Model

```
┌────────────────────────────────────────────────────┐
│                  HMS ADMIN (50000)                 │
│  ┌──────────────────────────────────────────────┐ │
│  │ Full RIMD Access to:                         │ │
│  │ • HMS Room (Create, Read, Modify, Delete)    │ │
│  │ • HMS Guest (Create, Read, Modify, Delete)   │ │
│  │ • HMS Booking (Create, Read, Modify, Delete) │ │
│  │ • All Pages                                  │ │
│  │ • All Codeunits                              │ │
│  └──────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────┐
│                   HMS USER (50001)                 │
│  ┌──────────────────────────────────────────────┐ │
│  │ Limited Access:                              │ │
│  │ • HMS Room (Read Only)                       │ │
│  │ • HMS Guest (Full RIMD)                      │ │
│  │ • HMS Booking (Full RIMD)                    │ │
│  │ • All Pages                                  │ │
│  │ • All Codeunits                              │ │
│  └──────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────┘
```

## Error Handling

### Validation Errors
- ❌ "Room {X} is already booked from {Date} to {Date}"
- ❌ "Check-out date must be after check-in date"
- ❌ "Check-in date cannot be in the past for new bookings"
- ❌ "Only confirmed bookings can be checked in"
- ❌ "Cannot delete room. Active bookings exist"
- ❌ "Cannot delete guest. Active bookings exist"
- ❌ "Cannot delete a checked-in booking"

### Success Messages
- ✅ "Guest checked in successfully for booking {X}"
- ✅ "Guest checked out successfully for booking {X}"
- ✅ "Booking {X} cancelled successfully"
- ✅ "Room {X} set to Available/Out of Order"

## Performance Characteristics

### Database Operations
- Room availability check: O(n) where n = active bookings for room
- Create booking: O(1) with constraint checks
- Guest search by name: O(log n) with indexed lookup
- Booking list query: O(n) with efficient filtering

### Optimizations
- Secondary indexes on frequently queried fields
- FlowFields to reduce JOIN operations
- Efficient date range queries with SetRange
- Minimal database round trips

## Constitutional Compliance Checklist

✅ **Naming Standards**
- All objects use HMS prefix
- PascalCase for objects
- camelCase for variables

✅ **Code Quality**
- Single responsibility per procedure
- Error handling on all operations
- XML documentation on public methods
- Clear, meaningful names

✅ **Performance**
- Proper indexes defined
- FlowFields for calculations
- SetRange for filtering

✅ **Architecture**
- Table relationships properly defined
- Business logic in codeunits
- Event-driven design ready
- Permission sets implemented

✅ **Data Protection**
- CustomerContent classification
- GDPR-compliant field handling
- Audit trail ready

## Deployment Checklist

- [x] AL extension project created
- [x] app.json configured for BC v22.0
- [x] All tables defined with proper keys
- [x] All pages created with actions
- [x] Business logic codeunits implemented
- [x] Enums for type safety
- [x] Permission sets defined
- [x] Documentation complete (README + IMPLEMENTATION_SUMMARY)
- [ ] Extension compiled (requires AL compiler)
- [ ] Extension published to sandbox
- [ ] Permission sets assigned to users
- [ ] Initial data loaded (sample rooms)
- [ ] User acceptance testing
- [ ] Production deployment

## Success Metrics

| Metric | Target | Implementation |
|--------|--------|----------------|
| Table relationships | Required | ✅ Guest ↔ Booking ↔ Room |
| Availability checking | Required | ✅ CheckRoomAvailability() |
| Overlap prevention | Required | ✅ CheckDoubleBooking() |
| Date validation | Required | ✅ ValidateDates() |
| HMS prefix | Required | ✅ All 15 objects |
| Documentation | Required | ✅ README + Summary |
| Code lines | Delivered | ✅ 1,435 lines |
| Test coverage | Target 80% | ⚠️ Awaiting AL Test Framework |

---

**Implementation Status**: ✅ COMPLETE
**Ready for**: Compilation and Deployment to BC v22.0 Sandbox
**Next Step**: Compile, publish, and conduct user acceptance testing
