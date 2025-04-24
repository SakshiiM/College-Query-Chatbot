-- Drop existing database if exists
DROP DATABASE IF EXISTS college_chatbot;

-- Create new database
CREATE DATABASE college_chatbot;
USE college_chatbot;

-- Create table for course details
CREATE TABLE course_details (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    program_level VARCHAR(20) DEFAULT 'B.Tech',
    duration VARCHAR(50) DEFAULT '4 years',
    description TEXT,
    eligibility TEXT,
    seats_available INT -- Updated intake for A.Y. 2024-25
);


-- Create table for fee structure
CREATE TABLE fee_structure (
    fee_entry_id INT PRIMARY KEY AUTO_INCREMENT,
    academic_year VARCHAR(10) NOT NULL,
    program_stream VARCHAR(100) NOT NULL, -- e.g., 'B.Tech - 1st Year', 'M.Tech - 1st Year'
    tuition_fee DECIMAL(10, 2),
    development_fee DECIMAL(10, 2),
    total_fee DECIMAL(10, 2), -- Storing the calculated total directly
    notes TEXT -- For approval dates, exclusions, etc.
);

-- Create table for contact details
CREATE TABLE contact_details (

    contact_point VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    timing VARCHAR(100)
    
);

-- Create table for admission process
CREATE TABLE admission_Process (
    process_id INT PRIMARY KEY AUTO_INCREMENT,
    step_number INT,
    stage_name VARCHAR(100),
    description TEXT,
    timeline VARCHAR(100),
    requirements TEXT,
    important_notes TEXT
);

CREATE TABLE events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(100) NOT NULL,
    event_type VARCHAR(50), -- 'Technical Fest', 'Cultural Fest', 'Coding Contest', 'Project Expo', 'Hackathon', 'Workshop'
    start_date DATE,
    end_date DATE,
    academic_year VARCHAR(10), -- e.g., '2024-25'
    description TEXT,
    organizer VARCHAR(100), -- e.g., 'PISB', 'PCSB', 'Art Circle', 'Dept Name'
    venue VARCHAR(100) DEFAULT 'PICT Campus',
    website_url VARCHAR(255), -- Link to event page if available
    notes VARCHAR(255) -- e.g., 'Dates are tentative'
);

CREATE TABLE curricular (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    activity_name VARCHAR(100) NOT NULL,        -- Short name/Acronym (e.g., PASC, PISB, PAC)
    full_name VARCHAR(255) NOT NULL,            -- Full name of the activity/club/event
    activity_type VARCHAR(50),                  -- e.g., 'Student Chapter', 'Technical Fest', 'Club', 'Competition'
    description TEXT,                           -- Detailed description
    establishment_year INT NULL,                -- Year founded, if known
    member_count_info VARCHAR(50) NULL,         -- e.g., '220+', '90+'
    website_url VARCHAR(255) NULL,
    instagram_url VARCHAR(255) NULL,
    facebook_url VARCHAR(255) NULL,
    linkedin_url VARCHAR(255) NULL,
    other_links TEXT NULL,                      -- For Itch.io, Twitter, etc.
    notes TEXT NULL                             -- For awards, upcoming details, etc.
);

CREATE TABLE placement_stats (
    stat_id INT PRIMARY KEY AUTO_INCREMENT,
    academic_year_passing VARCHAR(10) NOT NULL, -- Year of graduation batch (e.g., '2024')
    program_level VARCHAR(20) DEFAULT 'B.Tech', -- 'B.Tech', 'M.Tech', 'Overall'
    dept_code VARCHAR(10) DEFAULT 'ALL', -- 'ALL' for overall, or specific dept code ('CE', 'IT', etc.)
    students_eligible INT NULL, -- Mapped from 'Enrolled'
    students_placed INT NULL,
    placement_percentage DECIMAL(5, 2) NULL,
    notes VARCHAR(255) NULL -- e.g., 'Data based on NIRF submission / T&P report'
);

CREATE TABLE hostel_details (
    hostel_id INT PRIMARY KEY AUTO_INCREMENT,
    hostel_name VARCHAR(100) NOT NULL UNIQUE, -- e.g., 'Girls Hostel', 'Boys Hostel'
    intended_for VARCHAR(10) NOT NULL,        -- 'Girls' or 'Boys'
    total_rooms INT,
    occupancy_per_room INT DEFAULT 2,          -- Based on provided text
    total_capacity INT,                        -- Calculated: total_rooms * occupancy_per_room
    charge_attached_wc DECIMAL(10, 2),         -- Charge for room with attached WC
    charge_common_wc DECIMAL(10, 2),           -- Charge for room with common WC
    refundable_deposit DECIMAL(10, 2),
    charge_notes TEXT,                         -- e.g., 'Per academic year, includes mess fees. Subject to revision.'
    has_hot_water BOOLEAN DEFAULT TRUE,
    has_internet BOOLEAN DEFAULT TRUE,
    has_medical_officer BOOLEAN DEFAULT TRUE,
    has_mess_canteen BOOLEAN DEFAULT TRUE,
    has_sports_gym BOOLEAN DEFAULT TRUE,
    has_parking_2w BOOLEAN DEFAULT TRUE,
    has_generator_backup BOOLEAN DEFAULT TRUE,
    has_elevator BOOLEAN DEFAULT FALSE,         -- Specific to Girls Hostel in the text
    warden_name VARCHAR(100),                  -- Placeholder, update with actual name
    contact_phone VARCHAR(50),                 -- Placeholder
    contact_email VARCHAR(100),                -- Placeholder
    application_info TEXT,                     -- Brief info or link
    allotment_notes TEXT                       -- To store info about year-wise quotas
);

CREATE TABLE admission_p (
    process_id INT PRIMARY KEY AUTO_INCREMENT,
    step_number INT,
    stage_name VARCHAR(100),
    description TEXT,
    key_requirement VARCHAR(255),
    reference_info VARCHAR(255)
);

CREATE TABLE meta_responses (
    response_id INT PRIMARY KEY AUTO_INCREMENT,
    intent_tag VARCHAR(50) UNIQUE NOT NULL, -- e.g., 'welcome', 'goodbye', 'help'
    response_text TEXT NOT NULL
);



INSERT INTO course_details (course_name, program_level, duration, description, eligibility, seats_available) VALUES
('Computer Engineering (CE)', 'B.Tech', '4 years', 'Focuses on computer hardware, software, systems, and networks.', 'HSC (10+2) with PCM, Valid MHT-CET/JEE Main score, As per DTE Maharashtra norms', 240),
('Information Technology (IT)', 'B.Tech', '4 years', 'Focuses on software development, data management, networking, and IT security.', 'HSC (10+2) with PCM, Valid MHT-CET/JEE Main score, As per DTE Maharashtra norms', 180),
('Electronics and Telecommunication (ENTC)', 'B.Tech', '4 years', 'Focuses on communication systems, signal processing, embedded systems, and VLSI design.', 'HSC (10+2) with PCM, Valid MHT-CET/JEE Main score, As per DTE Maharashtra norms', 240),
('Artificial Intelligence and Data Science (AIDS)', 'B.Tech', '4 years', 'Focuses on AI algorithms, machine learning, data analytics, and intelligent system development.', 'HSC (10+2) with PCM, Valid MHT-CET/JEE Main score, As per DTE Maharashtra norms', 60),
('Electronics and Computer Engineering (E&C)', 'B.Tech', '4 years', 'Integrates electronics engineering with computer science, focusing on hardware-software interaction and embedded systems.', 'HSC (10+2) with PCM, Valid MHT-CET/JEE Main score, As per DTE Maharashtra norms', 60);

-- Insert new contact details
INSERT INTO contact_details (contact_point, phone, email, timing) VALUES
('General Enquiry / Main Office', '+91 20 24371101 ', 'registrar@pict.edu', 'Mon-Sat: 10:00 AM - 5:00 PM (Approx.)'),
('Principal Office', '+91 20 24371101', 'principal@pict.edu', 'By Appointment'),
('Director Office', '+91 20 24371101', 'director@pict.edu', 'By Appointment'),
('FE Admission Cell (UG First Year)', '8669241101', 'feadmission_admin@pict.edu', '10:00 AM - 5:00 PM (During Admission Period)'),
('Training & Placement Office (TPO)', '8275284977 ', 'placement@pict.edu', 'Mon-Fri: 9:30 AM - 5:30 PM (Approx.)'),
('Library', '+91 20 24371101 ', 'library@pict.edu', 'Library: 9am-7pm (Working Days), Reading Hall: 6am-12am (All Days)'),
('Accounts Section', '+91 20 24371101', 'Contact via Registrar or Main Office', 'Check with office for specific transaction timings'),
('HOD - Computer Engineering (CE)', '+91 20 24371101 ', 'hodce@pict.edu', 'Check Department Office Hours'),
('HOD - Information Technology (IT)', '+91 20 24371101 ', 'hodit@pict.edu', 'Check Department Office Hours'),
('HOD - Electronics & Telecommunication (E&TC)', '+91 20 24371101', 'hodetc@pict.edu', 'Check Department Office Hours'),
('HOD - Electronics & Computer Engineering (E&CE)', '+91 20 24371101', 'hodece@pict.edu', 'Check Department Office Hours'),
('HOD - First Year Engineering (FE / BS&E)', '+91 20 24371101', 'hodfe@pict.edu (Verify Email)', 'Check Department Office Hours');

INSERT INTO fee_structure
    (academic_year, program_stream, tuition_fee, development_fee, total_fee, notes)
VALUES
    ('2024-25', 'B.Tech - 1st Year', 95652.00, 14348.00, 110000.00, 'Fees as per FRA approval notice (Date Stated: 28.02.2025). Excludes hostel, university fees etc. Refer to official PICT circulars.');
    
INSERT INTO events (event_name, event_type, start_date, end_date, academic_year, description, organizer, website_url, notes) VALUES
('Pulzion', 'Technical Fest', '2024-10-03', '2024-10-05', '2024-25', 'Annual technical fest organized by PICT ACM Student Chapter (PASC) featuring coding competitions, workshops, and seminars.', 'PASC (PICT ACM Student Chapter)', 'https://pulzion.pict.edu/', 'Dates are based on previous year, check official site for confirmation.'),
('PICT InC (Impetus & Concepts)', 'Project Expo / Coding Contest', '2025-03-27', '2025-03-29', '2024-25', 'Flagship event featuring Impetus (Project competition for FE-TE), Concepts (Project competition for BE), and Pradnya (Coding competition).', 'PICT', 'https://pictinc.org/', 'Dates based on recent info, check official site.'),
('Pictofest', 'Cultural Fest / Art Expo', '2025-02-17', '2025-02-19', '2024-25', 'Annual cultural and arts festival organized by Pictoreal club, including art/photography exhibitions, literary events, and public speaking (Manthan).', 'Pictoreal', 'https://www.pictofest.in/', 'Dates are approximate, based on previous year.'),
('Addiction', 'Cultural / Entertainment Event', '2025-02-27', '2025-03-01', '2024-25', 'Major cultural event featuring music, dance, drama and other entertainment activities.', 'PICT Art Circle', NULL, 'Dates based on recent academic calendar entry.'),
('Credenz', 'Technical Symposium', '2025-09-15', '2025-09-17', '2025-26', 'Annual technical symposium organized by PICT IEEE Student Branch (PISB) with various technical events and competitions.', 'PISB (PICT IEEE Student Branch)', NULL, 'Dates are hypothetical based on past timing (Sept), check official announcements for A.Y. 2025-26.'),
('TechFiesta', 'Hackathon', '2025-01-10', '2025-01-12', '2024-25', 'PICT International Hackathon focusing on solving real-world challenges.', 'PICT', 'https://techfiesta.pict.edu/', 'Dates are hypothetical, check official site.');

INSERT INTO curricular
(activity_name, full_name, activity_type, description, establishment_year, member_count_info, website_url, instagram_url, facebook_url, linkedin_url, other_links, notes)
VALUES
('TechFiesta', 'TechFiesta: PICT International Hackathon', 'Hackathon', 'Planned international hackathon organized by PICT.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Details will be declared soon.'),
('SIH Participation', 'Smart India Hackathon Participation', 'Competition', 'PICT students participate in SIH, a nationwide competition by Ministry of Education, AICTE, Persistent Systems, i4C, solving real-world problems.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('PASC', 'PICT ACM Student Chapter', 'Student Chapter', 'Affiliated with ACM (Association for Computing Machinery). Fosters technical/non-technical skills in computing students. World’s largest educational/scientific computing society chapter at PICT.', 2011, '220+', 'https://pict.acm.org/', 'https://www.instagram.com/acm.pict/', 'https://www.facebook.com/acmpict/', 'https://www.linkedin.com/in/pict-acm-student-chapter-09004a132', NULL, 'Awarded Best ACM Student Chapter in India (2018, 2019).'),
('PISB', 'PICT IEEE Student Branch', 'Student Chapter', 'Affiliated with IEEE (Institute of Electrical and Electronics Engineers). Aims to inculcate technical awareness among student members.', 1988, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('InC', 'Impetus and Concepts', 'Technical Fest', 'Flagship annual technical event of PICT. Includes project exhibitions and competitions like Impetus, Concepts, and Pradnya (coding).', NULL, NULL, 'https://pictinc.org/', NULL, NULL, NULL, NULL, 'Usually held around March/April.'),
('PICT Robotics', 'PICT Robotics Team (Robocon)', 'Robotics Club', 'Platform for students passionate about robotics. Explore real-life applications, learn new technologies, participate in national level competitions (e.g., Robocon).', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('PICT CSI', 'PICT CSI Student Branch', 'Student Chapter', 'Affiliated with Computer Society of India. Facilitates research, knowledge sharing, learning, career enhancement for IT students.', 2016, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('GameDevutopia', 'GameDevutopia - PICT Game Development Club', 'GameDev Club', 'Official club for game development (coding, design, visual arts). Conducts workshops, industry sessions (past: Ubisoft, Microsoft), competes in game jams. Explores blockchain/NFT/Metaverse games.', 2021, '90+', 'https://gamedevutopia.in/', 'https://www.instagram.com/gamedevutopia/', NULL, NULL, 'Itch.io: https://teams24.itch.io', NULL);


INSERT INTO placement_stats
(academic_year_passing, program_level, dept_code, students_eligible, students_placed, placement_percentage, notes)
VALUES
('2018', 'B.Tech', 'ALL', 617, 405, 66.00, 'Institute Level Data from historical stats.'),
('2019', 'B.Tech', 'ALL', 631, 523, 82.88, 'Institute Level Data from historical stats.'),
('2020', 'B.Tech', 'ALL', 659, 555, 84.21, 'Institute Level Data from historical stats.'),
('2021', 'B.Tech', 'ALL', 720, 661, 91.80, 'Institute Level Data from historical stats.'),
('2022', 'B.Tech', 'ALL', 730, 671, 91.91, 'Institute Level Data from historical stats.'),
('2023', 'B.Tech', 'ALL', 755, 707, 93.64, 'Institute Level Data from historical stats.'),
('2024', 'B.Tech', 'ALL', 760, 706, 92.89, 'Institute Level Data from historical stats (Batch passing 2024).'),
('2025', 'B.Tech', 'ALL', 775, 301, NULL,  'Institute Level Data - Placement for 2025 batch currently In Progress (as of Apr 2025).');

INSERT INTO hostel_details (
    hostel_name, intended_for, total_rooms, total_capacity,
    charge_attached_wc, charge_common_wc, refundable_deposit, charge_notes,
    has_elevator, application_info, allotment_notes
) VALUES (
    'Girls Hostel', 'Girls', 106, (106 * 2),
    125000.00, 115000.00, 15000.00, 'Charges are indicative, likely per academic year, typically include mess fees. Verify on official website.',
    TRUE, 'Application process usually post-admission via PICT website.', 'Allotment Quotas (approx): FE/SE(Direct)/ME-I: 92, SE: 60, TE: 60 students.'
), (
    'Boys Hostel', 'Boys', 67, (67 * 2),
    125000.00, 115000.00, 15000.00, 'Charges are indicative, likely per academic year, typically include mess fees. Verify on official website.',
    FALSE, 'Application process usually post-admission via PICT website.', 'Allotment Quotas (approx): FE/SE(Direct)/ME-I: 66, SE: 34, TE: 34 students.'
);

INSERT INTO admission_p (step_number, stage_name, description, key_requirement, reference_info) VALUES
(1, 'Entrance Exam', 'Give MHT-CET or JEE Main.', 'Valid score in either exam.', 'mahacet.org or jeemain.nta.nic.in'),
(2, 'CAP Registration', 'Register online for CAP.', 'Scorecard, 10th/12th marksheets, category proof.', 'mahacet.org'),
(3, 'Doc Verification', 'Verify documents online or at FCs.', 'Originals + photocopies.', 'Check CAP instructions.'),
(4, 'Option Form', 'Select preferred colleges/courses.', 'Based on merit and choice.', 'CAP portal guide.'),
(5, 'Seat Allotment', 'View seat allotment result.', 'CAP portal login.', 'Follow CAP schedule.'),
(6, 'Institute Reporting', 'Confirm admission at college.', 'Allotment letter, docs, fee receipt.', 'pict.edu admission notice.');

INSERT INTO meta_responses (intent_tag, response_text) VALUES
('hi', 'Hi, my name is Noa! I’m your PICT info assistant — what do you want to know about?'),
('hello', 'Hey there! I’m Noa, your go-to guide for all things PICT. Ask me anything!'),
('hey', 'Hi! I’m Noa. Need help with admissions, courses, placements, or anything else at PICT?'),
('thanks', 'You’re welcome! Happy to help anytime '),
('thank you', 'No problem at all! Let me know if you have more questions.'),
('bye', 'Bye! Catch you later '),
('help', 'I can help with queries related to PICT’s admissions, fees, hostel, placements, courses, events, and more. Just type your question!');

CREATE TABLE IF NOT EXISTS faq_data (
    faq_id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(255) NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(50),
    keywords TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FULLTEXT KEY faq_search (keywords)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO faq_data (question, answer, category, keywords) VALUES
('What are the library timings?', 'The central library is open from 8:00 AM to 8:00 PM on weekdays, and 9:00 AM to 5:00 PM on Saturdays. Digital library access is available 24/7.', 'Facilities', 'library timing hours open close digital library access schedule working hours study hall'),

('How do I join college clubs?', 'You can join college clubs during the annual club recruitment drive in August. Follow the official college social media or check notice boards for announcements. Most clubs also accept members throughout the year.', 'Student Life', 'clubs societies join membership recruitment student chapter technical cultural clubs how to join club registration'),

('What sports facilities are available?', 'The college has facilities for cricket, football, basketball, volleyball, and indoor games. We also have a well-equipped gymnasium. Sports equipment can be borrowed from the sports department.', 'Sports', 'sports facilities gym gymnasium playground ground cricket football basketball volleyball indoor games equipment sports department'),

('Is there a college bus facility?', 'Yes, college buses run on multiple routes covering major areas of the city. Bus passes are available at the transport office. The schedule and routes are available on the college website.', 'Transport', 'bus transport facility college bus routes schedule timings bus pass transport office bus stop pickup drop'),

('How do I apply for scholarships?', 'Various scholarships are available based on merit, sports, and financial need. Applications are accepted in July-August. Visit the scholarship cell or check the college website for eligibility criteria and application process.', 'Financial Aid', 'scholarship financial aid merit scholarship sports scholarship need based scholarship how to apply scholarship application process'),

('What is the dress code?', 'The college follows a formal dress code. Students are expected to wear decent, formal attire. T-shirts with inappropriate messages, shorts, and sleeveless tops are not allowed.', 'Rules', 'dress code uniform formal dress what to wear college attire rules regulations clothing policy'),

('How can I get my documents verified?', 'Document verification is done at the academic section. Bring original documents and photocopies. The timing is 10:00 AM to 4:00 PM on working days. Processing typically takes 2-3 working days.', 'Administrative', 'document verification certificate attestation academic section original documents processing time verification process'),

('What are the placement companies visiting?', 'Top companies like TCS, Infosys, Wipro, IBM, and many startups visit regularly. The placement season starts in August. Details of visiting companies are shared through the placement portal.', 'Placements', 'placement companies recruiters job opportunities campus placement visiting companies recruitment drive placement season'),

('How do I access Wi-Fi?', 'Wi-Fi access is provided to all students. Register your device at the IT help desk with your college ID. The network name is "COLLEGE_NET". Access is available throughout the campus.', 'IT Services', 'wifi internet access network connectivity how to connect wifi registration it help desk internet facility'),

('What medical facilities are available?', 'We have a medical center on campus with a full-time doctor and nurse. Basic medical services are free. The center is open from 9:00 AM to 5:00 PM. Emergency services are available 24/7.', 'Healthcare', 'medical facility doctor health center clinic emergency services first aid medical help healthcare facilities nurse timing'); 

CREATE TABLE campus_locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    location_name VARCHAR(100) NOT NULL UNIQUE, -- The searchable name (e.g., 'Library', 'CE HOD Office', 'Canteen')
    building_name VARCHAR(100),                -- e.g., 'A Building', 'Main Building', 'Library Block'
    floor VARCHAR(50),                         -- e.g., 'Ground Floor', '1st Floor', 'Basement'
    landmarks TEXT,                            -- Nearby recognizable points (e.g., 'Opposite main stairs', 'Next to Auditorium')
    directions TEXT,                           -- Step-by-step directions (e.g., 'Enter A building, take lift to 3rd floor, turn left.')
    keywords TEXT NULL,                        -- Optional: Comma-separated keywords for better search matching (e.g., 'books, study, reading, borrow' for Library)
    -- Add a FULLTEXT index for better searching on name and keywords
    FULLTEXT KEY location_search (location_name, keywords)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO campus_locations
(location_name, building_name, floor, landmarks, directions, keywords)
VALUES
('Main Library', 'Library Building', '1st Floor', 'Above the reading hall, near the digital library section.', 'Enter the Library Building, take the stairs or elevator to the 1st floor. The main circulation desk is visible.', 'library, books, journals, borrow, return, study area'),
('Registrar Office', 'Main Admin Building', 'Ground Floor', 'Near the main entrance, Room G05.', 'Enter the Main Admin Building through the front doors. The Registrar Office is the third door on your left.', 'registrar, administration, documents, verification, official records, admission query'),
('Computer Engineering HOD Office', 'A Building', '2nd Floor', 'Wing A, next to the CE Department Staff Room.', 'Go to A Building, take the stairs/elevator to the 2nd floor. Follow signs for the Computer Engineering Department (Wing A). The HOD office is clearly marked.', 'hod, ce, computer engineering, head of department, faculty query'),
('Main Canteen', 'Canteen Block', 'Ground Floor', 'Behind the Workshop Building, opposite the basketball court.', 'Walk past the main academic buildings towards the sports ground. The Canteen Block is a separate building near the basketball court.', 'canteen, food, snacks, lunch, refreshments, eatery'),
('Placement Cell', 'Main Admin Building', '1st Floor', 'Wing B, above the Accounts Section.', 'Enter the Main Admin Building, take the stairs to the 1st floor. Go towards Wing B, the Training & Placement Office is at the end of the corridor.', 'tpo, placement, jobs, careers, companies, interviews, training'),
('Girls Hostel Warden', 'Girls Hostel', 'Ground Floor', 'Office near the hostel entrance.', 'Go to the Girls Hostel building. The warden\'s office is located just inside the main entrance lobby.', 'hostel, girls hostel, warden, accommodation, hostel query'),
('Boys Hostel Warden', 'Boys Hostel', 'Ground Floor', 'Office adjacent to the mess hall.', 'Enter the Boys Hostel premises. The warden\'s office is situated next to the main mess facility.', 'hostel, boys hostel, warden, accommodation, hostel query');

CREATE TABLE mess_menu (
    menu_id INT PRIMARY KEY AUTO_INCREMENT,
    day_of_week VARCHAR(10) NOT NULL UNIQUE, -- Day name ('Monday', 'Tuesday', etc. - must match DAYNAME() output)
    breakfast TEXT NULL,                     -- Items served for breakfast
    lunch TEXT NULL,                         -- Items served for lunch
    snacks TEXT NULL,                        -- Items served for evening snacks
    dinner TEXT NULL,                        -- Items served for dinner
    canteen_specials TEXT NULL               -- Specific items often available at canteen/chaat counter (can be integrated into other meals too)
);

-- Add an index to the day_of_week column for faster querying
CREATE INDEX idx_day_of_week ON mess_menu (day_of_week);

INSERT INTO mess_menu (day_of_week, breakfast, lunch, snacks, dinner, canteen_specials)
VALUES
('Monday',
 'Poha / Upma, Chai / Coffee / Milk',
 'Sabzi (Gravy), Sabzi (Dry), Roti, Rice, Dal Fry, Salad',
 'Samosa, Chai / Coffee',
 'Sabzi (Paneer), Roti, Jeera Rice, Dal Makhani, Pickle',
 'Vada Pav, Maggi, Dosa, Chai, Coffee available 8AM-7PM'),

('Tuesday',
 'Idli / Medu Vada, Sambar, Chutney, Chai / Coffee / Milk',
 'South Indian Special (e.g., Rice, Sambar, Rasam, Veg Poriyal), Roti, Papad',
 'Dhokla, Chai / Coffee',
 'Sabzi (Mixed Veg), Sabzi (Lentil), Roti, Rice, Dal, Salad',
 'Vada Pav, Maggi, Idli, Chai, Coffee available 8AM-7PM'),

('Wednesday', -- Today's Menu (based on context)
 'Aloo Paratha with Curd / Pickle, Chai / Coffee / Milk',
 'Sabzi (Seasonal Veg), Roti, Rice, Dal Tadka, Raita',
 'Vada Pav / Bhel Puri (Chaat), Chai / Coffee',
 'Sabzi (Kofta Curry), Roti / Puri, Pulao, Kadhi, Papad',
 'Samosa, Maggi, Dosa, Chaat, Chai, Coffee available 8AM-7PM'),

('Thursday',
 'Dosa (Plain/Masala), Sambar, Chutney, Chai / Coffee / Milk',
 'Sabzi (Gravy), Sabzi (Dry), Roti, Rice, Dal Palak, Salad',
 'Maggi (Veg/Egg), Chai / Coffee',
 'Sabzi (Chole), Roti / Bhature, Rice, Dal, Pickle',
 'Vada Pav, Idli, Paratha, Chaat, Chai, Coffee available 8AM-7PM'),

('Friday',
 'Uttapam / Misal Pav, Chai / Coffee / Milk',
 'Sabzi (Special Veg), Roti, Veg Biryani / Fried Rice, Dal Makhani, Curd',
 'Pani Puri (Chaat), Chai / Coffee',
 'Sabzi (Seasonal Veg), Roti, Rice, Dal Fry, Salad',
 'Vada Pav, Samosa, Maggi, Chaat, Chai, Coffee available 8AM-7PM'),

('Saturday',
 'Bread Butter/Jam, Boiled Eggs / Sprouts Salad, Chai / Coffee / Milk',
 'Sabzi (Paneer Butter Masala), Roti / Naan, Rice, Dal, Salad',
 'Paratha (Aloo/Gobi), Chai / Coffee',
 'Sabzi (Mixed Veg), Roti, Rice, Dal, Sweet Dish',
 'Vada Pav, Samosa, Dosa, Idli, Chaat, Chai, Coffee available 8AM-7PM'),

('Sunday',
 'Chole Bhature / Pav Bhaji, Chai / Coffee / Milk (Brunch Style)',
 'Special Lunch: Chicken/Paneer Dish, Veg Pulao, Roti, Dal, Raita, Sweet Dish',
 'Closed / Limited Snacks (e.g., Biscuits, Chai)',
 'Light Dinner: Khichdi / Dal Rice, Curd, Pickle',
 'Limited items available - Check Canteen Notice');
