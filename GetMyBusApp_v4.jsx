import { useState, useEffect, useMemo, createContext, useContext } from "react";
import {
  Bell, Search, Ticket as TicketIcon, User, Home as HomeIcon,
  ArrowLeft, RefreshCw, Bus, Clock, MapPin, Compass, Share2,
  CreditCard, Globe, HelpCircle, LogOut, Briefcase, Plus, Settings,
  Image as ImageIcon, Leaf, Check, Maximize2, Moon,
} from "lucide-react";

/* ---------------------------------------------------------------
   GetMyBus — Commuter App (v4: backlog pass)
   Built on top of v3. This pass works through the "ideas discussed,
   not yet built" list from the v3 handoff:
     - full-screen boarding mode
     - a real corner-radius scale (RADIUS below)
     - skeleton loading states
     - screen-transition choreography (fade/forward/back)
     - tactile press states (global, via CSS not per-element JS)
     - a purpose-built dark theme (see DARK below)
     - a recurring mascot (see <Mascot/>, used in empty states)
     - an optical-alignment pass on a few icon/text rows
     - hierarchy via weight, not just size, on the smallest labels
   Illustration spots are still left as labeled placeholders.
   Drop into any React project: npm i lucide-react
   --------------------------------------------------------------- */

/* ---------- Design tokens ---------- */

const LIGHT = {
  primary: "#2B57FF",
  primaryDark: "#1E3FCC",
  cyan: "#12CBE0",
  violet: "#8B5CF6",
  orange: "#FF9F45",
  warm: "#C17A54",
  bg: "#FAFBFD",
  surface: "#FFFFFF",
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

/* Dark theme is a rebalance, not a flat invert: blue and terracotta
   both get lifted a step lighter so they still pop on a near-black
   surface, "tint" becomes a raised dark panel instead of a pale
   wash, and success/danger get slightly desaturated so they don't
   vibrate against the dark background. */
const DARK = {
  primary: "#6C8CFF",
  primaryDark: "#98ABFF",
  cyan: "#4FE1EF",
  violet: "#B29CFF",
  orange: "#FFB870",
  warm: "#E0A57C",
  bg: "#0D0F14",
  surface: "#15181F",
  ink: "#F3F4F7",
  sub: "#A0A6B3",
  faint: "#6E7484",
  line: "#242833",
  tint: "#1C2130",
  success: "#3FD98A",
  successBg: "#123024",
  danger: "#FF6E64",
  font: "'Inter', system-ui, sans-serif",
};

const ROUTE_COLORS_LIGHT = { "42": LIGHT.primary, "7B": LIGHT.cyan, "12": LIGHT.violet };
const ROUTE_COLORS_DARK = { "42": DARK.primary, "7B": DARK.cyan, "12": DARK.violet };

/* Corner-radius scale — every rounded rectangle in the app now
   pulls from one of these four values instead of an ad-hoc number.
   Fully round elements (avatars, pills, dots) are exempt on purpose:
   the scale is for rectangular surfaces, not circles. */
const RADIUS = { chip: 8, card: 14, sheet: 20, frame: 28 };

/* Flip during Onam (or another festival window) to swap in themed
   onboarding art and a subtle accent strip — revert once the window
   passes. This is the only place seasonal theming needs to change. */
const SEASONAL_ONAM = false;

const ThemeContext = createContext({
  colors: LIGHT, routes: ROUTE_COLORS_LIGHT, radius: RADIUS, dark: false,
});
function useTheme() {
  return useContext(ThemeContext);
}

/* One-time keyframes + two small global CSS rules, injected once at
   the app root:
     - the motion signatures from v3 (ticket-scan pop, pull-to-refresh
       bus, live pulse ring, dashed-line flow, ETA flip-in)
     - shimmer, for skeleton loading blocks
     - forward/back/fade-scale, for screen-transition choreography
     - a universal tactile press state: every <button> (and anything
       tagged .tap-target) scales down slightly on tap. This is a
       global rule rather than per-element JS so every current and
       future button gets it for free. */
function GlobalKeyframes() {
  return (
    <style>{`
      @keyframes gmb-pop { 0% { transform: scale(0.6); opacity: 0; } 60% { transform: scale(1.08); opacity: 1; } 100% { transform: scale(1); opacity: 1; } }
      @keyframes gmb-bob { 0%, 100% { transform: translateX(0); } 50% { transform: translateX(14px); } }
      @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
      @keyframes gmb-pulse { from { transform: scale(0.6); opacity: 0.9; } to { transform: scale(2); opacity: 0; } }
      @keyframes gmb-flow { from { background-position-y: 0; } to { background-position-y: 12px; } }
      @keyframes gmb-flip { from { transform: translateY(-6px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
      @keyframes gmb-shimmer { 0% { background-position: 100% 0; } 100% { background-position: 0 0; } }
      @keyframes gmb-forward-in { from { transform: translateX(28px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
      @keyframes gmb-back-in { from { transform: translateX(-28px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
      @keyframes gmb-fade-scale-in { from { transform: scale(0.97); opacity: 0; } to { transform: scale(1); opacity: 1; } }
      button, .tap-target { transition: transform 0.12s ease; }
      button:active, .tap-target:active { transform: scale(0.96); }
    `}</style>
  );
}

/* ---------- Small shared primitives ---------- */

function PulseDot({ color, size = 6 }) {
  const { colors: T } = useTheme();
  const c = color || T.success;
  return (
    <span style={{ position: "relative", width: size, height: size, display: "inline-block", flexShrink: 0 }}>
      <span style={{ position: "absolute", inset: 0, borderRadius: 999, background: c }} />
      <span style={{ position: "absolute", inset: -4, borderRadius: 999, border: `1.5px solid ${c}`, animation: "gmb-pulse 1.8s ease-out infinite" }} />
    </span>
  );
}

function NoiseOverlay({ radius = RADIUS.sheet }) {
  return (
    <div style={{
      position: "absolute", inset: 0, borderRadius: radius, pointerEvents: "none",
      opacity: 0.5, mixBlendMode: "overlay",
      backgroundImage: "url(\"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg'><filter id='n'><feTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='2' stitchTiles='stitch'/></filter><rect width='100%25' height='100%25' filter='url(%23n)'/></svg>\")",
    }} />
  );
}

function RouteBadge({ num, size = 38 }) {
  const { routes: ROUTE_COLORS, colors: T, radius: RADIUS } = useTheme();
  const color = ROUTE_COLORS[num] || T.primary;
  return (
    <div style={{
      width: size, height: size, borderRadius: RADIUS.chip,
      background: `${color}1A`, display: "flex", alignItems: "center", justifyContent: "center",
      fontWeight: 600, color, fontSize: size >= 34 ? 13 : 12, flexShrink: 0,
    }}>{num}</div>
  );
}

/* Skeleton block for loading states — replaces the idea of a plain
   spinner for anything that has a known shape (a headline, a card,
   a row) so the layout doesn't jump once real content arrives. */
function Skeleton({ w = "100%", h = 14, radius, style }) {
  const { dark, radius: RADIUS } = useTheme();
  return (
    <div style={{
      width: w, height: h, borderRadius: radius ?? RADIUS.chip,
      backgroundImage: dark
        ? "linear-gradient(100deg, #1C2130 30%, #262C3C 45%, #1C2130 60%)"
        : "linear-gradient(100deg, #EEF0F4 30%, #E2E5EE 45%, #EEF0F4 60%)",
      backgroundSize: "250% 100%",
      animation: "gmb-shimmer 1.3s ease-in-out infinite",
      ...style,
    }} />
  );
}

/* Recurring mascot — the same continuous-stroke line-art character
   (a small friendly bus) reused across every empty/error state so
   the illustration set reads as one hand rather than a one-off. */
function Mascot({ size = 46 }) {
  const { colors: T } = useTheme();
  return (
    <svg width={size} height={size} viewBox="0 0 48 48" fill="none" aria-hidden="true">
      <path
        d="M10 30V16a4 4 0 0 1 4-4h20a4 4 0 0 1 4 4v14M10 30h28M10 30a3 3 0 1 0 6 0M32 30a3 3 0 1 0 6 0M14 22h20M16 12v8M32 12v8M18.5 35.5c1.4 1.3 2.9 1.3 4.3 0M25.2 35.5c1.4 1.3 2.9 1.3 4.3 0"
        stroke={T.warm} strokeWidth={1.75} strokeLinecap="round" strokeLinejoin="round"
      />
    </svg>
  );
}

function ToggleSwitch({ checked, onChange, label }) {
  const { colors: T } = useTheme();
  return (
    <button
      onClick={onChange} aria-pressed={checked} aria-label={label}
      style={{
        width: 42, height: 25, borderRadius: 999, border: "none", cursor: "pointer", padding: 2.5,
        background: checked ? T.primary : T.line, display: "flex",
        justifyContent: checked ? "flex-end" : "flex-start", flexShrink: 0,
      }}
    >
      <span style={{ width: 20, height: 20, borderRadius: 999, background: "#fff", display: "block", boxShadow: "0 1px 3px rgba(0,0,0,0.3)" }} />
    </button>
  );
}

/* Labeled placeholder for a not-yet-generated illustration. */
function IllustrationPlaceholder({ label, height = 160, pulseMarker = false }) {
  const { colors: T, radius: RADIUS } = useTheme();
  return (
    <div style={{
      position: "relative", height, borderRadius: RADIUS.sheet, background: T.tint,
      border: `1.5px dashed ${T.warm}80`,
      display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: 8, padding: "0 20px",
    }}>
      {pulseMarker && (
        <div style={{ position: "absolute", top: 18, right: 22 }}>
          <PulseDot color={T.primary} size={9} />
        </div>
      )}
      <ImageIcon size={20} color={T.warm} strokeWidth={1.75} />
      <span style={{ fontSize: 11, fontWeight: 600, color: T.warm, textAlign: "center" }}>{label}</span>
      <span style={{ fontSize: 9.5, fontWeight: 600, color: `${T.warm}99`, letterSpacing: "0.06em", textTransform: "uppercase" }}>Single continuous stroke · no fill</span>
    </div>
  );
}

function CrowdGauge({ level, color, showLabel = true, size = "md" }) {
  const { colors: T } = useTheme();
  const filled = level === "Low" ? 1 : level === "Medium" ? 2 : 3;
  const barW = size === "sm" ? 14 : 20;
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
      <div style={{ display: "flex", gap: 3 }}>
        {[0, 1, 2].map((i) => (
          <span key={i} style={{ width: barW, height: 4, borderRadius: 999, background: i < filled ? color : T.line }} />
        ))}
      </div>
      {showLabel && <span style={{ fontSize: 12, fontWeight: 500, color }}>{level}</span>}
    </div>
  );
}

function LiveRailChip({ route, eta, crowdColor }) {
  const { colors: T, routes: ROUTE_COLORS, radius: RADIUS } = useTheme();
  const color = ROUTE_COLORS[route] || T.primary;
  return (
    <div style={{
      flexShrink: 0, minWidth: 92, borderRadius: RADIUS.card, border: `1px solid ${T.line}`,
      borderTop: `3px solid ${color}`, padding: "11px 14px 12px", display: "flex", flexDirection: "column", gap: 8,
    }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span style={{ fontSize: 13, fontWeight: 600, color }}>{route}</span>
        <span style={{ width: 5, height: 5, borderRadius: 999, background: crowdColor }} />
      </div>
      <div style={{ fontSize: 17, fontWeight: 600, fontVariantNumeric: "tabular-nums", letterSpacing: "-0.01em", color: T.ink }}>{eta}</div>
      <div style={{ fontSize: 10.5, color: T.faint }}>away</div>
    </div>
  );
}

const NAV_ITEMS = [
  { key: "home", label: "Home", icon: HomeIcon },
  { key: "search", label: "Search", icon: Search },
  { key: "tickets", label: "Tickets", icon: TicketIcon },
  { key: "alerts", label: "Alerts", icon: Bell },
  { key: "profile", label: "Profile", icon: User },
];

/* ---------- Onboarding ---------- */

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
  const { colors: T, radius: RADIUS } = useTheme();
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
        <div style={{ width: 28, height: 28, borderRadius: RADIUS.chip, background: T.primary, display: "flex", alignItems: "center", justifyContent: "center" }}>
          <Bus size={15} color="#fff" strokeWidth={2} />
        </div>
        <span style={{ fontSize: 14, fontWeight: 600, letterSpacing: "-0.01em", color: T.ink }}>GetMyBus</span>
      </div>

      <div
        onClick={() => !last && setI(i + 1)}
        style={{ flex: 1, display: "flex", flexDirection: "column", justifyContent: "center", gap: 28, cursor: last ? "default" : "pointer" }}
      >
        <IllustrationPlaceholder height={280} label={heroIllustration} />
        <div>
          <div style={{ fontSize: 27, fontWeight: 600, letterSpacing: "-0.02em", lineHeight: 1.25, whiteSpace: "pre-line", color: T.ink }}>{slide.headline}</div>
          {/* Malayalam lines are a first pass for tone/authenticity —
              have a native speaker confirm phrasing before shipping. */}
          <div style={{ fontSize: 12.5, color: T.faint, marginTop: 4 }}>{slide.headlineMl}</div>
          <div style={{ fontSize: 14.5, color: T.sub, marginTop: 10, lineHeight: 1.5 }}>{slide.body}</div>
        </div>
        <div style={{ display: "flex", gap: 6 }}>
          {ONBOARDING_SLIDES.map((_, idx) => (
            <span
              key={idx} className="tap-target"
              onClick={(e) => { e.stopPropagation(); setI(idx); }}
              style={{ width: idx === i ? 18 : 4, height: 4, borderRadius: 999, background: idx === i ? T.ink : T.line, cursor: "pointer" }}
            />
          ))}
        </div>
      </div>

      <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
        <button onClick={() => (last ? onGetStarted() : setI(i + 1))} style={{
          background: T.ink, color: T.bg, fontSize: 15, fontWeight: 600, padding: 16,
          borderRadius: RADIUS.card, border: "none", cursor: "pointer",
        }}>{last ? "Get started" : "Next"}</button>
        {!last
          ? <div className="tap-target" onClick={onGetStarted} style={{ textAlign: "center", fontSize: 13, color: T.sub, cursor: "pointer" }}>Skip</div>
          : <div style={{ textAlign: "center", fontSize: 13, color: T.sub }}>Already have an account? <span style={{ color: T.primary, fontWeight: 600 }}>Sign in</span></div>
        }
      </div>
    </div>
  );
}

/* ---------- Nav & header ---------- */

function BottomNav({ active, onChange }) {
  const { colors: T } = useTheme();
  return (
    <div style={{
      margin: "0 18px 18px", padding: "10px 8px", borderRadius: 999,
      background: T.surface, boxShadow: "0 16px 32px -18px rgba(0,0,0,0.35)",
      display: "flex", alignItems: "center", justifyContent: "space-around", fontFamily: T.font,
    }}>
      {NAV_ITEMS.map(({ key, label, icon: Icon }) => {
        const isActive = key === active;
        const color = isActive ? T.ink : T.faint;
        return (
          <button key={key} onClick={() => onChange(key)}
            style={{ background: isActive ? T.tint : "none", border: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center", width: 40, height: 40, borderRadius: 999 }}>
            <Icon size={19} color={color} strokeWidth={isActive ? 2.25 : 1.75} />
          </button>
        );
      })}
    </div>
  );
}

function ScreenHeader({ title, onBack, right }) {
  const { colors: T } = useTheme();
  return (
    <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
      <button aria-label="Back" onClick={onBack} style={{ width: 36, height: 36, border: "none", background: "none", cursor: "pointer", marginLeft: -8 }}>
        <ArrowLeft size={19} color={T.ink} strokeWidth={1.75} />
      </button>
      <div style={{ fontSize: 16, fontWeight: 600, letterSpacing: "-0.01em", color: T.ink }}>{title}</div>
      <div style={{ width: 36, height: 36, display: "flex", alignItems: "center", justifyContent: "center" }}>{right}</div>
    </div>
  );
}

/* Empty state for the Home live rail during off-hours — now carries
   the recurring mascot instead of a generic image icon. */
function NoBusesState() {
  const { colors: T, radius: RADIUS } = useTheme();
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 14, borderRadius: RADIUS.card, border: `1px dashed ${T.line}`, padding: "16px 16px" }}>
      <div style={{ width: 52, height: 52, borderRadius: RADIUS.chip, background: T.tint, flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "center" }}>
        <Mascot size={34} />
      </div>
      <div>
        <div style={{ fontSize: 13.5, fontWeight: 600, color: T.ink }}>No live buses right now</div>
        <div style={{ fontSize: 12, color: T.sub, marginTop: 2 }}>Service resumes 5:30 AM</div>
      </div>
    </div>
  );
}

/* ---------- Skeletons ---------- */

function HomeSkeleton() {
  const { radius: RADIUS } = useTheme();
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 26, flex: 1 }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
        <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
          <Skeleton w={92} h={12} />
          <Skeleton w={150} h={22} radius={6} />
        </div>
        <Skeleton w={20} h={20} radius={999} />
      </div>
      <Skeleton h={50} radius={RADIUS.card} />
      <Skeleton h={190} radius={RADIUS.sheet} />
      <div style={{ display: "flex", justifyContent: "space-between", gap: 12 }}>
        <Skeleton h={54} radius={RADIUS.card} />
        <Skeleton h={54} radius={RADIUS.card} />
        <Skeleton h={54} radius={RADIUS.card} />
      </div>
      <Skeleton h={92} radius={RADIUS.card} />
      <Skeleton h={80} radius={RADIUS.sheet} />
    </div>
  );
}

function SearchResultsSkeleton() {
  const { radius: RADIUS } = useTheme();
  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 18 }}>
      {[0, 1, 2].map((i) => (
        <div key={i} style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
            <Skeleton w={38} h={38} radius={RADIUS.chip} />
            <div style={{ display: "flex", flexDirection: "column", gap: 6, flex: 1 }}>
              <Skeleton w="60%" h={13} />
              <Skeleton w="40%" h={11} />
            </div>
            <Skeleton w={40} h={15} />
          </div>
        </div>
      ))}
    </div>
  );
}

/* ---------- Home ---------- */

function HomeScreen({ onOpenTracking }) {
  const { colors: T, radius: RADIUS } = useTheme();
  const [noBuses, setNoBuses] = useState(false);
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 26, flex: 1, overflowY: "auto" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
        <div>
          <div style={{ fontSize: 13, color: T.sub }}>Good morning</div>
          <div style={{ fontSize: 23, fontWeight: 600, marginTop: 3, letterSpacing: "-0.02em", color: T.ink }}>Where to?</div>
          <div style={{ fontSize: 12.5, color: T.faint, marginTop: 2 }}>എവിടേക്ക്?</div>
        </div>
        <button aria-label="Notifications" style={{ width: 20, height: 20, border: "none", background: "none", cursor: "pointer", marginTop: 6 }}>
          <Bell size={20} color={T.ink} strokeWidth={1.75} />
        </button>
      </div>

      <div style={{ height: 50, background: T.tint, borderRadius: RADIUS.card, display: "flex", alignItems: "center", padding: "0 18px", gap: 10 }}>
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
              <PulseDot color={T.success} size={6} />
              <span style={{ fontSize: 11, fontWeight: 600, color: T.success, letterSpacing: "0.02em" }}>Live</span>
            </div>
            <div style={{ fontSize: 17, fontWeight: 600, marginTop: 4, letterSpacing: "-0.01em", color: T.ink }}>3 buses near you</div>
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
          <div style={{ fontSize: 15, fontWeight: 600, color: T.ink }}>Live near you</div>
          <span className="tap-target" onClick={() => setNoBuses(!noBuses)} style={{ fontSize: 11, color: T.faint, cursor: "pointer", textDecoration: "underline" }}>
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
        position: "relative", overflow: "hidden",
        display: "flex", alignItems: "center", gap: 14, borderRadius: RADIUS.sheet,
        background: `linear-gradient(135deg, ${T.warm}, #A65E3D)`,
        boxShadow: "0 20px 36px -22px rgba(193,122,84,0.55)",
        padding: "16px 18px",
      }}>
        <NoiseOverlay radius={RADIUS.sheet} />
        <div style={{ width: 44, height: 44, borderRadius: RADIUS.chip, background: "rgba(255,255,255,0.18)", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "center" }}>
          <ImageIcon size={18} color="#fff" strokeWidth={1.75} />
        </div>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 13, fontWeight: 600, color: "#fff" }}>2 trips to your free ride</div>
          <div style={{ fontSize: 11.5, color: "rgba(255,255,255,0.82)", marginTop: 2 }}>Illustration — line-art bus crossing a small finish flag, milestone reward banner</div>
        </div>
      </div>

      <div>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline" }}>
          <div style={{ fontSize: 15, fontWeight: 600, color: T.ink }}>Recent trips</div>
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
                <div style={{ fontSize: 14, fontWeight: 500, color: T.ink }}>{trip.from}</div>
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

/* ---------- Live tracking ---------- */

function LiveTrackingScreen({ onBack }) {
  const { colors: T, radius: RADIUS } = useTheme();
  const [refreshing, setRefreshing] = useState(false);
  const [eta, setEta] = useState(4);
  const [etaKey, setEtaKey] = useState(0);
  const doRefresh = () => {
    setRefreshing(true);
    setTimeout(() => {
      setRefreshing(false);
      setEta((e) => Math.max(2, e - 1));
      setEtaKey((k) => k + 1);
    }, 900);
  };
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

      <IllustrationPlaceholder label="Illustration — live map with bus route and marker" height={200} pulseMarker />

      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <RouteBadge num="42" />
          <div>
            <div style={{ fontSize: 15, fontWeight: 600, color: T.ink }}>To Chinnakada</div>
            <div style={{ fontSize: 12.5, color: T.sub, marginTop: 2 }}>via Kadappakada Rd</div>
          </div>
        </div>
        <div style={{ textAlign: "right", overflow: "hidden" }}>
          <div key={etaKey} style={{ fontSize: 19, fontWeight: 600, color: T.primary, fontVariantNumeric: "tabular-nums", animation: "gmb-flip 0.3s ease-out" }}>{eta} min</div>
          <div style={{ fontSize: 11.5, color: T.faint }}>1.2 km away</div>
        </div>
      </div>

      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
        <span style={{ fontSize: 13, color: T.sub }}>Crowd level</span>
        <CrowdGauge level="Low" color={T.success} />
      </div>

      <div>
        <div style={{ fontSize: 15, fontWeight: 600, marginBottom: 16, color: T.ink }}>Route stops</div>
        {stops.map((s, i) => (
          <div key={s.name} style={{ display: "flex", gap: 14 }}>
            <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
              <span style={{
                width: 9, height: 9, borderRadius: 999,
                background: s.state === "upcoming" ? T.surface : T.primary,
                border: s.state !== "done" ? `2px solid ${T.primary}` : "none",
              }} />
              {i < stops.length - 1 && (
                <span style={{
                  width: 1, flex: 1, marginTop: 3,
                  ...(s.state === "current"
                    ? {
                        backgroundImage: `repeating-linear-gradient(to bottom, ${T.primary} 0, ${T.primary} 4px, transparent 4px, transparent 9px)`,
                        backgroundSize: "1px 18px",
                        animation: "gmb-flow 0.8s linear infinite",
                      }
                    : { background: T.line }),
                }} />
              )}
            </div>
            <div style={{ paddingBottom: i < stops.length - 1 ? 22 : 0 }}>
              <div style={{ fontSize: 14, fontWeight: 500, color: T.ink }}>{s.name}</div>
              <div style={{ fontSize: 12, color: T.faint, marginTop: 2 }}>{s.meta}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

/* ---------- Search ---------- */

function RouteSearchScreen({ onBack }) {
  const { colors: T, radius: RADIUS } = useTheme();
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    const t = setTimeout(() => setLoading(false), 550);
    return () => clearTimeout(t);
  }, []);
  const routes = [
    { num: "42", time: "9:40 → 9:58 AM", meta: "18 min · 4 stops", fare: "₹15", crowd: "Low", crowdColor: T.success },
    { num: "7B", time: "9:45 → 10:12 AM", meta: "27 min · 7 stops", fare: "₹22", crowd: "Medium", crowdColor: T.orange },
    { num: "12", time: "9:52 → 10:20 AM", meta: "28 min · 6 stops", fare: "₹18", crowd: "Low", crowdColor: T.success },
  ];
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 20, flex: 1, overflowY: "auto" }}>
      <ScreenHeader title="Search routes" onBack={onBack} right={<Settings size={18} color={T.ink} strokeWidth={1.75} />} />

      <IllustrationPlaceholder label="Illustration — minimal single-line bus stop signpost with a faint coconut-palm silhouette, Kerala touch" height={120} />

      <div style={{ background: T.tint, borderRadius: RADIUS.card, padding: "14px 18px" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <span style={{ width: 8, height: 8, borderRadius: 999, border: `2px solid ${T.primary}`, flexShrink: 0 }} />
          {/* hierarchy pass: these tiny caption labels lean on weight
              + faint color rather than shrinking further, so they
              stay legible next to the value line below them */}
          <div><div style={{ fontSize: 11, fontWeight: 600, color: T.faint }}>From</div><div style={{ fontSize: 14.5, fontWeight: 500, marginTop: 1, color: T.ink }}>Kollam Bus Stand</div></div>
        </div>
        <div style={{ height: 1, background: T.line, margin: "12px 0 12px 4px" }} />
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <span style={{ width: 8, height: 8, borderRadius: 2, background: T.warm, flexShrink: 0 }} />
          <div><div style={{ fontSize: 11, fontWeight: 600, color: T.faint }}>To</div><div style={{ fontSize: 14.5, fontWeight: 500, marginTop: 1, color: T.ink }}>Chinnakada</div></div>
        </div>
      </div>

      <div style={{ display: "flex", gap: 20, overflowX: "auto" }}>
        {["Fastest", "Cheapest", "Fewest stops", "AC Buses"].map((label, i) => (
          <span key={label} style={{ fontSize: 13.5, fontWeight: i === 0 ? 600 : 500, color: i === 0 ? T.ink : T.sub, whiteSpace: "nowrap", borderBottom: i === 0 ? `2px solid ${T.ink}` : "2px solid transparent", paddingBottom: 6 }}>{label}</span>
        ))}
      </div>

      <div style={{ display: "flex", justifyContent: "space-between" }}>
        <span style={{ fontSize: 12.5, color: T.sub }}>6 routes found</span>
        <span style={{ fontSize: 12.5, fontWeight: 600, color: T.ink }}>Sort: Fastest ▾</span>
      </div>

      {loading ? <SearchResultsSkeleton /> : (
        <div>
          {routes.map((r, i) => (
            <div key={r.num} style={{ padding: "16px 0", borderTop: i === 0 ? "none" : `1px solid ${T.line}` }}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
                  <RouteBadge num={r.num} />
                  <div><div style={{ fontSize: 14, fontWeight: 500, color: T.ink }}>{r.time}</div><div style={{ fontSize: 12, color: T.faint, marginTop: 2 }}>{r.meta}</div></div>
                </div>
                <div style={{ textAlign: "right" }}><div style={{ fontSize: 15, fontWeight: 600, color: T.ink }}>{r.fare}</div><div style={{ fontSize: 11, color: T.faint }}>per seat</div></div>
              </div>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 12 }}>
                <CrowdGauge level={r.crowd} color={r.crowdColor} size="sm" />
                <button style={{ border: "none", background: "none", color: T.primary, fontSize: 13, fontWeight: 600, cursor: "pointer", padding: 0 }}>Track bus →</button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

/* ---------- Boarding mode ---------- */

/* Full-screen takeover: tapping the "expand" affordance on the
   ticket dims and blurs everything behind it and blows the QR up to
   arm's-length size, rather than morphing the code in place. Tapping
   the code itself still plays the scan-confirmation animation. */
function BoardingModeOverlay({ ticketId, onClose }) {
  const { colors: T, radius: RADIUS } = useTheme();
  const [scanned, setScanned] = useState(false);
  const confirm = (e) => {
    e.stopPropagation();
    setScanned(true);
    setTimeout(() => { setScanned(false); onClose(); }, 1400);
  };
  return (
    <div
      onClick={onClose}
      style={{
        position: "absolute", inset: 0, zIndex: 50,
        background: "rgba(8,9,14,0.74)", backdropFilter: "blur(8px)", WebkitBackdropFilter: "blur(8px)",
        display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: 20,
        animation: "gmb-fade-scale-in 0.28s ease-out",
      }}
    >
      <div
        onClick={confirm}
        style={{
          width: 224, height: 224, background: "#fff", borderRadius: RADIUS.sheet,
          display: "flex", alignItems: "center", justifyContent: "center", position: "relative", cursor: "pointer",
          boxShadow: "0 30px 60px -20px rgba(0,0,0,0.5)",
        }}
      >
        <div style={{ width: 184, height: 184, background: T.ink, borderRadius: RADIUS.card }} />
        {scanned && (
          <div style={{ position: "absolute", inset: 10, borderRadius: RADIUS.card, background: T.success, display: "flex", alignItems: "center", justifyContent: "center", animation: "gmb-pop 0.35s ease-out" }}>
            <Check size={58} color="#fff" strokeWidth={2.5} />
          </div>
        )}
      </div>
      <div style={{ color: "#fff", fontSize: 13.5, fontWeight: 600 }}>
        {scanned ? "Boarding confirmed" : "Show this to the conductor"}
      </div>
      <div style={{ color: "rgba(255,255,255,0.72)", fontSize: 11.5, fontFamily: "'IBM Plex Mono', ui-monospace, monospace", letterSpacing: "0.04em" }}>{ticketId}</div>
      <div style={{ color: "rgba(255,255,255,0.48)", fontSize: 11, marginTop: 12 }}>Tap anywhere to close</div>
    </div>
  );
}

/* ---------- Ticket ---------- */

function TicketScreen({ onBack, onOpenBoarding }) {
  const { colors: T, radius: RADIUS } = useTheme();
  const [scanned, setScanned] = useState(false);
  const simulateScan = () => { setScanned(true); setTimeout(() => setScanned(false), 1600); };
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 22, flex: 1, overflowY: "auto" }}>
      <ScreenHeader title="My ticket" onBack={onBack} right={<Share2 size={18} color={T.ink} strokeWidth={1.75} />} />

      <IllustrationPlaceholder label="Illustration — commuter holding a confirmed bus ticket" height={150} />

      {/* The one elevated surface on this screen — everything else on
          the app stays flat/hairline, so this card's shadow reads as
          meaningful rather than decorative. */}
      <div style={{ background: T.surface, borderRadius: RADIUS.sheet, padding: 22, boxShadow: "0 28px 52px -30px rgba(0,0,0,0.35)", position: "relative", overflow: "hidden" }}>
        <div>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <RouteBadge num="42" />
            <span style={{ fontSize: 11, fontWeight: 600, color: T.success, letterSpacing: "0.02em" }}>Confirmed</span>
          </div>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 18 }}>
            <div><div style={{ fontSize: 20, fontWeight: 600, fontVariantNumeric: "tabular-nums", color: T.ink }}>9:40 AM</div><div style={{ fontSize: 12, color: T.faint, marginTop: 3 }}>Kollam Bus Stand</div></div>
            <div style={{ color: T.faint }}>→</div>
            <div style={{ textAlign: "right" }}><div style={{ fontSize: 20, fontWeight: 600, fontVariantNumeric: "tabular-nums", color: T.ink }}>9:58 AM</div><div style={{ fontSize: 12, color: T.faint, marginTop: 3 }}>Chinnakada</div></div>
          </div>
          <div style={{ display: "flex", gap: 28, marginTop: 20, paddingTop: 18, borderTop: `1px solid ${T.line}` }}>
            <div><div style={{ fontSize: 11, fontWeight: 600, color: T.faint }}>Date</div><div style={{ fontSize: 13, fontWeight: 500, marginTop: 3, color: T.ink }}>26 Sep 2026</div></div>
            <div><div style={{ fontSize: 11, fontWeight: 600, color: T.faint }}>Seat</div><div style={{ fontSize: 13, fontWeight: 500, marginTop: 3, color: T.ink }}>A14</div></div>
            <div><div style={{ fontSize: 11, fontWeight: 600, color: T.faint }}>Bus no.</div><div style={{ fontSize: 13, fontWeight: 500, marginTop: 3, color: T.ink }}>KL-23 4521</div></div>
          </div>
        </div>

        {/* Boarding-pass style tear: perforated notches cut into the
            card edges either side of the dashed line, like an airline stub. */}
        <div style={{ position: "relative" }}>
          <div style={{ position: "absolute", left: -22, top: "50%", transform: "translateY(-50%)", width: 20, height: 20, borderRadius: 999, background: T.bg, border: `1px solid ${T.line}` }} />
          <div style={{ position: "absolute", right: -22, top: "50%", transform: "translateY(-50%)", width: 20, height: 20, borderRadius: 999, background: T.bg, border: `1px solid ${T.line}` }} />
          <div style={{ display: "flex", flexDirection: "column", alignItems: "center", padding: "22px 0", borderTop: `1.5px dashed ${T.line}`, borderBottom: `1.5px dashed ${T.line}` }}>
            <div onClick={simulateScan} style={{ width: 108, height: 108, background: T.ink, borderRadius: RADIUS.card, cursor: "pointer", position: "relative", display: "flex", alignItems: "center", justifyContent: "center" }}>
              {scanned && (
                <div style={{ position: "absolute", inset: 0, borderRadius: RADIUS.card, background: T.success, display: "flex", alignItems: "center", justifyContent: "center", animation: "gmb-pop 0.35s ease-out" }}>
                  <Check size={44} color="#fff" strokeWidth={2.5} />
                </div>
              )}
            </div>
            <div style={{ fontSize: 12, color: T.sub, marginTop: 14 }}>{scanned ? "Boarding confirmed" : "Show this code to the conductor"}</div>
            <div style={{ fontSize: 11, color: T.faint, marginTop: 4, fontFamily: "'IBM Plex Mono', ui-monospace, monospace", letterSpacing: "0.04em" }}>GMB-2609-77341</div>
            <button className="tap-target" onClick={onOpenBoarding} style={{
              display: "flex", alignItems: "center", gap: 6, marginTop: 10, border: "none", background: "none",
              color: T.primary, fontSize: 11.5, fontWeight: 600, cursor: "pointer", padding: 0,
            }}>
              <Maximize2 size={12} strokeWidth={2} />Full screen for boarding
            </button>
          </div>
        </div>

        <div style={{ marginTop: 20 }}>
          <div style={{ display: "flex", justifyContent: "space-between", fontSize: 14, color: T.sub }}><span>Base fare</span><span style={{ color: T.ink }}>₹13.00</span></div>
          <div style={{ display: "flex", justifyContent: "space-between", fontSize: 14, color: T.sub, marginTop: 12 }}><span>Taxes &amp; fees</span><span style={{ color: T.ink }}>₹2.00</span></div>
          <div style={{ display: "flex", justifyContent: "space-between", fontSize: 15, fontWeight: 600, marginTop: 16, paddingTop: 16, borderTop: `1px solid ${T.line}`, color: T.ink }}><span>Total paid</span><span style={{ fontVariantNumeric: "tabular-nums" }}>₹15.00</span></div>
        </div>
      </div>

      {/* Shareable trip card. */}
      <div>
        <div style={{ fontSize: 13, fontWeight: 600, marginBottom: 10, color: T.ink }}>Share this trip</div>
        <div style={{
          position: "relative", overflow: "hidden", borderRadius: RADIUS.card, padding: 18, color: "#fff",
          background: `linear-gradient(135deg, ${T.primary}, ${T.primaryDark})`,
        }}>
          <NoiseOverlay radius={RADIUS.card} />
          <div style={{ fontSize: 11, opacity: 0.75, letterSpacing: "0.04em" }}>GETMYBUS</div>
          <div style={{ fontSize: 16, fontWeight: 600, marginTop: 8 }}>Kollam → Chinnakada</div>
          <div style={{ fontSize: 12.5, opacity: 0.85, marginTop: 3 }}>Route 42 · 18 min · on time</div>
        </div>
        <button style={{
          width: "100%", marginTop: 10, display: "flex", alignItems: "center", justifyContent: "center", gap: 8,
          background: "#25D366", color: "#fff", fontSize: 14, fontWeight: 600, padding: 13, borderRadius: RADIUS.card, border: "none", cursor: "pointer",
        }}><Share2 size={16} strokeWidth={2} />Share to WhatsApp</button>
      </div>

      <div style={{ display: "flex", gap: 12 }}>
        <button style={{ flex: 1, border: `1px solid ${T.line}`, color: T.ink, fontSize: 14, fontWeight: 500, padding: 14, borderRadius: RADIUS.card, background: "none", cursor: "pointer" }}>Add to wallet</button>
        <button style={{ flex: 1, background: T.ink, color: T.bg, fontSize: 14, fontWeight: 500, padding: 14, borderRadius: RADIUS.card, border: "none", cursor: "pointer" }}>Download</button>
      </div>
    </div>
  );
}

/* ---------- Profile ---------- */

function SettingsRow({ icon: Icon, label, danger, last, right }) {
  const { colors: T } = useTheme();
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 14, padding: "13px 0", borderBottom: last ? "none" : `1px solid ${T.line}` }}>
      {/* optical alignment pass: lucide icons sit a touch high next
          to 14px text, so nudge them down half a pixel here */}
      <Icon size={18} color={danger ? T.danger : T.ink} strokeWidth={1.5} style={{ position: "relative", top: 0.5 }} />
      <div style={{ flex: 1, fontSize: 14, fontWeight: 500, color: danger ? T.danger : T.ink }}>{label}</div>
      {right ?? (!danger && <span style={{ color: T.faint }}>›</span>)}
    </div>
  );
}

function ProfileScreen({ dark, onToggleDark }) {
  const { colors: T, radius: RADIUS } = useTheme();
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 22, flex: 1, overflowY: "auto" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <div style={{ fontSize: 23, fontWeight: 600, letterSpacing: "-0.02em", color: T.ink }}>Profile</div>
        <Settings size={18} color={T.ink} strokeWidth={1.75} />
      </div>

      <div style={{ display: "flex", alignItems: "center", gap: 16 }}>
        <div style={{ width: 52, height: 52, borderRadius: 999, background: T.ink, color: T.bg, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 20, fontWeight: 600 }}>J</div>
        <div style={{ flex: 1 }}><div style={{ fontSize: 16, fontWeight: 600, color: T.ink }}>Jassim S.</div><div style={{ fontSize: 13, color: T.sub, marginTop: 2 }}>+91 98•••••210</div></div>
        <span style={{ fontSize: 13, fontWeight: 500, color: T.primary }}>Edit</span>
      </div>

      <div style={{ borderRadius: RADIUS.card, border: `1px solid ${T.line}`, padding: 20, position: "relative", overflow: "hidden" }}>
        <div style={{ position: "absolute", right: -18, top: -18, width: 96, height: 96, borderRadius: 999, background: T.tint, opacity: 0.7 }} />
        <div style={{ position: "relative" }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <div style={{ display: "flex", alignItems: "center", gap: 8, fontSize: 13, color: T.sub }}>
              <CreditCard size={16} color={T.sub} strokeWidth={1.5} style={{ position: "relative", top: 0.5 }} />Wallet
            </div>
            <span style={{ fontSize: 12, color: T.primary, fontWeight: 500 }}>History →</span>
          </div>
          <div style={{ fontSize: 28, fontWeight: 600, marginTop: 12, letterSpacing: "-0.01em", fontVariantNumeric: "tabular-nums", color: T.ink }}>₹245.50</div>
          <span style={{ display: "inline-block", marginTop: 14, fontSize: 13, fontWeight: 600, color: T.primary }}>+ Add money</span>
        </div>
      </div>
      <div style={{ marginTop: -10, fontSize: 10.5, color: T.faint }}>Illustration spot (optional) — tiny line-art coin or houseboat motif could sit inside the soft circle behind the balance, top-right of the wallet card</div>

      <div style={{ display: "flex", alignItems: "center", gap: 10, borderRadius: RADIUS.card, background: T.successBg, padding: "12px 16px" }}>
        <Leaf size={16} color={T.success} strokeWidth={1.75} style={{ position: "relative", top: 0.5 }} />
        <span style={{ fontSize: 12.5, color: T.ink }}>You've saved <b style={{ fontVariantNumeric: "tabular-nums" }}>~4.2 kg</b> CO₂ this month by riding the bus</span>
      </div>

      <div>
        <div style={{ fontSize: 15, fontWeight: 600, marginBottom: 4, color: T.ink }}>Saved places</div>
        <SettingsRow icon={HomeIcon} label="Home" />
        <SettingsRow icon={Briefcase} label="Work" />
        <SettingsRow icon={Plus} label="Add new place" last />
      </div>

      <div>
        <div style={{ fontSize: 15, fontWeight: 600, marginBottom: 4, color: T.ink }}>Settings</div>
        <SettingsRow
          icon={Moon} label="Dark theme"
          right={<ToggleSwitch checked={dark} onChange={onToggleDark} label="Dark theme" />}
        />
        <SettingsRow icon={CreditCard} label="Payment methods" />
        <SettingsRow icon={Bell} label="Notifications" />
        <SettingsRow icon={Globe} label="Language" />
        <SettingsRow icon={HelpCircle} label="Help & support" />
        <SettingsRow icon={LogOut} label="Log out" danger last />
      </div>
    </div>
  );
}

/* ---------- Root ---------- */

export default function GetMyBusApp() {
  const [dark, setDark] = useState(false);
  const [onboarded, setOnboarded] = useState(false);
  const [tab, setTab] = useState("home");
  const [tracking, setTracking] = useState(false);
  const [boarding, setBoarding] = useState(false);
  const [navAnim, setNavAnim] = useState("fade");
  const [homeLoading, setHomeLoading] = useState(false);

  // Skeleton loading: on entering the app for the first time, show a
  // Home skeleton briefly rather than popping content in instantly.
  useEffect(() => {
    if (onboarded) {
      setHomeLoading(true);
      const t = setTimeout(() => setHomeLoading(false), 700);
      return () => clearTimeout(t);
    }
  }, [onboarded]);

  const theme = useMemo(() => ({
    colors: dark ? DARK : LIGHT,
    routes: dark ? ROUTE_COLORS_DARK : ROUTE_COLORS_LIGHT,
    radius: RADIUS,
    dark,
  }), [dark]);

  const goTab = (k) => { setTab(k); setTracking(false); setBoarding(false); setNavAnim("fade"); };
  const openTracking = () => { setTracking(true); setNavAnim("forward"); };
  const backFromTracking = () => { setTracking(false); setNavAnim("back"); };
  const backToHome = () => { setTab("home"); setNavAnim("back"); };

  let screen;
  if (!onboarded) screen = <OnboardingScreen onGetStarted={() => { setOnboarded(true); setNavAnim("fade"); }} />;
  else if (tab === "home" && tracking) screen = <LiveTrackingScreen onBack={backFromTracking} />;
  else if (tab === "home") screen = homeLoading ? <HomeSkeleton /> : <HomeScreen onOpenTracking={openTracking} />;
  else if (tab === "search") screen = <RouteSearchScreen onBack={backToHome} />;
  else if (tab === "tickets") screen = <TicketScreen onBack={backToHome} onOpenBoarding={() => setBoarding(true)} />;
  else if (tab === "profile") screen = <ProfileScreen dark={dark} onToggleDark={() => setDark((d) => !d)} />;
  else screen = <HomeScreen onOpenTracking={openTracking} />;

  // Screen-transition choreography: tab switches cross-fade + scale;
  // pushing into Live tracking slides in from the right; backing out
  // (the header's back arrow, or closing tracking) slides in from
  // the left. Keying the wrapper on the navigation event forces the
  // animation to replay on every transition.
  const animName = navAnim === "forward" ? "gmb-forward-in" : navAnim === "back" ? "gmb-back-in" : "gmb-fade-scale-in";
  const screenKey = `${onboarded}-${tab}-${tracking}`;

  return (
    <ThemeContext.Provider value={theme}>
      <div style={{
        width: 390, height: 844, margin: "0 auto", background: theme.colors.bg, fontFamily: LIGHT.font,
        color: theme.colors.ink, display: "flex", flexDirection: "column", overflow: "hidden",
        borderRadius: RADIUS.frame, border: `1px solid ${theme.colors.line}`, position: "relative",
      }}>
        <GlobalKeyframes />
        <div key={screenKey} style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden", animation: `${animName} 0.32s cubic-bezier(0.22,1,0.36,1)` }}>
          {screen}
        </div>
        {onboarded && !boarding && <BottomNav active={tab} onChange={goTab} />}
        {boarding && (
          <BoardingModeOverlay ticketId="GMB-2609-77341" onClose={() => setBoarding(false)} />
        )}
      </div>
    </ThemeContext.Provider>
  );
}
