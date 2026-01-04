# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: User description: "$ARGUMENTS"
**Prompt Intake**: `ops/intake/prompt.md` | `ops/intake/clarifications.md`

## Execution Flow (main)
```
1. Parse user description from Input
   → If empty: ERROR "No feature description provided"
2. Extract key concepts from description
   → Identify: actors, actions, data, constraints
3. For each unclear aspect:
   → Mark with [NEEDS CLARIFICATION: specific question]
4. Fill User Scenarios & Testing section
   → If no clear user flow: ERROR "Cannot determine user scenarios"
5. Generate Functional Requirements
   → Each requirement must be testable
   → Mark ambiguous requirements
6. Identify Key Entities (if data involved)
7. Run Review Checklist
   → If any [NEEDS CLARIFICATION]: WARN "Spec has uncertainties"
   → If implementation details found: ERROR "Remove tech details"
8. Return: SUCCESS (spec ready for planning)
```

---

## ⚡ Quick Guidelines
- ✅ Focus on WHAT users need and WHY
- ❌ Avoid HOW to implement (no tech stack, APIs, code structure)
- 👥 Written for business stakeholders, not developers

### Section Requirements
- **Mandatory sections**: Must be completed for every feature
- **Optional sections**: Include only when relevant to the feature
- When a section doesn't apply, remove it entirely (don't leave as "N/A")

### For AI Generation
When creating this spec from a user prompt:
1. **Mark all ambiguities**: Use [NEEDS CLARIFICATION: specific question] for any assumption you'd need to make
2. **Don't guess**: If the prompt doesn't specify something (e.g., "login system" without auth method), mark it
3. **Think like a tester**: Every vague requirement should fail the "testable and unambiguous" checklist item
4. **Common underspecified areas**:
   - User types and permissions
   - Data retention/deletion policies  
   - Performance targets and scale
   - Error handling behaviors
   - Integration requirements
   - Security/compliance needs

---

## User Scenarios & Testing *(mandatory)*

### Primary User Story
[Describe the main user journey in plain language]

### Acceptance Scenarios
1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

### Edge Cases
- What happens when [boundary condition]?
- How does system handle [error scenario]?

## Requirements *(mandatory)*

### Functional Requirements
- **FR-001**: System MUST [specific capability, e.g., "allow users to create accounts"]
- **FR-002**: System MUST [specific capability, e.g., "validate email addresses"]  
- **FR-003**: Users MUST be able to [key interaction, e.g., "reset their password"]
- **FR-004**: System MUST [data requirement, e.g., "persist user preferences"]
- **FR-005**: System MUST [behavior, e.g., "log all security events"]

*Example of marking unclear requirements:*
- **FR-006**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]
- **FR-007**: System MUST retain user data for [NEEDS CLARIFICATION: retention period not specified]

### Key Entities *(include if feature involves data)*
- **[Entity 1]**: [What it represents, key attributes without implementation]
- **[Entity 2]**: [What it represents, relationships to other entities]

---

## Platform Requirements *(include if mobile or cross-platform)*

### Target Platforms
- [ ] Android (Minimum API Level: ___)
- [ ] iOS (Minimum Version: ___)
- [ ] Web (PWA Support: Yes/No)
- [ ] Desktop (Platforms: ___)

### Device Requirements
- **Screen Sizes**: [phone only, phone + tablet, responsive to all sizes]
- **Orientation**: [portrait only, landscape only, both]
- **Offline Support**: [required, nice-to-have, not needed]
- **Background Processing**: [required, not needed]

### Platform-Specific Behaviors
*Remove platforms not applicable to this feature*
- **Android**: [e.g., back button handling, notification channels, widgets]
- **iOS**: [e.g., swipe gestures, haptic feedback, app clips]
- **Web**: [e.g., keyboard shortcuts, drag-and-drop, PWA install prompt]

### App Store Requirements *(include for mobile apps)*
- **Age Rating**: [4+, 9+, 12+, 17+]
- **Required Permissions**: [camera, location, notifications, contacts, etc.]
- **Privacy Labels / Data Safety**: [data types collected, usage purposes]
- **In-App Purchases**: [none, consumables, subscriptions]

---

## UI/UX Requirements *(include for frontend/mobile)*

### Accessibility
- [ ] Screen reader support (VoiceOver / TalkBack)
- [ ] Minimum touch target size (44x44 pt iOS, 48x48 dp Android)
- [ ] Sufficient color contrast (WCAG AA minimum)
- [ ] Keyboard navigation support (web)
- [ ] Reduced motion support

### Responsive Design *(web/PWA only)*
- **Breakpoints**: [mobile, tablet, desktop sizes]
- **Critical Path**: [what must work on smallest screen]

### Performance Expectations
- **App Launch**: [target cold start time, e.g., <2 seconds]
- **Screen Transitions**: [target animation frame rate, e.g., 60fps]
- **Network Requests**: [timeout expectations, offline behavior]

---

## Review & Acceptance Checklist
*GATE: Automated checks run during main() execution*

### Content Quality
- [ ] No implementation details (languages, frameworks, APIs)
- [ ] Focused on user value and business needs
- [ ] Written for non-technical stakeholders
- [ ] All mandatory sections completed

### Requirement Completeness
- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous  
- [ ] Success criteria are measurable
- [ ] Scope is clearly bounded
- [ ] Dependencies and assumptions identified

---

## Execution Status
*Updated by main() during processing*

- [ ] User description parsed
- [ ] Key concepts extracted
- [ ] Ambiguities marked
- [ ] User scenarios defined
- [ ] Requirements generated
- [ ] Entities identified
- [ ] Review checklist passed

---
