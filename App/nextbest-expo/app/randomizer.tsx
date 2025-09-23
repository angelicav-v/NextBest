// app/randomizer.tsx

import { useCallback, useMemo, useState } from "react";
import { Dimensions, Pressable, Text, View } from "react-native";
import ConfettiCannon from "react-native-confetti-cannon";
import Animated, {
  Easing,
  runOnJS,
  useAnimatedStyle,
  useSharedValue,
  withTiming,
} from "react-native-reanimated";
import { G, Path, Svg } from "react-native-svg";

import { ITEMS } from "../data/items";
import { usePrefs } from "../hooks/usePrefs";
import { useXP } from "../hooks/useXP";
import { fmt, getRankedItems, pickWeightedByScore } from "../lib/rank";
import type { Item } from "../types";

const { width: SCREEN_W } = Dimensions.get("window");

const WHEEL_SIZE = Math.min(340, SCREEN_W * 0.94);
const R = WHEEL_SIZE / 2;

// pleasant, spaced palette
const PALETTE = [
  "#f52d31ff", // red
  "#FFA940", // orange
  "#FFD666", // yellow
  "#52C41A", // green
  "#36CFC9", // teal
  "#1890FF", // blue
  "#722ED1", // purple
  "#f643a6ff", // magenta
];
const COLOR_SPREAD = 3;

// spin feel
const SPINS = 7;
const SPIN_DURATION = 3800;
const POINTER_OFFSET_DEG = 0; // nudge ±1 if the landing looks a hair off

// Full wedge (to center). 0° points RIGHT; pointer is at TOP so we target -90° in math.
function wedgePath(cx: number, cy: number, r: number, a0: number, a1: number) {
  const toRad = (d: number) => (Math.PI / 180) * d;
  const x0 = cx + r * Math.cos(toRad(a0));
  const y0 = cy + r * Math.sin(toRad(a0));
  const x1 = cx + r * Math.cos(toRad(a1));
  const y1 = cy + r * Math.sin(toRad(a1));
  const large = a1 - a0 <= 180 ? 0 : 1;
  // Move along outer arc, then straight back to center
  return `M ${x0} ${y0} A ${r} ${r} 0 ${large} 1 ${x1} ${y1} L ${cx} ${cy} Z`;
}

export default function Randomizer() {
  const { addXP } = useXP();
  const { categories, maxDistanceKm } = usePrefs();
  const [result, setResult] = useState<Item | null>(null);
  const [confettiKey, setConfettiKey] = useState(0);

  const segments = useMemo(
    () => getRankedItems(ITEMS, { categories, maxDistanceKm }, 8) as Array<Item & { _score: number }>,
    [categories, maxDistanceKm]
  );
  const N = Math.max(segments.length, 1);
  const ANG = 360 / N;

  const rotation = useSharedValue(0);
  const wheelStyle = useAnimatedStyle(() => ({
    transform: [{ rotate: `${rotation.value}deg` }],
  }));

  const onSpinEnd = useCallback((pick: Item) => {
    setResult(pick);
    addXP(5, { game: "randomizer", label: `🎯 ${pick.name}` });
    setConfettiKey((k) => k + 1);
  }, [addXP]);

  const spin = () => {
    if (!segments.length) return;

    const chosen = pickWeightedByScore(segments);
    const winnerIdx = segments.findIndex((s) => s.id === chosen.id);

    const TOP_DEG = -90; // pointer at top in 0°=RIGHT system
    const current = rotation.value;

    const targetMod = (winnerIdx * ANG + TOP_DEG + POINTER_OFFSET_DEG) % 360;
    const currentMod = ((current % 360) + 360) % 360;
    let delta = ((targetMod - currentMod) % 360 + 360) % 360;

    const final = current + SPINS * 360 + delta;

    rotation.value = withTiming(
      final,
      { duration: SPIN_DURATION, easing: Easing.out(Easing.cubic) },
      () => runOnJS(onSpinEnd)(chosen)
    );
  };

  return (
    <View style={{ flex: 1, padding: 24, alignItems: "center" }}>
      <Text style={{ fontSize: 24, fontWeight: "800", marginTop: 8 }}>🎯 Decide For Me</Text>
      <Text style={{ opacity: 0.65, textAlign: "center", marginBottom: 16 }}>
        Spinning from your selected categories.
      </Text>

      <View style={{ width: WHEEL_SIZE, height: WHEEL_SIZE, alignItems: "center", justifyContent: "center" }}>
        {/* TOP pointer, outside, pointing DOWN */}
        <View
          style={{
            position: "absolute",
            top: -8,
            left: WHEEL_SIZE / 2 - 10,
            width: 0,
            height: 0,
            borderLeftWidth: 10,
            borderRightWidth: 10,
            borderTopWidth: 16,          // downwards
            borderLeftColor: "transparent",
            borderRightColor: "transparent",
            borderTopColor: "#111",
            zIndex: 3,
          }}
        />

        {/* spinning full-wedge wheel */}
        <Animated.View style={[{ width: WHEEL_SIZE, height: WHEEL_SIZE }, wheelStyle]}>
          <Svg width={WHEEL_SIZE} height={WHEEL_SIZE}>
            <G>
              {Array.from({ length: N }).map((_, i) => {
                const start = i * ANG - ANG / 2;
                const end = (i + 1) * ANG - ANG / 2;
                const colorIdx = (i * COLOR_SPREAD) % PALETTE.length;
                const color = PALETTE[colorIdx];
                const path = wedgePath(R, R, R, start, end);
                return (
                  <Path
                    key={i}
                    d={path}
                    fill={color}
                    // uncomment next two lines for thin white dividers between wedges:
                    // stroke="#fff"
                    // strokeWidth={1}
                  />
                );
              })}
            </G>
          </Svg>
        </Animated.View>

        {confettiKey > 0 && (
          <ConfettiCannon
            key={confettiKey}
            count={120}
            fadeOut
            explosionSpeed={360}
            fallSpeed={2400}
            origin={{ x: WHEEL_SIZE / 2, y: 0 }}
          />
        )}
      </View>

      <Pressable
        onPress={spin}
        style={{
          backgroundColor: "#111",
          paddingHorizontal: 24,
          paddingVertical: 12,
          borderRadius: 12,
          marginTop: 18,
        }}
      >
        <Text style={{ color: "white", fontSize: 16, fontWeight: "700" }}>Spin (+5 XP)</Text>
      </Pressable>

      {result && (
        <View style={{ marginTop: 14, gap: 6, alignItems: "center" }}>
          <Text style={{ fontSize: 18, fontWeight: "800" }}>{result.name}</Text>
          <Text style={{ opacity: 0.7 }}>
            {fmt.category(result.category)} · {result.price} · {fmt.distance(result.distanceKm)} · ★{" "}
            {result.rating.toFixed(1)}
          </Text>
          <Pressable onPress={() => setResult(null)} style={{ marginTop: 6 }}>
            <Text style={{ textDecorationLine: "underline" }}>Spin again</Text>
          </Pressable>
        </View>
      )}
    </View>
  );
}
