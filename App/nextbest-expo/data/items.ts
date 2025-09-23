// data/items.ts
import type { Item } from "../types";

export const ITEMS: Item[] = [
  // ---- FOOD ----
  { id: "f1", name: "Taco Loco", category: "food", rating: 4.5, price: "$",  distanceKm: 1.2, tags: ["mexican","casual"] },
  { id: "f2", name: "Sushi Mura", category: "food", rating: 4.7, price: "$$", distanceKm: 3.8, tags: ["japanese","date-night"] },
  { id: "f3", name: "Mama’s Pasta", category: "food", rating: 4.2, price: "$$", distanceKm: 2.1, tags: ["italian","family"] },

  // ---- ENTERTAINMENT ----
  { id: "e1", name: "Arcade Vault", category: "entertainment", rating: 4.6, price: "$",  distanceKm: 2.5, tags: ["games","group"] },
  { id: "e2", name: "Cinema XXI", category: "entertainment", rating: 4.3, price: "$$", distanceKm: 1.8, tags: ["movies"] },
  { id: "e3", name: "Escape Room HQ", category: "entertainment", rating: 4.8, price: "$$", distanceKm: 6.2, tags: ["puzzle","team"] },

  // ---- ACTIVITIES ----
  { id: "a1", name: "Riverside Walk", category: "activity", rating: 4.4, price: "$",  distanceKm: 0.9, tags: ["outdoors","free"] },
  { id: "a2", name: "Climbing Gym", category: "activity", rating: 4.7, price: "$$", distanceKm: 5.4, tags: ["fitness"] },
  { id: "a3", name: "Board Game Cafe", category: "activity", rating: 4.5, price: "$",  distanceKm: 3.1, tags: ["indoor","group"] },

  // a few extras for variety
  { id: "f4", name: "BBQ Shack", category: "food", rating: 4.1, price: "$$", distanceKm: 4.0, tags: ["bbq"] },
  { id: "e4", name: "Mini Golf Park", category: "entertainment", rating: 4.2, price: "$", distanceKm: 7.5, tags: ["outdoors","group"] },
  { id: "a4", name: "Yoga in the Park", category: "activity", rating: 4.6, price: "$", distanceKm: 2.9, tags: ["wellness","outdoors"] },
];
