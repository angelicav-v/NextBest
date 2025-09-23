// app/claw.tsx

import { useEffect, useMemo, useRef, useState } from "react";
import { Dimensions, Pressable, Text, View } from "react-native";
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withTiming,
  withDelay,
  Easing,
  runOnJS,
} from "react-native-reanimated";
import { useXP } from "../hooks/useXP";
import ConfettiCannon from "react-native-confetti-cannon";

const { width, height } = Dimensions.get("window");

const PAD = 24;
const ARENA_W = width * 0.88;
const ARENA_H = 340;
const NUM_SLOTS = 5;
const SLOT_W = ARENA_W / NUM_SLOTS;
const DROP_Y = 200;

type Prize = { icon: string; label: string; getXP: () => number };

const PRIZES: Prize[] = [
  { icon: "⭐", label: "+5 XP", getXP: () => 5 },
  { icon: "⭐", label: "+10 XP", getXP: () => 10 },
  { icon: "⭐", label: "+15 XP", getXP: () => 15 },
  { icon: "⭐", label: "+20 XP", getXP: () => 20 },
  { icon: "🎁", label: "Mystery +5–25 XP", getXP: () => 5 + Math.floor(Math.random() * 21) },
];

const slotToX = (s: number) => s * SLOT_W + SLOT_W / 2 - 20;
const randIndex = (n = NUM_SLOTS) => Math.floor(Math.random() * n);

export default function Claw() {
  const { addXP } = useXP();

  const [busy, setBusy] = useState(false);
  const [msg, setMsg] = useState<string | null>(null);
  const [highlight, setHighlight] = useState<number | null>(null);
  const [winning, setWinning] = useState<number | null>(null);
  const [confettiKey, setConfettiKey] = useState(0);

  // wrapper so runOnJS can trigger a new burst
  const bumpConfetti = () => setConfettiKey((k) => k + 1);

  // animations
  const clawX = useSharedValue(slotToX(Math.floor(NUM_SLOTS / 2)));
  const clawY = useSharedValue(0);
  const clawStyle = useAnimatedStyle(() => ({
    transform: [{ translateX: clawX.value }, { translateY: clawY.value }],
  }));

  // timer chain
  const timeoutRef = useRef<number | null>(null);
  useEffect(() => {
    return () => {
      if (timeoutRef.current !== null) clearTimeout(timeoutRef.current);
    };
  }, []);
  const clearTick = () => {
    if (timeoutRef.current !== null) {
      clearTimeout(timeoutRef.current);
      timeoutRef.current = null;
    }
  };

  const runDropSequence = (winner: number) => {
    const prize = PRIZES[winner];
    const xp = prize.getXP();

    clawX.value = withTiming(slotToX(winner), { duration: 320, easing: Easing.out(Easing.cubic) }, () => {
      clawY.value = withTiming(DROP_Y, { duration: 520, easing: Easing.in(Easing.cubic) }, () => {
        clawY.value = withDelay(
          220,
          withTiming(0, { duration: 520, easing: Easing.out(Easing.cubic) }, () => {
            runOnJS(setBusy)(false);
            runOnJS(setWinning)(winner);
            runOnJS(setMsg)(`You won ${prize.label}!`);
            runOnJS(addXP)(xp, { game: "claw", label: `🕹️ ${prize.label}` });
            // ✅ trigger confetti via wrapper (don’t pass a function arg to runOnJS)
            runOnJS(bumpConfetti)();
          })
        );
      });
    });
  };

  const grab = () => {
    if (busy) return;
    setBusy(true);
    setMsg(null);
    setWinning(null);

    const winner = randIndex();
    const cycles = 2 + Math.floor(Math.random() * 2); // 2–3 loops
    const endTick = cycles * NUM_SLOTS + winner;

    let tick = 0;
    let delay = 80;

    const spin = () => {
      setHighlight(tick % NUM_SLOTS);
      tick += 1;

      if (tick >= endTick) {
        clearTick();
        setHighlight(winner);
        runDropSequence(winner);
        return;
      }

      if (endTick - tick < 6) delay += 40; // slow down
      timeoutRef.current = setTimeout(spin, delay) as unknown as number;
    };

    spin();
  };

  const reset = () => {
    clearTick();
    setHighlight(null);
    setWinning(null);
    setMsg(null);
    setBusy(false);
    clawX.value = withTiming(slotToX(Math.floor(NUM_SLOTS / 2)), { duration: 0 });
    clawY.value = withTiming(0, { duration: 0 });
  };

  const slots = useMemo(() => Array.from({ length: NUM_SLOTS }, (_, i) => i), []);

  return (
    <View style={{ flex: 1, alignItems: "center", justifyContent: "center", padding: PAD }}>
      <Text style={{ fontSize: 22, fontWeight: "700", marginBottom: 12 }}>🕹️ Claw Rewards</Text>

      {/* Arena (overflow hidden for look) */}
      <View
        style={{
          width: ARENA_W,
          height: ARENA_H,
          borderRadius: 16,
          borderWidth: 2,
          borderColor: "#111",
          backgroundColor: "#f7f7f7",
          overflow: "hidden",
          alignItems: "center",
        }}
      >
        <View style={{ width: ARENA_W, height: 4, backgroundColor: "#111", marginTop: 8 }} />

        {/* Claw */}
        <Animated.View
          style={[
            {
              width: 40,
              height: 40,
              borderRadius: 8,
              backgroundColor: "#111",
              alignItems: "center",
              justifyContent: "center",
              position: "absolute",
              top: 12,
              left: 0,
            },
            clawStyle,
          ]}
        >
          <Text style={{ color: "white" }}>🤖</Text>
        </Animated.View>

        {/* Prize row */}
        <View
          style={{
            position: "absolute",
            bottom: 16,
            width: ARENA_W,
            flexDirection: "row",
            justifyContent: "space-between",
            paddingHorizontal: 8,
          }}
        >
          {slots.map((i) => {
            const isLit = highlight === i;
            const isWin = winning === i;
            return (
              <View
                key={i}
                style={{
                  width: SLOT_W - 12,
                  height: 48,
                  borderRadius: 10,
                  backgroundColor: isLit ? "#fff" : "#eaeaea",
                  borderWidth: isWin ? 3 : isLit ? 2 : 0,
                  borderColor: isWin ? "#22c55e" : isLit ? "#111" : "transparent",
                  alignItems: "center",
                  justifyContent: "center",
                }}
              >
                <Text style={{ fontSize: 20 }}>{PRIZES[i].icon}</Text>
              </View>
            );
          })}
        </View>
      </View>

      {/* Controls */}
      <View style={{ flexDirection: "row", gap: 12, marginTop: 16 }}>
        <Pressable
          onPress={grab}
          disabled={busy}
          style={{
            backgroundColor: "#111",
            paddingHorizontal: 24,
            paddingVertical: 12,
            borderRadius: 10,
            opacity: busy ? 0.7 : 1,
          }}
        >
          <Text style={{ color: "white", fontSize: 16 }}>Grab!</Text>
        </Pressable>

        <Pressable onPress={reset} style={{ paddingHorizontal: 16, paddingVertical: 12 }}>
          <Text style={{ textDecorationLine: "underline" }}>Reset</Text>
        </Pressable>
      </View>

      {msg && <Text style={{ marginTop: 12, fontSize: 18 }}>{msg}</Text>}

      {/* 🎊 Full-screen confetti overlay (outside clipped arena) */}
      {confettiKey > 0 && (
        <View pointerEvents="none" style={{ position: "absolute", top: 0, left: 0, right: 0, bottom: 0 }}>
          <ConfettiCannon
            key={confettiKey}
            count={120}
            fadeOut
            explosionSpeed={350}
            fallSpeed={2400}
            origin={{ x: width / 2, y: 80 }} // near top
          />
        </View>
      )}
    </View>
  );
}
