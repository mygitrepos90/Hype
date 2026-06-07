# HYPE — Complete Setup Guide
## From Demo to Live in 5 Steps

---

## STEP 1 — Supabase (Free Database)

1. Go to **supabase.com** → Sign up free
2. Click **New Project** → Name it "hype-shoes" → Set a strong database password → Create
3. Wait ~2 minutes for project to initialize
4. Go to **SQL Editor** → Paste the entire contents of `schema.sql` → Click Run
5. Go to **Project Settings → API**
6. Copy:
   - **Project URL** → looks like `https://abcdefgh.supabase.co`
   - **Anon public key** → long string starting with `eyJ...`
7. **Add admin user:**
   - Go to **Authentication → Users → Add User**
   - Email: your email, Password: strong password
   - This is your admin login for admin.html

---

## STEP 2 — Update Config in Both Files

Open **index.html** and find the `CFG` block at the top:

```js
const CFG = {
  brand:    'HYPE',              // Change brand name here
  tagline:  'Stay Fresh. Stay Hype.',
  insta:    '@hype.shoes',       // Your Instagram handle
  telegram: 'https://t.me/HypeShoes',  // Your Telegram link
  whatsapp: '919876543210',      // Your WhatsApp with country code
  razorpay: 'rzp_live_XXXXX',   // Your Razorpay key (Step 3)
  supaUrl:  'https://xxx.supabase.co',  // From Step 1
  supaKey:  'eyJhbGci...',       // From Step 1
};
```

Do the same in **admin.html** CFG block + update `adminEmail` and `adminPass`.

---

## STEP 3 — Razorpay (Payments)

1. Go to **razorpay.com** → Sign up
2. Complete KYC (takes 1-2 days — need PAN, bank account, business details)
3. After approval: **Settings → API Keys → Generate Key**
4. Copy the **Key ID** (starts with `rzp_live_`)
5. Paste it in the `razorpay` field in `CFG` in `index.html`

**Cost:** Zero setup. Only 2% per successful transaction. No monthly fees.

---

## STEP 4 — Deploy Website Free (Netlify)

### Option A — Without a domain (free subdomain)
1. Go to **netlify.com** → Sign up free
2. Drag and drop the entire `hype-demo` folder onto the Netlify dashboard
3. Your site is live at `https://something-random.netlify.app` in 60 seconds
4. To customize: **Site Settings → Change site name** → `hype-shoes.netlify.app`

### Option B — With a custom domain (recommended for client)
1. Buy domain at **namecheap.com** or **godaddy.com** → search for `hypeshoes.in` or `kross.in` (~₹800/year)
2. Deploy to Netlify (Option A first)
3. In Netlify → **Domain Settings → Add custom domain**
4. Follow DNS instructions to connect domain (takes 5-30 minutes)

---

## STEP 5 — n8n Automation (Order Notifications)

### If you already have n8n running:
1. Open n8n → **Workflows → Import from JSON** → paste `n8n-workflow.json`
2. Update these two values in the workflow:
   - `YOUR_TELEGRAM_CHAT_ID` → get this by messaging @userinfobot on Telegram
   - `YOUR_GOOGLE_SHEET_ID` → from the URL of your Google Sheet
3. Set up credentials (Telegram bot token + Google OAuth)
4. In Supabase → **Database → Webhooks → Create New:**
   - Table: `orders`
   - Events: `INSERT`
   - URL: `https://your-n8n-instance/webhook/hype-new-order`
5. Activate the workflow

### Telegram Bot setup (5 minutes):
1. Message **@BotFather** on Telegram → `/newbot`
2. Follow prompts → get your Bot Token
3. Add token in n8n Credentials
4. Message your new bot once, then visit:
   `https://api.telegram.org/botYOUR_TOKEN/getUpdates`
5. Copy `"id"` from the result — that's your `chat_id`

---

## STEP 6 — Instagram & Telegram Setup

### Instagram:
1. Download Instagram app → Create new account
2. Username: `hype.shoes` or similar
3. Bio template:
   ```
   👟 HYPE Footwear
   Sports | Casual | Streetwear
   🚚 Free Delivery Pan India
   🔗 Shop here ↓
   ```
4. Add your website link in bio
5. Post your shoe photos — use same product photos from the website

### Telegram Channel:
1. Open Telegram → New Channel
2. Name: HYPE Shoes | Username: @HypeShoes
3. Description: Fresh drops, deals, and new arrivals. Order via website 👟
4. Update the telegram link in your `CFG` config

---

## HOW CLIENT MANAGES THE WEBSITE

### Adding a new product:
1. Open `yourdomain.com/admin`
2. Login with email + password
3. Click **Products → Add New Product**
4. Fill in: Name, Category, Price, Description
5. Tick available sizes
6. Upload photos from phone/laptop
7. Click **Save Product** → appears on website instantly

### Managing orders:
1. Open admin panel → **Orders tab**
2. See all orders with customer details
3. Change order status (New → Confirmed → Dispatched → Delivered)
4. Search by customer name or phone

### When a new order comes:
- Telegram notification arrives instantly with full order details
- Order also appears in Google Sheet automatically
- Admin panel shows it in Orders tab

---

## QUICK REFERENCE

| What | Where | Cost |
|------|-------|------|
| Website code | This folder | Free |
| Hosting | Netlify | Free |
| Custom domain | Namecheap/GoDaddy | ~₹800/year |
| Database | Supabase | Free |
| Payments | Razorpay | 2% per order |
| Automation | n8n | Free (self-hosted) |
| Instagram | Meta | Free |
| Telegram | Telegram | Free |

---

## CHANGE BRAND NAME LATER

To change from HYPE to any other brand:
1. Open `index.html` → Find `CFG` block → Change `brand: 'HYPE'` to new name
2. Open `admin.html` → Same CFG block → Same change
3. Search and replace `HYPE` in both files if it appears elsewhere
4. Done — 5 minutes total

---

*Built for HYPE Footwear — June 2025*
