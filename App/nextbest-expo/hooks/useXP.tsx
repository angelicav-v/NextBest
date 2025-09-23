// hooks/useXP.tsx
import React, {
  createContext,
  useContext,
  useEffect,
  useState,
  type ReactNode,
} from "react";
import AsyncStorage from "@react-native-async-storage/async-storage";

type GameName = "randomizer" | "swipe" | "claw";

export type Win = {
  game: GameName;
  label: string;     // e.g. "🍿 Popcorn", "LIKE: Interstellar"
  ts: number;        // timestamp
  xp: number;        // how many XP were awarded
};

type XpContextType = {
  xp: number;
  recentWins: Win[];
  addXP: (amount: number, win?: Omit<Win, "ts" | "xp">) => void;
  resetXP: () => void;
};

const XpContext = createContext<XpContextType | null>(null);

export function XPProvider({ children }: { children: ReactNode }) {
  const [xp, setXp] = useState(0);
  const [recentWins, setRecentWins] = useState<Win[]>([]);
  const [hydrated, setHydrated] = useState(false);

  // ---- load from disk on first mount ----
  useEffect(() => {
    (async () => {
      try {
        const [xps, wins] = await Promise.all([
          AsyncStorage.getItem("@xp"),
          AsyncStorage.getItem("@wins"),
        ]);
        if (xps != null) setXp(Number.parseInt(xps, 10) || 0);
        if (wins != null) {
          try {
            setRecentWins(JSON.parse(wins));
          } catch {
            setRecentWins([]);
          }
        }
      } finally {
        setHydrated(true);
      }
    })();
  }, []);

  // ---- persist whenever values change (after hydration) ----
  useEffect(() => {
    if (!hydrated) return;
    AsyncStorage.setItem("@xp", String(xp)).catch(() => {});
    AsyncStorage.setItem("@wins", JSON.stringify(recentWins.slice(0, 10))).catch(() => {});
  }, [xp, recentWins, hydrated]);

  // award XP and optionally log a “win” item
  const addXP: XpContextType["addXP"] = (amount, win) => {
    setXp((v) => Math.max(0, v + amount));
    if (win) {
      setRecentWins((curr) => [
        { ...win, ts: Date.now(), xp: amount },
        ...curr,
      ].slice(0, 10));
    }
  };

  const resetXP = () => {
    setXp(0);
    setRecentWins([]);
  };

  return (
    <XpContext.Provider value={{ xp, recentWins, addXP, resetXP }}>
      {children}
    </XpContext.Provider>
  );
}

// convenient hook
export const useXP = () => {
  const ctx = useContext(XpContext);
  if (!ctx) throw new Error("useXP must be used within XPProvider");
  return ctx;
};
