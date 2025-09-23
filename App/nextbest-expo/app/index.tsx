// app/index.tsx

import { useRouter } from "expo-router";
import { View, Text, Pressable } from "react-native";
import { useEffect } from "react";
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSequence,
  withTiming,
  Easing,
} from "react-native-reanimated";
import { useXP } from "../hooks/useXP";
import { usePrefs } from "../hooks/usePrefs";

function Chip({
  label, active, onPress,
}: { label: string; active: boolean; onPress: () => void }) {
  return (
    <Pressable
      onPress={onPress}
      style={{
        paddingHorizontal: 12, paddingVertical: 8, borderRadius: 999,
        backgroundColor: active ? "#111" : "#f1f1f1",
      }}
    >
      <Text style={{ color: active ? "white" : "#111" }}>{label}</Text>
    </Pressable>
  );
}

export default function Home() {
  const router = useRouter();
  const { xp, recentWins, resetXP } = useXP();
  const { categories, toggleCategory } = usePrefs();

  const active = (c: "food" | "entertainment" | "activity") => categories.includes(c);

  // ⭐ Pulse animation when XP changes
  const pulse = useSharedValue(1);
  const xpStyle = useAnimatedStyle(() => ({
    transform: [{ scale: pulse.value }],
  }));

  useEffect(() => {
    // gentle pop (slightly up, then back)
    pulse.value = withSequence(
      withTiming(1.08, { duration: 130, easing: Easing.out(Easing.cubic) }),
      withTiming(1, { duration: 180, easing: Easing.inOut(Easing.cubic) })
    );
  }, [xp]);

  return (
    <View style={{ flex: 1, padding: 24, gap: 16 }}>
      <Text style={{ fontSize: 26, fontWeight: "800" }}>NextBest</Text>
      <Text style={{ opacity: 0.7, marginTop: -6 }}>Quick picks for food, entertainment, and activities.</Text>

      {/* XP header (animated) */}
      <Animated.View
        style={[
          {
            backgroundColor: "#111",
            padding: 16,
            borderRadius: 12,
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "space-between",
          },
          xpStyle,
        ]}
      >
        <Text style={{ color: "white", fontSize: 18, fontWeight: "700" }}>
          ⭐ XP: {xp}
        </Text>
        <Pressable onPress={resetXP} style={{ padding: 8 }}>
          <Text style={{ color: "#ddd", textDecorationLine: "underline" }}>Reset</Text>
        </Pressable>
      </Animated.View>

      {/* Preferences */}
      <View style={{ gap: 10 }}>
        <Text style={{ fontWeight: "700" }}>Include categories</Text>
        <View style={{ flexDirection: "row", gap: 8 }}>
          <Chip label="Food" active={active("food")} onPress={() => toggleCategory("food")} />
          <Chip label="Entertainment" active={active("entertainment")} onPress={() => toggleCategory("entertainment")} />
          <Chip label="Activity" active={active("activity")} onPress={() => toggleCategory("activity")} />
        </View>
      </View>

      {/* Nav buttons */}
      <View style={{ gap: 10, marginTop: 8 }}>
        <Pressable onPress={() => router.push("/randomizer")} style={{ padding: 14, borderRadius: 10, backgroundColor: "#f1f1f1" }}>
          <Text>🎯 Decide For Me (Randomizer)</Text>
        </Pressable>
        <Pressable onPress={() => router.push("/swipe")} style={{ padding: 14, borderRadius: 10, backgroundColor: "#f1f1f1" }}>
          <Text>🃏 Swipe Pick</Text>
        </Pressable>
        <Pressable onPress={() => router.push("/claw")} style={{ padding: 14, borderRadius: 10, backgroundColor: "#f1f1f1" }}>
          <Text>🕹️ Claw Rewards</Text>
        </Pressable>
      </View>

      {/* Recent wins */}
      <View style={{ marginTop: 8, flex: 1 }}>
        <Text style={{ fontSize: 16, fontWeight: "700", marginBottom: 8 }}>Recent wins</Text>
        {recentWins.length === 0 ? (
          <Text style={{ opacity: 0.6 }}>No wins yet — go play!</Text>
        ) : (
          recentWins.slice(0, 8).map((w, i) => (
            <View
              key={i}
              style={{
                padding: 12,
                borderRadius: 10,
                backgroundColor: "#fafafa",
                marginBottom: 8,
                flexDirection: "row",
                justifyContent: "space-between",
              }}
            >
              <Text>
                {w.label} <Text style={{ opacity: 0.6 }}>· {w.game}</Text>
              </Text>
              <Text style={{ fontWeight: "700" }}>+{w.xp}</Text>
            </View>
          ))
        )}
      </View>
    </View>
  );
}
