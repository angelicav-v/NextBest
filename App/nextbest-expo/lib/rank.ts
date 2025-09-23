// lib/rank.ts
import type { Item, Category } from "../types";

export type Prefs = {
  categories: Category[];           // which kinds to include
  maxDistanceKm: number;            // ignore items farther than this
  pricePrefs?: Array<"$" | "$$" | "$$$">; // preferred price tiers
};

const kmToMi = (km: number) => km * 0.621371;

export function scoreItem(item: Item, prefs: Prefs): number {
  if (!prefs.categories.includes(item.category)) return -Infinity;
  if (item.distanceKm > prefs.maxDistanceKm) return -Infinity;

  // simple scoring: rating-heavy, then distance, then price preference
  let s = 0;
  s += item.rating * 2;                       // rating matters most
  s += Math.max(0, 6 - item.distanceKm);     // closer is better (cap @6km boost)
  if (prefs.pricePrefs && prefs.pricePrefs.includes(item.price)) s += 1.5;

  // small tag flavor (optional)
  if (item.tags?.includes("group")) s += 0.5;
  return s;
}

export function getRankedItems(items: Item[], prefs: Prefs, limit = 10) {
  const ranked = items
    .map((it) => ({ it, s: scoreItem(it, prefs) }))
    .filter((x) => x.s !== -Infinity)
    .sort((a, b) => b.s - a.s)
    .slice(0, limit)
    .map(({ it, s }) => ({ ...it, _score: s }));

  return ranked as Array<Item & { _score: number }>;
}

export function pickWeightedByScore<T extends { _score: number }>(arr: T[]): T {
  // bias toward top items without being deterministic
  const weights = arr.map((x) => Math.max(0.01, Math.pow(x._score, 1.5)));
  const total = weights.reduce((a, b) => a + b, 0);
  let r = Math.random() * total;
  for (let i = 0; i < arr.length; i++) {
    r -= weights[i];
    if (r <= 0) return arr[i];
  }
  return arr[0];
}

export const fmt = {
  price: (p: "$" | "$$" | "$$$") => p,
  distance: (km: number) => `${kmToMi(km).toFixed(1)} mi`,
  category: (c: Category) => ({ food: "Food", entertainment: "Entertainment", activity: "Activity" }[c]),
};
