document.addEventListener("DOMContentLoaded", () => {
  const chatMessages = document.querySelector("#chat-messages");
  const chatInputForm = document.querySelector(".chat-input-form");
  const chatInput = document.querySelector("#tynChatInput");
  const userImage = chatInputForm.dataset.userImage;

  async function simulateTyping(element, text, interval = 30) {
    for (let i = 0; i < text.length; i++) {
      element.innerHTML += text[i];
      await new Promise((resolve) => setTimeout(resolve, interval));
    }
  }

  function addMessageToChat(sender, message) {
    const messageElement = document.createElement("div");
    messageElement.classList.add("chat-message", sender.toLowerCase());

    const imageElement = document.createElement("img");
    imageElement.src = sender === "User" ? userImage : "bot-image-path";
    messageElement.appendChild(imageElement);

    const textElement = document.createElement("div");
    textElement.classList.add("text");
    messageElement.appendChild(textElement);

    chatMessages.appendChild(messageElement);

    if (sender === "Chatbot") {
      simulateTyping(textElement, message);
    } else {
      textElement.textContent = message;
    }

    chatMessages.scrollTop = chatMessages.scrollHeight;
  }

  async function getChatbotResponse(userMessage) {
    const response = await fetch("/openai/generate_response", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content') // Added CSRF token
      },
      body: JSON.stringify({ input: userMessage }),
    });

    if (!response.ok) {
      throw new Error(`HTTP error ${response.status}`);
    }

    const data = await response.json();
    console.log("Chatbot response:", data.message);
    return data.message;
  }

  const sendMessage = async () => {
    const userMessage = chatInput.value.trim(); 
    console.log("User message:", userMessage);
    if (userMessage.length > 0) {
      addMessageToChat("User", userMessage);
      chatInput.value = ""; 
      try {
        const chatbotResponse = await getChatbotResponse(userMessage);
        addMessageToChat("Chatbot", chatbotResponse);
      } catch (error) {
        console.error("Error fetching chatbot response:", error);
        addMessageToChat("Chatbot", "An error occurred. Please try again later.");
      }
    }
    return false;  
  };

  document.querySelector(".btn.btn-icon.btn-white.btn-md.btn-pill").addEventListener("click", async (event) => {
    event.preventDefault();
    sendMessage();
    return false;
  });
  
  chatInput.addEventListener("keydown", async (event) => {
    if (event.key === "Enter" || event.keyCode === 13) {
      event.preventDefault();
      sendMessage();
      return false;
    }
  });
  
  chatInputForm.addEventListener("submit", (event) => {
    event.preventDefault();
    return false;
  });  
});
