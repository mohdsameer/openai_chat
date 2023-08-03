class AiResponseJob < ApplicationJob

  def perform(message_id:, reply_id:)
    reply        = Message.find(reply_id)
    message      = Message.find(message_id)
    conversation = message.conversation

    conversation_history = "User: You are an AI software engineer who can help me with development tasks and general programming questions related to Python, JavaScript, Ruby, Ruby on Rails, CSS, and HTML. You can also provide code snippets and example HTML pages.\nAI: That's right! I'm here to help you with software engineering, web development, programming languages, frameworks, and any other technical questions you might have related to Python, JavaScript, Ruby, Ruby on Rails, CSS, and HTML. I can also provide code snippets and example HTML pages.\n"

    conversation_history += "User: My name is #{message.conversation.user.name}\n"

    input = "#{conversation_history}User: #{message.content}"

    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    response = client.chat(
      parameters: {
                    model: "gpt-4",
                    messages: [{ role: "user", content: input}], # Required.
                    temperature: 0.4,
                    max_tokens: 450,
                    n: 1,
                  }
    )

    if response.has_key?('error')
      response_message = "Something is wrong with api, if you are admin please check the logs"
    elsif response.has_key?('choices')
      response_message = response['choices'][0]['message']['content'].strip

      code_blocks = response_message.scan(/```.*?```/m)

      code_blocks.each_with_index do |code_block, i|
        language = code_block.split("\n").first.gsub("`", "")
        formatted_code_block = "<div class='tyn-code-block'><h6 class='tyn-code-block-title tyn-overline'>#{language.upcase}</h6><button data-clipboard-target='##{language}-tuts-#{i}' class='tyn-copy'>Copy</button><pre class='language-#{language}' tabindex='0'><code class='language-#{language}' id='#{language}-tuts-#{i}'>#{code_block}</code></pre></div>".gsub("```#{language}\n", '').gsub('`', '')

        response_message = response_message.gsub(code_block, formatted_code_block)
      end
    else
      response_message = ''
    end

    if response_message.empty?
      response_message = "I'm sorry, but I don't have an answer for your question."
    end

    reply.content = response_message

    reply.save
    reply.broadcast_content_change
  end
end
