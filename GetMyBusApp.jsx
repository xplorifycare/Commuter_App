import { useState } from "react";
import {
  Bell, Search, Ticket as TicketIcon, User, Home as HomeIcon,
  ArrowLeft, RefreshCw, Bus, Clock, MapPin, Compass, Share2,
  CreditCard, Globe, HelpCircle, LogOut, Briefcase, Plus, Settings,
} from "lucide-react";

/* ---------------------------------------------------------------
   GetMyBus — Commuter App
   Matches the design tokens from the GetMyBus handoff doc:
   colors, type scale, spacing, radius. Drop into any React project
   with `lucide-react` installed (npm i lucide-react).
   --------------------------------------------------------------- */

const T = {
  primary: "#2B57FF",
  primaryDark: "#1E3FCC",
  cyan: "#12CBE0",
  orange: "#FF9F45",
  bg: "#F6F8FC",
  card: "#FFFFFF",
  text: "#101828",
  textSecondary: "#667085",
  textMuted: "#98A2B3",
  border: "#EAECF3",
  tint: "#EEF2FF",
  success: "#17B26A",
  successBg: "#E9FBF1",
  danger: "#E4483C",
  font: "'Inter', system-ui, sans-serif",
};

const NAV_ITEMS = [
  { key: "home", label: "Home", icon: HomeIcon },
  { key: "search", label: "Search", icon: Search },
  { key: "tickets", label: "Tickets", icon: TicketIcon },
  { key: "alerts", label: "Alerts", icon: Bell },
  { key: "profile", label: "Profile", icon: User },
];

function BottomNav({ active, onChange }) {
  return (
    <div style={{
      height: 64, background: T.card, borderTop: `1px solid ${T.border}`,
      display: "flex", alignItems: "center", justifyContent: "space-around",
      fontFamily: T.font,
    }}>
      {NAV_ITEMS.map(({ key, label, icon: Icon }) => {
        const isActive = key === active;
        const color = isActive ? T.primary : T.textMuted;
        return (
          <button key={key} onClick={() => onChange(key)}
            style={{
              background: "none", border: "none", cursor: "pointer",
              display: "flex", flexDirection: "column", alignItems: "center", gap: 4,
            }}>
            <Icon size={20} color={color} />
            <span style={{ fontSize: 11, fontWeight: isActive ? 600 : 400, color }}>{label}</span>
          </button>
        );
      })}
    </div>
  );
}

function ScreenHeader({ title, onBack, right }) {
  return (
    <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
      <button aria-label="Back" onClick={onBack} style={{ width: 40, height: 40, border: "none", background: "none", cursor: "pointer" }}>
        <ArrowLeft size={18} color={T.text} />
      </button>
      <div style={{ fontSize: 16, fontWeight: 700 }}>{title}</div>
      <div style={{ width: 40, height: 40, display: "flex", alignItems: "center", justifyContent: "center" }}>{right}</div>
    </div>
  );
}

function HomeScreen({ onOpenTracking }) {
  return (
    <div style={{ padding: "28px 20px 0", display: "flex", flexDirection: "column", gap: 20, flex: 1, overflowY: "auto" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
        <div>
          <div style={{ fontSize: 13, color: T.textSecondary, fontWeight: 500 }}>Good morning</div>
          <div style={{ fontSize: 20, fontWeight: 700, marginTop: 4 }}>Where are you headed?</div>
        </div>
        <button aria-label="Notifications" style={{ width: 44, height: 44, borderRadius: 999, background: T.card, border: `1px solid ${T.border}`, display: "flex", alignItems: "center", justifyContent: "center" }}>
          <Bell size={20} color={T.text} />
        </button>
      </div>

      <div style={{ height: 54, background: T.card, border: `1px solid ${T.border}`, borderRadius: 999, display: "flex", alignItems: "center", padding: "0 20px", gap: 12 }}>
        <Search size={20} color={T.textMuted} />
        <span style={{ fontSize: 14, color: T.textMuted }}>Search a stop, route or destination</span>
      </div>

      <button onClick={onOpenTracking} style={{
        textAlign: "left", border: "none", cursor: "pointer", borderRadius: 20,
        background: `linear-gradient(135deg, ${T.primary}, ${T.primaryDark})`, padding: 20, color: "#fff",
      }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div style={{ display: "flex", alignItems: "center", gap: 6, background: "rgba(255,255,255,0.15)", borderRadius: 999, padding: "5px 12px 5px 8px" }}>
            <span style={{ width: 6, height: 6, borderRadius: 999, background: T.success, display: "inline-block" }} />
            <span style={{ fontSize: 11, fontWeight: 700, letterSpacing: "0.05em" }}>LIVE</span>
          </div>
          <Bus size={22} color="#fff" />
        </div>
        <div style={{ fontSize: 22, fontWeight: 700, marginTop: 16 }}>3 buses near you</div>
        <div style={{ fontSize: 13, opacity: 0.85, marginTop: 6 }}>Route 42, 7B and 12 arrive within 5 minutes</div>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 18 }}>
          <span style={{ fontSize: 14, fontWeight: 600 }}>View live map →</span>
          <span style={{ display: "flex", alignItems: "center", gap: 6, background: "rgba(255,255,255,0.15)", borderRadius: 999, padding: "8px 14px", fontSize: 13, fontWeight: 600 }}>
            <Clock size={12} color="#fff" /> Next: 2 min
          </span>
        </div>
      </button>

      <div style={{ display: "flex", justifyContent: "space-between" }}>
        {[
          { icon: MapPin, label: "Nearby Stops" },
          { icon: Compass, label: "My Routes" },
          { icon: TicketIcon, label: "Tickets" },
        ].map(({ icon: Icon, label }) => (
          <button key={label} style={{ background: "none", border: "none", cursor: "pointer", display: "flex", flexDirection: "column", alignItems: "center", gap: 10, width: 108 }}>
            <div style={{ width: 40, height: 40, borderRadius: 999, background: T.tint, display: "flex", alignItems: "center", justifyContent: "center" }}>
              <Icon size={20} color={T.primary} />
            </div>
            <span style={{ fontSize: 13, fontWeight: 500, color: T.text }}>{label}</span>
          </button>
        ))}
      </div>

      <div>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div style={{ fontSize: 16, fontWeight: 700 }}>Recent trips</div>
          <span style={{ fontSize: 13, color: T.primary, fontWeight: 600 }}>See all</span>
        </div>
        <div style={{ background: T.card, border: `1px solid ${T.border}`, borderRadius: 16, marginTop: 12, overflow: "hidden" }}>
          {[
            { route: "42", from: "Kadappakada → Chinnakada", meta: "Route 42 · 12 min ago", fare: "₹15" },
            { route: "7B", from: "Kollam Bus Stand → Chavara", meta: "Route 7B · Yesterday", fare: "₹22" },
          ].map((trip, i) => (
            <div key={trip.route} style={{ display: "flex", alignItems: "center", gap: 14, padding: 14, borderBottom: i === 0 ? `1px solid ${T.border}` : "none" }}>
              <div style={{ width: 42, height: 42, borderRadius: 12, background: T.tint, display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700, color: T.primary, fontSize: 14 }}>{trip.route}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, fontWeight: 600 }}>{trip.from}</div>
                <div style={{ fontSize: 12, color: T.textSecondary, marginTop: 3 }}>{trip.meta}</div>
              </div>
              <div style={{ fontSize: 14, fontWeight: 600 }}>{trip.fare}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

function LiveTrackingScreen({ onBack }) {
  const stops = [
    { name: "Kollam Bus Stand", meta: "Departed 9:40 AM", state: "done" },
    { name: "Kadappakada", meta: "Departed 9:52 AM", state: "done" },
    { name: "Thattamala", meta: "ETA 10:02 AM", state: "current" },
    { name: "Chinnakada", meta: "ETA 10:11 AM", state: "upcoming" },
  ];
  return (
    <div style={{ padding: "28px 20px 0", display: "flex", flexDirection: "column", gap: 16, flex: 1, overflowY: "auto" }}>
      <ScreenHeader title="Live Tracking" onBack={onBack} right={<RefreshCw size={18} color={T.text} />} />

      <div style={{ height: 220, borderRadius: 20, background: T.tint, position: "relative", border: `1px solid ${T.border}`, display: "flex", alignItems: "center", justifyContent: "center" }}>
        <div style={{ width: 44, height: 44, borderRadius: 999, background: T.primary, display: "flex", alignItems: "center", justifyContent: "center", boxShadow: `0 4px 12px rgba(43,87,255,0.4)` }}>
          <Bus size={20} color="#fff" />
        </div>
      </div>

      <div style={{ background: T.card, border: `1px solid ${T.border}`, borderRadius: 16, padding: 20 }}>
        <div style={{ display: "flex", justifyContent: "space-between" }}>
          <div style={{ display: "flex", alignItems: "center", gap: 14 }}>
            <div style={{ width: 42, height: 42, borderRadius: 12, background: T.tint, display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700, color: T.primary }}>42</div>
            <div>
              <div style={{ fontSize: 15, fontWeight: 600 }}>To Chinnakada</div>
              <div style={{ fontSize: 12, color: T.textSecondary, marginTop: 3 }}>via Kadappakada Rd</div>
            </div>
          </div>
          <div style={{ textAlign: "right" }}>
            <div style={{ fontSize: 20, fontWeight: 700, color: T.primary }}>4 min</div>
            <div style={{ fontSize: 11, color: T.textSecondary }}>1.2 km away</div>
          </div>
        </div>
        <div style={{ display: "flex", alignItems: "center", gap: 10, marginTop: 16 }}>
          <span style={{ fontSize: 13, color: T.textSecondary }}>Crowd level</span>
          <div style={{ display: "flex", gap: 4, flex: 1 }}>
            <span style={{ width: 20, height: 6, borderRadius: 999, background: T.success }} />
            <span style={{ width: 20, height: 6, borderRadius: 999, background: T.success }} />
            <span style={{ width: 20, height: 6, borderRadius: 999, background: T.border }} />
          </div>
          <span style={{ fontSize: 13, fontWeight: 600, color: T.success }}>Low</span>
        </div>
      </div>

      <div>
        <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 14 }}>Route stops</div>
        {stops.map((s, i) => (
          <div key={s.name} style={{ display: "flex", gap: 14 }}>
            <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
              <span style={{
                width: 14, height: 14, borderRadius: 999,
                background: s.state === "upcoming" ? "#fff" : T.primary,
                border: s.state !== "done" ? `2px solid ${T.primary}` : "none",
              }} />
              {i < stops.length - 1 && <span style={{ width: 2, flex: 1, background: T.border, marginTop: 2 }} />}
            </div>
            <div style={{ paddingBottom: i < stops.length - 1 ? 22 : 0 }}>
              <div style={{ fontSize: 14, fontWeight: 600 }}>{s.name}</div>
              <div style={{ fontSize: 12, color: T.textSecondary, marginTop: 2 }}>{s.meta}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function RouteSearchScreen({ onBack }) {
  const routes = [
    { num: "42", time: "9:40 AM → 9:58 AM", meta: "18 min · 4 stops", fare: "₹15", crowd: "Low", crowdColor: T.success, crowdBg: T.successBg },
    { num: "7B", time: "9:45 AM → 10:12 AM", meta: "27 min · 7 stops", fare: "₹22", crowd: "Medium", crowdColor: T.orange, crowdBg: "#FFF4E8" },
    { num: "12", time: "9:52 AM → 10:20 AM", meta: "28 min · 6 stops", fare: "₹18", crowd: "Low", crowdColor: T.success, crowdBg: T.successBg },
  ];
  return (
    <div style={{ padding: "28px 20px 0", display: "flex", flexDirection: "column", gap: 16, flex: 1, overflowY: "auto" }}>
      <ScreenHeader title="Search Routes" onBack={onBack} right={<Settings size={18} color={T.text} />} />

      <div style={{ background: T.card, border: `1px solid ${T.border}`, borderRadius: 16, padding: "16px 18px" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <span style={{ width: 16, height: 16, borderRadius: 999, border: `2px solid ${T.primary}`, flexShrink: 0 }} />
          <div><div style={{ fontSize: 10, color: T.textMuted, fontWeight: 600, letterSpacing: "0.06em" }}>FROM</div><div style={{ fontSize: 15, fontWeight: 600, marginTop: 2 }}>Kollam Bus Stand</div></div>
        </div>
        <div style={{ height: 1, background: T.border, margin: "14px 0 14px 26px" }} />
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <span style={{ width: 10, height: 10, borderRadius: 3, background: T.orange, flexShrink: 0, margin: "0 3px" }} />
          <div><div style={{ fontSize: 10, color: T.textMuted, fontWeight: 600, letterSpacing: "0.06em" }}>TO</div><div style={{ fontSize: 15, fontWeight: 600, marginTop: 2 }}>Chinnakada</div></div>
        </div>
      </div>

      <div style={{ display: "flex", gap: 8, overflowX: "auto" }}>
        {["Fastest", "Cheapest", "Fewest stops", "AC Buses"].map((label, i) => (
          <span key={label} style={{
            background: i === 0 ? T.primary : T.card, color: i === 0 ? "#fff" : T.text,
            border: i === 0 ? "none" : `1px solid ${T.border}`, fontSize: 13, fontWeight: i === 0 ? 600 : 500,
            padding: "8px 16px", borderRadius: 999, whiteSpace: "nowrap",
          }}>{label}</span>
        ))}
      </div>

      <div style={{ display: "flex", justifyContent: "space-between" }}>
        <span style={{ fontSize: 13, fontWeight: 600, color: T.textSecondary }}>6 routes found</span>
        <span style={{ fontSize: 13, fontWeight: 600, color: T.primary }}>Sort: Fastest ▾</span>
      </div>

      <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
        {routes.map((r) => (
          <div key={r.num} style={{ background: T.card, border: `1px solid ${T.border}`, borderRadius: 16, padding: 16 }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
              <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
                <div style={{ width: 40, height: 40, borderRadius: 12, background: T.tint, display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700, color: T.primary }}>{r.num}</div>
                <div><div style={{ fontSize: 14, fontWeight: 600 }}>{r.time}</div><div style={{ fontSize: 12, color: T.textSecondary, marginTop: 2 }}>{r.meta}</div></div>
              </div>
              <div style={{ textAlign: "right" }}><div style={{ fontSize: 16, fontWeight: 700 }}>{r.fare}</div><div style={{ fontSize: 11, color: T.textSecondary }}>per seat</div></div>
            </div>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 16 }}>
              <span style={{ display: "flex", alignItems: "center", gap: 6, background: r.crowdBg, color: r.crowdColor, fontSize: 12, fontWeight: 600, padding: "5px 12px", borderRadius: 999 }}>
                <span style={{ width: 6, height: 6, borderRadius: 999, background: r.crowdColor }} />{r.crowd} crowd
              </span>
              <button style={{ border: `1px solid ${T.primary}`, background: "none", color: T.primary, fontSize: 13, fontWeight: 600, padding: "6px 16px", borderRadius: 999, cursor: "pointer" }}>Track bus</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function TicketScreen({ onBack }) {
  return (
    <div style={{ padding: "28px 20px 0", display: "flex", flexDirection: "column", gap: 16, flex: 1, overflowY: "auto" }}>
      <ScreenHeader title="My Ticket" onBack={onBack} right={<Share2 size={18} color={T.text} />} />

      <div style={{ background: T.card, borderRadius: 20, overflow: "hidden", boxShadow: "0 8px 20px rgba(16,24,40,0.06)" }}>
        <div style={{ background: `linear-gradient(135deg, ${T.primary}, ${T.primaryDark})`, padding: 22, color: "#fff" }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <div style={{ width: 44, height: 44, borderRadius: 12, background: "rgba(255,255,255,0.18)", display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700 }}>42</div>
            <span style={{ background: "rgba(255,255,255,0.2)", fontSize: 11, fontWeight: 700, letterSpacing: "0.05em", padding: "5px 12px", borderRadius: 999 }}>CONFIRMED</span>
          </div>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 22 }}>
            <div><div style={{ fontSize: 22, fontWeight: 700 }}>9:40 AM</div><div style={{ fontSize: 12, opacity: 0.8, marginTop: 4 }}>Kollam Bus Stand</div></div>
            <div style={{ opacity: 0.7 }}>→</div>
            <div style={{ textAlign: "right" }}><div style={{ fontSize: 22, fontWeight: 700 }}>9:58 AM</div><div style={{ fontSize: 12, opacity: 0.8, marginTop: 4 }}>Chinnakada</div></div>
          </div>
          <div style={{ display: "flex", gap: 28, marginTop: 20 }}>
            <div><div style={{ fontSize: 10, opacity: 0.7, fontWeight: 600 }}>DATE</div><div style={{ fontSize: 13, fontWeight: 600, marginTop: 4 }}>26 Sep 2026</div></div>
            <div><div style={{ fontSize: 10, opacity: 0.7, fontWeight: 600 }}>SEAT</div><div style={{ fontSize: 13, fontWeight: 600, marginTop: 4 }}>A14</div></div>
            <div><div style={{ fontSize: 10, opacity: 0.7, fontWeight: 600 }}>BUS NO.</div><div style={{ fontSize: 13, fontWeight: 600, marginTop: 4 }}>KL-23 4521</div></div>
          </div>
        </div>
        <div style={{ padding: 24, display: "flex", flexDirection: "column", alignItems: "center", borderTop: `2px dashed ${T.border}` }}>
          <div style={{ width: 120, height: 120, background: T.text, borderRadius: 12 }} />
          <div style={{ fontSize: 12, color: T.textSecondary, marginTop: 14 }}>Show this QR code to the conductor</div>
          <div style={{ fontSize: 11, color: T.textMuted, marginTop: 4, letterSpacing: "0.04em" }}>TICKET ID GMB-2609-77341</div>
        </div>
      </div>

      <div style={{ background: T.card, border: `1px solid ${T.border}`, borderRadius: 16, padding: 18 }}>
        <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 14 }}>Fare breakdown</div>
        <div style={{ display: "flex", justifyContent: "space-between", fontSize: 14, color: T.textSecondary }}><span>Base fare</span><span style={{ color: T.text }}>₹13.00</span></div>
        <div style={{ display: "flex", justifyContent: "space-between", fontSize: 14, color: T.textSecondary, marginTop: 14 }}><span>Taxes &amp; fees</span><span style={{ color: T.text }}>₹2.00</span></div>
        <div style={{ height: 1, background: T.border, margin: "14px 0" }} />
        <div style={{ display: "flex", justifyContent: "space-between", fontSize: 15, fontWeight: 700 }}><span>Total paid</span><span>₹15.00</span></div>
      </div>

      <div style={{ display: "flex", gap: 12 }}>
        <button style={{ flex: 1, border: `1px solid ${T.border}`, color: T.text, fontSize: 14, fontWeight: 600, padding: 14, borderRadius: 999, background: T.card, cursor: "pointer" }}>+ Add to Wallet</button>
        <button style={{ flex: 1, background: T.primary, color: "#fff", fontSize: 14, fontWeight: 600, padding: 14, borderRadius: 999, border: "none", cursor: "pointer" }}>Download</button>
      </div>
    </div>
  );
}

function SettingsRow({ icon: Icon, label, danger, last, iconBg }) {
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 14, padding: "14px 0", borderBottom: last ? "none" : `1px solid ${T.border}` }}>
      <div style={{ width: 36, height: 36, borderRadius: 999, background: iconBg || T.tint, display: "flex", alignItems: "center", justifyContent: "center" }}>
        <Icon size={16} color={danger ? T.danger : T.primary} />
      </div>
      <div style={{ flex: 1, fontSize: 14, fontWeight: 600, color: danger ? T.danger : T.text }}>{label}</div>
      {!danger && <span style={{ color: T.textMuted }}>›</span>}
    </div>
  );
}

function ProfileScreen() {
  return (
    <div style={{ padding: "28px 20px 0", display: "flex", flexDirection: "column", gap: 18, flex: 1, overflowY: "auto" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <div style={{ fontSize: 22, fontWeight: 700 }}>Profile</div>
        <Settings size={18} color={T.text} />
      </div>

      <div style={{ background: T.card, border: `1px solid ${T.border}`, borderRadius: 16, padding: 18, display: "flex", alignItems: "center", gap: 16 }}>
        <div style={{ width: 56, height: 56, borderRadius: 999, background: T.primary, color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 22, fontWeight: 700 }}>J</div>
        <div style={{ flex: 1 }}><div style={{ fontSize: 16, fontWeight: 700 }}>Jassim S.</div><div style={{ fontSize: 13, color: T.textSecondary, marginTop: 3 }}>+91 98•••••210</div></div>
        <span style={{ border: `1px solid ${T.border}`, fontSize: 12, fontWeight: 600, padding: "8px 16px", borderRadius: 999 }}>Edit</span>
      </div>

      <div style={{ background: `linear-gradient(135deg, ${T.primary}, ${T.primaryDark})`, borderRadius: 16, padding: 20, color: "#fff" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8, fontSize: 13, opacity: 0.85 }}><CreditCard size={16} color="#fff" />GetMyBus Wallet</div>
          <span style={{ fontSize: 12, opacity: 0.85 }}>View history →</span>
        </div>
        <div style={{ fontSize: 30, fontWeight: 700, marginTop: 14 }}>₹245.50</div>
        <span style={{ display: "inline-block", marginTop: 14, background: "rgba(255,255,255,0.18)", fontSize: 13, fontWeight: 600, padding: "9px 18px", borderRadius: 999 }}>+ Add Money</span>
      </div>

      <div>
        <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 6 }}>Saved places</div>
        <div style={{ background: T.card, border: `1px solid ${T.border}`, borderRadius: 16, padding: "0 16px" }}>
          <SettingsRow icon={HomeIcon} label="Home" />
          <SettingsRow icon={Briefcase} label="Work" />
          <SettingsRow icon={Plus} label="Add new place" last />
        </div>
      </div>

      <div>
        <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 6 }}>Settings</div>
        <div style={{ background: T.card, border: `1px solid ${T.border}`, borderRadius: 16, padding: "0 16px" }}>
          <SettingsRow icon={CreditCard} label="Payment methods" />
          <SettingsRow icon={Bell} label="Notifications" />
          <SettingsRow icon={Globe} label="Language" />
          <SettingsRow icon={HelpCircle} label="Help & support" />
          <SettingsRow icon={LogOut} label="Log out" danger last iconBg="#FDECEA" />
        </div>
      </div>
    </div>
  );
}

export default function GetMyBusApp() {
  const [tab, setTab] = useState("home");
  const [tracking, setTracking] = useState(false);

  let screen;
  if (tab === "home" && tracking) screen = <LiveTrackingScreen onBack={() => setTracking(false)} />;
  else if (tab === "home") screen = <HomeScreen onOpenTracking={() => setTracking(true)} />;
  else if (tab === "search") screen = <RouteSearchScreen onBack={() => setTab("home")} />;
  else if (tab === "tickets") screen = <TicketScreen onBack={() => setTab("home")} />;
  else if (tab === "profile") screen = <ProfileScreen />;
  else screen = <HomeScreen onOpenTracking={() => setTracking(true)} />; // alerts placeholder falls back to home

  return (
    <div style={{
      width: 390, height: 844, margin: "0 auto", background: T.bg, fontFamily: T.font,
      color: T.text, display: "flex", flexDirection: "column", overflow: "hidden",
      borderRadius: 32, border: "1px solid #E5E7EB",
    }}>
      {screen}
      <BottomNav active={tab} onChange={(k) => { setTab(k); setTracking(false); }} />
    </div>
  );
}
