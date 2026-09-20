import { NavLink, Outlet } from "react-router";

const navigationItems = [
  { label: "Dashboard", path: "/dashboard" },
  { label: "Workers", path: "/workers" },
  { label: "Experiments", path: "/experiments" },
  { label: "Events", path: "/events" },
  { label: "Artifacts", path: "/artifacts" },
];

export function AppLayout() {
  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="brand">
          <h1>HeteroES</h1>
          <p>ES Post-Training Platform</p>
        </div>

        <nav className="navigation">
          {navigationItems.map((item) => (
            <NavLink
              key={item.path}
              to={item.path}
              className={({ isActive }) =>
                isActive ? "nav-link active" : "nav-link"
              }
            >
              {item.label}
            </NavLink>
          ))}
        </nav>
      </aside>

      <div className="content-area">
        <header className="topbar">
          <span>HeteroES Dashboard</span>
        </header>

        <main className="main-content">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
