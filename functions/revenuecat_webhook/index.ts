import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

serve(async (req) => {
  try {
    const webhook = await req.json()
    
    // Verify webhook (you should add signature verification in production)
    
    const supabase = createClient(SUPABASE_URL!, SUPABASE_SERVICE_ROLE_KEY!)
    
    const {
      event,
      app_user_id,
      product_id,
      purchased_at_ms,
      expiration_at_ms,
    } = webhook

    let status = 'active'
    if (event.type === 'CANCELLATION') {
      status = 'cancelled'
    } else if (event.type === 'EXPIRATION') {
      status = 'expired'
    }

    // Upsert subscription record
    await supabase
      .from('subscriptions')
      .upsert({
        owner_id: app_user_id,
        product_id: product_id,
        status: status,
        purchase_date: new Date(purchased_at_ms),
        expires_at: expiration_at_ms ? new Date(expiration_at_ms) : null,
        raw_payload: webhook,
      })

    return new Response(
      JSON.stringify({ received: true }),
      { headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Webhook error:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
