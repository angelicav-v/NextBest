// app/_layout.tsx
import { useMemo } from "react";
import { View } from "react-native";
import { Stack } from "expo-router";

export default function RootLayout() {
  const Root = useMemo(() => {
    try {
      const mod = require("react-native-gesture-handler");
      return mod?.GestureHandlerRootView ?? View;
    } catch {
      return View;
    }
  }, []);
  return (
    <Root style={{ flex: 1 }}>
      <Stack screenOptions={{ headerShadowVisible: false }} />
    </Root>
  );
}
