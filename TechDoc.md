## **1. High-level Architecture**

**Style:**

- Backend: **Java (Spring Boot)** — REST API, stateless

- DB: **PostgreSQL** (or MySQL if you prefer)

- ORM: **Spring webflux**

- Auth: **JWT-based authentication**

- Storage: S3-compatible (or local FS in dev) for uploads

- Docs: **OpenAPI/Swagger** (springdoc-openapi)

**Services (logical):**

- `auth-service` (signup, login, JWT)

- `user-service` (profiles, roles)

- `brand-service` (brand profiles + franchise listings)

- `investor-service` (investor profiles)

- `lead-service` (franchise requests/leads)

- `admin-service` (approvals, moderation)

- `file-service` (uploads, linking)

For MVP, these can all live in **one Spring Boot app** as separate packages/modules.

***


## **2. Core Domain Model**

### **2.1 Entities**

    User

- `id: Long`

- `email: String` (unique)

- `passwordHash: String` (or nullable if OTP-based)

- `fullName: String`

- `phone: String`

- `role: UserRole` (ENUM: `ADMIN`, `BRAND_OWNER`, `INVESTOR`)

- `isEmailVerified: boolean`

- `isPhoneVerified: boolean`

- `createdAt, updatedAt`

Brand and Investor specific details go into separate tables related 1–1 or 1–many.

***

    Brand

Represents a brand owner’s entity (one user can own multiple brands, but MVP you can also keep 1–1).

- `id: Long`

- `owner: User` (ManyToOne)

- `brandName: String`

- `logoUrl: String` (nullable)

- `websiteUrl: String` (nullable)

- `description: Text`

- `createdAt, updatedAt`

- (**Optional-later**) `gstNumber: String`

- (**Optional-later**) `trademarkDocUrl: String

  `

***

    FranchiseListing

Public franchise opportunity.

- `id: Long`

- `brand: Brand` (ManyToOne)

- `title: String`

- `shortDescription: String`

- `fullDescription: Text`

- `minInvestment: BigDecimal`

- `maxInvestment: BigDecimal`

- `currency: String` (e.g., `"INR"`)

- `category: FranchiseCategory` (ENUM: `FOOD_BEV`, `RETAIL`, `EDTECH`, etc.)

- `city: String`

- `state: String`

- `country: String` (default `"IN"` for now)

- `status: ListingStatus` (ENUM: `DRAFT`, `PENDING_APPROVAL`, `APPROVED`, `REJECTED`, `ARCHIVED`)

- `reasonForRejection: String` (nullable)

- `isFeatured: boolean` (future monetization)

- `createdAt, updatedAt`

(**Optional-later**):

- `expectedRoiSummary: String` (nullable)

***

    InvestorProfile

Extra info for investor users.

- `id: Long`

- `user: User` (OneToOne)

- `minBudget: BigDecimal`

- `maxBudget: BigDecimal`

- `preferredCategories: Set<FranchiseCategory>`

- `preferredCities: String` (simple comma-separated / JSON string for MVP)

- `preferredStates: String`

- `investmentHorizonMonths: Integer` (nullable)

- `createdAt, updatedAt`

- (**Optional-later**) `panNumber: String`, `panDocUrl: String

  `

***

    Lead

Represents an investor request for a specific listing.

- `id: Long`

- `listing: FranchiseListing` (ManyToOne)

- `investor: InvestorProfile` (ManyToOne)

- `initialMessage: Text`

- `status: LeadStatus` (ENUM: `NEW`, `VIEWED_BY_BRAND`, `IN_DISCUSSION`, `REJECTED`, `CLOSED_WON`, `CLOSED_LOST`)

- `brandNote: Text` (notes by brand owner, internal)

- `createdAt, updatedAt`

Later can attach chat/messages as another entity.

***

    Document

File metadata (franchise decks, agreements, etc.)

- `id: Long`

- `ownerUser: User` (ManyToOne)

- `associatedBrand: Brand` (nullable)

- `associatedListing: FranchiseListing` (nullable)

- `fileName: String`

- `fileType: String` (MIME)

- `fileUrl: String`

- `documentType: DocumentType` (ENUM: `FRANCHISE_DECK`, `AGREEMENT_TEMPLATE`, `KYC`, etc.)

- `createdAt, updatedAt`

***

    AdminActionLog

Audit trail of critical actions.

- `id: Long`

- `adminUser: User`

- `actionType: AdminActionType` (ENUM)

- `entityType: String` (`"LISTING"`, `"USER"`, `"BRAND"`, etc.)

- `entityId: Long`

- `description: Text`

- `createdAt

  `

***


### **2.2 Enums (suggested)**

- `UserRole` – `ADMIN`, `BRAND_OWNER`, `INVESTOR`

- `ListingStatus` – `DRAFT`, `PENDING_APPROVAL`, `APPROVED`, `REJECTED`, `ARCHIVED`

- `LeadStatus` – `NEW`, `VIEWED_BY_BRAND`, `IN_DISCUSSION`, `REJECTED`, `CLOSED_WON`, `CLOSED_LOST`

- `FranchiseCategory` – etc.

- `DocumentType`**,** `AdminActionType`

***


## **3. API Design (MVP)**

Base URL: `/api/v1`

Use DTOs for requests/responses, not entities.


### **3.1 Auth APIs**

**POST** `/auth/register`

- Request:

    - `email`, `password`, `fullName`, `phone`, `role`

- Response:

    - `userId`, `role`, `accessToken`, `refreshToken` (if using refresh)

**POST** `/auth/login`

- Request:

    - `email`, `password`

- Response:

    - `accessToken`, `refreshToken`, `user` summary

**POST** `/auth/refresh` (optional MVP but recommended)

**POST** `/auth/logout` (optional; can be handled client-side by deleting token)

***


### **3.2 User & Profile APIs**

**GET** `/users/me`

- Auth required

- Response: current user details + role

**PUT** `/users/me`

- Update `fullName`, `phone`, etc.

\


**Investor profile**

**GET** `/investors/me
` **POST** `/investors` (first-time create)\
&#x20;**PUT** `/investors/me`

***


### **3.3 Brand & Listing APIs**

**Brand**

**GET** `/brands/my` – list brands owned by current user\
&#x20;**POST** `/brands` – create brand\
&#x20;**PUT** `/brands/{id}` – update (owner or admin)

**FranchiseListing**

**POST** `/brands/{brandId}/listings`

- Body: title, descriptions, investment range, location, category, etc.

- Result: listing with `status = DRAFT` or `PENDING_APPROVAL` (you choose flow).

**PUT** `/listings/{id}`

- Only brand owner (if editable) or admin.

**POST** `/listings/{id}/submit-for-approval`

- Changes status to `PENDING_APPROVAL`.

**GET** `/listings` (public / investor side)\
&#x20;Query params:

- `page`, `size`

- `city`

- `state`

- `minInvestment`, `maxInvestment`

- `category`

- `brandName` (optional search by name)

Returns paginated list with limited fields.

**GET** `/listings/{id}`

- Detailed info, including associated brand and attached public docs.

***


### **3.4 Lead APIs**

**POST** `/listings/{id}/leads` (Investor → Brand)

- Auth: `INVESTOR`

- Body:

    - `initialMessage`

- Creates `Lead` with `status = NEW`.

- Send notification to brand (email).

**GET** `/leads/as-investor`

- Auth: `INVESTOR`

- Returns leads created by this investor.

**GET** `/leads/as-brand`

- Auth: `BRAND_OWNER`

- Returns leads on listings of brands owned by this user.

**GET** `/leads/{id}`

- Accessible to involved brand\_owner or investor or admin.

**PATCH** `/leads/{id}`

- Update `status` (brand owner and admin), `brandNote` (brand owner).

No messaging/chat yet — that’s v2.

***

\
\



### **3.5 Admin APIs**

Auth: `ADMIN` only.

**GET** `/admin/listings?status=PENDING_APPROVAL`

- Paginated.

**POST** `/admin/listings/{id}/approve`

- Set status to `APPROVED`.

**POST** `/admin/listings/{id}/reject`

- Body: `reason`

- Sets status to `REJECTED`, stores reason.

**GET** `/admin/users`, `/admin/brands`, `/admin/leads` (basic list / filters)

***


### **3.6 File Upload APIs**

For MVP, simplest pattern:

**POST** `/files/upload`

- Multipart upload

- Query or body: `documentType`, optional `brandId`, `listingId`

- Store in S3/local; save record in `Document`.

- Return `documentId` + `fileUrl`.

**GET** `/files/{id}`

- Either direct redirect to pre-signed URL or stream.

You can later add role checks so only appropriate parties can view.

***

\



### **3.7 Notifications (Email)**

Use an async mechanism (e.g., Spring events + simple queue later, or just sync in MVP):

Events that trigger mail:

- New lead created → send to brand owner’s email.

- Listing approved/rejected → send to brand owner.

Expose no API first, but internal service `NotificationService`.

***


## **4. Security & Validation**

- **JWT** in `Authorization: Bearer <token>`.

- Method-level security annotations:

    - `@PreAuthorize("hasRole('BRAND_OWNER')")`, etc.

- Ownership checks:

    - For `/brands/{id}` operations, ensure `brand.owner.id == currentUser.id`.

    - For listing/lead access, validate same.

- Input validation:

    - Use `javax.validation` (`@NotNull`, `@Size`, `@Min`, `@Max`, etc.) on DTO classes.

- Rate limiting (optional later): per IP or per user for critical endpoints.

***

\
\
\
\



## **5. Packages / Module Structure (Suggestion)**

    com.yourcompany.franchise
      ├─ config/
      ├─ security/
      ├─ auth/
      ├─ users/
      ├─ brands/
      ├─ listings/
      ├─ investors/
      ├─ leads/
      ├─ documents/
      ├─ admin/
      ├─ notifications/
      └─ common/

Each feature package contains:

- `controller`

- `service`

- `repository`

- `dto`

- `model` (entities)

***


## **6. Non-functional Requirements (MVP-level)**

- **Performance**:

    - Pagination on list endpoints.

    - N+1 query avoidance with JPA fetch strategies.

- **Logging**:

    - Request/response logging (excluding sensitive fields).

    - Admin actions logged in `AdminActionLog`.

- **Error Handling**: Global `@ControllerAdvice` for consistent error response format.

- **Environment Config**:

    - Externalized properties (DB URL, S3 keys, JWT secret) via `application.yml` + env overrides.

***


## **7. Implementation Order (Backend)**

1. Project skeleton (Spring Boot, basic modules, DB config).

2. Entities + JPA repositories.

3. Auth (register/login + JWT).

4. Brand + Listing CRUD (with status flow).

5. Investor profile + listing search APIs.

6. Lead creation + listing leads view.

7. Admin approval flows.

8. File upload (basic).

9. Email notifications.

10. OpenAPI/Swagger documentation.
