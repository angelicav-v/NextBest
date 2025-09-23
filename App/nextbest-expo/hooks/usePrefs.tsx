// hooks/usePrefs.tsx
import React, { createContext, useContext, useState, type ReactNode } from "react";
import type { Category } from "../types";

type PrefsCtx = {
  categories: Category[];
  maxDistanceKm: number;
  toggleCategory: (c: Category) => void;
  setMaxDistanceKm: (n: number) => void;
};

const PrefsContext = createContext<PrefsCtx | null>(null);

export function PrefsProvider({ children }: { children: ReactNode }) {
  const [categories, setCategories] = useState<Category[]>(["food", "entertainment", "activity"]);
  const [maxDistanceKm, setMaxDistanceKm] = useState<number>(10);

  const toggleCategory = (c: Category) =>
    setCategories((prev) => (prev.includes(c) ? prev.filter((x) => x !== c) : [...prev, c]));

  return (
    <PrefsContext.Provider value={{ categories, maxDistanceKm, toggleCategory, setMaxDistanceKm }}>
      {children}
    </PrefsContext.Provider>
  );
}

export const usePrefs = () => {
  const ctx = useContext(PrefsContext);
  if (!ctx) throw new Error("usePrefs must be used within PrefsProvider");
  return ctx;
};
