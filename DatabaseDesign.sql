Core Tables

1. users
CREATE TABLE users (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 email VARCHAR(255) UNIQUE NOT NULL,
 phone VARCHAR(20) UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 role VARCHAR(20) NOT NULL CHECK (role IN ('INVESTOR', 'BRAND_OWNER', 'ADMIN')),
 email_verified BOOLEAN DEFAULT FALSE,
 phone_verified BOOLEAN DEFAULT FALSE,
 status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'SUSPENDED', 'DELETED')),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

 CREATE INDEX idx_users_email ON users(email);
 CREATE INDEX idx_users_role ON users(role);
 CREATE INDEX idx_users_status ON users(status);


2. brands
CREATE TABLE brands (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 brand_name VARCHAR(255) NOT NULL,
 description TEXT,
 logo_url VARCHAR(500),
 website VARCHAR(255),
 established_year INTEGER,
 headquarters_location VARCHAR(255),
 status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'SUSPENDED', 'INACTIVE')),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 UNIQUE(owner_id)
 );

 CREATE INDEX idx_brands_owner ON brands(owner_id);
 CREATE INDEX idx_brands_status ON brands(status);


3. franchise_listings
CREATE TABLE franchise_listings (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
 title VARCHAR(255) NOT NULL,
 description TEXT,
 category VARCHAR(50) NOT NULL,
 min_investment DECIMAL(15, 2) NOT NULL,
 max_investment DECIMAL(15, 2) NOT NULL,
 currency VARCHAR(3) DEFAULT 'INR',
 franchise_fee DECIMAL(15, 2),
 royalty_percentage DECIMAL(5, 2),
 area_required_sqft INTEGER,
 staff_required INTEGER,
 status VARCHAR(30) DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'PENDING_APPROVAL', 'APPROVED', 'REJECTED', 'INACTIVE')),
 rejection_reason TEXT,
 submitted_at TIMESTAMP,
 approved_at TIMESTAMP,
 approved_by UUID REFERENCES users(id),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CHECK (max_investment >= min_investment)
 );

 CREATE INDEX idx_listings_brand ON franchise_listings(brand_id);
 CREATE INDEX idx_listings_status ON franchise_listings(status);
 CREATE INDEX idx_listings_category ON franchise_listings(category);
 CREATE INDEX idx_listings_investment ON franchise_listings(min_investment, max_investment);



4. listing_locations
CREATE TABLE listing_locations (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 listing_id UUID NOT NULL REFERENCES franchise_listings(id) ON DELETE CASCADE,
 city VARCHAR(100),
 state VARCHAR(100),
 country VARCHAR(100) DEFAULT 'India',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

 CREATE INDEX idx_listing_locations_listing ON listing_locations(listing_id);
 CREATE INDEX idx_listing_locations_city ON listing_locations(city);
 CREATE INDEX idx_listing_locations_state ON listing_locations(state);


5. investor_profiles
CREATE TABLE investor_profiles (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 min_budget DECIMAL(15, 2),
 max_budget DECIMAL(15, 2),
 currency VARCHAR(3) DEFAULT 'INR',
 experience_level VARCHAR(20) CHECK (experience_level IN ('FIRST_TIME', 'EXPERIENCED', 'SERIAL_INVESTOR')),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CHECK (max_budget >= min_budget)
 );

 CREATE INDEX idx_investor_profiles_user ON investor_profiles(user_id);
 CREATE INDEX idx_investor_profiles_budget ON investor_profiles(min_budget, max_budget);


6. investor_preferred_categories
CREATE TABLE investor_preferred_categories (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 investor_profile_id UUID NOT NULL REFERENCES investor_profiles(id) ON DELETE CASCADE,
 category VARCHAR(50) NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 UNIQUE(investor_profile_id, category)
 );

CREATE INDEX idx_preferred_categories_profile ON investor_preferred_categories(investor_profile_id);


7. investor_preferred_locations
CREATE TABLE investor_preferred_locations (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 investor_profile_id UUID NOT NULL REFERENCES investor_profiles(id) ON DELETE CASCADE,
 city VARCHAR(100),
 state VARCHAR(100),
 country VARCHAR(100) DEFAULT 'India',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 UNIQUE(investor_profile_id, city, state)
 );

CREATE INDEX idx_preferred_locations_profile ON investor_preferred_locations(investor_profile_id);


8. leads
CREATE TABLE leads (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 listing_id UUID NOT NULL REFERENCES franchise_listings(id) ON DELETE CASCADE,
 investor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
 message TEXT,
 status VARCHAR(30) DEFAULT 'NEW' CHECK (status IN ('NEW', 'CONTACTED', 'IN_DISCUSSION', 'QUALIFIED', 'DISQUALIFIED', 'CLOSED')),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 responded_at TIMESTAMP,
 UNIQUE(listing_id, investor_id)
 );

 CREATE INDEX idx_leads_listing ON leads(listing_id);
 CREATE INDEX idx_leads_investor ON leads(investor_id);
 CREATE INDEX idx_leads_brand ON leads(brand_id);
 CREATE INDEX idx_leads_status ON leads(status);
 CREATE INDEX idx_leads_created ON leads(created_at DESC);


9. documents
CREATE TABLE documents (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 entity_type VARCHAR(20) NOT NULL CHECK (entity_type IN ('BRAND', 'LISTING', 'USER')),
 entity_id UUID NOT NULL,
 file_name VARCHAR(255) NOT NULL,
 file_path VARCHAR(500) NOT NULL,
 file_size BIGINT,
 mime_type VARCHAR(100),
 document_type VARCHAR(50) NOT NULL,
 uploaded_by UUID NOT NULL REFERENCES users(id),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

 CREATE INDEX idx_documents_entity ON documents(entity_type, entity_id);
 CREATE INDEX idx_documents_uploader ON documents(uploaded_by);


10. refresh_tokens
CREATE TABLE refresh_tokens (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 token VARCHAR(500) UNIQUE NOT NULL,
 expires_at TIMESTAMP NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

 CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);
 CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);
 CREATE INDEX idx_refresh_tokens_expires ON refresh_tokens(expires_at);


11. audit_logs
CREATE TABLE audit_logs (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 admin_id UUID NOT NULL REFERENCES users(id),
 action VARCHAR(50) NOT NULL,
 entity_type VARCHAR(20) NOT NULL,
 entity_id UUID NOT NULL,
 metadata JSONB,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

 CREATE INDEX idx_audit_logs_admin ON audit_logs(admin_id);
 CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
 CREATE INDEX idx_audit_logs_created ON audit_logs(created_at DESC);

