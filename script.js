// Chat state
let isChatOpen = false;

// Initialize chat when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // DOM Elements
    const chatToggle = document.querySelector('.chat-toggle');
    const chatContainer = document.querySelector('.chat-container');
    const closeChat = document.querySelector('.chat-header span:last-child');
    const messageInput = document.getElementById('message-input');
    const sendButton = document.querySelector('.chat-input button');
    const chatMessages = document.querySelector('.chat-messages');
    const loadingIndicator = document.querySelector('.loading');

    // Hide chat container initially
    chatContainer.style.display = 'none';

    // Event Listeners
    chatToggle.addEventListener('click', toggleChat);
    closeChat.addEventListener('click', toggleChat);
    messageInput.addEventListener('keypress', handleKeyPress);
    sendButton.addEventListener('click', sendMessage);

    // Toggle Chat
    function toggleChat() {
        isChatOpen = !isChatOpen;
        chatContainer.style.display = isChatOpen ? 'flex' : 'none';
        if (isChatOpen) {
            messageInput.focus();
        }
    }

    // Handle Enter Key Press
    function handleKeyPress(event) {
        if (event.key === 'Enter') {
            sendMessage();
        }
    }

    // Format bot messages
    function formatBotMessage(message) {
        // Convert markdown-style formatting to HTML
        message = message.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
        message = message.replace(/\n/g, '<br>');
        
        // Convert bullet points to list items
        message = message.replace(/•\s([^\n]+)/g, '<li>$1</li>');
        if (message.includes('<li>')) {
            message = '<ul>' + message + '</ul>';
        }
        
        // Format emojis and titles
        const emojiMap = {
            '📚': 'Courses',
            '🎓': 'Admission',
            '💰': 'Fees',
            '🏠': 'Hostel',
            '📅': 'Events',
            '💼': 'Placements',
            '📞': 'Contact',
            '✨': 'Features',
            '📋': 'Details',
            '📧': 'Email',
            '🌟': 'Highlights',
            'ℹ️': 'Information',
            '▶': 'Steps',
            '➤': 'Details',
            '⏰': 'Timing',
            '🌐': 'Website'
        };
        
        for (const [emoji, title] of Object.entries(emojiMap)) {
            if (message.includes(emoji)) {
                message = message.replace(
                    new RegExp(`${emoji}\\s*([^\\n]+)`),
                    `<h3>${emoji} ${title}</h3>$1`
                );
            }
        }
        
        return message;
    }

    // Add a message to the chat
    function addMessage(message, isUser = false) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${isUser ? 'user-message' : 'bot-message'}`;
        
        if (!isUser) {
            message = formatBotMessage(message);
        }
        
        messageDiv.innerHTML = message;
        chatMessages.appendChild(messageDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    // Send message to server
    async function sendMessage() {
        const message = messageInput.value.trim();
        
        if (message) {
            // Add user message
            addMessage(message, true);
            messageInput.value = '';
            
            // Show loading
            loadingIndicator.style.display = 'block';
            
            try {
                // Send to server
                const response = await fetch('/chat', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ message: message })
                });
                
                const data = await response.json();
                
                // Hide loading
                loadingIndicator.style.display = 'none';
                
                // Add bot response
                if (data.message) {
                    addMessage(data.message, false);
                }
            } catch (error) {
                console.error('Error:', error);
                loadingIndicator.style.display = 'none';
                addMessage("I apologize, but I'm having trouble connecting to the server. Please try again later.", false);
            }
        }
    }
}); 