Final assigment of PawPal continuity development project.

Name: Muhammad Haziq bin Idrus 
Matric Number: 300652 
Course: Mobile Web Programming (Final Assessment)

# 1. Project Overview
PawPal is a full-stack mobile application developed using Flutter, PHP, and MySQL. It serves as a platform to connect pet owners with potential adopters and donors. The app allows users to browse available pets, request adoptions, and make donations (money or supplies) to pets in need.

# 2. Key Features
This project implements the following modules as per the assignment requirements:

      A. Authentication
      - Login & Registration: Secure user account creation and authentication.

      - Session Management: Uses SharedPreferences to manage user credentials for login.

      B. Public Pet Listing
      - Browse: View all pets available for adoption in public listing.
        
      - Search & Filter: Search pets by name or filter by category (All, Cat, Dog, Bird, Other).
        
      - Dynamic Badges: Visual indicators for pet status (Available/Adopted) and Category of Submission (Adoption Request, Donation, Help/Rescue).

      C. Adoption Module
      - Pet Details: Comprehensive view of pet information (Name, Age, Gender, Health, Description, Type, Category).
       
      - Adoption Request: Users can submit a motivation message to request adoption.

      - Validation: Prevents duplicate requests for the same pet.

      D. Donation Module
          Dynamic Forms:
          - Money: Inputs amount (RM).
        
          - Food/Medical: Inputs description of items to be donated.
       
          - Donation History: A dedicated screen listing all past donations made by the logged-in user, fetching data via SQL Joins (User + Donation + Pet).

      E. User Profile
      - View Profile: Displays user details, donation history tab, logout button.
      
      - Edit Profile: Allows updating Name and Phone Number.

# 3. Database Design (ERD)
<img width="884" height="790" alt="Screenshot 2026-01-10 231106" src="https://github.com/user-attachments/assets/3960eed2-4379-499d-8ecc-e69739bf000b" />

The system uses the following relational tables:

    - tbl_users: Stores user credentials and profile info.
    - tbl_pets: Stores details about the pets.
    - tbl_adoptions: links Users to Pets for adoption requests.
    - tbl_donations: Records donation history.

# 4. API Endpoints
The Flutter app communicates with the backend via the following PHP scripts located in /pawpal/api/:

    - edit_profile.php: Updates the user details and profile image
    - get_my_donations.php: Retrieve the donations done by the logged-in user
    - get_my_pets.php: Retrieve all the public listing data of pets
    - login_user.php: Handles the login of a user
    - register_user.php: Handles the registration of a user
    - submit_adoption_request.php: Insert a new adoption request into tbl_adoptions
    - submit_donation.php: Insert a new donation record into tbl_donations
    - submit_pet.php: Handles the submission of new pet.

# 5. Installation & Setup Guide
      Backend Setup
      1. Install XAMPP.
      2. Start Apache and MySQL services.
      3. Import the database file pawpal_db.sql into phpMyAdmin (located in server/pawpal_db.sql).
      4. Copy the pawpal server folder into your htdocs directory (C:\xampp\htdocs\pawpal).
      5. Check dbconnect.php to ensure the database credentials match your local setup.

      Frontend (Flutter) Setup
      1. Open the project in VS Code.
      
      2. Run flutter pub get in the terminal to install dependencies.
      
      3. Update IP Address:
      
      - Open lib/myconfig.dart.
      
      - Change the baseUrl to your machine's local IPv4 address or use locahost (except emulator)
            
      4. Run the application

# 6. Screenshot
## Login Screen: 
<img width="1919" height="913" alt="Screenshot 2026-01-10 232503" src="https://github.com/user-attachments/assets/8c24d30a-0377-4e2a-bbc3-d867b6658b6c" />

## Registration Screen:
<img width="1919" height="910" alt="Screenshot 2026-01-10 232646" src="https://github.com/user-attachments/assets/9dba13da-51ac-4c5e-ad61-aa3e8763803c" />

## Home Page (Public Pet Listing)
<img width="1919" height="919" alt="Screenshot 2026-01-11 004143" src="https://github.com/user-attachments/assets/fdf04626-3cd7-4fdf-a0c7-f127febac0de" />

## Donation History
<img width="1919" height="914" alt="Screenshot 2026-01-11 012133" src="https://github.com/user-attachments/assets/8d0a6ece-0422-4d00-b91d-a32bed833bd6" />

## User Profile
<img width="1919" height="908" alt="Screenshot 2026-01-11 012722" src="https://github.com/user-attachments/assets/b64cf271-a8b6-45f9-88d8-2a94e332590b" />

## Adoption Module
<img width="1919" height="915" alt="Screenshot 2026-01-11 010241" src="https://github.com/user-attachments/assets/d11de930-8b22-4581-ac07-0e082d898a0a" />
<img width="1919" height="920" alt="Screenshot 2026-01-11 035620" src="https://github.com/user-attachments/assets/04496561-2c60-4c8c-81c9-b2942a39ed85" />

## Donation Module
<img width="1919" height="909" alt="Screenshot 2026-01-11 010610" src="https://github.com/user-attachments/assets/8e59edbc-e71e-4d0a-a425-35cb036a752c" />
<img width="1919" height="910" alt="Screenshot 2026-01-11 010433" src="https://github.com/user-attachments/assets/f652efb9-95dd-493e-ac44-2f310151e036" />
<img width="1919" height="901" alt="Screenshot 2026-01-11 010459" src="https://github.com/user-attachments/assets/fc0086dc-7820-458d-89f8-3fd34187e31f" />

## Edit Profile
<img width="1919" height="905" alt="Screenshot 2026-01-11 012927" src="https://github.com/user-attachments/assets/a1cb7ac1-31ee-4124-a222-4a62ce1e4980" />



             
