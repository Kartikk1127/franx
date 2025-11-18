# **Franx API Documentation**


---


## **Base URL**

http://localhost:8080/api/v1


## **Authentication**

Most endpoints require JWT authentication via `Authorization` header:

Authorization: Bearer &lt;jwt_token>


---


# **1. AUTH MODULE**


## **1.1 Register User**

**Endpoint:** `POST /auth/register \
` **Description:** Register a new user (investor, brand owner, or admin). Creates user account with hashed password.

**Request Body:**

json

{

"email": "john@example.com",

"password": "SecurePass123!",

"phone": "+919876543210",

"role": "BRAND_OWNER"

}

**Response:** `201 Created`

json

{

"id": "550e8400-e29b-41d4-a716-446655440000",

"email": "john@example.com",

"phone": "+919876543210",

"role": "BRAND_OWNER",

"emailVerified": false,

"phoneVerified": false,

"status": "ACTIVE",

"createdAt": "2025-11-19T10:30:00Z"

}

**Error Response:** `400 Bad Request`

json

{

"error": "VALIDATION_ERROR",

"message": "Email already exists",

"timestamp": "2025-11-19T10:30:00Z"

}


---


## **1.2 Login**

**Endpoint:** `POST /auth/login \
` **Description:** Authenticate user and receive JWT access token and refresh token.

**Request Body:**

json

{

"email": "john@example.com",

"password": "SecurePass123!"

}

**Response:** `200 OK`

json

{

"accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",

"refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",

"tokenType": "Bearer",

"expiresIn": 3600,

"user": {

    "id": "550e8400-e29b-41d4-a716-446655440000",

    "email": "john@example.com",

    "role": "BRAND_OWNER"

}

}

**Error Response:** `401 Unauthorized`

json

{

"error": "INVALID_CREDENTIALS",

"message": "Invalid email or password",

"timestamp": "2025-11-19T10:30:00Z"

}


---


## **1.3 Refresh Token**

**Endpoint:** `POST /auth/refresh \
` **Description:** Get new access token using refresh token when access token expires.

**Request Body:**

json

{

"refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

}

**Response:** `200 OK`

json

{

"accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",

"refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",

"tokenType": "Bearer",

"expiresIn": 3600

}


---


## **1.4 Logout**

**Endpoint:** `POST /auth/logout \
` **Description:** Invalidate refresh token and logout user. \
**Auth Required:** Yes

**Request Body:**

json

{

"refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

}

**Response:** `200 OK`

json

{

"message": "Logged out successfully"

}


---


# **2. BRANDS MODULE**


## **2.1 Create Brand**

**Endpoint:** `POST /brands \
` **Description:** Create a new brand profile. Only users with BRAND_OWNER role can create brands. \
**Auth Required:** Yes (BRAND_OWNER)

**Request Body:**

json

{

"brandName": "McDonald's India",

"description": "Leading fast food franchise with global presence",

"website": "https://mcdonalds.co.in",

"establishedYear": 1996,

"headquartersLocation": "Mumbai, Maharashtra"

}

**Response:** `201 Created`

json

{

"id": "brand-550e8400-e29b-41d4-a716-446655440000",

"ownerId": "550e8400-e29b-41d4-a716-446655440000",

"brandName": "McDonald's India",

"description": "Leading fast food franchise with global presence",

"logoUrl": null,

"website": "https://mcdonalds.co.in",

"establishedYear": 1996,

"headquartersLocation": "Mumbai, Maharashtra",

"status": "ACTIVE",

"createdAt": "2025-11-19T10:30:00Z",

"updatedAt": "2025-11-19T10:30:00Z"

}

**Error Response:** `409 Conflict`

json

{

"error": "BRAND_ALREADY_EXISTS",

"message": "User already owns a brand",

"timestamp": "2025-11-19T10:30:00Z"

}


---


## **2.2 Get My Brand**

**Endpoint:** `GET /brands/my \
` **Description:** Get the brand owned by the authenticated user. \
**Auth Required:** Yes (BRAND_OWNER)

**Response:** `200 OK`

json

{

"id": "brand-550e8400-e29b-41d4-a716-446655440000",

"ownerId": "550e8400-e29b-41d4-a716-446655440000",

"brandName": "McDonald's India",

"description": "Leading fast food franchise with global presence",

"logoUrl": "https://s3.amazonaws.com/franx/logos/mcdonalds.png",

"website": "https://mcdonalds.co.in",

"establishedYear": 1996,

"headquartersLocation": "Mumbai, Maharashtra",

"status": "ACTIVE",

"createdAt": "2025-11-19T10:30:00Z",

"updatedAt": "2025-11-19T10:35:00Z"

}

**Error Response:** `404 Not Found`

json

{

"error": "BRAND_NOT_FOUND",

"message": "No brand found for this user",

"timestamp": "2025-11-19T10:30:00Z"

}


---


## **2.3 Update Brand**

**Endpoint:** `PUT /brands/{brandId} \
` **Description:** Update brand details. Only the brand owner can update their brand. \
**Auth Required:** Yes (BRAND_OWNER)

**Request Body:**

json

{

"brandName": "McDonald's India Pvt Ltd",

"description": "World's leading fast food franchise with 200+ outlets in India",

"website": "https://mcdonalds.co.in",

"establishedYear": 1996,

"headquartersLocation": "Mumbai, Maharashtra",

"logoUrl": "https://s3.amazonaws.com/franx/logos/mcdonalds-new.png"

}

**Response:** `200 OK`

json

{

"id": "brand-550e8400-e29b-41d4-a716-446655440000",

"ownerId": "550e8400-e29b-41d4-a716-446655440000",

"brandName": "McDonald's India Pvt Ltd",

"description": "World's leading fast food franchise with 200+ outlets in India",

"logoUrl": "https://s3.amazonaws.com/franx/logos/mcdonalds-new.png",

"website": "https://mcdonalds.co.in",

"establishedYear": 1996,

"headquartersLocation": "Mumbai, Maharashtra",

"status": "ACTIVE",

"createdAt": "2025-11-19T10:30:00Z",

"updatedAt": "2025-11-19T11:00:00Z"

}


---


## **2.4 Get Brand By ID**

**Endpoint:** `GET /brands/{brandId} \
` **Description:** Get public brand details by ID. Accessible to all authenticated users. \
**Auth Required:** Yes

**Response:** `200 OK`

json

{

"id": "brand-550e8400-e29b-41d4-a716-446655440000",

"brandName": "McDonald's India",

"description": "Leading fast food franchise with global presence",

"logoUrl": "https://s3.amazonaws.com/franx/logos/mcdonalds.png",

"website": "https://mcdonalds.co.in",

"establishedYear": 1996,

"headquartersLocation": "Mumbai, Maharashtra",

"status": "ACTIVE"

}


---


# **3. LISTINGS MODULE**


## **3.1 Create Listing**

**Endpoint:** `POST /brands/{brandId}/listings \
` **Description:** Create a new franchise listing under a brand. Created in DRAFT status by default. \
**Auth Required:** Yes (BRAND_OWNER)

**Request Body:**

json

{

"title": "McDonald's Franchise - Tier 2 Cities",

"description": "Opportunity to own McDonald's franchise in emerging tier 2 cities",

"category": "FOOD_BEVERAGE",

"minInvestment": 5000000,

"maxInvestment": 10000000,

"currency": "INR",

"franchiseFee": 2500000,

"royaltyPercentage": 5.0,

"areaRequiredSqft": 1500,

"staffRequired": 15,

"locations": [

    {

      "city": "Indore",

      "state": "Madhya Pradesh",

      "country": "India"

    },

    {

      "city": "Coimbatore",

      "state": "Tamil Nadu",

      "country": "India"

    }

]

}

**Response:** `201 Created`

json

{

"id": "listing-750e8400-e29b-41d4-a716-446655440000",

"brandId": "brand-550e8400-e29b-41d4-a716-446655440000",

"title": "McDonald's Franchise - Tier 2 Cities",

"description": "Opportunity to own McDonald's franchise in emerging tier 2 cities",

"category": "FOOD_BEVERAGE",

"minInvestment": 5000000,

"maxInvestment": 10000000,

"currency": "INR",

"franchiseFee": 2500000,

"royaltyPercentage": 5.0,

"areaRequiredSqft": 1500,

"staffRequired": 15,

"status": "DRAFT",

"locations": [

    {

      "id": "loc-850e8400-e29b-41d4-a716-446655440000",

      "city": "Indore",

      "state": "Madhya Pradesh",

      "country": "India"

    },

    {

      "id": "loc-950e8400-e29b-41d4-a716-446655440000",

      "city": "Coimbatore",

      "state": "Tamil Nadu",

      "country": "India"

    }

],

"createdAt": "2025-11-19T10:30:00Z",

"updatedAt": "2025-11-19T10:30:00Z"

}


---


## **3.2 Get All Listings (Public Browse)**

**Endpoint:** `GET /listings \
` **Description:** Browse all approved franchise listings with filters. Only shows APPROVED listings to investors. \
**Auth Required:** Yes

**Query Parameters:**



* `category` (optional): Filter by category (e.g., FOOD_BEVERAGE, RETAIL, EDUCATION)
* `minInvestment` (optional): Minimum investment filter
* `maxInvestment` (optional): Maximum investment filter
* `city` (optional): Filter by city
* `state` (optional): Filter by state
* `page` (optional, default: 0): Page number
* `size` (optional, default: 20): Page size

**Example:** `GET /listings?category=FOOD_BEVERAGE&minInvestment=5000000&maxInvestment=10000000&city=Indore&page=0&size=20`

**Response:** `200 OK`

json

{

"content": [

    {

      "id": "listing-750e8400-e29b-41d4-a716-446655440000",

      "brandId": "brand-550e8400-e29b-41d4-a716-446655440000",

      "brandName": "McDonald's India",

      "brandLogo": "https://s3.amazonaws.com/franx/logos/mcdonalds.png",

      "title": "McDonald's Franchise - Tier 2 Cities",

      "description": "Opportunity to own McDonald's franchise in emerging tier 2 cities",

      "category": "FOOD_BEVERAGE",

      "minInvestment": 5000000,

      "maxInvestment": 10000000,

      "currency": "INR",

      "locations": [

        {

          "city": "Indore",

          "state": "Madhya Pradesh",

          "country": "India"

        },

        {

          "city": "Coimbatore",

          "state": "Tamil Nadu",

          "country": "India"

        }

      ],

      "approvedAt": "2025-11-19T12:00:00Z"

    }

],

"pageable": {

    "pageNumber": 0,

    "pageSize": 20,

    "totalElements": 1,

    "totalPages": 1

}

}


---


## **3.3 Get Listing By ID**

**Endpoint:** `GET /listings/{listingId} \
` **Description:** Get detailed information about a specific listing. Includes full details with brand info. \
**Auth Required:** Yes

**Response:** `200 OK`

json

{

"id": "listing-750e8400-e29b-41d4-a716-446655440000",

"brand": {

    "id": "brand-550e8400-e29b-41d4-a716-446655440000",

    "brandName": "McDonald's India",

    "logoUrl": "https://s3.amazonaws.com/franx/logos/mcdonalds.png",

    "website": "https://mcdonalds.co.in",

    "establishedYear": 1996

},

"title": "McDonald's Franchise - Tier 2 Cities",

"description": "Opportunity to own McDonald's franchise in emerging tier 2 cities",

"category": "FOOD_BEVERAGE",

"minInvestment": 5000000,

"maxInvestment": 10000000,

"currency": "INR",

"franchiseFee": 2500000,

"royaltyPercentage": 5.0,

"areaRequiredSqft": 1500,

"staffRequired": 15,

"status": "APPROVED",

"locations": [

    {

      "id": "loc-850e8400-e29b-41d4-a716-446655440000",

      "city": "Indore",

      "state": "Madhya Pradesh",

      "country": "India"

    },

    {

      "id": "loc-950e8400-e29b-41d4-a716-446655440000",

      "city": "Coimbatore",

      "state": "Tamil Nadu",

      "country": "India"

    }

],

"approvedAt": "2025-11-19T12:00:00Z",

"createdAt": "2025-11-19T10:30:00Z",

"updatedAt": "2025-11-19T12:00:00Z"

}


---


## **3.4 Update Listing**

**Endpoint:** `PUT /listings/{listingId} \
` **Description:** Update listing details. Only brand owner can update. If listing is APPROVED, status reverts to DRAFT. \
**Auth Required:** Yes (BRAND_OWNER)

**Request Body:**

json

{

"title": "McDonald's Franchise - Premium Tier 2 Cities",

"description": "Exclusive opportunity to own McDonald's franchise in emerging tier 2 cities with high footfall",

"category": "FOOD_BEVERAGE",

"minInvestment": 6000000,

"maxInvestment": 12000000,

"currency": "INR",

"franchiseFee": 3000000,

"royaltyPercentage": 5.5,

"areaRequiredSqft": 2000,

"staffRequired": 20,

"locations": [

    {

      "city": "Indore",

      "state": "Madhya Pradesh",

      "country": "India"

    },

    {

      "city": "Coimbatore",

      "state": "Tamil Nadu",

      "country": "India"

    },

    {

      "city": "Nagpur",

      "state": "Maharashtra",

      "country": "India"

    }

]

}

**Response:** `200 OK`

json

{

"id": "listing-750e8400-e29b-41d4-a716-446655440000",

"brandId": "brand-550e8400-e29b-41d4-a716-446655440000",

"title": "McDonald's Franchise - Premium Tier 2 Cities",

"description": "Exclusive opportunity to own McDonald's franchise in emerging tier 2 cities with high footfall",

"category": "FOOD_BEVERAGE",

"minInvestment": 6000000,

"maxInvestment": 12000000,

"currency": "INR",

"franchiseFee": 3000000,

"royaltyPercentage": 5.5,

"areaRequiredSqft": 2000,

"staffRequired": 20,

"status": "DRAFT",

"locations": [

    {

      "id": "loc-850e8400-e29b-41d4-a716-446655440000",

      "city": "Indore",

      "state": "Madhya Pradesh",

      "country": "India"

    },

    {

      "id": "loc-950e8400-e29b-41d4-a716-446655440000",

      "city": "Coimbatore",

      "state": "Tamil Nadu",

      "country": "India"

    },

    {

      "id": "loc-1050e8400-e29b-41d4-a716-446655440000",

      "city": "Nagpur",

      "state": "Maharashtra",

      "country": "India"

    }

],

"createdAt": "2025-11-19T10:30:00Z",

"updatedAt": "2025-11-19T14:00:00Z"

}


---


## **3.5 Get My Listings**

**Endpoint:** `GET /brands/{brandId}/listings \
` **Description:** Get all listings for a specific brand. Shows all statuses (DRAFT, PENDING, APPROVED, REJECTED). \
**Auth Required:** Yes (BRAND_OWNER)

**Query Parameters:**



* `status` (optional): Filter by status
* `page` (optional, default: 0): Page number
* `size` (optional, default: 20): Page size

**Response:** `200 OK`

json

{

"content": [

    {

      "id": "listing-750e8400-e29b-41d4-a716-446655440000",

      "title": "McDonald's Franchise - Tier 2 Cities",

      "category": "FOOD_BEVERAGE",

      "minInvestment": 5000000,

      "maxInvestment": 10000000,

      "status": "APPROVED",

      "submittedAt": "2025-11-19T11:00:00Z",

      "approvedAt": "2025-11-19T12:00:00Z",

      "createdAt": "2025-11-19T10:30:00Z"

    },

    {

      "id": "listing-850e8400-e29b-41d4-a716-446655440000",

      "title": "McDonald's Franchise - Metro Cities",

      "category": "FOOD_BEVERAGE",

      "minInvestment": 15000000,

      "maxInvestment": 25000000,

      "status": "DRAFT",

      "createdAt": "2025-11-19T15:00:00Z"

    }

],

"pageable": {

    "pageNumber": 0,

    "pageSize": 20,

    "totalElements": 2,

    "totalPages": 1

}

}


---


## **3.6 Submit Listing for Approval**

**Endpoint:** `POST /listings/{listingId}/submit-for-approval \
` **Description:** Submit a DRAFT listing for admin approval. Changes status from DRAFT to PENDING_APPROVAL. \
**Auth Required:** Yes (BRAND_OWNER)

**Response:** `200 OK`

json

{

"id": "listing-750e8400-e29b-41d4-a716-446655440000",

"status": "PENDING_APPROVAL",

"submittedAt": "2025-11-19T11:00:00Z",

"message": "Listing submitted for approval successfully"

}

**Error Response:** `400 Bad Request`

json

{

"error": "INVALID_STATUS",

"message": "Only DRAFT listings can be submitted for approval",

"timestamp": "2025-11-19T11:00:00Z"

}


---


## **3.7 Delete Listing**

**Endpoint:** `DELETE /listings/{listingId} \
` **Description:** Delete a listing. Only DRAFT and REJECTED listings can be deleted. \
**Auth Required:** Yes (BRAND_OWNER)

**Response:** `204 No Content`

**Error Response:** `400 Bad Request`

json

{

"error": "CANNOT_DELETE",

"message": "Cannot delete listing with status APPROVED",

"timestamp": "2025-11-19T11:00:00Z"

}


---


# **4. INVESTORS MODULE**


## **4.1 Create Investor Profile**

**Endpoint:** `POST /investors/profile \
` **Description:** Create investor profile with budget and preferences. Required before creating leads. \
**Auth Required:** Yes (INVESTOR)

**Request Body:**

json

{

"minBudget": 5000000,

"maxBudget": 15000000,

"currency": "INR",

"experienceLevel": "FIRST_TIME",

"preferredCategories": ["FOOD_BEVERAGE", "RETAIL", "EDUCATION"],

"preferredLocations": [

    {

      "city": "Mumbai",

      "state": "Maharashtra",

      "country": "India"

    },

    {

      "city": "Pune",

      "state": "Maharashtra",

      "country": "India"

    }

]

}

**Response:** `201 Created`

json

{

"id": "profile-650e8400-e29b-41d4-a716-446655440000",

"userId": "550e8400-e29b-41d4-a716-446655440000",

"minBudget": 5000000,

"maxBudget": 15000000,

"currency": "INR",

"experienceLevel": "FIRST_TIME",

"preferredCategories": [

    {

      "id": "cat-1",

      "category": "FOOD_BEVERAGE"

    },

    {

      "id": "cat-2",

      "category": "RETAIL"

    },

    {

      "id": "cat-3",

      "category": "EDUCATION"

    }

],

"preferredLocations": [

    {

      "id": "loc-1",

      "city": "Mumbai",

      "state": "Maharashtra",

      "country": "India"

    },

    {

      "id": "loc-2",

      "city": "Pune",

      "state": "Maharashtra",

      "country": "India"

    }

],

"createdAt": "2025-11-19T10:30:00Z",

"updatedAt": "2025-11-19T10:30:00Z"

}


---


## **4.2 Get My Investor Profile**

**Endpoint:** `GET /investors/profile/my \
` **Description:** Get the investor profile for authenticated user. \
**Auth Required:** Yes (INVESTOR)

**Response:** `200 OK`

json

{

"id": "profile-650e8400-e29b-41d4-a716-446655440000",

"userId": "550e8400-e29b-41d4-a716-446655440000",

"minBudget": 5000000,

"maxBudget": 15000000,

"currency": "INR",

"experienceLevel": "FIRST_TIME",

"preferredCategories": [

    {

      "id": "cat-1",

      "category": "FOOD_BEVERAGE"

    },

    {

      "id": "cat-2",

      "category": "RETAIL"

    }

],

"preferredLocations": [

    {

      "id": "loc-1",

      "city": "Mumbai",

      "state": "Maharashtra",

      "country": "India"

    }

],

"createdAt": "2025-11-19T10:30:00Z",

"updatedAt": "2025-11-19T14:00:00Z"

}


---


## **4.3 Update Investor Profile**

**Endpoint:** `PUT /investors/profile \
` **Description:** Update investor profile details including budget and preferences. \
**Auth Required:** Yes (INVESTOR)

**Request Body:**

json

{

"minBudget": 8000000,

"maxBudget": 20000000,

"currency": "INR",

"experienceLevel": "EXPERIENCED",

"preferredCategories": ["FOOD_BEVERAGE", "HEALTHCARE"],

"preferredLocations": [

    {

      "city": "Bangalore",

      "state": "Karnataka",

      "country": "India"

    },

    {

      "city": "Hyderabad",

      "state": "Telangana",

      "country": "India"

    }

]

}

**Response:** `200 OK`

json

{

"id": "profile-650e8400-e29b-41d4-a716-446655440000",

"userId": "550e8400-e29b-41d4-a716-446655440000",

"minBudget": 8000000,

"maxBudget": 20000000,

"currency": "INR",

"experienceLevel": "EXPERIENCED",

"preferredCategories": [

    {

      "id": "cat-1",

      "category": "FOOD_BEVERAGE"

    },

    {

      "id": "cat-4",

      "category": "HEALTHCARE"

    }

],

"preferredLocations": [

    {

      "id": "loc-3",

      "city": "Bangalore",

      "state": "Karnataka",

      "country": "India"

    },

    {

      "id": "loc-4",

      "city": "Hyderabad",

      "state": "Telangana",

      "country": "India"

    }

],

"createdAt": "2025-11-19T10:30:00Z",

"updatedAt": "2025-11-19T16:00:00Z"

}


---


## **4.4 Get Recommended Listings**

**Endpoint:** `GET /investors/recommendations \
` **Description:** Get personalized franchise recommendations based on investor profile preferences. \
**Auth Required:** Yes (INVESTOR)

**Query Parameters:**



* `page` (optional, default: 0): Page number
* `size` (optional, default: 20): Page size

**Response:** `200 OK`

json

{

"content": [

    {

      "id": "listing-750e8400-e29b-41d4-a716-446655440000",

      "brandName": "McDonald's India",

      "brandLogo": "https://s3.amazonaws.com/franx/logos/mcdonalds.png",

      "title": "McDonald's Franchise - Tier 2 Cities",

      "category": "FOOD_BEVERAGE",

      "minInvestment": 5000000,

      "maxInvestment": 10000000,

      "matchScore": 95,

      "matchReasons": [

        "Within your budget range",

        "Matches preferred category",

        "Available in your preferred locations"

      ]

    }

],

"pageable": {

    "pageNumber": 0,

    "pageSize": 20,

    "totalElements": 1,

    "totalPages": 1

}

}


---


# **5. LEADS MODULE**


## **5.1 Create Lead**

**Endpoint:** `POST /listings/{listingId}/leads \
` **Description:** Investor expresses interest in a listing by creating a lead. Sends notification to brand owner. \
**Auth Required:** Yes (INVESTOR)

**Request Body:**

json

{

"message": "Hi, I'm interested in this franchise opportunity in Indore. I have retail experience and meet the investment criteria. Please share more details."

}

**Response:** `201 Created`

json

{

"id": "lead-950e8400-e29b-41d4-a716-446655440000",

"listingId": "listing-750e8400-e29b-41d4-a716-446655440000",

"investorId": "550e8400-e29b-41d4-a716-446655440000",

"brandId": "brand-550e8400-e29b-41d4-a716-446655440000",

"message": "Hi, I'm interested in this franchise opportunity in Indore. I have retail experience and meet the investment criteria. Please share more details.",

"status": "NEW",

"createdAt": "2025-11-19T10:30:00Z"

}

**Error Response:** `409 Conflict`

json

{

"error": "LEAD_ALREADY_EXISTS",

"message": "You have already expressed interest in this listing",

"timestamp": "2025-11-19T10:30:00Z"

}


---


## **5.2 Get Leads as Investor**

**Endpoint:** `GET /leads/as-investor \
` **Description:** Get all leads created by the authenticated investor with listing details. \
**Auth Required:** Yes (INVESTOR)

**Query Parameters:**



* `status` (optional): Filter by status
* `page` (optional, default: 0): Page number
* `size` (optional, default: 20): Page size

**Response:** `200 OK`

json

{

"content": [

    {

      "id": "lead-950e8400-e29b-41d4-a716-446655440000",

      "listing": {

        "id": "listing-750e8400-e29b-41d4-a716-446655440000",

        "title": "McDonald's Franchise - Tier 2 Cities",

        "brandName": "McDonald's India",

        "brandLogo": "https://s3.amazonaws.com/franx/logos/mcdonalds.png",

        "category": "FOOD_BEVERAGE",

        "minInvestment": 5000000,

        "maxInvestment": 10000000

      },

      "message": "Hi, I'm interested in this franchise opportunity in Indore.",

      "status": "CONTACTED",

      "createdAt": "2025-11-19T10:30:00Z",

      "respondedAt": "2025-11-19T15:00:00Z"

    }

],

"pageable": {

    "pageNumber": 0,

    "pageSize": 20,

    "totalElements": 1,

    "totalPages": 1

}

}


---


## **5.3 Get Leads as Brand**

**Endpoint:** `GET /leads/as-brand \
` **Description:** Get all leads received for brand's listings with investor contact details. \
**Auth Required:** Yes (BRAND_OWNER)

**Query Parameters:**



* `status` (optional): Filter by status
* `listingId` (optional): Filter by specific listing
* `page` (optional, default: 0): Page number
* `size` (optional, default: 20): Page size

**Response:** `200 OK`

json

{

"content": [

    {

      "id": "lead-950e8400-e29b-41d4-a716-446655440000",

      "listing": {

        "id": "listing-750e8400-e29b-41d4-a716-446655440000",

        "title": "McDonald's Franchise - Tier 2 Cities"

      },

      "investor": {

        "id": "550e8400-e29b-41d4-a716-446655440000",

        "email": "sarah@investor.com",

        "phone": "+919876543210",

        "budget": {

          "min": 5000000,

          "max": 15000000

        },

        "experienceLevel": "FIRST_TIME"

      },

      "message": "Hi, I'm interested in this franchise opportunity in Indore.",

      "status": "NEW",

      "createdAt": "2025-11-19T10:30:00Z",

      "respondedAt": null

    }

],

"pageable": {

    "pageNumber": 0,

    "pageSize": 20,

    "totalElements": 1,

    "totalPages": 1

}

}


---


## **5.4 Update Lead Status**

**Endpoint:** `PATCH /leads/{leadId}/status \
` **Description:** Brand owner updates lead status to track progress. \
**Auth Required:** Yes (BRAND_OWNER)

**Request Body:**

json

{

"status": "CONTACTED"

}

**Response:** `200 OK`

json

{

"id": "lead-950e8400-e29b-41d4-a716-446655440000",

"status": "CONTACTED",

"respondedAt": "2025-11-19T15:00:00Z",

"updatedAt": "2025-11-19T15:00:00Z",

"message": "Lead status updated successfully"

}


---


## **5.5 Get Lead By ID**

**Endpoint:** `GET /leads/{leadId} \
` **Description:** Get detailed information about a specific lead. Accessible to both investor and brand owner. \
**Auth Required:** Yes

**Response:** `200 OK`

json

{

"id": "lead-950e8400-e29b-41d4-a716-446655440000",

"listing": {

    "id": "listing-750e8400-e29b-41d4-a716-446655440000",

    "title": "McDonald's Franchise - Tier 2 Cities",

    "brandName": "McDonald's India",

    "category": "FOOD_BEVERAGE"

},

"investor": {

    "id": "550e8400-e29b-41d4-a716-446655440000",

    "email": "sarah@investor.com",

    "phone": "+919876543210"

},

"message": "Hi, I'm interested in this franchise opportunity in Indore.",

"status": "IN_DISCUSSION",

"createdAt": "2025-11-19T10:30:00Z",

"respondedAt": "2025-11-19T15:00:00Z",

"updatedAt": "2025-11-19T16:30:00Z"

}


---


# **6. ADMIN MODULE**


## **6.1 Get Pending Listings**

**Endpoint:** `GET /admin/listings \
` **Description:** Get all listings pending approval or with specific status for moderation. \
**Auth Required:** Yes (ADMIN)

**Query Parameters:**



* `status` (optional, default: PENDING_APPROVAL): Filter by status
* `page` (optional, default: 0): Page number
* `size` (optional, default: 20): Page size

**Response:** `200 OK`

json

{

"content": [

    {

      "id": "listing-750e8400-e29b-41d4-a716-446655440000",

      "brand": {

        "id": "brand-550e8400-e29b-41d4-a716-446655440000",

        "brandName": "McDonald's India",

        "logoUrl": "https://s3.amazonaws.com/franx/logos/mcdonalds.png"

      },

      "title": "McDonald's Franchise - Tier 2 Cities",

      "category": "FOOD_BEVERAGE",

      "minInvestment": 5000000,

      "maxInvestment": 10000000,

      "status": "PENDING_APPROVAL",

      "submittedAt": "2025-11-19T11:00:00Z",

      "createdAt": "2025-11-19T10:30:00Z"

    }

],

"pageable": {

    "pageNumber": 0,

    "pageSize": 20,

    "totalElements": 1,

    "totalPages": 1

}

}


---


## **6.2 Approve Listing**

**Endpoint:** `POST /admin/listings/{listingId}/approve \
` **Description:** Approve a pending listing. Changes status to APPROVED and makes it visible to investors. \
**Auth Required:** Yes (ADMIN)

**Response:** `200 OK`

json

{

"id": "listing-750e8400-e29b-41d4-a716-446655440000",

"status": "APPROVED",

"approvedAt": "2025-11-19T12:00:00Z",

"approvedBy": "admin-550e8400-e29b-41d4-a716-446655440000",

"message": "Listing approved successfully"

}


---


## **6.3 Reject Listing**

**Endpoint:** `POST /admin/listings/{listingId}/reject \
` **Description:** Reject a pending listing with reason. Changes status to REJECTED. \
**Auth Required:** Yes (ADMIN)

**Request Body:**

json

{

"reason": "Investment figures appear unrealistic. Please provide supporting documentation."

}

**Response:** `200 OK`

json

{

"id": "listing-750e8400-e29b-41d4-a716-446655440000",

"status": "REJECTED",

"rejectionReason": "Investment figures appear unrealistic. Please provide supporting documentation.",

"rejectedAt": "2025-11-19T12:00:00Z",

"rejectedBy": "admin-550e8400-e29b-41d4-a716-446655440000",

"message": "Listing rejected successfully"

}


---


## **6.4 Get All Users**

**Endpoint:** `GET /admin/users \
` **Description:** Get all users with filtering options for moderation. \
**Auth Required:** Yes (ADMIN)

**Query Parameters:**



* `role` (optional): Filter by role
* `status` (optional): Filter by status
* `page` (optional, default: 0): Page number
* `size` (optional, default: 20): Page size

**Response:** `200 OK`

json

{

"content": [

    {

      "id": "550e8400-e29b-41d4-a716-446655440000",

      "email": "john@example.com",

      "phone": "+919876543210",

      "role": "BRAND_OWNER",

      "emailVerified": true,

      "phoneVerified": true,

      "status": "ACTIVE",

      "createdAt": "2025-11-19T10:00:00Z"

    },

    {

      "id": "650e8400-e29b-41d4-a716-446655440000",

      "email": "sarah@investor.com",

      "phone": "+919876543211",

      "role": "INVESTOR",

      "emailVerified": true,

      "phoneVerified": false,

      "status": "ACTIVE",

      "createdAt": "2025-11-19T10:15:00Z"

    }

],

"pageable": {

    "pageNumber": 0,

    "pageSize": 20,

    "totalElements": 2,

    "totalPages": 1

}

}


---


## **6.5 Suspend User**

**Endpoint:** `POST /admin/users/{userId}/suspend \
` **Description:** Suspend a user account. Prevents user from accessing the platform. \
**Auth Required:** Yes (ADMIN)

**Request Body:**

json

{

"reason": "Violation of terms of service - fraudulent listing"

}

**Response:** `200 OK`

json

{

"id": "550e8400-e29b-41d4-a716-446655440000",

"status": "SUSPENDED",

"suspendedAt": "2025-11-19T14:00:00Z",

"suspendedBy": "admin-550e8400-e29b-41d4-a716-446655440000",

"reason": "Violation of terms of service - fraudulent listing",

"message": "User suspended successfully"

}


---


## **6.6 Activate User**

**Endpoint:** `POST /admin/users/{userId}/activate \
` **Description:** Reactivate a suspended user account. \
**Auth Required:** Yes (ADMIN)

**Response:** `200 OK`

json

{

"id": "550e8400-e29b-41d4-a716-446655440000",

"status": "ACTIVE",

"activatedAt": "2025-11-19T15:00:00Z",

"activatedBy": "admin-550e8400-e29b-41d4-a716-446655440000",

"message": "User activated successfully"

}


---


## **6.7 Get Audit Logs**

**Endpoint:** `GET /admin/audit-logs \
` **Description:** Get audit trail of all admin actions for compliance and tracking. \
**Auth Required:** Yes (ADMIN)

**Query Parameters:**



* `adminId` (optional): Filter by admin who performed action
* `entityType` (optional): Filter by entity type
* `entityId` (optional): Filter by specific entity
* `action` (optional): Filter by action type
* `startDate` (optional): Filter from date
* `endDate` (optional): Filter to date
* `page` (optional, default: 0): Page number
* `size` (optional, default: 50): Page size

**Response:** `200 OK`

json

{

"content": [

    {

      "id": "audit-1050e8400-e29b-41d4-a716-446655440000",

      "adminId": "admin-550e8400-e29b-41d4-a716-446655440000",

      "adminEmail": "admin@franx.com",

      "action": "APPROVE_LISTING",

      "entityType": "LISTING",

      "entityId": "listing-750e8400-e29b-41d4-a716-446655440000",

      "metadata": {

        "listingTitle": "McDonald's Franchise - Tier 2 Cities",

        "brandId": "brand-550e8400-e29b-41d4-a716-446655440000"

      },

      "createdAt": "2025-11-19T12:00:00Z"

    },

    {

      "id": "audit-1150e8400-e29b-41d4-a716-446655440000",

      "adminId": "admin-550e8400-e29b-41d4-a716-446655440000",

      "adminEmail": "admin@franx.com",

      "action": "SUSPEND_USER",

      "entityType": "USER",

      "entityId": "550e8400-e29b-41d4-a716-446655440000",

      "metadata": {

        "reason": "Violation of terms of service",

        "userEmail": "violator@example.com"

      },

      "createdAt": "2025-11-19T14:00:00Z"

    }

],

"pageable": {

    "pageNumber": 0,

    "pageSize": 50,

    "totalElements": 2,

    "totalPages": 1

}

}

```

---

# **7. DOCUMENTS MODULE**

## **7.1 Upload Document**

**Endpoint:** `POST /documents/upload`  

**Description:** Upload a document (franchise deck, agreement, etc.) to S3. Returns file metadata.  

**Auth Required:** Yes  

**Content-Type:** `multipart/form-data`

**Request (Form Data):**

```

file: [binary file]

entityType: LISTING

entityId: listing-750e8400-e29b-41d4-a716-446655440000

documentType: FRANCHISE_DECK

**Response:** `201 Created`

json

{

"id": "doc-1250e8400-e29b-41d4-a716-446655440000",

"entityType": "LISTING",

"entityId": "listing-750e8400-e29b-41d4-a716-446655440000",

"fileName": "mcdonalds-franchise-deck.pdf",

"filePath": "documents/listing-750e8400/mcdonalds-franchise-deck.pdf",

"fileSize": 2457600,

"mimeType": "application/pdf",

"documentType": "FRANCHISE_DECK",

"uploadedBy": "550e8400-e29b-41d4-a716-446655440000",

"uploadUrl": "https://s3.amazonaws.com/franx/documents/listing-750e8400/mcdonalds-franchise-deck.pdf",

"createdAt": "2025-11-19T10:30:00Z"

}

**Error Response:** `413 Payload Too Large`

json

{

"error": "FILE_TOO_LARGE",

"message": "File size exceeds maximum limit of 10MB",

"timestamp": "2025-11-19T10:30:00Z"

}


---


## **7.2 Get Document**

**Endpoint:** `GET /documents/{documentId} \
` **Description:** Get document metadata and presigned URL for download. \
**Auth Required:** Yes

**Response:** `200 OK`

json

{

"id": "doc-1250e8400-e29b-41d4-a716-446655440000",

"entityType": "LISTING",

"entityId": "listing-750e8400-e29b-41d4-a716-446655440000",

"fileName": "mcdonalds-franchise-deck.pdf",

"filePath": "documents/listing-750e8400/mcdonalds-franchise-deck.pdf",

"fileSize": 2457600,

"mimeType": "application/pdf",

"documentType": "FRANCHISE_DECK",

"downloadUrl": "https://s3.amazonaws.com/franx/documents/listing-750e8400/mcdonalds-franchise-deck.pdf?X-Amz-Expires=3600&...",

"createdAt": "2025-11-19T10:30:00Z"

}


---


## **7.3 Get Documents for Entity**

**Endpoint:** `GET /documents \
` **Description:** Get all documents for a specific entity (brand, listing, or user). \
**Auth Required:** Yes

**Query Parameters:**



* `entityType` (required): Entity type (BRAND, LISTING, USER)
* `entityId` (required): Entity ID
* `documentType` (optional): Filter by document type

**Example:** `GET /documents?entityType=LISTING&entityId=listing-750e8400-e29b-41d4-a716-446655440000`

**Response:** `200 OK`

json

{

"content": [

    {

      "id": "doc-1250e8400-e29b-41d4-a716-446655440000",

      "fileName": "mcdonalds-franchise-deck.pdf",

      "fileSize": 2457600,

      "mimeType": "application/pdf",

      "documentType": "FRANCHISE_DECK",

      "downloadUrl": "https://s3.amazonaws.com/franx/documents/listing-750e8400/mcdonalds-franchise-deck.pdf?X-Amz-Expires=3600&...",

      "createdAt": "2025-11-19T10:30:00Z"

    },

    {

      "id": "doc-1350e8400-e29b-41d4-a716-446655440000",

      "fileName": "franchise-agreement-template.pdf",

      "fileSize": 1536000,

      "mimeType": "application/pdf",

      "documentType": "AGREEMENT",

      "downloadUrl": "https://s3.amazonaws.com/franx/documents/listing-750e8400/franchise-agreement-template.pdf?X-Amz-Expires=3600&...",

      "createdAt": "2025-11-19T11:00:00Z"

    }

]

}


---


## **7.4 Delete Document**

**Endpoint:** `DELETE /documents/{documentId} \
` **Description:** Delete a document from S3 and database. Only uploader or admin can delete. \
**Auth Required:** Yes

**Response:** `204 No Content`

**Error Response:** `403 Forbidden`

json

{

"error": "FORBIDDEN",

"message": "You don't have permission to delete this document",

"timestamp": "2025-11-19T10:30:00Z"

}


---


# **COMMON ERROR RESPONSES**

All endpoints may return these common errors:


## **401 Unauthorized**

json

{

"error": "UNAUTHORIZED",

"message": "Authentication required",

"timestamp": "2025-11-19T10:30:00Z"

}


## **403 Forbidden**

json

{

"error": "FORBIDDEN",

"message": "You don't have permission to access this resource",

"timestamp": "2025-11-19T10:30:00Z"

}


## **404 Not Found**

json

{

"error": "NOT_FOUND",

"message": "Resource not found",

"timestamp": "2025-11-19T10:30:00Z"

}


## **500 Internal Server Error**

json

{

"error": "INTERNAL_SERVER_ERROR",

"message": "An unexpected error occurred",

"timestamp": "2025-11-19T10:30:00Z"

}


---


# **ENUMS & CONSTANTS**


## **User Roles**



* `INVESTOR`
* `BRAND_OWNER`
* `ADMIN`


## **User Status**



* `ACTIVE`
* `SUSPENDED`
* `DELETED`


## **Brand Status**



* `ACTIVE`
* `SUSPENDED`
* `INACTIVE`


## **Listing Status**



* `DRAFT` - Created but not submitted
* `PENDING_APPROVAL` - Submitted, waiting for admin approval
* `APPROVED` - Approved and visible to investors
* `REJECTED` - Rejected by admin
* `INACTIVE` - Deactivated by brand owner


## **Lead Status**



* `NEW` - Just created
* `CONTACTED` - Brand has reached out
* `IN_DISCUSSION` - Active conversation
* `QUALIFIED` - Investor meets criteria
* `DISQUALIFIED` - Investor doesn't meet criteria
* `CLOSED` - Lead completed or abandoned


## **Experience Level**



* `FIRST_TIME` - First franchise investment
* `EXPERIENCED` - Has owned franchises before
* `SERIAL_INVESTOR` - Multiple franchise investments


## **Categories (Example - expand as needed)**



* `FOOD_BEVERAGE`
* `RETAIL`
* `EDUCATION`
* `HEALTHCARE`
* `HOSPITALITY`
* `FITNESS`
* `AUTOMOTIVE`
* `REAL_ESTATE`


## **Document Types**



* `FRANCHISE_DECK`
* `AGREEMENT`
* `FINANCIAL_STATEMENT`
* `BRAND_PROFILE`
* `LEGAL_DOCUMENT`
* `OTHER`