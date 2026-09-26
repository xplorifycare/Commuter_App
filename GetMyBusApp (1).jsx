import { useState } from "react";
import {
  Bell, Search, Ticket as TicketIcon, User, Home as HomeIcon,
  ArrowLeft, RefreshCw, Bus, Clock, MapPin, Compass, Share2,
  CreditCard, Globe, HelpCircle, LogOut, Briefcase, Plus, Settings,
  Image as ImageIcon,
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

function HomeScreen({ onOpenTracking }) {
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 26, flex: 1, overflowY: "auto" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
        <div>
          <div style={{ fontSize: 13, color: T.sub }}>Good morning</div>
          <div style={{ fontSize: 23, fontWeight: 600, marginTop: 3, letterSpacing: "-0.02em" }}>Where to?</div>
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
              <div style={{ width: 38, height: 38, borderRadius: 12, background: T.tint, display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 600, color: T.primary, fontSize: 13 }}>{trip.route}</div>
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
  const stops = [
    { name: "Kollam Bus Stand", meta: "Departed 9:40 AM", state: "done" },
    { name: "Kadappakada", meta: "Departed 9:52 AM", state: "done" },
    { name: "Thattamala", meta: "ETA 10:02 AM", state: "current" },
    { name: "Chinnakada", meta: "ETA 10:11 AM", state: "upcoming" },
  ];
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 22, flex: 1, overflowY: "auto" }}>
      <ScreenHeader title="Live tracking" onBack={onBack} right={<RefreshCw size={18} color={T.ink} strokeWidth={1.75} />} />

      <IllustrationPlaceholder label="Illustration — live map with bus route and marker" height={200} />

      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <div style={{ width: 38, height: 38, borderRadius: 12, background: T.tint, display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 600, color: T.primary, fontSize: 13 }}>42</div>
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

      <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
        <span style={{ fontSize: 13, color: T.sub }}>Crowd level</span>
        <div style={{ display: "flex", gap: 4, flex: 1 }}>
          <span style={{ width: 20, height: 5, borderRadius: 999, background: T.success }} />
          <span style={{ width: 20, height: 5, borderRadius: 999, background: T.success }} />
          <span style={{ width: 20, height: 5, borderRadius: 999, background: T.line }} />
        </div>
        <span style={{ fontSize: 13, fontWeight: 600, color: T.success }}>Low</span>
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
                <div style={{ width: 38, height: 38, borderRadius: 12, background: T.tint, display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 600, color: T.primary, fontSize: 13 }}>{r.num}</div>
                <div><div style={{ fontSize: 14, fontWeight: 500 }}>{r.time}</div><div style={{ fontSize: 12, color: T.faint, marginTop: 2 }}>{r.meta}</div></div>
              </div>
              <div style={{ textAlign: "right" }}><div style={{ fontSize: 15, fontWeight: 600 }}>{r.fare}</div><div style={{ fontSize: 11, color: T.faint }}>per seat</div></div>
            </div>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 12 }}>
              <span style={{ display: "flex", alignItems: "center", gap: 6, fontSize: 12, color: r.crowdColor, fontWeight: 500 }}>
                <span style={{ width: 6, height: 6, borderRadius: 999, background: r.crowdColor }} />{r.crowd} crowd
              </span>
              <button style={{ border: "none", background: "none", color: T.primary, fontSize: 13, fontWeight: 600, cursor: "pointer", padding: 0 }}>Track bus →</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function TicketScreen({ onBack }) {
  return (
    <div style={{ padding: "30px 22px 0", display: "flex", flexDirection: "column", gap: 22, flex: 1, overflowY: "auto" }}>
      <ScreenHeader title="My ticket" onBack={onBack} right={<Share2 size={18} color={T.ink} strokeWidth={1.75} />} />

      <IllustrationPlaceholder label="Illustration — commuter holding a confirmed bus ticket" height={150} />

      <div>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div style={{ width: 38, height: 38, borderRadius: 12, background: T.tint, display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 600, color: T.primary, fontSize: 13 }}>42</div>
          <span style={{ fontSize: 11, fontWeight: 600, color: T.success, letterSpacing: "0.02em" }}>Confirmed</span>
        </div>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 18 }}>
          <div><div style={{ fontSize: 20, fontWeight: 600 }}>9:40 AM</div><div style={{ fontSize: 12, color: T.faint, marginTop: 3 }}>Kollam Bus Stand</div></div>
          <div style={{ color: T.faint }}>→</div>
          <div style={{ textAlign: "right" }}><div style={{ fontSize: 20, fontWeight: 600 }}>9:58 AM</div><div style={{ fontSize: 12, color: T.faint, marginTop: 3 }}>Chinnakada</div></div>
        </div>
        <div style={{ display: "flex", gap: 28, marginTop: 20, paddingTop: 18, borderTop: `1px solid ${T.line}` }}>
          <div><div style={{ fontSize: 10.5, color: T.faint }}>Date</div><div style={{ fontSize: 13, fontWeight: 500, marginTop: 3 }}>26 Sep 2026</div></div>
          <div><div style={{ fontSize: 10.5, color: T.faint }}>Seat</div><div style={{ fontSize: 13, fontWeight: 500, marginTop: 3 }}>A14</div></div>
          <div><div style={{ fontSize: 10.5, color: T.faint }}>Bus no.</div><div style={{ fontSize: 13, fontWeight: 500, marginTop: 3 }}>KL-23 4521</div></div>
        </div>
      </div>

      <div style={{ display: "flex", flexDirection: "column", alignItems: "center", padding: "20px 0", borderTop: `1px dashed ${T.line}`, borderBottom: `1px dashed ${T.line}` }}>
        <div style={{ width: 108, height: 108, background: T.ink, borderRadius: 14 }} />
        <div style={{ fontSize: 12, color: T.sub, marginTop: 14 }}>Show this code to the conductor</div>
        <div style={{ fontSize: 11, color: T.faint, marginTop: 4 }}>GMB-2609-77341</div>
      </div>

      <div>
        <div style={{ display: "flex", justifyContent: "space-between", fontSize: 14, color: T.sub }}><span>Base fare</span><span style={{ color: T.ink }}>₹13.00</span></div>
        <div style={{ display: "flex", justifyContent: "space-between", fontSize: 14, color: T.sub, marginTop: 12 }}><span>Taxes &amp; fees</span><span style={{ color: T.ink }}>₹2.00</span></div>
        <div style={{ display: "flex", justifyContent: "space-between", fontSize: 15, fontWeight: 600, marginTop: 16, paddingTop: 16, borderTop: `1px solid ${T.line}` }}><span>Total paid</span><span>₹15.00</span></div>
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

      <div style={{ borderRadius: 18, border: `1px solid ${T.line}`, padding: 20 }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8, fontSize: 13, color: T.sub }}><CreditCard size={16} color={T.sub} strokeWidth={1.5} />Wallet</div>
          <span style={{ fontSize: 12, color: T.primary, fontWeight: 500 }}>History →</span>
        </div>
        <div style={{ fontSize: 28, fontWeight: 600, marginTop: 12, letterSpacing: "-0.01em" }}>₹245.50</div>
        <span style={{ display: "inline-block", marginTop: 14, fontSize: 13, fontWeight: 600, color: T.primary }}>+ Add money</span>
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
  const [tab, setTab] = useState("home");
  const [tracking, setTracking] = useState(false);

  let screen;
  if (tab === "home" && tracking) screen = <LiveTrackingScreen onBack={() => setTracking(false)} />;
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
      {screen}
      <BottomNav active={tab} onChange={(k) => { setTab(k); setTracking(false); }} />
    </div>
  );
}
