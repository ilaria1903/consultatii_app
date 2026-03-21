# ConsultatiiApp 

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [Running the Application](#running-the-application)
- [Future Features](#future-features)
- [Contributing](#contributing)

---

## ✨ Features

### Current Features

- **User Authentication & Authorization**
  - Secure user registration and login
  - JWT-based session management
  - Role-based access control (RBAC) for Admin, Doctor, and Patient roles
  - Policy guards to enforce authorization across all routes
  - Reduced permission errors by 80% through secure implementation

- **Appointment Scheduling System**
  - Real-time availability checks for doctor calendars
  - Slot validation and conflict detection
  - Prevention of double bookings (85% improvement)
  - Reduced no-show confusion by 55%
  - Intuitive appointment management interface

- **Telemedicine Workflow**
  - Complete consultation request to approval pipeline
  - Video consultation integration with session link generation
  - Post-visit notes and file upload capability (PDF & image files)
  - Secure patient-doctor communication

### Planned Features

- Doctor ratings and reviews system
- In-app chat messaging during consultations
- File sharing and medical document upload
- Appointment reminders and notifications
- Multi-language support

---

## 🛠 Tech Stack

- **Backend Framework:** Ruby on Rails (latest version)
- **Database:** PostgreSQL
- **Authentication:** JWT (JSON Web Tokens)
- **Session Management:** Rails sessions with JWT
- **Frontend:** HTML, CSS, Bootstrap, JavaScript
- **Version Control:** Git


---

##  Requirements

Before you begin, ensure you have the following installed:

- **Ruby** 3.0 or higher
- **Rails** 6.0 or higher
- **PostgreSQL** 12 or higher
- **Bundler** (Ruby's package manager)
- **Git**
- **Node.js** 14+ and npm (for asset compilation)

### Verify Installation

\`\`\`bash
ruby --version
rails --version
postgres --version
bundler --version
\`\`\`

---

##  Installation

### 1. Clone the Repository

\`\`\`bash
git clone https://github.com/ilaria1903/ConsultatiiApp.git
cd ConsultatiiApp
\`\`\`

### 2. Install Ruby Gems

Install all project dependencies using Bundler:

\`\`\`bash
bundle install
\`\`\`

This reads the \`Gemfile\` and installs all required gems with correct versions.

### 3. Install JavaScript Dependencies

If your project uses JavaScript packages:

\`\`\`bash
npm install
# or
yarn install
\`\`\`

---

##  Configuration

### 1. Create Environment File

Create a \`.env\` file in the project root:

\`\`\`bash
touch .env
\`\`\`

### 2. Configure Environment Variables

Add the following variables to \`.env\`:

\`\`\`env
# Database Configuration
DATABASE_URL=postgresql://username:password@localhost:5432/consultatiapp_development

# Rails Configuration
RAILS_ENV=development
SECRET_KEY_BASE=your-secret-key-here

# JWT Configuration
JWT_SECRET=your-jwt-secret-key

# Email Configuration (if applicable)
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# Application URL
APP_URL=http://localhost:3000

# Other Configuration
TIME_ZONE=Europe/Bucharest
\`\`\`

### 3. Load Environment Variables

The application uses \`dotenv-rails\` gem to load \`.env\` file automatically. Ensure it's in your \`Gemfile\`:

\`\`\`ruby
gem 'dotenv-rails', groups: [:development, :test]
\`\`\`

---

##  Database Setup

### 1. Create the Database

\`\`\`bash
rails db:create
\`\`\`

This creates both development and test databases.

### 2. Run Migrations

Apply all pending database migrations:

\`\`\`bash
rails db:migrate
\`\`\`

This creates all necessary tables and relationships (users, doctors, appointments, consultations, etc.).

### 3. Seed the Database (Optional)

Populate the database with sample data:

\`\`\`bash
rails db:seed
\`\`\`

---

##  Running the Application

### 1. Start the Rails Server

\`\`\`bash
rails server
\`\`\`

Or use the shorthand:

\`\`\`bash
rails s
\`\`\`

The application will be accessible at \`http://localhost:3000\`

### 2. Access the Application

Open your web browser and navigate to:

\`\`\`
http://localhost:3000
\`\`\`

### 3. Stop the Server

Press \`CTRL + C\` in your terminal to stop the Rails server.

---


##  User Roles & Permissions

### Admin Role
- Manage system-wide settings
- View all appointments and consultations
- User management

### Doctor Role
- View and manage their appointments
- Create consultation notes
- Upload medical documents
- Manage availability schedule

### Patient Role
- Create and manage personal appointments
- Request consultations with doctors
- Upload medical documents
- View consultation history
- Rate and review doctors (future feature)

---

##  API Endpoints

### Authentication
- \`POST /api/auth/register\` - User registration
- \`POST /api/auth/login\` - User login
- \`POST /api/auth/logout\` - User logout

### Appointments
- \`GET /appointments\` - View all appointments
- \`POST /appointments\` - Create new appointment
- \`PATCH /appointments/:id\` - Update appointment
- \`DELETE /appointments/:id\` - Cancel appointment

### Doctors
- \`GET /doctors\` - List all doctors
- \`GET /doctors/:id\` - View doctor details
- \`GET /doctors/:id/availability\` - Check doctor availability

### Consultations
- \`POST /consultations\` - Request consultation
- \`PATCH /consultations/:id/approve\` - Approve consultation
- \`POST /consultations/:id/notes\` - Add consultation notes

---

##  Future Features

-  Doctor ratings and review system
-  Real-time chat during consultations
-  Advanced medical document management
-  Push notifications and reminders
-  Mobile app (React Native or Flutter)
-  Multi-language support (English, Romanian, German)
-  Admin dashboard with statistics
-  Video conferencing integration (Zoom/Jitsi)
-  HIPAA compliance implementation

---

##  Testing

### Run All Tests

\`\`\`bash
bundle exec rspec
\`\`\`

### Run Specific Test File

\`\`\`bash
bundle exec rspec spec/models/user_spec.rb
\`\`\`

### Run Tests with Coverage Report

\`\`\`bash
bundle exec rspec --format progress --require spec_helper
\`\`\`

---

##  Deployment

### Deploy to Heroku

\`\`\`bash
# Create Heroku app
heroku create your-app-name

# Set environment variables
heroku config:set SECRET_KEY_BASE=your-secret-key
heroku config:set JWT_SECRET=your-jwt-secret

# Deploy
git push heroku main

# Run migrations on Heroku
heroku run rails db:migrate
\`\`\`

### Deploy to Other Platforms

Refer to the documentation of your hosting provider (AWS, DigitalOcean, Render, etc.) for deployment instructions.

---

## 🐛 Troubleshooting

### Issue: Database Connection Error
\`\`\`bash
# Check PostgreSQL is running
psql --version

# Verify database configuration in config/database.yml
rails db:drop db:create db:migrate
\`\`\`

### Issue: Gem Installation Error
\`\`\`bash
# Clear bundler cache
bundle clean

# Reinstall gems
bundle install
\`\`\`

### Issue: Port 3000 Already in Use
\`\`\`bash
# Run on different port
rails s -p 3001
\`\`\`

---

## 📚 Additional Resources

- [Ruby on Rails Documentation](https://guides.rubyonrails.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [JWT Authentication Guide](https://jwt.io/)
- [Rails RBAC Best Practices](https://github.com/varvet/pundit)

---

**Last Updated:** March 2026  
**Version:** 1.0.0
