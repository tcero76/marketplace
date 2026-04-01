"use client";

import { useEffect } from "react";

export default function GoogleOneTap() {
  useEffect(() => {
    if (typeof window === "undefined") return;
    if (!document.querySelector('script[src="https://accounts.google.com/gsi/client"]')) {
      const script = document.createElement("script");
      script.src = "https://accounts.google.com/gsi/client";
      script.async = true;
      script.defer = true;
      document.body.appendChild(script);

      script.onload = () => {
        initializeGoogle();
      };
    } else {
      initializeGoogle();
    }

    function initializeGoogle() {
      window.google?.accounts.id.initialize({
        client_id: process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID!,
        callback: handleCredentialResponse,
        auto_select: false,
        cancel_on_tap_outside: true,
        context: "signin",
      });

      // window.google?.accounts.id.prompt((notification) => {
      //   if (notification.isNotDisplayed()) {
      //     console.log("Prompt no mostrado:", notification.getNotDisplayedReason());
      //   } else if (notification.isSkippedMoment()) {
      //     console.log("Prompt skipped (quizás ya lo vio antes)");
      //   }
      // });

      window.google?.accounts.id.renderButton(
        document.getElementById("googleSignInButton")!,
        {
          type: "standard",
          size: "large",
          theme: "outline",
          text: "sign_in_with",
          shape: "rectangular",
          logo_alignment: "left",
        }
      );
    }

    function handleCredentialResponse(response: { credential: string }) {
      fetch("/api/auth/google", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ token: response.credential }),
      })
        .then((res) => res.json())
        .then((data) => {
          console.log("Login exitoso:", data);
          window.location.href = "/dashboard";
        })
        .catch((err) => console.error("Error en login:", err));
    }
  }, []);

  return (
    <div>
      <div id="googleSignInButton" style={{ display: "inline-block" }}></div>
    </div>
  );
}