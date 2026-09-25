#!/usr/bin/env python3
import os, sys, time, urllib.request, urllib.error

API_URL = os.environ.get("API_URL", "http://localhost:8080/health")
MAX_LATENCY = float(os.environ.get("MAX_LATENCY_SEC", "2.0"))
RETRIES, INTERVAL = 10, 5

print(f"=== [HEALTHCHECK] Cible : {API_URL} (Seuil : {MAX_LATENCY}s) ===")

for i in range(1, RETRIES + 1):
    start = time.time()
    try:
        req = urllib.request.Request(API_URL, headers={"User-Agent": "HealthCheck/1.0"})
        with urllib.request.urlopen(req, timeout=5) as res:
            latency = round(time.time() - start, 3)
            print(f"[{i}/{RETRIES}] HTTP {res.getcode()} | Latence : {latency}s")
            
            if latency > MAX_LATENCY:
                print(f"[ECHEC] Latence trop élevée (> {MAX_LATENCY}s)")
                sys.exit(2)
            print("[SUCCÈS] API opérationnelle.")
            sys.exit(0)
            
    except Exception as e:
        print(f"[{i}/{RETRIES}] Injoignable ou erreur ({e}). Nouvelle tentative dans {INTERVAL}s...")
        if i == RETRIES:
            print("[CRITIQUE] Échec définitif du healthcheck après plusieurs essais.")
            sys.exit(1)
        time.sleep(INTERVAL)