import { useState } from "react";
import {
  Bell, Search, Ticket as TicketIcon, User, Home as HomeIcon,
  ArrowLeft, RefreshCw, Bus, Clock, MapPin, Compass, Share2,
  CreditCard, Globe, HelpCircle, LogOut, Briefcase, Plus, Settings,
  Image as ImageIcon, Leaf, Check,
} from "lucide-react";

/* ---------------------------------------------------------------
   GetMyBus — Commuter App (v2: modern, minimal)
   Illustration spots are left as labeled placeholders — see the
   generation prompts listed in the chat reply for each one.
   Drop into any React project: npm i lucide-react
   --------------------------------------------------------------- */

const T = {
  primary: "#2B57FF",
  primaryDark: "#1E3FCC",
  cyan: "#12CBE0",
  violet: "#8B5CF6",
  orange: "#FF9F45",
  bg: "#FAFBFD",
  ink: "#12141C",
  sub: "#6B7280",
  faint: "#9AA2B1",
  line: "#EEF0F4",
  tint: "#EEF2FF",
  success: "#17B26A",
  successBg: "#EAF9F1",
  danger: "#E4483C",
  font: "'Inter', system-ui, sans-serif",
};

/* Fixed per-route accent colors — like a metro map, each route number
   always reads in the same color everywhere it appears (badges, the
   Home live rail, search results). Add new routes here as needed. */
const ROUTE_COLORS = { "42": T.primary, "7B": T.cyan, "12": T.violet };

/* Flip during Onam (or another festival window) to swap in themed
   onboarding art and a subtle accent strip — revert once the window
   passes. This is the only place seasonal theming needs to change. */
const SEASONAL_ONAM = false;

/* One-time keyframes for the small motion moments below (ticket-scan
   checkmark, pull-to-refresh bus). Injected once at the app root. */
function GlobalKeyframes() {
  return (
    <style>{`
      @keyframes gmb-pop { 0% { transform: scale(0.6); opacity: 0; } 60% { transform: scale(1.08); opacity: 1; } 100% { transform: scale(1); opacity: 1; } }
      @keyframes gmb-bob { 0%, 100% { transform: translateX(0); } 50% { transform: translateX(14px); } }
      @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
    `}</style>
  );
}

/* Reusable route badge — background/text tint derived from the
   route's fixed color in ROUTE_COLORS rather than always primary. */
function RouteBadge({ num, size = 38 }) {
  const color = ROUTE_COLORS[num] || T.primary;
  return (
    <div style={{
      width: size, height: size, borderRadius: size >= 34 ? 12 : 10,
      background: `${color}1A`, display: "flex", alignItems: "center", justifyContent: "center",
      fontWeight: 600, color, fontSize: size >= 34 ? 13 : 12, flexShrink: 0,
    }}>{num}</div>
  );
}

const NAV_ITEMS = [
  { key: "home", label: "Home", icon: HomeIcon },
  { key: "search", label: "Search", icon: Search },
  { key: "tickets", label: "Tickets", icon: TicketIcon },
  { key: "alerts", label: "Alerts", icon: Bell },
  { key: "profile", label: "Profile", icon: User },
];

/* Labeled placeholder for a not-yet-generated illustration.
   Swap the div's background for an <img src="..."> once you
   have the asset — sizing stays the same. */
function IllustrationPlaceholder({ label, height = 160 }) {
  return (
    <div style={{
      height, borderRadius: 20, background: T.tint,
      border: `1.5px dashed ${T.primary}66`,
      display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: 8,
    }}>
      <ImageIcon size={20} color={T.primary} strokeWidth={1.75} />
      <span style={{ fontSize: 11, fontWeight: 600, color: T.primary, textAlign: "center", padding: "0 24px" }}>{label}</span>
    </div>
  );
}

/* Unified crowd indicator — a 3-segment gauge instead of a colored
   dot + label. Reused across the route list and live tracking. */
function CrowdGauge({ level, color, showLabel = true, size = "md" }) {
  const filled = level === "Low" ? 1 : level === "Medium" ? 2 : 3;
  const barW = size === "sm" ? 14 : 20;
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
      <div style={{ display: "flex", gap: 3 }}>
        {[0, 1, 2].map((i) => (
          <span key={i} style={{
            width: barW, height: 4, borderRadius: 999,
            background: i < filled ? color : T.line,
          }} />
        ))}
      </div>
      {showLabel && <span style={{ fontSize: 12, fontWeight: 500, color }}>{level}</span>}
    </div>
  );
}

/* Small horizontal-scroll chip used in the Home "Live rail". */
function LiveRailChip({ route, eta, crowdColor }) {
  const color = ROUTE_COLORS[route] || T.primary;
  return (
    <div style={{
      flexShrink: 0, minWidth: 92, borderRadius: 16, border: `1px solid ${T.line}`,
      borderTop: `3px solid ${color}`, padding: "11px 14px 12px", display: "flex", flexDirection: "column", gap: 8,
    }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span style={{ fontSize: 13, fontWeight: 600, color }}>{route}</span>
        <span style={{ width: 5, height: 5, borderRadius: 999, background: crowdColor }} />
      </div>
      <div style={{ fontSize: 17, fontWeight: 600, fontVariantNumeric: "tabular-nums", letterSpacing: "-0.01em" }}>{eta}</div>
      <div style={{ fontSize: 10.5, color: T.faint }}>away</div>
    </div>
  );
}

const ONBOARDING_SLIDES = [
  {
    illustration: "Hero illustration — a single-line-art commuter at a bus stop watching a bus approach on a curved road, warm and calm, primary-blue line art on tint background",
    headline: "Know exactly\nwhen it arrives.",
    headlineMl: "ബസ് എപ്പോൾ എത്തുമെന്ന് കൃത്യമായി അറിയാം",
    body: "Live GPS tracking for every private bus route in Kollam — no more guessing at the stop.",
  },
  {
    illustration: "Illustration — minimal line art of a phone showing a QR ticket being scanned by a conductor, single stroke weight, primary-blue on tint background",
    headline: "Board without\nthe queue.",
    headlineMl: "ക്യൂ ഇല്ലാതെ ബസിൽ കയറാം",
    body: "Buy your ticket in the app and show the code — no cash, no counting change.",
  },
  {
    illustration: "Illustration — minimal line art of a wallet with a single coin sliding in, one stroke weight, primary-blue on tint background",
    headline: "Top up once,\nride all week.",
    headlineMl: "ഒരിക്കൽ റീചാർജ് ചെയ്യൂ, ആഴ്ചയിലുടനീളം യാത്ര ചെയ്യൂ",
    body: "Keep a running balance across every route and skip the fumbling at the door.",
  },
];

function OnboardingScreen({ onGetStarted }) {
  const [i, setI] = useState(0);
  const last = i === ONBOARDING_SLIDES.length - 1;
  const slide = ONBOARDING_SLIDES[i];
  const heroIllustration = i === 0 && SEASONAL_ONAM
    ? "Onam-season variant — the same commuter-at-a-bus-stop scene, but the bus stop is decorated with a small single-line pookalam (flower rangoli) motif at its base, still one stroke weight, primary-blue on tint"
    : slide.illustration;

  return (
    <div style={{ padding: "44px 26px 34px", display: "flex", flexDirection: "column", flex: 1 }}>
      {SEASONAL_ONAM && (
        <div style={{ display: "flex", gap: 4, marginBottom: 18, marginTop: -20, marginLeft: -26, marginRight: -26 }}>
          {["#FFC93C", "#FF6B6B", "#4ECDC4", "#2B57FF", "#8B5CF6"].map((c) => (
            <span key={c} style={{ flex: 1, height: 3, background: c }} />
          ))}
        </div>
      )}
      <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
        <div style={{ width: 28, height: 28, borderRadius: 9, background: T.primary, display: "flex", alignItems: "center", justifyContent: "center" }}>
          <Bus size={15} color="#fff" strokeWidth={2} />
        </div>
        <span style={{ fontSize: 14, fontWeight: 600, letterSpacing: "-0.01em" }}>GetMyBus</span>
      </div>

      <div
        onClick={() => !last && setI(i + 1)}
        style={{ flex: 1, display: "flex", flexDirection: "column", justifyContent: "center", gap: 28, cursor: last ? "default" : "pointer" }}
      >
        <IllustrationPlaceholder height={280} label={heroIllustration} />
        <div>
          <div style={{ fontSize: 27, fontWeight: 600, letterSpacing: "-0.02em", lineHeight: 1.25, whiteSpace: "pre-line" }}>{slide.headline}</div>
          {/* Malayalam lines are a first pass for tone/authenticity —
              have a native speaker confirm phrasing before shipping. */}
          <div style={{ fontSize: 12.5, color: T.faint, marginTop: 4 }}>{slide.headlineMl}</div>
          <div style={{ fontSize: 14.5, color: T.sub, marginTop: 10, lineHeight: 1.5 }}>{slide.body}</div>
        </div>
        <div style={{ display: "flex", gap: 6 }}>
          {ONBOARDING_SLIDES.map((_, idx) => (
            <span
              key={idx}
              onClick={(e) => { e.stopPropagation(); setI(idx); }}
              style={{ width: idx === i ? 18 : 4, height: 4, borderRadius: 999, background: idx === i ? T.ink : T.line, cursor: "pointer" }}
            />
          ))}
        </div>
      </div>

      <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
        <button onClick={() => (last ? onGetStarted() : setI(i + 1))} style={{
          background: T.ink, color: "#fff", fontSize: 15, fontWeight: 600, padding: 16,
          borderRadius: 16, border: "none", cursor: "pointer",
        }}>{last ? "Get started" : "Next"}</button>
        {!last
          ? <div onClick={onGetStarted} style={{ textAlign: "center", fontSize: 13, color: T.sub, cursor: "pointer" }}>Skip</div>
          : <div style={{ textAlign: "center", fontSize: 13, color: T.sub }}>Already have an account? <span style={{ color: T.primary, fontWeight: 600 }}>Sign in</span></div>
        }
      </div>
    </div>
  );
}

function BottomNav({ active, onChange }) {
  return (
    <div style={{
      height: 62, borderTop: `1px solid ${T.line}`,
      display: "flex", alignItems: "center", justifyContent: "space-around", fontFamily: T.font,
    }}>
      {NAV_ITEMS.map(({ key, label, icon: Icon }) => {
        const isActive = key === active;
        const color = isActive ? T.ink : T.faint;
        return (
          <button key={key} onClick={() => onChange(key)}
            style={{ background: "none", border: "none", cursor: "pointer", display: "flex", flexDirection: "column", alignItems: "center", gap: 5 }}>
            <Icon size={20} color={color} strokeWidth={isActive ? 2.25 : 1.75} />
            <span style={{ width: 4, height: 4, borderRadius: 999, background: isActive ? T.primary : "transparent" }} />
          </button>
        );
      })}
    </div>
  );
}

function ScreenHeader({ title, onBack, right }) {
  return (
    <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
      <button aria-label="Back" onClick={onBack} style={{ width: 36, height: 36, border: "none", background: "none", cursor: "pointer", marginLeft: -8 }}>
        <ArrowLeft size={19} color={T.ink} strokeWidth={1.75} />
      </button>
      <div style={{ fontSize: 16, fontWeight: 600, letterSpacing: "-0.01em" }}>{title}</div>
      <div style={{ width: 36, height: 36, display: "flex", alignItems: "center", justifyContent: "center" }}>{right}</div>
    </div>
  );
}

/* Empty state for the Home live rail during off-hours (late night /
   pre-dawn) instead of just showing nothing. */
function NoBusesState() {
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 14, borderRadius: 16, border: `1px dashed ${T.line}`, padding: "16px 16px" }}>
      <div style={{ width: 44, height: 44, borderRadius: 12, background: T.tint, flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "center" }}>
        <ImageIcon size={17} color={T.primary} strokeWidth={1.75} />
      </div>
      <div>
        <div style={{ fontSize: 13.5, fontWeight: 600 }}>No live buses right now</div>
        <div style={{ fontSize: 12, color: T.sub, marginTop: 2 }}>Service resumes 5:30 AM · Illustration — line-art bus parked at a depot under a crescent moon</div>
      </div>
    </div>
  );
}

function HomeScreen({ onOpenTracking }) {
  const [noBuses, setNoBuses] = useState(false);
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 26, flex: 1, overflowY: "auto" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
        <div>
          <div style={{ fontSize: 13, color: T.sub }}>Good morning</div>
          <div style={{ fontSize: 23, fontWeight: 600, marginTop: 3, letterSpacing: "-0.02em" }}>Where to?</div>
          <div style={{ fontSize: 12.5, color: T.faint, marginTop: 2 }}>എവിടേക്ക്?</div>
        </div>
        <button aria-label="Notifications" style={{ width: 20, height: 20, border: "none", background: "none", cursor: "pointer", marginTop: 6 }}>
          <Bell size={20} color={T.ink} strokeWidth={1.75} />
        </button>
      </div>

      <div style={{ height: 50, background: "#F1F3F8", borderRadius: 16, display: "flex", alignItems: "center", padding: "0 18px", gap: 10 }}>
        <Search size={18} color={T.faint} strokeWidth={1.75} />
        <span style={{ fontSize: 14, color: T.faint }}>Search a stop, route or destination</span>
      </div>

      <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
        <IllustrationPlaceholder label="Illustration — commuter checking live bus location" />
        <button onClick={onOpenTracking} style={{
          textAlign: "left", border: "none", background: "none", cursor: "pointer", padding: 0,
          display: "flex", justifyContent: "space-between", alignItems: "center",
        }}>
          <div>
            <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
              <span style={{ width: 6, height: 6, borderRadius: 999, background: T.success }} />
              <span style={{ fontSize: 11, fontWeight: 600, color: T.success, letterSpacing: "0.02em" }}>Live</span>
            </div>
            <div style={{ fontSize: 17, fontWeight: 600, marginTop: 4, letterSpacing: "-0.01em" }}>3 buses near you</div>
            <div style={{ fontSize: 13, color: T.sub, marginTop: 2 }}>Route 42, 7B and 12 · within 5 min</div>
          </div>
          <div style={{ fontSize: 13, fontWeight: 600, color: T.primary, whiteSpace: "nowrap" }}>View map →</div>
        </button>
      </div>

      <div style={{ display: "flex", justifyContent: "space-between" }}>
        {[
          { icon: MapPin, label: "Nearby" },
          { icon: Compass, label: "Routes" },
          { icon: TicketIcon, label: "Tickets" },
        ].map(({ icon: Icon, label }) => (
          <button key={label} style={{ background: "none", border: "none", cursor: "pointer", display: "flex", flexDirection: "column", alignItems: "center", gap: 8, width: 108 }}>
            <Icon size={22} color={T.ink} strokeWidth={1.5} />
            <span style={{ fontSize: 12.5, color: T.sub }}>{label}</span>
          </button>
        ))}
      </div>

      <div>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", marginBottom: 12 }}>
          <div style={{ fontSize: 15, fontWeight: 600 }}>Live near you</div>
          <span onClick={() => setNoBuses(!noBuses)} style={{ fontSize: 11, color: T.faint, cursor: "pointer", textDecoration: "underline" }}>
            {noBuses ? "Show live buses" : "Preview: no buses"}
          </span>
        </div>
        {noBuses ? <NoBusesState /> : (
          <div style={{ display: "flex", gap: 10, overflowX: "auto", paddingBottom: 2 }}>
            <LiveRailChip route="42" eta="4 min" crowdColor={T.success} />
            <LiveRailChip route="7B" eta="6 min" crowdColor={T.orange} />
            <LiveRailChip route="12" eta="9 min" crowdColor={T.success} />
          </div>
        )}
      </div>

      <div style={{
        display: "flex", alignItems: "center", gap: 14, borderRadius: 18,
        background: `linear-gradient(135deg, ${T.primary}, ${T.primaryDark})`,
        padding: "16px 18px",
      }}>
        <div style={{ width: 44, height: 44, borderRadius: 14, background: "rgba(255,255,255,0.16)", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "center" }}>
          <ImageIcon size={18} color="#fff" strokeWidth={1.75} />
        </div>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 13, fontWeight: 600, color: "#fff" }}>2 trips to your free ride</div>
          <div style={{ fontSize: 11.5, color: "rgba(255,255,255,0.8)", marginTop: 2 }}>Illustration — line-art bus crossing a small finish flag, milestone reward banner</div>
        </div>
      </div>

      <div>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline" }}>
          <div style={{ fontSize: 15, fontWeight: 600 }}>Recent trips</div>
          <span style={{ fontSize: 12.5, color: T.sub }}>See all</span>
        </div>
        <div style={{ marginTop: 14 }}>
          {[
            { route: "42", from: "Kadappakada → Chinnakada", meta: "12 min ago", fare: "₹15" },
            { route: "7B", from: "Kollam Bus Stand → Chavara", meta: "Yesterday", fare: "₹22" },
          ].map((trip, i) => (
            <div key={trip.route} style={{ display: "flex", alignItems: "center", gap: 14, padding: "12px 0", borderTop: i === 0 ? "none" : `1px solid ${T.line}` }}>
              <RouteBadge num={trip.route} />
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, fontWeight: 500 }}>{trip.from}</div>
                <div style={{ fontSize: 12, color: T.faint, marginTop: 2 }}>{trip.meta}</div>
              </div>
              <div style={{ fontSize: 14, fontWeight: 600, color: T.sub }}>{trip.fare}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

function LiveTrackingScreen({ onBack }) {
  const [refreshing, setRefreshing] = useState(false);
  const doRefresh = () => { setRefreshing(true); setTimeout(() => setRefreshing(false), 900); };
  const stops = [
    { name: "Kollam Bus Stand", meta: "Departed 9:40 AM", state: "done" },
    { name: "Kadappakada", meta: "Departed 9:52 AM", state: "done" },
    { name: "Thattamala", meta: "ETA 10:02 AM", state: "current" },
    { name: "Chinnakada", meta: "ETA 10:11 AM", state: "upcoming" },
  ];
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 22, flex: 1, overflowY: "auto" }}>
      <ScreenHeader title="Live tracking" onBack={onBack} right={
        <button onClick={doRefresh} aria-label="Refresh" style={{ border: "none", background: "none", cursor: "pointer", padding: 0, display: "flex" }}>
          <RefreshCw size={18} color={T.ink} strokeWidth={1.75} style={refreshing ? { animation: "spin 0.9s linear" } : undefined} />
        </button>
      } />

      {refreshing && (
        <div style={{ height: 3, borderRadius: 999, background: T.line, position: "relative", overflow: "hidden" }}>
          <Bus size={14} color={T.primary} style={{ position: "absolute", top: -6, left: 0, animation: "gmb-bob 0.9s ease-in-out infinite" }} />
        </div>
      )}

      <IllustrationPlaceholder label="Illustration — live map with bus route and marker" height={200} />

      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <RouteBadge num="42" />
          <div>
            <div style={{ fontSize: 15, fontWeight: 600 }}>To Chinnakada</div>
            <div style={{ fontSize: 12.5, color: T.sub, marginTop: 2 }}>via Kadappakada Rd</div>
          </div>
        </div>
        <div style={{ textAlign: "right" }}>
          <div style={{ fontSize: 19, fontWeight: 600, color: T.primary }}>4 min</div>
          <div style={{ fontSize: 11.5, color: T.faint }}>1.2 km away</div>
        </div>
      </div>

      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
        <span style={{ fontSize: 13, color: T.sub }}>Crowd level</span>
        <CrowdGauge level="Low" color={T.success} />
      </div>

      <div>
        <div style={{ fontSize: 15, fontWeight: 600, marginBottom: 16 }}>Route stops</div>
        {stops.map((s, i) => (
          <div key={s.name} style={{ display: "flex", gap: 14 }}>
            <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
              <span style={{
                width: 9, height: 9, borderRadius: 999,
                background: s.state === "upcoming" ? "#fff" : T.primary,
                border: s.state !== "done" ? `2px solid ${T.primary}` : "none",
              }} />
              {i < stops.length - 1 && <span style={{ width: 1, flex: 1, background: T.line, marginTop: 3 }} />}
            </div>
            <div style={{ paddingBottom: i < stops.length - 1 ? 22 : 0 }}>
              <div style={{ fontSize: 14, fontWeight: 500 }}>{s.name}</div>
              <div style={{ fontSize: 12, color: T.faint, marginTop: 2 }}>{s.meta}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function RouteSearchScreen({ onBack }) {
  const routes = [
    { num: "42", time: "9:40 → 9:58 AM", meta: "18 min · 4 stops", fare: "₹15", crowd: "Low", crowdColor: T.success },
    { num: "7B", time: "9:45 → 10:12 AM", meta: "27 min · 7 stops", fare: "₹22", crowd: "Medium", crowdColor: T.orange },
    { num: "12", time: "9:52 → 10:20 AM", meta: "28 min · 6 stops", fare: "₹18", crowd: "Low", crowdColor: T.success },
  ];
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 20, flex: 1, overflowY: "auto" }}>
      <ScreenHeader title="Search routes" onBack={onBack} right={<Settings size={18} color={T.ink} strokeWidth={1.75} />} />

      <IllustrationPlaceholder label="Illustration — minimal single-line bus stop signpost with a faint coconut-palm silhouette, Kerala touch" height={120} />

      <div style={{ background: "#F1F3F8", borderRadius: 16, padding: "14px 18px" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <span style={{ width: 8, height: 8, borderRadius: 999, border: `2px solid ${T.primary}`, flexShrink: 0 }} />
          <div><div style={{ fontSize: 10.5, color: T.faint }}>From</div><div style={{ fontSize: 14.5, fontWeight: 500, marginTop: 1 }}>Kollam Bus Stand</div></div>
        </div>
        <div style={{ height: 1, background: "#E2E5EC", margin: "12px 0 12px 4px" }} />
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <span style={{ width: 8, height: 8, borderRadius: 2, background: T.orange, flexShrink: 0 }} />
          <div><div style={{ fontSize: 10.5, color: T.faint }}>To</div><div style={{ fontSize: 14.5, fontWeight: 500, marginTop: 1 }}>Chinnakada</div></div>
        </div>
      </div>

      <div style={{ display: "flex", gap: 20, overflowX: "auto" }}>
        {["Fastest", "Cheapest", "Fewest stops", "AC Buses"].map((label, i) => (
          <span key={label} style={{ fontSize: 13.5, fontWeight: i === 0 ? 600 : 400, color: i === 0 ? T.ink : T.sub, whiteSpace: "nowrap", borderBottom: i === 0 ? `2px solid ${T.ink}` : "2px solid transparent", paddingBottom: 6 }}>{label}</span>
        ))}
      </div>

      <div style={{ display: "flex", justifyContent: "space-between" }}>
        <span style={{ fontSize: 12.5, color: T.sub }}>6 routes found</span>
        <span style={{ fontSize: 12.5, fontWeight: 500, color: T.ink }}>Sort: Fastest ▾</span>
      </div>

      <div>
        {routes.map((r, i) => (
          <div key={r.num} style={{ padding: "16px 0", borderTop: i === 0 ? "none" : `1px solid ${T.line}` }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
              <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
                <RouteBadge num={r.num} />
                <div><div style={{ fontSize: 14, fontWeight: 500 }}>{r.time}</div><div style={{ fontSize: 12, color: T.faint, marginTop: 2 }}>{r.meta}</div></div>
              </div>
              <div style={{ textAlign: "right" }}><div style={{ fontSize: 15, fontWeight: 600 }}>{r.fare}</div><div style={{ fontSize: 11, color: T.faint }}>per seat</div></div>
            </div>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 12 }}>
              <CrowdGauge level={r.crowd} color={r.crowdColor} size="sm" />
              <button style={{ border: "none", background: "none", color: T.primary, fontSize: 13, fontWeight: 600, cursor: "pointer", padding: 0 }}>Track bus →</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function TicketScreen({ onBack }) {
  const [scanned, setScanned] = useState(false);
  const simulateScan = () => { setScanned(true); setTimeout(() => setScanned(false), 1600); };
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 22, flex: 1, overflowY: "auto" }}>
      <ScreenHeader title="My ticket" onBack={onBack} right={<Share2 size={18} color={T.ink} strokeWidth={1.75} />} />

      <IllustrationPlaceholder label="Illustration — commuter holding a confirmed bus ticket" height={150} />

      <div>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <RouteBadge num="42" />
          <span style={{ fontSize: 11, fontWeight: 600, color: T.success, letterSpacing: "0.02em" }}>Confirmed</span>
        </div>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 18 }}>
          <div><div style={{ fontSize: 20, fontWeight: 600, fontVariantNumeric: "tabular-nums" }}>9:40 AM</div><div style={{ fontSize: 12, color: T.faint, marginTop: 3 }}>Kollam Bus Stand</div></div>
          <div style={{ color: T.faint }}>→</div>
          <div style={{ textAlign: "right" }}><div style={{ fontSize: 20, fontWeight: 600, fontVariantNumeric: "tabular-nums" }}>9:58 AM</div><div style={{ fontSize: 12, color: T.faint, marginTop: 3 }}>Chinnakada</div></div>
        </div>
        <div style={{ display: "flex", gap: 28, marginTop: 20, paddingTop: 18, borderTop: `1px solid ${T.line}` }}>
          <div><div style={{ fontSize: 10.5, color: T.faint }}>Date</div><div style={{ fontSize: 13, fontWeight: 500, marginTop: 3 }}>26 Sep 2026</div></div>
          <div><div style={{ fontSize: 10.5, color: T.faint }}>Seat</div><div style={{ fontSize: 13, fontWeight: 500, marginTop: 3 }}>A14</div></div>
          <div><div style={{ fontSize: 10.5, color: T.faint }}>Bus no.</div><div style={{ fontSize: 13, fontWeight: 500, marginTop: 3 }}>KL-23 4521</div></div>
        </div>
      </div>

      {/* Boarding-pass style tear: perforated notches cut into the
          card edges either side of the dashed line, like an airline stub. */}
      <div style={{ position: "relative" }}>
        <div style={{ position: "absolute", left: -22, top: "50%", transform: "translateY(-50%)", width: 20, height: 20, borderRadius: 999, background: T.bg, border: `1px solid ${T.line}` }} />
        <div style={{ position: "absolute", right: -22, top: "50%", transform: "translateY(-50%)", width: 20, height: 20, borderRadius: 999, background: T.bg, border: `1px solid ${T.line}` }} />
        <div style={{ display: "flex", flexDirection: "column", alignItems: "center", padding: "22px 0", borderTop: `1.5px dashed ${T.line}`, borderBottom: `1.5px dashed ${T.line}` }}>
          <div onClick={simulateScan} style={{ width: 108, height: 108, background: T.ink, borderRadius: 14, cursor: "pointer", position: "relative", display: "flex", alignItems: "center", justifyContent: "center" }}>
            {scanned && (
              <div style={{ position: "absolute", inset: 0, borderRadius: 14, background: T.success, display: "flex", alignItems: "center", justifyContent: "center", animation: "gmb-pop 0.35s ease-out" }}>
                <Check size={44} color="#fff" strokeWidth={2.5} />
              </div>
            )}
          </div>
          <div style={{ fontSize: 12, color: T.sub, marginTop: 14 }}>{scanned ? "Boarding confirmed" : "Show this code to the conductor"}</div>
          <div style={{ fontSize: 11, color: T.faint, marginTop: 4, fontFamily: "'IBM Plex Mono', ui-monospace, monospace", letterSpacing: "0.04em" }}>GMB-2609-77341</div>
          {!scanned && <div style={{ fontSize: 10, color: T.faint, marginTop: 6 }}>(tap the code to preview the scan confirmation)</div>}
        </div>
      </div>

      <div>
        <div style={{ display: "flex", justifyContent: "space-between", fontSize: 14, color: T.sub }}><span>Base fare</span><span style={{ color: T.ink }}>₹13.00</span></div>
        <div style={{ display: "flex", justifyContent: "space-between", fontSize: 14, color: T.sub, marginTop: 12 }}><span>Taxes &amp; fees</span><span style={{ color: T.ink }}>₹2.00</span></div>
        <div style={{ display: "flex", justifyContent: "space-between", fontSize: 15, fontWeight: 600, marginTop: 16, paddingTop: 16, borderTop: `1px solid ${T.line}` }}><span>Total paid</span><span style={{ fontVariantNumeric: "tabular-nums" }}>₹15.00</span></div>
      </div>

      {/* Shareable trip card — a compact, WhatsApp-status-shaped
          summary the commuter can post after a ride. Low-cost organic
          marketing since WhatsApp is the default share sheet here. */}
      <div>
        <div style={{ fontSize: 13, fontWeight: 600, marginBottom: 10 }}>Share this trip</div>
        <div style={{
          borderRadius: 16, padding: 18, color: "#fff",
          background: `linear-gradient(135deg, ${T.primary}, ${T.primaryDark})`,
        }}>
          <div style={{ fontSize: 11, opacity: 0.75, letterSpacing: "0.04em" }}>GETMYBUS</div>
          <div style={{ fontSize: 16, fontWeight: 600, marginTop: 8 }}>Kollam → Chinnakada</div>
          <div style={{ fontSize: 12.5, opacity: 0.85, marginTop: 3 }}>Route 42 · 18 min · on time</div>
        </div>
        <button style={{
          width: "100%", marginTop: 10, display: "flex", alignItems: "center", justifyContent: "center", gap: 8,
          background: "#25D366", color: "#fff", fontSize: 14, fontWeight: 600, padding: 13, borderRadius: 14, border: "none", cursor: "pointer",
        }}><Share2 size={16} strokeWidth={2} />Share to WhatsApp</button>
      </div>

      <div style={{ display: "flex", gap: 12 }}>
        <button style={{ flex: 1, border: `1px solid ${T.line}`, color: T.ink, fontSize: 14, fontWeight: 500, padding: 14, borderRadius: 14, background: "none", cursor: "pointer" }}>Add to wallet</button>
        <button style={{ flex: 1, background: T.ink, color: "#fff", fontSize: 14, fontWeight: 500, padding: 14, borderRadius: 14, border: "none", cursor: "pointer" }}>Download</button>
      </div>
    </div>
  );
}

function SettingsRow({ icon: Icon, label, danger, last }) {
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 14, padding: "13px 0", borderBottom: last ? "none" : `1px solid ${T.line}` }}>
      <Icon size={18} color={danger ? T.danger : T.ink} strokeWidth={1.5} />
      <div style={{ flex: 1, fontSize: 14, fontWeight: 500, color: danger ? T.danger : T.ink }}>{label}</div>
      {!danger && <span style={{ color: T.faint }}>›</span>}
    </div>
  );
}

function ProfileScreen() {
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 22, flex: 1, overflowY: "auto" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <div style={{ fontSize: 23, fontWeight: 600, letterSpacing: "-0.02em" }}>Profile</div>
        <Settings size={18} color={T.ink} strokeWidth={1.75} />
      </div>

      <div style={{ display: "flex", alignItems: "center", gap: 16 }}>
        <div style={{ width: 52, height: 52, borderRadius: 999, background: T.ink, color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 20, fontWeight: 600 }}>J</div>
        <div style={{ flex: 1 }}><div style={{ fontSize: 16, fontWeight: 600 }}>Jassim S.</div><div style={{ fontSize: 13, color: T.sub, marginTop: 2 }}>+91 98•••••210</div></div>
        <span style={{ fontSize: 13, fontWeight: 500, color: T.primary }}>Edit</span>
      </div>

      <div style={{ borderRadius: 18, border: `1px solid ${T.line}`, padding: 20, position: "relative", overflow: "hidden" }}>
        <div style={{ position: "absolute", right: -18, top: -18, width: 96, height: 96, borderRadius: 999, background: T.tint, opacity: 0.7 }} />
        <div style={{ position: "relative" }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <div style={{ display: "flex", alignItems: "center", gap: 8, fontSize: 13, color: T.sub }}><CreditCard size={16} color={T.sub} strokeWidth={1.5} />Wallet</div>
            <span style={{ fontSize: 12, color: T.primary, fontWeight: 500 }}>History →</span>
          </div>
          <div style={{ fontSize: 28, fontWeight: 600, marginTop: 12, letterSpacing: "-0.01em", fontVariantNumeric: "tabular-nums" }}>₹245.50</div>
          <span style={{ display: "inline-block", marginTop: 14, fontSize: 13, fontWeight: 600, color: T.primary }}>+ Add money</span>
        </div>
      </div>
      <div style={{ marginTop: -10, fontSize: 10.5, color: T.faint }}>Illustration spot (optional) — tiny line-art coin or houseboat motif could sit inside the soft circle behind the balance, top-right of the wallet card</div>

      <div style={{ display: "flex", alignItems: "center", gap: 10, borderRadius: 14, background: T.successBg, padding: "12px 16px" }}>
        <Leaf size={16} color={T.success} strokeWidth={1.75} />
        <span style={{ fontSize: 12.5, color: T.ink }}>You've saved <b style={{ fontVariantNumeric: "tabular-nums" }}>~4.2 kg</b> CO₂ this month by riding the bus</span>
      </div>

      <div>
        <div style={{ fontSize: 15, fontWeight: 600, marginBottom: 4 }}>Saved places</div>
        <SettingsRow icon={HomeIcon} label="Home" />
        <SettingsRow icon={Briefcase} label="Work" />
        <SettingsRow icon={Plus} label="Add new place" last />
      </div>

      <div>
        <div style={{ fontSize: 15, fontWeight: 600, marginBottom: 4 }}>Settings</div>
        <SettingsRow icon={CreditCard} label="Payment methods" />
        <SettingsRow icon={Bell} label="Notifications" />
        <SettingsRow icon={Globe} label="Language" />
        <SettingsRow icon={HelpCircle} label="Help & support" />
        <SettingsRow icon={LogOut} label="Log out" danger last />
      </div>
    </div>
  );
}

export default function GetMyBusApp() {
  const [onboarded, setOnboarded] = useState(false);
  const [tab, setTab] = useState("home");
  const [tracking, setTracking] = useState(false);

  let screen;
  if (!onboarded) screen = <OnboardingScreen onGetStarted={() => setOnboarded(true)} />;
  else if (tab === "home" && tracking) screen = <LiveTrackingScreen onBack={() => setTracking(false)} />;
  else if (tab === "home") screen = <HomeScreen onOpenTracking={() => setTracking(true)} />;
  else if (tab === "search") screen = <RouteSearchScreen onBack={() => setTab("home")} />;
  else if (tab === "tickets") screen = <TicketScreen onBack={() => setTab("home")} />;
  else if (tab === "profile") screen = <ProfileScreen />;
  else screen = <HomeScreen onOpenTracking={() => setTracking(true)} />;

  return (
    <div style={{
      width: 390, height: 844, margin: "0 auto", background: T.bg, fontFamily: T.font,
      color: T.ink, display: "flex", flexDirection: "column", overflow: "hidden",
      borderRadius: 32, border: "1px solid #E5E7EB",
    }}>
      <GlobalKeyframes />
      {screen}
      {onboarded && <BottomNav active={tab} onChange={(k) => { setTab(k); setTracking(false); }} />}
    </div>
  );
}
