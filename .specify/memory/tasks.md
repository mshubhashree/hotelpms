# Tasks: Hotel Property Management System (PMS)

**Input**: Design documents from `hotel-pms-spec.md` and `plan.md`
**Prerequisites**: plan.md (completed), spec.md (completed), constitution.md (completed)

**Tests**: AL Test Framework tests are included as required by constitutional TDD principles (80% minimum coverage).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story, following Business Central extension development patterns.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5)
- File paths follow AL extension structure with HMS prefix

## Phase 1: Setup (AL Extension Infrastructure)

**Purpose**: Business Central extension project initialization and AL development environment

- [ ] T001 Create AL extension project structure with app.json manifest (HMS Hotel PMS v1.0.0)
- [ ] T002 [P] Configure .vscode/launch.json for AL debugging with BC22.0 Sandbox US
- [ ] T003 [P] Configure .vscode/settings.json with AL language server and HMS naming rules
- [ ] T004 [P] Create .gitignore with AL-specific exclusions (.alpackages, .snapshots)
- [ ] T005 [P] Setup AL test project structure with test app.json configuration

---

## Phase 2: Foundational (Core AL Objects - Blocking Prerequisites)

**Purpose**: Essential AL objects that ALL user stories depend on - MUST complete before any user story work

**⚠️ CRITICAL**: No user story implementation can begin until this phase is complete

- [ ] T006 Create HMS_RoomType.Enum.al (Enum 50000: Standard, Deluxe, Suite, Executive)
- [ ] T007 Create HMS_RoomStatus.Enum.al (Enum 50001: Available, Occupied, OutOfOrder, Maintenance)
- [ ] T008 Create HMS_BookingStatus.Enum.al (Enum 50002: Confirmed, CheckedIn, CheckedOut, Cancelled)
- [ ] T009 [P] Create HMS_ADMIN.PermissionSet.al with full table/page permissions
- [ ] T010 [P] Create HMS_MANAGER.PermissionSet.al with manager-level permissions  
- [ ] T011 [P] Create HMS_USER.PermissionSet.al with front desk user permissions
- [ ] T012 Setup AL error handling patterns and telemetry framework integration

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Room Management (Priority: P1) 🎯 MVP

**Goal**: Hotel staff can create, view, update rooms with types, rates, and status management

**Independent Test**: Create rooms with different types/rates, verify display, update status independently

### Tests for User Story 1 ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation (TDD)**

- [ ] T013 [P] [US1] Unit test for HMS Room table validation in tests/src/HMS_RoomTest.Codeunit.al
- [ ] T014 [P] [US1] Integration test for room creation workflow in tests/src/HMS_RoomTest.Codeunit.al
- [ ] T015 [P] [US1] Unit test for HMS Room Management procedures in tests/src/HMS_RoomTest.Codeunit.al

### Implementation for User Story 1

- [ ] T016 [US1] Create HMS_Room.Table.al (Table 50000) with fields: Room No., Type, Rate, Status, Description, Max Occupancy
- [ ] T017 [US1] Add HMS Room table keys: Primary (Room No.), Secondary (Type, Status, Rate)
- [ ] T018 [US1] Add HMS Room field validation: unique room numbers, positive rates, required fields
- [ ] T019 [US1] Create HMS_RoomManagement.Codeunit.al (Codeunit 50000) with CreateRoom, UpdateRate, SetStatus procedures
- [ ] T020 [US1] Add XML documentation and error handling to HMS Room Management procedures
- [ ] T021 [US1] Create HMS_RoomList.Page.al (Page 50000) with room grid, actions, and filters by Type/Status
- [ ] T022 [US1] Create HMS_RoomCard.Page.al (Page 50001) with detailed room form and status actions
- [ ] T023 [US1] Add room search and filtering capabilities (by type, status, rate range)
- [ ] T024 [US1] Implement room status change validation and business rules

**Checkpoint**: Room management fully functional - can create, view, edit, filter rooms independently

---

## Phase 4: User Story 2 - Guest Registration and Management (Priority: P2)

**Goal**: Hotel staff can register guests, manage contact details, and search guest profiles

**Independent Test**: Create guest profiles, search by name/email, update contact info without booking dependency

### Tests for User Story 2 ⚠️

- [ ] T025 [P] [US2] Unit test for HMS Guest table validation in tests/src/HMS_GuestTest.Codeunit.al
- [ ] T026 [P] [US2] Integration test for guest registration workflow in tests/src/HMS_GuestTest.Codeunit.al
- [ ] T027 [P] [US2] Unit test for guest search functionality in tests/src/HMS_GuestTest.Codeunit.al

### Implementation for User Story 2

- [ ] T028 [P] [US2] Create HMS_Guest.Table.al (Table 50001) with fields: Guest No., Name, Email, Phone, Address fields
- [ ] T029 [US2] Add HMS Guest table keys: Primary (Guest No.), Secondary (Name, Email) for search optimization
- [ ] T030 [US2] Add HMS Guest field validation: required name, email format, phone format, data classification
- [ ] T031 [US2] Create HMS_GuestManagement.Codeunit.al (Codeunit 50001) with RegisterGuest, UpdateContact, SearchGuest procedures
- [ ] T032 [US2] Add XML documentation and error handling to HMS Guest Management procedures
- [ ] T033 [US2] Create HMS_GuestList.Page.al (Page 50002) with guest grid and search functionality
- [ ] T034 [US2] Create HMS_GuestCard.Page.al (Page 50003) with detailed guest form and contact management
- [ ] T035 [US2] Implement guest search by name, email (partial match), and phone number
- [ ] T036 [US2] Add guest data validation and GDPR compliance field classification

**Checkpoint**: Guest management fully functional - can register, search, update guests independently

---

## Phase 5: User Story 3 - Booking Creation and Management (Priority: P1) 🎯 Core Business

**Goal**: Hotel staff can create bookings linking guests to rooms with dates and status tracking

**Independent Test**: Create bookings, verify date validation, prevent double-booking, manage status changes

### Tests for User Story 3 ⚠️

- [ ] T037 [P] [US3] Unit test for HMS Booking table validation in tests/src/HMS_BookingTest.Codeunit.al
- [ ] T038 [P] [US3] Integration test for booking creation workflow in tests/src/HMS_BookingTest.Codeunit.al
- [ ] T039 [P] [US3] Unit test for double-booking prevention logic in tests/src/HMS_BookingTest.Codeunit.al
- [ ] T040 [P] [US3] Integration test for booking status workflow in tests/src/HMS_BookingTest.Codeunit.al

### Implementation for User Story 3

- [ ] T041 [US3] Create HMS_Booking.Table.al (Table 50002) with fields: Booking No., Guest No., Room No., Check-in/out Dates, Status, Total Amount
- [ ] T042 [US3] Add HMS Booking table keys: Primary (Booking No.), Secondary (Guest No., Room No., Dates)
- [ ] T043 [US3] Add HMS Booking table relationships: Guest No. → HMS Guest, Room No. → HMS Room
- [ ] T044 [US3] Create HMS_BookingManagement.Codeunit.al (Codeunit 50002) with CreateBooking, ValidateDates, CheckDoubleBooking procedures
- [ ] T045 [US3] Implement double-booking prevention logic with date overlap detection
- [ ] T046 [US3] Add booking status transition validation and business rules
- [ ] T047 [US3] Create HMS_BookingList.Page.al (Page 50004) with booking grid and status filters
- [ ] T048 [US3] Create HMS_BookingCard.Page.al (Page 50005) with detailed booking form and guest/room lookups
- [ ] T049 [US3] Add booking cost calculation based on room rate and duration
- [ ] T050 [US3] Implement booking modification with date change validation
- [ ] T051 [US3] Add XML documentation and comprehensive error handling for all booking procedures

**Checkpoint**: Core booking functionality complete - can create, manage, validate bookings independently

---

## Phase 6: User Story 4 - Availability and Occupancy Tracking (Priority: P2)

**Goal**: Hotel staff can view room availability and occupancy status across date ranges

**Independent Test**: Check availability for date ranges, view occupancy dashboard, verify real-time updates

### Tests for User Story 4 ⚠️

- [ ] T052 [P] [US4] Unit test for room availability calculations in tests/src/HMS_BookingTest.Codeunit.al
- [ ] T053 [P] [US4] Integration test for occupancy tracking workflow in tests/src/HMS_IntegrationTest.Codeunit.al

### Implementation for User Story 4

- [ ] T054 [P] [US4] Add FlowFields to HMS Room table for Current Booking Count and Availability Status
- [ ] T055 [US4] Create availability calculation procedures in HMS_BookingManagement.Codeunit.al
- [ ] T056 [US4] Create HMS_RoomAvailability.Report.al (Report 50003) for availability reporting
- [ ] T057 [US4] Add occupancy dashboard functionality to HMS_RoomList.Page.al
- [ ] T058 [US4] Implement date range availability queries with performance optimization
- [ ] T059 [US4] Add real-time availability updates when bookings change status

**Checkpoint**: Availability tracking complete - can view occupancy and availability in real-time

---

## Phase 7: User Story 5 - Booking Status Workflow (Priority: P3)

**Goal**: Hotel staff can manage booking status transitions with proper workflow and room updates

**Independent Test**: Transition bookings through status changes, verify timestamps and room status updates

### Tests for User Story 5 ⚠️

- [ ] T060 [P] [US5] Unit test for booking status transitions in tests/src/HMS_BookingTest.Codeunit.al
- [ ] T061 [P] [US5] Integration test for complete guest journey workflow in tests/src/HMS_IntegrationTest.Codeunit.al

### Implementation for User Story 5

- [ ] T062 [P] [US5] Add timestamp fields to HMS Booking table (Check-in Time, Check-out Time)
- [ ] T063 [US5] Create status workflow procedures in HMS_BookingManagement.Codeunit.al
- [ ] T064 [US5] Add check-in/check-out actions to HMS_BookingCard.Page.al
- [ ] T065 [US5] Implement room status updates based on booking status changes
- [ ] T066 [US5] Add booking status change audit trail and logging
- [ ] T067 [US5] Create status transition validation rules and business logic

**Checkpoint**: Complete booking workflow implemented with full status management

---

## Phase 8: Advanced Features and Reporting

**Purpose**: Enhanced functionality and business intelligence features

- [ ] T068 [P] Create HMS_BookingSummary.Report.al (Report 50004) for business reporting
- [ ] T069 [P] Add HMS_RoleCenter.PageExt.al with hotel management menu and KPIs
- [ ] T070 [P] Implement advanced room filtering and search capabilities
- [ ] T071 [P] Add guest booking history display on HMS_GuestCard.Page.al
- [ ] T072 Create AL events for booking lifecycle (OnBookingCreated, OnStatusChanged)
- [ ] T073 Add Application Insights telemetry for monitoring and diagnostics

---

## Phase 9: Polish & AppSource Compliance

**Purpose**: Final testing, optimization, and AppSource readiness

- [ ] T074 [P] Complete XML documentation for all public procedures and functions
- [ ] T075 [P] Run AppSource validation and fix any compliance issues
- [ ] T076 Performance optimization: review table keys, optimize queries <1s response time
- [ ] T077 [P] Security review: verify permission sets and field classifications
- [ ] T078 [P] Create extension installation and configuration documentation
- [ ] T079 End-to-end testing of complete hotel workflow scenarios
- [ ] T080 Code review and refactoring for maintainability and constitutional compliance

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories  
- **User Story 1 (Phase 3)**: Depends on Foundational - MVP foundation
- **User Story 2 (Phase 4)**: Depends on Foundational - Independent from US1
- **User Story 3 (Phase 5)**: Depends on Foundational + US1 + US2 - Core business logic
- **User Story 4 (Phase 6)**: Depends on US1 + US3 - Requires rooms and bookings
- **User Story 5 (Phase 7)**: Depends on US3 - Extends booking functionality
- **Advanced Features (Phase 8)**: Depends on all user stories
- **Polish (Phase 9)**: Depends on complete functionality

### Critical Path for MVP

1. **Phase 1 + 2**: Setup + Foundation (Week 1)
2. **Phase 3**: Room Management (Week 2) → **MVP 1.0** 
3. **Phase 4**: Guest Management (Week 2-3) → **MVP 2.0**
4. **Phase 5**: Booking Management (Week 3-4) → **MVP 3.0** (Complete core functionality)

### Parallel Opportunities

- **Setup Phase**: All tasks marked [P] can run in parallel
- **Foundation Phase**: Permission sets (T009-T011) can run in parallel with enums
- **User Stories**: US1 and US2 can develop in parallel after Foundation
- **Testing**: All test tasks marked [P] can run in parallel within each story
- **Advanced Features**: Most tasks in Phase 8 can run in parallel

### Constitutional Compliance Checkpoints

- **After Phase 2**: Verify AL naming standards compliance (HMS prefix, PascalCase)
- **After each User Story**: Run tests to ensure 80% coverage requirement
- **After Phase 5**: Performance testing for <1s queries, <2s booking creation
- **Before Phase 9**: Complete constitutional compliance audit

---

## Implementation Strategy

### MVP-First Approach

1. **Week 1**: Complete Setup + Foundation → AL extension ready
2. **Week 2**: User Story 1 (Rooms) → **DEPLOY MVP 1.0** (Room management only)
3. **Week 3**: User Story 2 (Guests) → **DEPLOY MVP 2.0** (Rooms + Guests)  
4. **Week 4**: User Story 3 (Bookings) → **DEPLOY MVP 3.0** (Complete core PMS)
5. **Week 5**: US4 + US5 + Polish → **DEPLOY FULL 1.0**

### Parallel Team Strategy

With 2-3 AL developers:
1. **Team completes Setup + Foundation together** (Week 1)
2. **Split after Foundation**:
   - **Developer A**: User Story 1 (Rooms) + User Story 4 (Availability)
   - **Developer B**: User Story 2 (Guests) + User Story 5 (Workflow)  
   - **Developer C**: User Story 3 (Bookings) + Advanced Features
3. **Converge for integration testing and polish**

---

## Notes

- All AL objects use HMS prefix per constitutional requirements
- TDD approach: Tests written first, must fail before implementation
- Each user story delivers independent business value
- Performance targets: <1s availability queries, <2s booking creation
- AppSource compliance verified throughout development
- Constitutional compliance checkpoints at major milestones
- 80% minimum test coverage enforced via AL Test Framework