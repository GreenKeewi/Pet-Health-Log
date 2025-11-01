import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY')
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

const systemPrompt = `You are a precise data-extraction assistant for pet vet receipts and medical notes.
Input: a block of raw OCR'd text from a vet receipt or clinic note.
Output: a JSON object with keys:
- clinic_name (string or null)
- visit_date (ISO 8601 or null)
- total_cost (number or null)
- medications (array of strings)
- procedures (array of strings)
- notes_summary (short string)
- confidence (0-1)
Return only valid JSON, nothing else.`

serve(async (req) => {
  try {
    const { extracted_text, attachment_id } = await req.json()

    if (!extracted_text) {
      return new Response(
        JSON.stringify({ error: 'Missing extracted_text' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Call OpenAI API
    const openaiResponse = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${OPENAI_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-4o-mini',
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: extracted_text }
        ],
        max_tokens: 300,
        temperature: 0.1,
      }),
    })

    if (!openaiResponse.ok) {
      throw new Error(`OpenAI API error: ${openaiResponse.statusText}`)
    }

    const openaiData = await openaiResponse.json()
    const extractedData = JSON.parse(
      openaiData.choices[0].message.content.trim()
    )

    // Optionally update attachment with extracted data
    if (attachment_id && SUPABASE_URL && SUPABASE_SERVICE_ROLE_KEY) {
      const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)
      await supabase
        .from('attachments')
        .update({ 
          extracted_text: JSON.stringify(extractedData)
        })
        .eq('id', attachment_id)
    }

    return new Response(
      JSON.stringify(extractedData),
      { headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
