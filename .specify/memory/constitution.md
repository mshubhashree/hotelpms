<!--
Sync Impact Report:
- Version change: Template → 1.0.0
- New constitution established with AL/Business Central focus
- Added principles: AL Naming Standards, Code Quality, Performance, Extension Architecture, Test-Driven Development
- Added sections: Development Standards, Quality Assurance, Performance Requirements  
- Templates requiring updates: ⚠ All templates pending alignment with new AL-focused principles
- Follow-up TODOs: None - all placeholders replaced
-->

# Hotel PMS Constitution

## Core Principles

### I. AL Naming Standards (NON-NEGOTIABLE)
All AL objects MUST follow Microsoft AL naming conventions and extend with project-specific standards:
- **Objects**: Use PascalCase with meaningful descriptive names (e.g., `HotelRoomMgt`, `ReservationHistory`)
- **Variables**: Use camelCase with clear intent (e.g., `roomAvailabilityDate`, `customerBookingRef`)
- **Fields**: Match table field naming with proper prefixes (`HMS` for Hotel Management System)
- **Procedures**: Start with action verbs and describe purpose (`CalculateRoomRate`, `ValidateReservationDates`)
- **Constants**: Use UPPER_CASE with descriptive names (`MAX_ROOM_CAPACITY`, `DEFAULT_CHECKOUT_TIME`)
- **Prefixes**: All custom objects MUST use `HMS` prefix to avoid conflicts

### II. Code Quality Excellence
Every line of AL code MUST meet professional enterprise standards:
- **Single Responsibility**: Each procedure performs one clear function with explicit purpose
- **Error Handling**: All database operations and API calls MUST include proper error handling with meaningful messages
- **Documentation**: All public procedures require XML documentation with parameters, returns, and purpose
- **Code Reviews**: Two-person approval required for all commits; focus on maintainability and Business Central best practices
- **Complexity Limits**: Cyclomatic complexity ≤10 per procedure; refactor when exceeded

### III. Performance Optimization
Performance MUST be considered in every development decision:
- **Database Efficiency**: Use appropriate keys, filters, and indexes; avoid unnecessary FlowField calculations
- **Memory Management**: Proper variable scope and object disposal; minimize temp table usage
- **Query Optimization**: Use SetRange over SetFilter; implement proper record filtering before loops
- **Batch Processing**: Large operations MUST use batch processing with progress indicators
- **Caching Strategy**: Implement intelligent caching for frequently accessed data with proper invalidation

### IV. Business Central Extension Architecture
Extension design MUST follow Microsoft standards and best practices:
- **AppSource Compliance**: All code MUST pass AppSource validation rules and maintain upgrade compatibility
- **Event-Driven Design**: Use events and subscribers instead of modifying base application
- **Permission Sets**: Implement granular permission sets following principle of least privilege
- **Telemetry**: Include Application Insights telemetry for monitoring and diagnostics
- **Upgrade Compatibility**: Design for seamless updates without data loss or customization conflicts

### V. Test-Driven Development (NON-NEGOTIABLE)
Testing is fundamental to code quality and system reliability:
- **Test Coverage**: Minimum 80% code coverage for all custom functionality
- **Test Types**: Unit tests for business logic, integration tests for workflows, UI tests for critical paths
- **Test Data**: Use consistent test data sets with proper cleanup procedures
- **Automated Testing**: All tests MUST run in CI/CD pipeline with failure blocking deployment
- **Test Documentation**: Test scenarios documented with business context and expected outcomes

## Development Standards

### Code Structure Requirements
- **Solution Organization**: Logical folder structure mirroring business domains (Reservations, Rooms, Billing, Reports)
- **Dependency Management**: Clear separation between core business logic and UI/integration layers
- **Configuration Management**: Use app.json and extension settings appropriately; avoid hardcoded values
- **Version Control**: Semantic versioning (MAJOR.MINOR.PATCH) with clear changelog documentation
- **Branch Strategy**: Feature branches with pull request workflow; main branch always deployable

### Security and Compliance
- **Data Protection**: Implement proper field classification and data sensitivity handling
- **Access Control**: Role-based security model aligned with hotel business roles
- **Audit Trail**: Comprehensive logging of all business-critical operations
- **Integration Security**: Secure API endpoints with proper authentication and authorization
- **Compliance**: GDPR, PCI DSS, and industry-specific regulatory compliance where applicable

## Quality Assurance

### Code Review Process
1. **Automated Checks**: Static analysis, code formatting, and basic compliance verification
2. **Peer Review**: Focus on business logic, architecture, and maintainability
3. **Technical Review**: Senior developer approval for architectural decisions and complex implementations
4. **Business Review**: Domain expert validation for business rules and workflows
5. **Final Approval**: Technical lead sign-off before merge to main branch

### Testing Gates
- **Unit Tests**: Must pass with ≥80% coverage
- **Integration Tests**: End-to-end workflow validation
- **Performance Tests**: Response time and throughput benchmarks
- **Security Tests**: Vulnerability scanning and penetration testing
- **User Acceptance Tests**: Business stakeholder validation

## Performance Requirements

### Response Time Standards
- **Page Load**: ≤2 seconds for standard pages, ≤5 seconds for complex reports
- **Database Operations**: ≤1 second for CRUD operations, ≤10 seconds for complex queries
- **API Endpoints**: ≤500ms for simple operations, ≤3 seconds for complex processing
- **Batch Jobs**: Progress indicators required for operations >5 seconds
- **Background Processing**: Proper job queue implementation with monitoring

### Scalability Targets
- **Concurrent Users**: Support minimum 50 concurrent users without performance degradation
- **Data Volume**: Design for hotels with 1000+ rooms and 10+ years of historical data
- **Transaction Volume**: Handle peak check-in/check-out periods (200+ operations/hour)
- **Storage Growth**: Plan for 20% annual data growth with performance maintenance
- **Integration Load**: Support real-time integration with PMS, POS, and booking engines

## Governance

### Constitutional Authority
This constitution supersedes all other development practices and coding standards. All development decisions MUST align with these principles. Violations require immediate remediation or formal exception approval.

### Amendment Process
- **Proposal**: Technical lead or senior developer proposes changes with business justification
- **Review**: Team review with impact analysis on existing codebase
- **Approval**: Unanimous technical team approval required for constitutional changes
- **Migration**: Implementation plan with timeline and backward compatibility strategy
- **Documentation**: Updated constitution with version increment and change rationale

### Compliance Monitoring
- **Daily**: Automated code quality checks in CI/CD pipeline
- **Weekly**: Code review metrics and technical debt assessment  
- **Monthly**: Performance benchmarks and scalability review
- **Quarterly**: Full constitutional compliance audit with remediation planning
- **Annually**: Constitution review and update based on technology evolution

All pull requests MUST include constitutional compliance verification. Complex architectural decisions require explicit justification against these principles. Development teams use this constitution as the primary decision-making framework for the Hotel PMS project.

**Version**: 1.0.0 | **Ratified**: 2025-10-22 | **Last Amended**: 2025-10-22
