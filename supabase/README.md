# Supabase Configuration

This directory contains Supabase-related configuration and migrations.

## Migrations

Database migrations are stored in the `migrations/` directory. Apply them in order:

```bash
# Using Supabase CLI
supabase db push

# Or manually in SQL Editor
# Copy the contents of each migration file and run in Supabase SQL Editor
```

## Edge Functions

Deploy edge functions from the parent `functions/` directory:

```bash
supabase functions deploy ai_extract_receipt
supabase functions deploy ai_summarize_visit
supabase functions deploy revenuecat_webhook
```

## Environment Variables

Set the following secrets for your Supabase functions:

```bash
supabase secrets set OPENAI_API_KEY=your_key
```

## Storage Buckets

Create the following storage bucket in Supabase:
- `attachments` - For vet receipts and documents (private)

Configure bucket policies to allow authenticated users to upload files.
