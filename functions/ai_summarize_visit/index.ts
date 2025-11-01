import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY')
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

const systemPrompt = `You are an empathetic veterinary assistant that summarizes vet visits for pet owners in plain language.
Input:
- pet: JSON {name, species, age, weight_kg}
- visit: JSON with extracted fields (clinic_name, visit_date, total_cost, medications, procedures, notes)
Output: JSON:
- ai_summary: 1-3 sentence plain-language summary for the pet owner
- ai_tags: {"visit_type":"checkup|vaccine|dental|emergency|other", "medications":[...], "next_steps":[...]}
- suggested_reminder_iso: ISO 8601 date string for next recommended appointment (or null)
Return only JSON.`

serve(async (req) => {
  try {
    const { pet, visit } = await req.json()

    if (!pet || !visit) {
      return new Response(
        JSON.stringify({ error: 'Missing pet or visit data' }),
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
          { role: 'user', content: JSON.stringify({ pet, visit }) }
        ],
        max_tokens: 300,
        temperature: 0.3,
      }),
    })

    if (!openaiResponse.ok) {
      throw new Error(`OpenAI API error: ${openaiResponse.statusText}`)
    }

    const openaiData = await openaiResponse.json()
    const summary = JSON.parse(
      openaiData.choices[0].message.content.trim()
    )

    return new Response(
      JSON.stringify(summary),
      { headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
