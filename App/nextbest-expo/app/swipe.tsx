
import { useState, useMemo } from "react";
import { View, Text, Dimensions, Pressable } from "react-native";
import { Gesture, GestureDetector } from "react-native-gesture-handler";
import Animated, {
  useSharedValue, useAnimatedStyle, withSpring, withTiming,
  interpolate, Extrapolation, runOnJS,
} from "react-native-reanimated";
import { useXP } from "../hooks/useXP";
import { usePrefs } from "../hooks/usePrefs";
import { ITEMS } from "../data/items";
import { getRankedItems, fmt } from "../lib/rank";
import type { Item } from "../types";

const { width } = Dimensions.get("window");
const THRESHOLD = width * 0.25;
const EXIT_MS = 220;

export default function Swipe() {
  const { addXP } = useXP();
  const { categories, maxDistanceKm } = usePrefs();

  const deck = useMemo(
    () => getRankedItems(ITEMS, { categories, maxDistanceKm }, 10) as Array<Item & { _score: number }>,
    [categories, maxDistanceKm]
  );

  const [index, setIndex] = useState(0);
  const [likes, setLikes] = useState<Item[]>([]);
  const [skips, setSkips] = useState<Item[]>([]);

  const card = deck[index] ?? null;
  const next = deck[index + 1] ?? null;

  // anim state
  const x = useSharedValue(0);
  const y = useSharedValue(0);
  const rotateDeg = useSharedValue(0);
  const nextScale = useSharedValue(0.96);
  const nextOpacity = useSharedValue(0.8);
  const animating = useSharedValue(false);

  const promoteUnderlay = () => { "worklet";
    nextScale.value = withTiming(1, { duration: EXIT_MS });
    nextOpacity.value = withTiming(1, { duration: EXIT_MS });
  };
  const resetUnderlay = () => { "worklet";
    nextScale.value = 0.96; nextOpacity.value = 0.8;
  };

  const cardStyle = useAnimatedStyle(() => ({
    transform: [{ translateX: x.value }, { translateY: y.value }, { rotate: `${rotateDeg.value}deg` }],
  }));
  const likeStyle = useAnimatedStyle(() => ({
    opacity: interpolate(x.value, [0, THRESHOLD], [0, 1], Extrapolation.CLAMP),
  }));
  const nopeStyle = useAnimatedStyle(() => ({
    opacity: interpolate(x.value, [-THRESHOLD, 0], [1, 0], Extrapolation.CLAMP),
  }));
  const nextStyle = useAnimatedStyle(() => ({
    transform: [{ scale: nextScale.value }], opacity: nextOpacity.value,
  }));

  const commit = (decision: "like" | "nope", it: Item) => {
    if (decision === "like") {
      setLikes((s) => [...s, it]);
      addXP(3, { game: "swipe", label: `👍 ${it.name}` });
    } else {
      setSkips((s) => [...s, it]);
      addXP(1, { game: "swipe", label: `👎 ${it.name}` });
    }
    setIndex((i) => i + 1);
    x.value = 0; y.value = 0; rotateDeg.value = 0; resetUnderlay(); animating.value = false;
  };

  const pan = Gesture.Pan()
    .onChange((e) => {
      if (animating.value) return;
      x.value += e.changeX; y.value += e.changeY; rotateDeg.value = x.value / 20;
      const p = Math.min(Math.abs(x.value) / THRESHOLD, 1);
      nextScale.value = 0.96 + 0.04 * p; nextOpacity.value = 0.8 + 0.2 * p;
    })
    .onEnd(() => {
      if (animating.value || !card) return;
      if (x.value > THRESHOLD) {
        animating.value = true; promoteUnderlay();
        const it = card;
        x.value = withTiming(width + 120, { duration: EXIT_MS }, () => runOnJS(commit)("like", it));
      } else if (x.value < -THRESHOLD) {
        animating.value = true; promoteUnderlay();
        const it = card;
        x.value = withTiming(-width - 120, { duration: EXIT_MS }, () => runOnJS(commit)("nope", it));
      } else {
        x.value = withSpring(0); y.value = withSpring(0); rotateDeg.value = withSpring(0); resetUnderlay();
      }
    });

  const resetDeck = () => { setIndex(0); setLikes([]); setSkips([]); resetUnderlay(); };

  if (!card) {
    return (
      <View style={{ flex: 1, alignItems: "center", justifyContent: "center", gap: 12 }}>
        <Text style={{ fontSize: 20, fontWeight: "700" }}>No more cards</Text>
        <Text style={{ opacity: 0.7 }}>
          Final picks: {likes.length} liked · {skips.length} skipped
        </Text>
        <Pressable onPress={resetDeck} style={{ paddingHorizontal: 16, paddingVertical: 10, backgroundColor: "#111", borderRadius: 10 }}>
          <Text style={{ color: "white" }}>Reset Deck</Text>
        </Pressable>
      </View>
    );
  }

  const Info = ({ it }: { it: Item }) => (
    <View style={{ alignItems: "center" }}>
      <Text style={{ fontSize: 20, fontWeight: "700", marginBottom: 4 }}>{it.name}</Text>
      <Text style={{ opacity: 0.7 }}>
        {fmt.category(it.category)} · {it.price} · {fmt.distance(it.distanceKm)} · ★ {it.rating.toFixed(1)}
      </Text>
    </View>
  );

  return (
    <View style={{ flex: 1, alignItems: "center", justifyContent: "center" }}>
      {/* preloaded underlay */}
      {next && (
        <Animated.View style={[{
          position: "absolute", width: width * 0.82, height: 280, borderRadius: 18, backgroundColor: "#f6f6f6",
          alignItems: "center", justifyContent: "center",
        }, nextStyle]}>
          <Text style={{ opacity: 0.5 }}>{next.name}</Text>
        </Animated.View>
      )}

      <GestureDetector gesture={pan}>
        <Animated.View style={[{
          width: width * 0.82, height: 280, borderRadius: 18, backgroundColor: "#f2f2f2",
          alignItems: "center", justifyContent: "center", shadowColor: "#000",
          shadowOpacity: 0.15, shadowRadius: 12, shadowOffset: { width: 0, height: 6 }, elevation: 4,
        }, cardStyle]}>
          <Info it={card} />

          <Animated.Text style={[{ position: "absolute", top: 16, left: 16, fontSize: 18, fontWeight: "800" }, likeStyle]}>
            LIKE
          </Animated.Text>
          <Animated.Text style={[{ position: "absolute", top: 16, right: 16, fontSize: 18, fontWeight: "800" }, nopeStyle]}>
            NOPE
          </Animated.Text>
        </Animated.View>
      </GestureDetector>

      <View style={{ marginTop: 14 }}>
        <Text style={{ opacity: 0.6, fontSize: 12 }}>
          👍 {likes.length} · 👎 {skips.length}
        </Text>
      </View>
    </View>
  );
}
