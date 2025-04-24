from flask import Flask, render_template, request, jsonify
import mysql.connector
from dotenv import load_dotenv
import os
from datetime import datetime

app = Flask(__name__)
load_dotenv()

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=os.getenv('DB_HOST', 'localhost'),
            user=os.getenv('DB_USER', 'root'),
            password=os.getenv('DB_PASSWORD', 'Sakshi123'),
            database=os.getenv('DB_NAME', 'college_chatbot'),
            port=int(os.getenv('DB_PORT', '3307'))
        )
        print("Database connection successful")
        return connection
    except mysql.connector.Error as err:
        print(f"Database connection failed: {err}")
        return None

def process_message(message):
    # Convert message to lowercase for better matching
    message = message.lower()
    message_words = set(message.split())
    
    # First check for meta intents (greetings, thanks, etc.)
    meta_intents = {
        'hi': ['hi', 'hello', 'hey', 'greetings', 'good morning', 'good afternoon', 'good evening'],
        'thanks': ['thanks', 'thank you', 'thankyou', 'appreciate it', 'ty'],
        'bye': ['bye', 'goodbye', 'see you', 'cya', 'good night'],
        'help': ['help', 'assist', 'guide', 'support', 'what can you do']
    }
    
    # Check for meta responses first
    for intent, keywords in meta_intents.items():
        if any(word in message for word in keywords):
            try:
                conn = get_db_connection()
                if not conn:
                    return {'message': "👋 Hi! I'm having trouble connecting to my database, but I'm here to help!"}
                    
                cursor = conn.cursor(dictionary=True)
                cursor.execute("SELECT response_text FROM meta_responses WHERE intent_tag = %s", (intent,))
                result = cursor.fetchone()
                cursor.close()
                conn.close()
                
                if result:
                    return {'message': result['response_text']}
            except Exception as e:
                print(f"Error fetching meta response: {str(e)}")
                # Fall through to regular intent matching if meta response fails
    
    # Define keywords for each intent with expanded matches
    intents = {
        'admission': ['admission', 'how to apply', 'enroll', 'cap', 'mht cet', 'jee', 'entrance'],
        'courses': ['course', 'branch', 'program', 'ce', 'it', 'entc', 'aids', 'e&c'],
        'fees': ['fee', 'cost', 'payment', 'charges', 'scholarship', 'tuition'],
        'contact': ['contact', 'reach', 'phone', 'email', 'office', 'hod'],
        'hostel': ['hostel', 'accommodation', 'room', 'mess', 'girls hostel', 'boys hostel'],
        'events': ['event', 'fest', 'pulzion', 'credenz', 'techfiesta', 'pictofest', 'addiction'],
        'placement': ['placement', 'placements', 'stats', 'statistics', 'job', 'company', 'package', 'salary', 'recruit', 'placed'],
        'activities': ['activities', 'activity', 'club', 'chapter', 'pasc', 'pisb', 'robotics', 'gamedev', 'student club'],
        'faq': ['what is', 'how do i', 'where is', 'when is', 'can i', 'tell me about', 'explain', 'help with', 'guide', 'info about'],
        'locations': ['where is', 'how to reach', 'location of', 'directions to', 'find', 'map', 'building', 'department', 'lab', 'classroom', 'office'],
        'food': ['mess', 'canteen', 'menu', 'food', 'cafeteria', 'lunch', 'dinner', 'breakfast', 'snacks']
    }
    
    # Find matching intent with scoring
    matched_intent = None
    best_score = 0
    
    for intent, keywords in intents.items():
        score = 0
        for keyword in keywords:
            # Check for exact phrase matches
            if keyword in message:
                score += 2  # Give higher score for phrase matches
            # Check for individual word matches
            elif any(kw in message_words for kw in keyword.split()):
                score += 1
        
        # Prioritize certain intents based on specific words
        if intent == 'activities' and any(word in message_words for word in ['club', 'chapter', 'activity', 'activities']):
            score += 3  # Give extra weight to activity-specific terms
        elif intent == 'placement' and any(word in message_words for word in ['placement', 'placements', 'stats']):
            score += 3  # Give extra weight to placement-specific terms
        
        if score > best_score:
            best_score = score
            matched_intent = intent
    
    if not matched_intent:
        return {
            'message': "👋 Hi! I'm Noa! I can help you with:\n\n"
                      "📚 Courses (CE/IT/ENTC/AIDS/E&C)\n"
                      "🎓 Admissions (MHT-CET/JEE)\n"
                      "💰 Fees & Scholarships\n"
                      "🏠 Hostel Information\n"
                      "📅 Events & Activities\n"
                      "💼 Placements\n"
                      "📞 Contact Info\n\n"
                      "What would you like to know?"
        }
    
    try:
        conn = get_db_connection()
        if not conn:
            return {'message': "Hi! I'm Noa, but I'm having trouble accessing my database right now. Please try again later."}
            
        cursor = conn.cursor(dictionary=True)
        
        if matched_intent == 'admission':
            cursor.execute("SELECT * FROM admission_p ORDER BY step_number")
            steps = cursor.fetchall()
            response = "🎓 Admission Process:\n\n"
            for step in steps:
                response += f"{step['step_number']}. {step['stage_name']}\n"
                response += f"➤ {step['description']}\n"
                if step['key_requirement']:
                    response += f"📋 Required: {step['key_requirement']}\n"
                if step['reference_info']:
                    response += f"ℹ️ Info: {step['reference_info']}\n"
                response += "\n"
        
        elif matched_intent == 'courses':
            cursor.execute("SELECT * FROM course_details")
            courses = cursor.fetchall()
            response = "📚 Engineering Programs:\n\n"
            for course in courses:
                response += f"▶ {course['course_name']}\n"
                response += f"Duration: {course['duration']} | Seats: {course['seats_available']}\n"
                response += f"Eligibility: {course['eligibility']}\n\n"
        
        elif matched_intent == 'fees':
            cursor.execute("SELECT * FROM fee_structure WHERE academic_year = '2024-25'")
            fees = cursor.fetchall()
            response = "💰 Fee Structure (2024-25):\n\n"
            for fee in fees:
                response += f"▶ {fee['program_stream']}\n"
                response += f"Total Fee: ₹{fee['total_fee']:,.2f}\n"
                if fee['notes']:
                    response += f"Note: {fee['notes']}\n"
                response += "\n"
        
        elif matched_intent == 'contact':
            cursor.execute("SELECT * FROM contact_details LIMIT 6")
            contacts = cursor.fetchall()
            response = "📞 Key Contacts:\n\n"
            for contact in contacts:
                response += f"▶ {contact['contact_point']}\n"
                if contact['email']:
                    response += f"📧 {contact['email']}\n"
                response += f"📱 {contact['phone']}\n"
                if contact['timing']:
                    response += f"⏰ {contact['timing']}\n"
                response += "\n"
        
        elif matched_intent == 'hostel':
            cursor.execute("SELECT * FROM hostel_details")
            hostels = cursor.fetchall()
            response = "🏠 Hostel Information:\n\n"
            for hostel in hostels:
                response += f"▶ {hostel['hostel_name']}\n"
                response += f"Capacity: {hostel['total_capacity']} students\n"
                response += f"Room Charges:\n"
                response += f"- With Attached WC: ₹{hostel['charge_attached_wc']:,.2f}\n"
                response += f"- With Common WC: ₹{hostel['charge_common_wc']:,.2f}\n"
                response += f"Deposit: ₹{hostel['refundable_deposit']:,.2f}\n"
                if hostel['application_info']:
                    response += f"Application: {hostel['application_info']}\n"
                response += "\n"
        
        elif matched_intent == 'events':
            cursor.execute("SELECT * FROM events WHERE academic_year = '2024-25' ORDER BY start_date LIMIT 4")
            events = cursor.fetchall()
            response = "📅 Major Events (2024-25):\n\n"
            for event in events:
                response += f"▶ {event['event_name']}\n"
                response += f"Type: {event['event_type']}\n"
                response += f"By: {event['organizer']}\n"
                if event['website_url']:
                    response += f"🌐 {event['website_url']}\n"
                response += "\n"
        
        elif matched_intent == 'placement':
            cursor.execute("SELECT * FROM placement_stats ORDER BY academic_year_passing DESC LIMIT 3")
            stats = cursor.fetchall()
            
            if not stats:
                return {'message': "💼 No placement statistics available at the moment."}
            
            response = "💼 Recent Placement Statistics:\n\n"
            for stat in stats:
                response += f"▶ Batch {stat['academic_year_passing']}\n"
                response += f"Students Eligible: {stat['students_eligible']}\n"
                response += f"Students Placed: {stat['students_placed']}\n"
                if stat.get('placement_percentage'):
                    response += f"Placement %: {stat['placement_percentage']}%\n"
                if stat.get('highest_package'):
                    response += f"Highest Package: ₹{stat['highest_package']:,.2f} LPA\n"
                if stat.get('average_package'):
                    response += f"Average Package: ₹{stat['average_package']:,.2f} LPA\n"
                response += "\n"
        
        elif matched_intent == 'faq':
            # Extract meaningful search terms
            search_terms = ' '.join(word for word in message_words 
                                  if word not in ['what', 'is', 'the', 'how', 'to', 'can', 'i', 'tell', 'me', 'about'])
            
            # Try exact match first using FULLTEXT search on keywords
            cursor.execute("""
                SELECT faq_id, question, answer, category,
                       MATCH(keywords) AGAINST(%s IN NATURAL LANGUAGE MODE) as relevance
                FROM faq_data 
                WHERE MATCH(keywords) AGAINST(%s IN NATURAL LANGUAGE MODE) > 0
                ORDER BY relevance DESC
                LIMIT 3
            """, (search_terms, search_terms))
            
            faqs = cursor.fetchall()
            
            # If no results from keywords, try matching question directly
            if not faqs:
                cursor.execute("""
                    SELECT faq_id, question, answer, category
                    FROM faq_data 
                    WHERE LOWER(question) LIKE %s
                    OR LOWER(answer) LIKE %s
                    LIMIT 2
                """, (f"%{search_terms.lower()}%", f"%{search_terms.lower()}%"))
                faqs = cursor.fetchall()
            
            if not faqs:
                return {
                    'message': "I couldn't find a specific answer to your question. Here are some topics I can help with:\n\n"
                              "📚 Library & Study Areas\n"
                              "🎯 College Clubs & Activities\n"
                              "🏃 Sports & Recreation\n"
                              "🚌 Transport & Facilities\n"
                              "💰 Scholarships & Financial Aid\n"
                              "👔 College Rules & Policies\n"
                              "📝 Document Services\n"
                              "💼 Placements & Career\n"
                              "🌐 IT & Wi-Fi Services\n"
                              "🏥 Medical & Healthcare\n\n"
                              "Please try asking about one of these topics!"
                }
            
            response = "Here's what I found:\n\n"
            for faq in faqs:
                response += f"❓ {faq['question']}\n"
                response += f"➤ {faq['answer']}\n"
                if faq['category']:
                    response += f"📑 Category: {faq['category']}\n"
                response += "\n"
            
            if len(faqs) > 1:
                response += "I hope one of these answers helps! Let me know if you need more specific information."
        
        elif matched_intent == 'activities':
            cursor.execute("SELECT * FROM curricular WHERE activity_type IN ('Student Chapter', 'Club') LIMIT 4")
            activities = cursor.fetchall()
            response = "🎯 Student Activities:\n\n"
            for activity in activities:
                response += f"▶ {activity['activity_name']} - {activity['full_name']}\n"
                response += f"Type: {activity['activity_type']}\n"
                if activity['member_count_info']:
                    response += f"Members: {activity['member_count_info']}\n"
                if activity['website_url']:
                    response += f"🌐 {activity['website_url']}\n"
                response += "\n"
        
        elif matched_intent == 'locations':
            # Extract meaningful search terms
            search_terms = ' '.join(word for word in message_words 
                                  if word not in ['where', 'is', 'the', 'how', 'to', 'reach', 'find', 'located', 'get'])
            
            # Try exact match first
            cursor.execute("""
                SELECT * FROM campus_locations 
                WHERE location_name LIKE %s
                LIMIT 1
            """, (f"%{search_terms}%",))
            
            locations = cursor.fetchall()
            
            # If no exact match, try FULLTEXT search
            if not locations:
                cursor.execute("""
                    SELECT *, MATCH(location_name, keywords) AGAINST(%s IN NATURAL LANGUAGE MODE) as relevance 
                    FROM campus_locations 
                    WHERE MATCH(location_name, keywords) AGAINST(%s IN NATURAL LANGUAGE MODE) > 0.2
                    ORDER BY relevance DESC
                    LIMIT 3
                """, (search_terms, search_terms))
                locations = cursor.fetchall()
            
            if not locations:
                return {
                    'message': "I couldn't find that specific location. Here are the places I can help you find:\n\n"
                              "🏛️ Main Library\n"
                              "📝 Registrar Office\n"
                              "👨‍💼 Department HOD Offices\n"
                              "🍽️ Main Canteen\n"
                              "💼 Placement Cell\n"
                              "🏠 Hostel Wardens\n\n"
                              "Please try asking about one of these!"
                }
            
            response = "🗺️ Here's what I found:\n\n"
            for location in locations:
                response += f"▶ {location['location_name']}\n"
                if location['building_name']:
                    response += f"Building: {location['building_name']}\n"
                if location['floor']:
                    response += f"Floor: {location['floor']}\n"
                if location['landmarks']:
                    response += f"Landmarks: {location['landmarks']}\n"
                if location['directions']:
                    response += f"Directions: {location['directions']}\n"
                response += "\n"
        
        elif matched_intent == 'food':
            # Get current day's menu
            cursor.execute("SELECT * FROM mess_menu WHERE day_of_week = DAYNAME(CURDATE())")
            menu = cursor.fetchone()
            
            if not menu:
                return {'message': "🍽️ I couldn't find today's menu. Please check back during cafeteria hours!"}
            
            current_hour = int(datetime.now().strftime('%H'))
            
            # Determine which meals to show based on time of day
            response = "🍽️ Today's Menu:\n\n"
            
            if current_hour < 11:  # Before 11 AM
                if menu['breakfast']:
                    response += "🌅 Breakfast:\n" + menu['breakfast'] + "\n\n"
                if menu['lunch']:
                    response += "🍱 Upcoming Lunch:\n" + menu['lunch'] + "\n"
            elif current_hour < 16:  # Before 4 PM
                if menu['lunch']:
                    response += "🍱 Lunch:\n" + menu['lunch'] + "\n\n"
                if menu['snacks']:
                    response += "🍪 Upcoming Snacks:\n" + menu['snacks'] + "\n"
            elif current_hour < 19:  # Before 7 PM
                if menu['snacks']:
                    response += "🍪 Snacks:\n" + menu['snacks'] + "\n\n"
                if menu['dinner']:
                    response += "🍽️ Upcoming Dinner:\n" + menu['dinner'] + "\n"
            else:  # After 7 PM
                if menu['dinner']:
                    response += "🍽️ Dinner:\n" + menu['dinner'] + "\n"
            
            if menu['canteen_specials']:
                response += "\n📍 Canteen Specials:\n" + menu['canteen_specials']
        
        cursor.close()
        conn.close()
        return {'message': response}
    
    except Exception as e:
        print(f"Error: {str(e)}")
        return {'message': "I apologize, but I'm having trouble accessing the information right now. Please try again later."}

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/chat', methods=['POST'])
def chat():
    try:
        data = request.get_json()
        message = data.get('message', '')
        response = process_message(message)
        return jsonify(response)
    except Exception as e:
        print(f"Error in chat endpoint: {str(e)}")
        return jsonify({
            'message': "I apologize, but I'm having trouble processing your request. Please try again later."
        })

if __name__ == '__main__':
    app.run(debug=True) 