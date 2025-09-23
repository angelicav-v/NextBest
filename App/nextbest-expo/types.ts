// types.ts
export type Category = "food" | "entertainment" | "activity";

export type Item = {
  id: string;
  name: string;
  category: Category;
  rating: number;               // 0..5
  price: "$" | "$$" | "$$$";
  distanceKm: number;           // pretend distance from user
  tags?: string[];
};
