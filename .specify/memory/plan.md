# Implementation Plan: Hotel Property Management System (PMS)

**Branch**: `001-hotel-pms-core` | **Date**: 2025-10-22 | **Spec**: [hotel-pms-spec.md](./hotel-pms-spec.md)
**Input**: Feature specification from `hotel-pms-spec.md`

## Summary

Implement a comprehensive Hotel PMS system using AL for Business Central 22.0 with core entities (Rooms, Guests, Bookings) and essential pages (Room List, Guest Card, Booking Card). The system will manage hotel operations including room inventory, guest registration, and booking workflows with full AL naming compliance and Business Central best practices.

## Technical Context

**Language/Version**: AL for Business Central 22.0 (Sandbox US)  
**Primary Dependencies**: Business Central Base Application, System Application  
**Storage**: Business Central SQL Database with proper AL table structure  
**Testing**: AL Test Framework with unit and integration tests  
**Target Platform**: Business Central SaaS/On-Premises environment  
**Project Type**: Business Central Extension (.app package)  
**Performance Goals**: <1s room availability queries, <2s booking creation, 50+ concurrent users  
**Constraints**: AppSource compliance, table ID range 50000-50010, HMS prefix mandatory  
**Scale/Scope**: 1000+ rooms, 100k+ guests, 10+ years historical data retention

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **AL Naming Standards**: HMS prefix enforced for all objects, PascalCase for objects, camelCase for variables  
✅ **Code Quality Excellence**: Single responsibility principle, proper error handling, XML documentation required  
✅ **Performance Optimization**: Database efficiency with proper keys/filters, memory management, query optimization  
✅ **Business Central Extension Architecture**: AppSource compliance, event-driven design, proper permission sets  
✅ **Test-Driven Development**: 80% minimum test coverage, comprehensive test types, automated CI/CD testing

## Project Structure

### Documentation (this feature)

```text
.specify/memory/
├── constitution.md         # Project constitution (completed)
├── hotel-pms-spec.md      # Feature specification (completed)
├── plan.md                # This implementation plan
├── research.md            # Phase 0: AL/BC research and architecture decisions
├── data-model.md          # Phase 1: Complete AL table/field specifications
├── quickstart.md          # Phase 1: Development environment setup guide
├── contracts/             # Phase 1: AL interface contracts and API definitions
└── tasks.md               # Phase 2: Detailed implementation tasks (/speckit.tasks)
```

### Source Code (AL Extension Structure)

```text
src/
├── Tables/
│   ├── HMS_Room.Table.al              # Table 50000: HMS Room
│   ├── HMS_Guest.Table.al             # Table 50001: HMS Guest  
│   └── HMS_Booking.Table.al           # Table 50002: HMS Booking
├── Pages/
│   ├── HMS_RoomList.Page.al           # Page 50000: HMS Room List
│   ├── HMS_RoomCard.Page.al           # Page 50001: HMS Room Card
│   ├── HMS_GuestList.Page.al          # Page 50002: HMS Guest List
│   ├── HMS_GuestCard.Page.al          # Page 50003: HMS Guest Card
│   ├── HMS_BookingList.Page.al        # Page 50004: HMS Booking List
│   └── HMS_BookingCard.Page.al        # Page 50005: HMS Booking Card
├── Codeunits/
│   ├── HMS_RoomManagement.Codeunit.al # Codeunit 50000: Room business logic
│   ├── HMS_GuestManagement.Codeunit.al # Codeunit 50001: Guest business logic
│   └── HMS_BookingManagement.Codeunit.al # Codeunit 50002: Booking business logic
├── Enums/
│   ├── HMS_RoomType.Enum.al           # Enum 50000: Room types
│   ├── HMS_RoomStatus.Enum.al         # Enum 50001: Room availability status
│   └── HMS_BookingStatus.Enum.al      # Enum 50002: Booking status workflow
├── PageExtensions/
│   └── HMS_RoleCenter.PageExt.al      # Role Center customization
├── PermissionSets/
│   ├── HMS_ADMIN.PermissionSet.al     # Full admin permissions
│   ├── HMS_MANAGER.PermissionSet.al   # Manager-level permissions
│   └── HMS_USER.PermissionSet.al      # Front desk user permissions
└── Reports/
    ├── HMS_RoomAvailability.Report.al # Room availability report
    └── HMS_BookingSummary.Report.al   # Booking summary report

tests/
├── src/
│   ├── HMS_RoomTest.Codeunit.al       # Room management unit tests
│   ├── HMS_GuestTest.Codeunit.al      # Guest management unit tests
│   ├── HMS_BookingTest.Codeunit.al    # Booking management unit tests
│   └── HMS_IntegrationTest.Codeunit.al # End-to-end workflow tests
└── app.json                           # Test app configuration

app.json                               # Main extension manifest
.vscode/
├── launch.json                        # AL debugging configuration
└── settings.json                      # AL language server settings
```

**Structure Decision**: Selected Business Central Extension structure following Microsoft AL development standards. This provides proper separation of concerns with dedicated folders for each AL object type, comprehensive testing framework, and AppSource-compliant organization.

## Phase 0: Research & Architecture

### AL/Business Central Research Tasks

1. **Table Design Research**
   - Review Business Central table design patterns and best practices
   - Research field naming conventions and data classification requirements
   - Investigate primary key strategies and table relationships in AL
   - Study FlowField and CalcFormula implementations for calculated fields

2. **Page Development Research**
   - Analyze Business Central page types (List, Card, Document) and their use cases
   - Research page actions, filters, and lookup implementations
   - Study page part integration for master-detail relationships
   - Investigate field validation and error handling on pages

3. **Business Logic Architecture**
   - Research AL codeunit patterns for business logic encapsulation
   - Study event-driven architecture using AL events and subscribers
   - Investigate error handling and transaction management in AL
   - Research AL testing framework and test automation patterns

4. **AppSource Compliance Research**
   - Review AppSource validation rules and requirements
   - Study permission set design and security best practices
   - Research telemetry implementation for monitoring and diagnostics
   - Investigate upgrade compatibility requirements

### Architecture Decisions Required

1. **Object ID Allocation Strategy**
   - Tables: 50000-50002 (Room, Guest, Booking)
   - Pages: 50000-50005 (Lists and Cards)
   - Codeunits: 50000-50002 (Management units)
   - Enums: 50000-50002 (Room Type, Room Status, Booking Status)
   - Reports: 50003-50004 (Availability, Summary)

2. **Table Relationship Design**
   - HMS Room → HMS Booking (One-to-Many via Room No.)
   - HMS Guest → HMS Booking (One-to-Many via Guest No.)
   - Booking status workflow and state transitions

3. **Performance Optimization Strategy**
   - Primary and secondary key definitions for optimal queries
   - FlowField calculations for room availability and booking counts
   - Index strategy for date range queries and guest searches

## Phase 1: Detailed Design

### Data Model Specifications

**HMS Room Table (50000)**
- Primary Key: Room No. (Code[20])
- Fields: Room Type, Rate, Status, Description, Max Occupancy
- Keys: Room Type, Status, Rate ranges
- FlowFields: Current Booking Count, Availability Status

**HMS Guest Table (50001)**  
- Primary Key: Guest No. (Code[20])
- Fields: Name, Email, Phone, Address fields, Preferences
- Keys: Name, Email for search optimization
- Data Classification: Customer data with proper sensitivity

**HMS Booking Table (50002)**
- Primary Key: Booking No. (Code[20])
- Fields: Guest No., Room No., Check-in/out Dates, Status, Total Amount
- Keys: Guest No., Room No., Date combinations
- FlowFields: Duration calculation, Rate calculations

### Page Design Specifications

**Room List Page (50000)**
- Source Table: HMS Room
- Page Type: List
- Actions: New, Edit, Delete, Set Status, View Bookings
- Filters: Room Type, Status, Rate Range

**Guest Card Page (50003)**
- Source Table: HMS Guest  
- Page Type: Card
- Parts: Booking History (List Part)
- Actions: New Booking, Communication, View History

**Booking Card Page (50005)**
- Source Table: HMS Booking
- Page Type: Card
- Actions: Check-in, Check-out, Modify, Cancel
- Validation: Date overlap checking, Room availability

### Business Logic Specifications

**HMS Room Management (Codeunit 50000)**
- Procedures: CreateRoom, UpdateRoomRate, SetRoomStatus, CheckAvailability
- Events: OnRoomStatusChange, OnRateUpdate
- Validation: Unique room numbers, valid rate ranges

**HMS Booking Management (Codeunit 50002)**
- Procedures: CreateBooking, ValidateDates, CheckDoubleBooking, UpdateStatus
- Events: OnBookingStatusChange, OnCheckIn, OnCheckOut
- Complex Logic: Date overlap detection, availability calculations

## Phase 2: Implementation Tasks

### Development Milestones

**Milestone 1: Core Tables (Week 1)**
- Create HMS Room, Guest, Booking tables with all fields
- Implement primary keys, relationships, and basic validation
- Add data classification and field properties

**Milestone 2: Basic Pages (Week 2)**  
- Develop Room List, Guest Card, Booking Card pages
- Implement basic CRUD operations and navigation
- Add field validation and error handling

**Milestone 3: Business Logic (Week 3)**
- Create management codeunits with core procedures
- Implement booking validation and double-booking prevention
- Add event-driven architecture for status changes

**Milestone 4: Advanced Features (Week 4)**
- Implement room availability calculations and FlowFields
- Add search and filtering capabilities
- Create reports and permission sets

**Milestone 5: Testing & Polish (Week 5)**
- Comprehensive unit and integration testing
- AppSource compliance validation
- Performance optimization and code review

## Complexity Tracking

> **No constitutional violations identified - all requirements align with established principles**

| Aspect | Implementation | Constitutional Alignment |
|--------|----------------|-------------------------|
| Naming Standards | HMS prefix, PascalCase objects | ✅ Fully compliant |
| Performance | <1s queries, proper indexing | ✅ Meets optimization requirements |
| Architecture | Event-driven, subscriber pattern | ✅ Follows BC best practices |
| Testing | 80%+ coverage, automated tests | ✅ Exceeds TDD requirements |
| Documentation | XML docs, comprehensive specs | ✅ Meets quality standards |

The implementation follows all constitutional principles without requiring any exceptions or violations. The AL development approach aligns perfectly with Business Central extension best practices and AppSource requirements.